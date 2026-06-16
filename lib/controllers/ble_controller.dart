import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'fall_notification_server.dart';

class BleController extends GetxController {
  // ================= UUIDs FROM ESP32 =================
  final Guid sensorServiceUuid =
  Guid("b19c4247-db2e-4034-b5b2-263f050c8817");
  final Guid readingCharUuid =
  Guid("fa3d69e0-cff9-4be0-aee8-2e39d1350235"); 
  final Guid heartRateCharUuid =
  Guid("b975214e-faac-49cb-b71e-e85747917315");
  final Guid heartRateDescriptorUuid =
  Guid("1e23efb0-b0ad-4f78-9af6-281862fc1880");

  // ================= OBSERVABLES =================
  var isScanning = false.obs;
  var isConnecting = false.obs;
  var isConnected = false.obs;

  var heartRate = 0.obs;
  var bloodOxygen = 0.obs;

  var fallDetected = false.obs;
  var fallCount = 0.obs;

  BluetoothDevice? connectedDevice;
  final RxList<ScanResult> scanResults = <ScanResult>[].obs;

  final List<int> _hrBuffer = [];
  final List<int> _spo2Buffer = [];
  Timer? _averageTimer;

  final FallNotificationService fallNotificationService =
  FallNotificationService();

  @override
  void onInit() {
    super.onInit();
    fallNotificationService.initialize();
  }


  void _startAveraging() {
    _averageTimer?.cancel();

    _averageTimer = Timer.periodic(
      const Duration(seconds: 10),
          (_) {
        if (_hrBuffer.isNotEmpty) {
          heartRate.value =
              (_hrBuffer.reduce((a, b) => a + b) / _hrBuffer.length).round();
        }

        if (_spo2Buffer.isNotEmpty) {
          bloodOxygen.value =
              (_spo2Buffer.reduce((a, b) => a + b) / _spo2Buffer.length).round();
        }

        debugPrint("═══════════════════════════════════════");
        debugPrint("❤️ Avg HR: ${heartRate.value}");
        debugPrint("🫁 Avg SpO₂: ${bloodOxygen.value}");
        debugPrint("═══════════════════════════════════════");

        _hrBuffer.clear();
        _spo2Buffer.clear();
      },
    );
  }

  // ================= SCAN =================
  Future<void> scanDevices() async {
    final scanStatus = await Permission.bluetoothScan.request();
    final connectStatus = await Permission.bluetoothConnect.request();
    final locationStatus = await Permission.location.request();

    if (!await Permission.bluetoothScan.isGranted ||
        !await Permission.bluetoothConnect.isGranted) {
      debugPrint("❌ Bluetooth permissions not granted");
      return;
    }

    try {
      scanResults.clear();
      isScanning.value = true;

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
      );

      FlutterBluePlus.scanResults.listen((results) {
        scanResults.assignAll(results);
      });

      await Future.delayed(const Duration(seconds: 10));
      await FlutterBluePlus.stopScan();
      isScanning.value = false;
    } catch (e) {
      debugPrint("❌ Scan error: $e");
      isScanning.value = false;
    }
  }

  // ================= CONNECT =================
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      isConnecting.value = true;
      connectedDevice = device;

      await device.connect(
        timeout: const Duration(seconds: 10),
        license: License.free,
      );

      isConnected.value = true;

      List<BluetoothService> services =
      await device.discoverServices();

      for (var service in services) {
        if (service.uuid == sensorServiceUuid) {
          for (var char in service.characteristics) {
            // ========= HR + SpO2 =========
            if (char.uuid == heartRateCharUuid) {
              await char.setNotifyValue(true);

              for (var desc in char.descriptors) {
                if (desc.uuid == heartRateDescriptorUuid) {
                  await desc.write(utf8.encode("send"));
                }
              }

              char.lastValueStream.listen((value) {
                if (value.isNotEmpty) {
                  try {
                    final dataStr = String.fromCharCodes(value);

                    if (dataStr.contains("HR:") &&
                        dataStr.contains("SpO2:")) {
                      final hrMatch =
                      RegExp(r'HR:(\d+)').firstMatch(dataStr);
                      final spo2Match =
                      RegExp(r'SpO2:(\d+)').firstMatch(dataStr);

                      if (hrMatch != null && spo2Match != null) {
                        final hr = int.parse(hrMatch.group(1)!);
                        final spo2 = int.parse(spo2Match.group(1)!);

                        _hrBuffer.add(hr);
                        _spo2Buffer.add(spo2);

                        if (_averageTimer == null ||
                            !_averageTimer!.isActive) {
                          _startAveraging();
                        }
                      }
                    }
                  } catch (e) {
                    debugPrint("❌ HR parse error: $e");
                  }
                }
              });
            }

            if (char.uuid == readingCharUuid) {
              await char.setNotifyValue(true);

              char.lastValueStream.listen((value) {
                if (value.isNotEmpty) {
                  try {
                    final dataStr = String.fromCharCodes(value);

                    if (dataStr.contains("FALL_DETECTED")) {
                      if (!fallDetected.value) {

                        debugPrint("🚨🚨 FALL DETECTED 🚨🚨");
                      }

                      fallDetected.value = true;
                      fallCount.value++;

                      debugPrint("📊 Total Falls: ${fallCount.value}");
                      debugPrint("⏱ Time: ${DateTime.now()}");

                      fallNotificationService.showFallDetected(
                        time: DateTime.now(),
                      );
                    } else {
                      if (fallDetected.value) {
                        debugPrint("✅ Fall state cleared");
                      }
                      fallDetected.value = false;
                    }

                  } catch (e) {
                    debugPrint("❌ Fall parse error: $e");
                  }
                }
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Connection failed: $e");
      isConnected.value = false;
    } finally {
      isConnecting.value = false;
    }
  }




  // ================= STOP STREAM =================
  Future<void> stopHeartRateStream() async {
    if (connectedDevice == null) return;

    try {
      final services =
      await connectedDevice!.discoverServices();

      for (var service in services) {
        if (service.uuid == sensorServiceUuid) {
          for (var char in service.characteristics) {
            if (char.uuid == heartRateCharUuid) {
              for (var desc in char.descriptors) {
                if (desc.uuid == heartRateDescriptorUuid) {
                  await desc.write(utf8.encode("stop"));
                }
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Stop stream error: $e");
    }
  }

  // ================= DISCONNECT =================
  Future<void> disconnectDevice() async {
    _averageTimer?.cancel();
    _hrBuffer.clear();
    _spo2Buffer.clear();

    if (connectedDevice != null) {
      await stopHeartRateStream();
      await connectedDevice!.disconnect();
      connectedDevice = null;
      isConnected.value = false;
    }
  }

  @override
  void onClose() {
    FlutterBluePlus.stopScan();
    disconnectDevice();
    super.onClose();
  }
}

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import '../controllers/ble_controller.dart';
import 'custom_appbar.dart';

class PairingPage extends StatefulWidget {
  const PairingPage({Key? key}) : super(key: key);

  @override
  State<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  final BleController bleController = Get.find<BleController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterDevices);
  }

  void _filterDevices() {
    // Trigger rebuild when search changes
    setState(() {});
  }

  List<ScanResult> _getFilteredDevices() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      return bleController.scanResults;
    }

    return bleController.scanResults
        .where(
          (result) =>
              result.device.platformName.toLowerCase().contains(query) ||
              result.device.remoteId.str.toLowerCase().contains(query),
        )
        .toList();
  }

  void _startScanning() async {
    await bleController.scanDevices();
  }

  void _connectDevice(BluetoothDevice device) async {
    try {
      await bleController.connectToDevice(device);

      if (mounted) {
        // ✅ SUCCESS message after connection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Device "${device.platformName.isNotEmpty ? device.platformName : "Unknown Device"}" connected successfully',
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFF00BFA5),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Connection error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Connection error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onESOMPressed: () {
          print('ESOS pressed');
        },
        onNotificationPressed: () {
          print('Notification pressed');
        },
        onMenuPressed: () {
          print('Menu pressed');
        },
        onSearchChanged: (value) {
          searchController.text = value;
        },
        onFilterPressed: () {
          print('Filter pressed');
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pairing Bands",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: bleController.isScanning.value
                          ? null
                          : _startScanning,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: bleController.isScanning.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.add, color: Colors.black54, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manage Your Bands",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF136A88),
                      ),
                    ),
                    SizedBox(height: 12),
                    Image.asset(
                      'assets/images/band.png',
                      height: 260,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              Obx(
                () => bleController.isScanning.value
                    ? Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF0097A7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFF0097A7).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0097A7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Scanning for devices... (${bleController.scanResults.length} found)",
                                style: TextStyle(
                                  color: Color(0xFF0097A7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              Obx(
                () => bleController.isScanning.value
                    ? SizedBox(height: 16)
                    : SizedBox.shrink(),
              ),
              Text(
                "Connected Band",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF606B75),
                ),
              ),
              SizedBox(height: 12),

              Obx(() {
                final devices = _getFilteredDevices();

                if (devices.isEmpty && !bleController.isScanning.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.bluetooth_disabled,
                            size: 48,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No devices found",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Tap the + button or \"ADD Another Band\" to scan",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (devices.isEmpty && bleController.isScanning.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        "Searching for devices...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index].device;
                    final rssi = devices[index].rssi;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/images/band1.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 6),
                                          Text(
                                            "Available",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF00BFA5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        device.platformName.isNotEmpty
                                            ? device.platformName
                                            : "Unknown Device",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.bluetooth,
                                            size: 16,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "RSSI: $rssi",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Band ${device.remoteId.str.substring(device.remoteId.str.length - 4).toUpperCase()}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _connectDevice(device),
                                  icon: Icon(
                                    Icons.bluetooth,
                                    size: 16,
                                    color: Color(0xFF136A88),
                                  ),
                                  label: Text(
                                    "Connect",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF136A88),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.notifications_off,
                                    size: 18,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 16),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF64CDC6), Color(0xFF136A88)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: bleController.isScanning.value
                          ? null
                          : _startScanning,
                      icon: Icon(
                        bleController.isScanning.value
                            ? Icons.stop
                            : Icons.bluetooth,
                        size: 20,
                      ),
                      label: Text(
                        bleController.isScanning.value
                            ? "SCANNING..."
                            : "ADD Another Band",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        // Button itself is transparent
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        disabledForegroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

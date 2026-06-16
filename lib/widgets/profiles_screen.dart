import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ble_controller.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({Key? key}) : super(key: key);

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  final BleController bleController = Get.find<BleController>();

  // Hard coded data
  final String fullName = "Ahmed Hassan";
  final String email = "Ahmed.Hassan@gmail.com";
  final String phoneNumber = "+201025289544";
  final int age = 48;
  final String gender = "Male";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Transform.translate(
                offset: const Offset(0, -30),
                child: _buildWhiteCard(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E9AA8), Color(0xFF2AAFBA)],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackButton(color: Colors.white),
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(child: _buildNameAndStatus()),
              const Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFB3E5FC),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(Icons.person, size: 50, color: Color(0xFF0288D1)),
    );
  }

  Widget _buildNameAndStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final connected = bleController.isConnected.value;
          return Text(
            'Status: ${connected ? "Active" : "Inactive"}',
            style: TextStyle(
              color: connected ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
      ],
    );
  }

  // ================= WHITE CARD =================

  Widget _buildWhiteCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Personal information'),
                _infoRow(Icons.person, 'Full Name', fullName),
                _infoRow(Icons.mail, 'Email Address', email),
                _phoneAndAgeRow(),
                _infoRow(Icons.male, 'Gender', gender, showArrow: false),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Band connected information'),
                _buildBandIdRow(),
                const SizedBox(height: 12),
                _buildConnectionRow(),
                const SizedBox(height: 12),
                _buildStatusRow(),
                const SizedBox(height: 12),
                _buildBatteryRow(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2AAFBA),
                padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: const Text(
                'See profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SMALL HELPERS =================

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0277BD),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _infoRow(
      IconData icon,
      String label,
      String value, {
        bool showArrow = true,
      }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0277BD)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        if (showArrow)
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF0277BD),
          ),
      ],
    );
  }

  Widget _phoneAndAgeRow() {
    return Row(
      children: [
        Expanded(child: _infoRow(Icons.phone, 'Phone Number', phoneNumber)),
        const SizedBox(width: 12),
        Expanded(
          child: _infoRow(Icons.cake, 'Age', '$age', showArrow: false),
        ),
      ],
    );
  }

  // ================= GETX SAFE ROWS =================

  Widget _buildBandIdRow() {
    return Obx(() {
      final connected = bleController.isConnected.value;

      final bandId = connected && bleController.connectedDevice != null
          ? bleController.connectedDevice!.remoteId.str
          : 'N/A';

      return _infoRow(
        Icons.devices,
        'Band ID',
        bandId,
        showArrow: false,
      );
    });
  }

  Widget _buildConnectionRow() {
    return Obx(() {
      final connected = bleController.isConnected.value;

      return _infoRow(
        Icons.circle,
        'Connection',
        connected ? 'Connected' : 'Disconnected',
        showArrow: false,
      );
    });
  }

  Widget _buildStatusRow() {
    return Obx(() {
      final connected = bleController.isConnected.value;

      return _infoRow(
        Icons.schedule,
        'Status',
        connected ? 'Connected' : 'Disconnected',
        showArrow: false,
      );
    });
  }

  Widget _buildBatteryRow() {
    return Obx(() {
      final oxygen = bleController.bloodOxygen.value;

      return _infoRow(
        Icons.battery_full,
        'Battery',
        '$oxygen%',
        showArrow: false,
      );
    });
  }
}

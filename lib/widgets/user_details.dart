import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:vigil/widgets/page_trans.dart';

import 'add_user.dart' show AddUser;
import 'main_screen.dart'; // Real BLE connection status

class UserDetailPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final int userIndex;

  const UserDetailPage({
    Key? key,
    required this.userData,
    required this.userIndex,
  }) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Map<String, dynamic> _currentUserData;

  @override
  void initState() {
    super.initState();
    _currentUserData = Map<String, dynamic>.from(widget.userData);
  }

  // Polling stream to check live Bluetooth connection states on the phone
  Stream<List<BluetoothDevice>> _connectedDevicesStream() async* {
    while (mounted) {
      yield FlutterBluePlus.connectedDevices;
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  void _editProfile() async {
    // Navigates directly back into user setup view populated with state data modifications
    final Map<String, dynamic>? updatedData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddUser(initialData: _currentUserData),
      ),
    );

    if (updatedData != null) {
      setState(() {
        _currentUserData = updatedData;
      });
      // Pop modified metadata context bubble frame back up to main level dashboard map list
      Navigator.of(context).pop(_currentUserData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto = _currentUserData['image'] != null;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF64CDC6), Color(0xFF136A88)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // --- Header Row Elements ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // --- Curved Dynamic Content Container ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBFBFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Profile Intro Top Bar Badge Row ---
                        Row(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: hasPhoto ? Colors.grey[100] : null,
                                gradient: !hasPhoto
                                    ? const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF76D6FF),
                                          Color(0xFF3BA2FE),
                                        ],
                                      )
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: hasPhoto
                                    ? Image.file(
                                        _currentUserData['image'],
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.person_rounded,
                                        size: 55,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentUserData['name'] ?? "Ahmed Hassan",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: const [
                                      Text(
                                        "Status: ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        "Active",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00BFA5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // --- SECTION 1: Personal Information Card Section ---
                        const Text(
                          "Personal information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF136A88),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 12,
                        ),
                        const SizedBox(height: 8),

                        _buildInfoRowWithNavigation(
                          icon: Icons.person_rounded,
                          title: "Full Name",
                          value: _currentUserData['name'] ?? "Ahmed Hassan",
                        ),
                        _buildInfoRowWithNavigation(
                          icon: Icons.email_rounded,
                          title: "Email Address",
                          value: _currentUserData['email']?.isNotEmpty == true
                              ? _currentUserData['email']
                              : "Ahmed.Hassan@gmail.com",
                        ),

                        // Two column split element row for Phone & Age matching image schema perfectly
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildInfoRowWithoutNavigation(
                                icon: Icons.phone_rounded,
                                title: "Phone Number",
                                value:
                                    _currentUserData['phone']?.isNotEmpty ==
                                        true
                                    ? _currentUserData['phone']
                                    : "+201025289544",
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildInfoRowWithoutNavigation(
                                icon: Icons.spa_rounded,
                                title: "Age",
                                value:
                                    _currentUserData['age']?.isNotEmpty == true
                                    ? _currentUserData['age']
                                    : "48",
                              ),
                            ),
                          ],
                        ),

                        _buildInfoRowWithoutNavigation(
                          icon: Icons.male_rounded,
                          title: "Gender",
                          value: _currentUserData['gender'] ?? "Male",
                        ),

                        const SizedBox(height: 24),

                        // --- SECTION 2: Band Connected Information Section ---
                        const Text(
                          "Band connected information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF136A88),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 12,
                        ),
                        const SizedBox(height: 12),

                        // StreamBuilder injected here to handle Real-Time Connection Processing gracefully
                        StreamBuilder<List<BluetoothDevice>>(
                          stream: _connectedDevicesStream(),
                          builder: (context, snapshot) {
                            final List<BluetoothDevice> connectedDevices =
                                snapshot.data ?? [];
                            final bool isConnected =
                                connectedDevices.isNotEmpty;

                            // Calculate hardware-driven text values dynamic states
                            String bandDisplayId = "No band connected";
                            String connectionSubtitle = "Disconnected";
                            bool statusColorFlag = false;

                            if (isConnected) {
                              final BluetoothDevice firstDevice =
                                  connectedDevices.first;
                              final String realName =
                                  firstDevice.platformName.isNotEmpty
                                  ? firstDevice.platformName
                                  : "Smart Band v1.0";

                              bandDisplayId = realName.length > 5
                                  ? realName
                                        .substring(realName.length - 5)
                                        .toUpperCase()
                                        .replaceAll(" ", "")
                                  : "A037";
                              connectionSubtitle = "Connected";
                              statusColorFlag = true;
                            }

                            return Column(
                              children: [
                                _buildBandDataTile(
                                  icon: Icons.vibration_rounded,
                                  richTitle: RichText(
                                    text: TextSpan(
                                      text: 'Band ID: ',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: isConnected
                                              ? '#$bandDisplayId'
                                              : bandDisplayId,
                                          style: TextStyle(
                                            color: isConnected
                                                ? Colors.redAccent
                                                : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: connectionSubtitle,
                                  isStatusGreen: statusColorFlag,
                                ),

                                _buildBandDataTile(
                                  icon: Icons.access_time_filled_rounded,
                                  richTitle: const Text(
                                    "Status",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  subtitle: connectionSubtitle,
                                  isStatusGreen: statusColorFlag,
                                ),
                              ],
                            );
                          },
                        ),

                        // Keeping Dummy Data completely isolated strictly within Battery metric Tile layout row
                        _buildBandDataTile(
                          icon: Icons.battery_charging_full_rounded,
                          richTitle: RichText(
                            text: const TextSpan(
                              text: 'Battery: ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                              children: [
                                TextSpan(
                                  text: '82%',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: "",
                          isStatusGreen: false,
                        ),

                        const SizedBox(height: 32),

                        // --- Bottom Two Buttons Layout Row matching Figma Specs ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 1. See Profile Button -> Routes back to Main Screen Dashboard
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 44,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF64CDC6),
                                      Color(0xFF136A88),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      smoothTransition(
                                        MainScreen(initialIndex: 0),
                                      ),
                                    );
                                  }, // Goes back to main screen
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "See profile",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 2. Edit Profile Button
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 44,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF64CDC6),
                                      Color(0xFF136A88),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed: _editProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Edit profile",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRowWithNavigation({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF64CDC6).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF136A88)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black87,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithoutNavigation({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF64CDC6).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF136A88)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBandDataTile({
    required IconData icon,
    required Widget richTitle,
    required String subtitle,
    required bool isStatusGreen,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF64CDC6).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF136A88)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richTitle,
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (isStatusGreen) ...[
                        const Icon(
                          Icons.circle,
                          color: Color(0xFF00BFA5),
                          size: 10,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: isStatusGreen
                              ? const Color(0xFF00BFA5)
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

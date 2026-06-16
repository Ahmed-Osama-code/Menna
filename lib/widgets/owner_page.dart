import 'package:flutter/material.dart';
import 'package:vigil/widgets/add_user.dart';
import 'package:vigil/widgets/user_details.dart';

class OwnerPage extends StatefulWidget {
  const OwnerPage({Key? key}) : super(key: key);

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  // Starts completely empty as requested.
  final List<Map<String, dynamic>> _users = [];

  void _navigateToCreateUser() async {
    final Map<String, dynamic>? newUserData = await Navigator.of(context).push(

      MaterialPageRoute(builder: (context) => const AddUser()),
    );

    if (newUserData != null) {
      setState(() {
        _users.add(newUserData);
      });
    }
  }

  void _viewUserDetails(int index) async {
    // Navigate to details page and await possible edits back
    final Map<String, dynamic>? updatedUserData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailPage(
          userData: _users[index],
          userIndex: index,
        ),
      ),
    );

    // If edited, update the data in place
    if (updatedUserData != null) {
      setState(() {
        _users[index] = updatedUserData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "All users",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "All monitored persons on this phone",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // --- Content Sheet ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9F9FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: _users.isEmpty
                              ? _buildEmptyState()
                              : _buildUserList(),
                        ),

                        // --- Bottom Action Button ---
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            top: 16.0,
                            bottom: 32.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF64CDC6), Color(0xFF136A88)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF136A88).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _navigateToCreateUser,
                              icon: const Icon(Icons.add, size: 26, color: Colors.white),
                              label: const Text(
                                "ADD Another user",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "No Users Monitored Yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF606B75),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap 'ADD Another user' to register profiles for device tracking.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 24.0, left: 20.0, right: 20.0, bottom: 8.0),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        final bool hasPhoto = user['image'] != null;

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Avatar Frame - If user didn't add photo, show clean default blue profile circle
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasPhoto ? Colors.grey[100] : null,
                    gradient: !hasPhoto
                        ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF76D6FF), Color(0xFF3BA2FE)],
                    )
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(38),
                    child: hasPhoto
                        ? Image.file(user['image'], fit: BoxFit.cover)
                        : const Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? 'Unnamed Profile',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Text("Status: ", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00BFA5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Clickable right side diagnostic small arrow to enter detailed information page
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF136A88), size: 24),
                  onPressed: () => _viewUserDetails(index),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}
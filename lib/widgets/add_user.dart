import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../controllers/ble_controller.dart';

class AddUser extends StatefulWidget {
  // Accept existing user data if editing
  final Map<String, dynamic>? initialData;

  const AddUser({Key? key, this.initialData}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final BleController bleController = Get.find<BleController>();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;

  String? _selectedGender;
  String? _selectedBand;

  @override
  void initState() {
    super.initState();

    // Check if we are editing an existing user, otherwise use empty values
    final data = widget.initialData;

    _nameController = TextEditingController(text: data?['name'] ?? '');
    _emailController = TextEditingController(text: data?['email'] ?? '');
    _phoneController = TextEditingController(text: data?['phone'] ?? '');
    _ageController = TextEditingController(text: data?['age'] ?? '');
    _selectedGender = data?['gender'];
    _selectedBand = data?['band'];
    _selectedImage = data?['image'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Profile Image Source",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF136A88),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSourceOptionTile(
                      icon: Icons.camera_alt_rounded,
                      label: "Camera",
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    _buildSourceOptionTile(
                      icon: Icons.photo_library_rounded,
                      label: "Gallery",
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error selecting file photo resource: $e");
    }
  }

  Widget _buildSourceOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF64CDC6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF136A88)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _saveForm() {
    // 1. Full Name Validation Check
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Full name is required"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2. Email Validation Check
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email address is required"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 3. Phone Number Validation Check
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Phone number is required"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 4. Gender Validation Check
    if (_selectedGender == null || _selectedGender!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gender selection is required"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 5. Age Validation Check
    if (_ageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Age is required"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // All mandatory verification elements passed safely, complete transaction state context save pipeline mapping:
    Navigator.of(context).pop({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'gender': _selectedGender,
      'age': _ageController.text.trim(),
      'band': _selectedBand,
      'image': _selectedImage,
    });
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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Row(
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
                    const SizedBox(width: 16),
                    Text(
                      widget.initialData != null
                          ? "Edit User Profile"
                          : "Add New User",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: _selectedImage != null
                                        ? Image.file(
                                            _selectedImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFF76D6FF),
                                                  Color(0xFF3BA2FE),
                                                ],
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.person_rounded,
                                              size: 85,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: _showImageSourcePicker,
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Color(0xFF136A88),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildLabelRow(Icons.person_rounded, "Full Name"),
                        _buildInputField(
                          controller: _nameController,
                          hint: "Enter Full Name",
                        ),
                        _buildLabelRow(Icons.email_rounded, "Email"),
                        _buildInputField(
                          controller: _emailController,
                          hint: "Enter Your Email",
                          inputType: TextInputType.emailAddress,
                        ),
                        _buildLabelRow(Icons.phone_rounded, "Phone number"),
                        _buildInputField(
                          controller: _phoneController,
                          hint: "Enter Your phone number",
                          inputType: TextInputType.phone,
                        ),
                        _buildLabelRow(Icons.male_rounded, "Gender"),
                        _buildDropdownField(
                          hint: "Select Your Gender",
                          value: _selectedGender,
                          items: const ["Male", "Female"],
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                        ),
                        _buildLabelRow(Icons.spa_rounded, "Age"),
                        _buildInputField(
                          controller: _ageController,
                          hint: "Enter Your Age",
                          inputType: TextInputType.number,
                        ),
                        _buildLabelRow(null, "Paired Band"),
                        Obx(() {
                          final devicesList = bleController.scanResults;
                          if (devicesList.isEmpty) {
                            _selectedBand = null;
                            return _buildDisabledDropdownField(
                              hint: "No connected band",
                            );
                          }
                          final List<String> bandNames = devicesList.map((
                            result,
                          ) {
                            final name = result.device.platformName;
                            return name.isNotEmpty
                                ? name
                                : "Unknown Device (${result.device.remoteId.str.substring(result.device.remoteId.str.length - 4).toUpperCase()})";
                          }).toList();

                          if (_selectedBand != null &&
                              !bandNames.contains(_selectedBand)) {
                            _selectedBand = null;
                          }

                          return _buildDropdownField(
                            hint: "Select Your Band",
                            value: _selectedBand,
                            items: bandNames,
                            onChanged: (val) =>
                                setState(() => _selectedBand = val),
                          );
                        }),
                        const SizedBox(height: 32),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF64CDC6), Color(0xFF136A88)],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF136A88,
                                  ).withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _saveForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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

  Widget _buildLabelRow(IconData? icon, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0, left: 2.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 22, color: const Color(0xFF136A88)),
            const SizedBox(width: 8),
          ],
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
            size: 28,
          ),
          elevation: 2,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDisabledDropdownField({required String hint}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.bluetooth_disabled_rounded,
            color: Colors.grey,
            size: 22,
          ),
        ],
      ),
    );
  }
}

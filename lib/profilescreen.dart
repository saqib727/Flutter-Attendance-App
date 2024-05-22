import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/user.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  const ProfileScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  Color primary = const Color(0xffee444c);
  String birth = "Date of birth";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool _editable = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');
      final userSnapshot = await usersRef.where('id', isEqualTo: User.employeeId).get();
      final userId = userSnapshot.docs.first.id;

      final profileRef = usersRef.doc(userId).collection('profile');
      final profileSnapshot = await profileRef.get();
      if (profileSnapshot.docs.isNotEmpty) {
        final profileData = profileSnapshot.docs.first.data();
        setState(() {
          firstNameController.text = profileData['firstName'];
          lastNameController.text = profileData['lastName'];
          birth = profileData['birth'];
          addressController.text = profileData['address'];
        });
      }
    } catch (error) {
      print('Error loading profile data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),
            Align(
              child: Text(
                "Employee ID: ${User.employeeId}",
                style: TextStyle(
                  fontSize: 18,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
            const SizedBox(height: 24),
            textField("First Name", "Enter your first name", firstNameController),
            textField("Last Name", "Enter your last name", lastNameController),
            buildDateOfBirthField(),
            textField("Address", "Enter your address", addressController),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget textField(String title, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            cursorColor: primary,
            maxLines: 1,
            enabled: _editable,
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: widget.isDarkMode ? Colors.white70 : Colors.black54,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date of Birth",
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _editable ? _selectBirthDate : null,
          child: Container(
            height: 60,
            width: screenWidth,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                birth,
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectBirthDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        if (value != null) {
          birth = DateFormat("MM/dd/yyyy").format(value);
        }
      });
    });
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: _editable ? _handleSave : _toggleEditMode,
      style: ElevatedButton.styleFrom(
        primary: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      ),
      child: Text(
        _editable ? 'Save' : 'Update Info',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _editable = !_editable;
    });
  }

  void _handleSave() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String address = addressController.text;

    if (firstName.isEmpty || lastName.isEmpty || birth.isEmpty || address.isEmpty) {
      showSnackBar("All fields are required.");
    } else {
      _saveProfileData(firstName, lastName, birth, address);
      _toggleEditMode();
    }
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
      ),
    );
  }

  void _saveProfileData(String firstName, String lastName, String birth, String address) async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');
      final userSnapshot = await usersRef.where('id', isEqualTo: User.employeeId).get();
      final userId = userSnapshot.docs.first.id;

      final profileRef = usersRef.doc(userId).collection('profile');
      final profileSnapshot = await profileRef.get();

      if (profileSnapshot.docs.isNotEmpty) {
        final profileId = profileSnapshot.docs.first.id;
        await profileRef.doc(profileId).update({
          'firstName': firstName,
          'lastName': lastName,
          'birth': birth,
          'address': address,
        });
      } else {
        await profileRef.add({
          'firstName': firstName,
          'lastName': lastName,
          'birth': birth,
          'address': address,
        });
      }
    } catch (error) {
      print('Error saving profile data: $error');
    }
  }
}

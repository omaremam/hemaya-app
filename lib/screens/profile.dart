import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String name, userId, email, password;
  const Profile({
    super.key,
    required this.name,
    required this.userId,
    required this.email,
    required this.password,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // Controller for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Flag to track if the fields are in edit mode
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Name", nameController),
            _buildTextField("Email", emailController),
            _buildTextField("Phone Number", phoneController),
            _buildTextField("Password", passwordController, isPassword: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: isPassword,
                  readOnly: !isEditing,
                  decoration: InputDecoration(labelText: label),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
    );
  }
}

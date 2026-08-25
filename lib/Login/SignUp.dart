import 'package:charity/Login/Login.dart';
import 'package:charity/Login/Controller/signupController.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/Dashboard.dart';
import 'package:charity/widget/ReuseAblemap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? selectedRole;
  int selectedRoleId = 0;

  final Map<String, int> rolesMap = {
    "Donor": 5,
    "Donee": 6,
    "Rider": 7,
    // "Admin": 8,
  };

  double latitude = 31.5204;
  double longitude = 74.3587;

  void signUp() async {
    if (selectedRoleId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a role")));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    var response = await SignupController.signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      phoneNo: phoneController.text.trim(),
      roleId: selectedRoleId,
      latitude: latitude,
      longitude: longitude,
    );

    if (response["statusCode"] == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup Successful")));
      selectRole(selectedRole!);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response["body"]["Message"])));
    }
  }

  void selectRole(String role) {
    if (role == 'Donor') Get.to(LoginScreen());
    if (role == 'Donee') Get.to(LoginScreen());
    if (role == 'Admin') Get.to(SuperAdminDashboard());
    if (role == 'Rider') Get.to(LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F8F7A),
        title: const Text('Register', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'CREATE ACCOUNT',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              /// NAME
              TextField(
                controller: nameController,
                decoration: _inputDecoration('Full Name', Icons.person),
              ),
              const SizedBox(height: 20),

              /// EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email', Icons.email),
              ),
              const SizedBox(height: 20),

              /// PASSWORD
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: _passwordDecoration(
                  'Password',
                  _obscurePassword,
                  () => setState(() {
                    _obscurePassword = !_obscurePassword;
                  }),
                ),
              ),
              const SizedBox(height: 20),

              /// CONFIRM PASSWORD
              TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: _passwordDecoration(
                  'Confirm Password',
                  _obscureConfirmPassword,
                  () => setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  }),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration('Phone Number', Icons.phone),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedRole,
                hint: const Text('Select Role'),
                items: rolesMap.keys.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                    selectedRoleId = rolesMap[value]!;
                  });
                },
                decoration: _inputDecoration('Role', Icons.people),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReusableMap()),
                  );

                  if (result != null && result is LatLng) {
                    setState(() {
                      latitude = result.latitude;
                      longitude = result.longitude;
                    });
                  }
                },
                child: Text(
                  "Location Selected: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}",
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0F8F7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (selectedRole == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Select Role First")),
                      );
                      return;
                    }
                    signUp();
                    Get.to(LoginScreen());
                  },
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  InputDecoration _passwordDecoration(
    String label,
    bool obscure,
    VoidCallback toggle,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: toggle,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

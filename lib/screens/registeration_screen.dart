import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hemaya/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';

  bool isPasswordMatch = true;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> registerUser(String email, String password, String name) async {
    try {
      // Check if the email already exists in the "users" collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Email already exists, handle the error
        return false;
      }

      // Create a new document in the "users" collection with the user data
      await FirebaseFirestore.instance.collection('users').add({
        'email': email,
        'password': password,
        'name': name,
      });

      // Registration successful
      return true;
    } catch (e) {
      // Handle registration errors
      print('Registration failed: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  'assets/hemaya.png',
                  width: 170,
                  height: 170,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF009F98), Color(0xFF1281AE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                padding: const EdgeInsets.only(top: 20, bottom: 80),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        "إنشاء حساب",
                        style: TextStyle(color: Colors.white, fontSize: 24.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'إيميل المستخدم',
                            prefixIcon: Icon(Icons.email),
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'اسم المستخدم',
                            prefixIcon: Icon(Icons.person),
                          ),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            errorText: !isPasswordMatch
                                ? 'كلمة المرور غير متطابقة'
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          textAlign: TextAlign.right,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'تأكيد كلمة المرور',
                            prefixIcon: Icon(Icons.lock),
                            errorText: !isPasswordMatch
                                ? 'كلمة المرور غير متطابقة'
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              confirmPassword = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isPasswordMatch = password == confirmPassword;
                          });

                          if (isPasswordMatch) {
                            bool isRegistered =
                                await registerUser(email, password, name);

                            if (isRegistered) {
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Email already exists")));
                            }
                          }
                        },
                        child: const Text('تسجيل'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // loginWithEmailAndPassword(username, password); temporarly disabled for testing
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text('تسجيل الدخول'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

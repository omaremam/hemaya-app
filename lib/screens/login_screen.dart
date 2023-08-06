import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hemaya/screens/join_screen.dart';
import 'package:hemaya/screens/registeration_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  Future<Map<String, double>> getLocation() async {
    try {
      // Request permission to access the device's location
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle the case when the user denies the location permission
        print('Location permission denied.');
        return {'latitude': 0.0, 'longitude': 0.0};
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle the case when the user denies the location permission forever
        print(
            'Location permission denied forever. You need to enable it from settings.');
        return {'latitude': 0.0, 'longitude': 0.0};
      }

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.high, // You can choose the desired accuracy
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      print('Latitude: $latitude, Longitude: $longitude');
      return {'latitude': latitude, 'longitude': longitude};
    } catch (e) {
      print('Error getting location: $e');
      return {'latitude': 0.0, 'longitude': 0.0};
    }
  }

  Future<void> requestLocationPermission() async {
    // Check if the location permission is already granted
    if (await Permission.location.isGranted) {
      print('Location permission already granted.');
      return;
    }

    // Request the location permission
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      print('Location permission granted.');
    } else if (status.isDenied) {
      print('Location permission denied.');
    } else if (status.isPermanentlyDenied) {
      print(
          'Location permission permanently denied. You need to enable it from settings.');
    }
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // If user found, return the user data as a Map with the document ID added
      final userDoc = snapshot.docs.first;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      userData['id'] = userDoc.id;
      return userData;
    } else {
      // If no user found, return null
      return null;
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
                padding: const EdgeInsets.only(top: 50.0),
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
                padding: const EdgeInsets.only(top: 20, bottom: 160),
                child: Column(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "تسجيل الدخول",
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
                            prefixIcon: Icon(Icons.person),
                          ),
                          onChanged: (value) {
                            setState(() {
                              username = value;
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
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'كلمة المرور',
                            prefixIcon: Icon(Icons.lock),
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
                          horizontal: 20.0, vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic>? user =
                              await login(username, password);

                          if (user != null) {
                            // ignore: use_build_context_synchronously
                            await requestLocationPermission();
                            Map<String, double> position = await getLocation();
                            double? latitude = position["latitude"];
                            double? longitude = position["longitude"];
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JoinScreen(
                                      selfCallerId: user["id"],
                                      name: user["name"],
                                      lat: latitude,
                                      long: longitude)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Invalid user")));
                          }
                          // ignore: use_build_context_synchronously
                        },
                        child: const Text('تسجيل'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // loginWithEmailAndPassword(username, password); temporarly disabled for testing
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen()),
                          );
                        },
                        child: const Text('إنشاء حساب'),
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

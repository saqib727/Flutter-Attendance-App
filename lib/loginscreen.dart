import 'package:app/homescreen.dart';
import 'package:app/model/user.dart';
import 'package:app/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _supportState = false;

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
      (bool isSupported) {
        setState(() {
          _supportState = isSupported;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: screenHeight / 3.5,
            width: screenWidth,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(70),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: screenWidth / 5,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: screenHeight / 25,
              bottom: screenHeight / 20,
            ),
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: screenWidth / 20,
                fontFamily: "NexaBold",
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTitle("Personal ID"),
                customInputField("Enter your Personal ID", idController, false),
                customTitle("Password"),
                customInputField(
                  "Enter your Password",
                  passController,
                  true,
                  isPassword: true,
                ),
                GestureDetector(
                  onTap: () async {
                    await loginWithIdPassword();
                  },
                  child: Container(
                    height: 40,
                    width: screenWidth,
                    margin: EdgeInsets.only(top: screenHeight / 40),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: const Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: 17,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2),
                _supportState
                    ? GestureDetector(
                        onTap: () async {
                          await loginWithBiometrics();
                        },
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(top: screenHeight / 40),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.fingerprint,
                                  color:Colors.white,
                              )
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 2),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Make an Account!",
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: 15,
                        color: primary,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginWithIdPassword() async {
    String id = idController.text.trim();
    String password = passController.text.trim();

    if (id.isEmpty) {
      _showSnackbar("ID is still empty");
    } else if (password.isEmpty) {
      _showSnackbar("Password is still empty");
    } else {
      try {
        // Query Firestore for user credentials
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: id)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // User found, check password
          var user = querySnapshot.docs.first;
          final userId = querySnapshot.docs.first.id;

          String storedPassword = user.get('password');
          if (password == storedPassword) {
            // Password matched, navigate to HomeScreen
            User.employeeId = id;
            User.id = userId;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            _showSnackbar("Invalid password");
          }
        } else {
          _showSnackbar("User not found");
        }
      } catch (e) {
        _showSnackbar("Error: $e");
      }
    }
  }

  Future<void> loginWithBiometrics() async {
    String id = idController.text.trim();
    if (id.isEmpty) {
      _showSnackbar("Please enter your ID first");
      return;
    }

    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        // Perform login action (this example assumes one user, adjust accordingly)
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('users').where('id',isEqualTo: id).limit(1).get();

        if (querySnapshot.docs.isNotEmpty) {
          var user = querySnapshot.docs.first;
          final userId = querySnapshot.docs.first.id;

          String id = user.get('id');
          User.employeeId = id;
          User.id = userId;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          _showSnackbar("No user found for biometric login");
        }
      }
    } catch (e) {
      _showSnackbar("Authentication error: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget customTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }

  Widget customInputField(
    String hint,
    TextEditingController controller,
    bool obscure, {
    bool isPassword = false,
  }) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 8,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        )
                      : null,
                ),
                maxLines: 1,
                obscureText: isPassword ? !_isPasswordVisible : obscure,
              ),
            ),
          )
        ],
      ),
    );
  }
}

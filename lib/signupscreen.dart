import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/loginscreen.dart';
import 'package:local_auth/local_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(
            () {
          _supportState = isSupported;
        },
      ),
    );
  }

  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  bool _isPasswordVisible = false;

  Color primary = const Color(0xffeef444c);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
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
                  Icons.person_add,
                  color: Colors.white,
                  size: screenWidth / 5,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 29,
                bottom: screenHeight / 20,
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: screenWidth / 20,
                  fontFamily: "NexaBold",
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTitle("Personal ID"),
                  customInputField(
                    "Enter your Personal ID",
                    idController,
                    false,
                  ),
                  customTitle("Password"),
                  customInputField(
                    "Enter your Password",
                    passController,
                    true,
                    isPassword: true,
                  ),
                  customTitle("Confirm Password"),
                  customInputField(
                    "Confirm your Password",
                    confirmPassController,
                    true,
                    isPassword: true,
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () {
                      // Handle signup logic
                      signUp();
                    },
                    child: Container(
                      height: 50,
                      width: screenWidth,
                      margin: EdgeInsets.only(top: screenHeight / 40),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: const Center(
                        child: Text(
                          "SIGN UP",
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
                  const SizedBox(height: 2),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Center(
                      child: Text(
                        "Already have an account? Log In",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: 12,
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
      ),
    );
  }

  void signUp() async {
    String id = idController.text;
    String password = passController.text;
    String confirmPassword = confirmPassController.text;

    if (id.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("Please fill all fields!");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("Passwords do not match");
      return;
    }

    bool didAuthenticate = false;
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to sign up',

        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      _showSnackbar("Authentication error: $e");
      return;
    }

    if (!didAuthenticate) {
      _showSnackbar("Authentication failed");
      return;
    }

    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    try {
      DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc();
      await documentReference.set({
        'id': id,
        'password': password,
      });
      _showSnackbar("Sign up successful");

      // Redirect to login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      _showSnackbar("Error: $e");
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

  Widget customInputField(String hint, TextEditingController controller, bool obscure, {bool isPassword = false}) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(bottom: 8),
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
            width: screenWidth / 10,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth / 20,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 20),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 50,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                  suffixIcon: isPassword
                      ? IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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

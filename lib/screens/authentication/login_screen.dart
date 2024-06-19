import 'package:flutter/material.dart';
import 'package:pdc/core/constants.dart';
import 'package:pdc/screens/home/home_screen.dart';
import 'package:pdc/screens/widgets/custom_elevated_button.dart';
import 'package:pdc/screens/widgets/custom_text.dart';
import 'package:pdc/services/services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false; 

  // Function to validate credentials
  void _login() {
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Replace with your actual authentication logic
    if (username == 'pdc' && password == 'password') {
      Services().showCustomSnackBar(context, "Login Successful");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      Services().showCustomSnackBar(context, "Invalid username or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Login",
                      fontSize: 40,
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color(0xffA8A8A9),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: mainAppThemeColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffix: IconButton(
                          icon: Icon(
                            passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color(0xffA8A8A9),
                            width: 1,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: mainAppThemeColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    CustomElevatedButton(
                      height: 60,
                      width: double.infinity,
                      onPressed: _login,
                      backgroundColor: mainAppThemeColor.withOpacity(0.5),
                      label: "Login",
                      labelColor: Colors.white,
                      labelSize: 16,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

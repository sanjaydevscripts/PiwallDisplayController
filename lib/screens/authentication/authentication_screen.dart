import 'package:flutter/material.dart';
import 'package:pdc/core/constants.dart';
import 'package:pdc/screens/authentication/login_screen.dart';
import 'package:pdc/screens/widgets/custom_elevated_button.dart';
import 'package:pdc/screens/widgets/custom_text.dart';


class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 30,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Container(
              child: Image(
                image: AssetImage("lib/core/assets/images/seo.png"),
              ),
            ),
            Spacer(),
            CustomText(
              text: "PDC",
              fontSize: 24,
            ),
            CustomText(
              text: "Control Of Your Video Wall",
              fontSize: 18,
            ),
            SizedBox(height: 50),
            CustomElevatedButton(
              height: 50,
              width: 350,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              backgroundColor: mainAppThemeColor.withOpacity(0.5),
              label: "Login",
              labelColor: Colors.white,
              labelSize: 16,
            ),
          ],
        ),
      )),
    );
  }
}

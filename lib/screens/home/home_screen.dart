//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdc/core/constants.dart';
import 'package:pdc/screens/authentication/login_screen.dart';
import 'package:pdc/screens/video%20wall/wall.dart';
import 'package:pdc/screens/widgets/custom_elevated_button.dart';
import 'package:pdc/screens/widgets/custom_text.dart';
import 'package:pdc/services/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CustomText(
                    text: "Hey,\nUser!",
                    fontSize: 30,
                    fontweight: FontWeight.w600,
                  ),
                ),
                Spacer(),
         IconButton(
  icon: Icon(Icons.logout, size: 30),
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Implement sign-out functionality here
                // For example, you can call a sign-out method from your authentication provider
                // authProvider.signOut();
                // Close the dialog
                Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => LoginScreen()));
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  },
),

        ],
              
            ),
            SizedBox(height: 60),
            Flexible(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: mainAppThemeColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Your Devices",
                        fontColor: Colors.white,
                        fontSize: 20,
                      ),
                      SizedBox(height: 20),
                      CustomElevatedButton(
                        height: 40,
                        width: double.infinity,
                        radius: 15,
                        onPressed: () async{
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const ScreenWall()));

                        },
                        iconWidget: Icon(Icons.play_arrow_outlined),
                        backgroundColor: Colors.grey,
                        label: "Video Wall 1",
                        labelColor: Colors.black,
                        labelSize: 16,
                      ),
                      SizedBox(height: 10),
                      CustomElevatedButton(
                        height: 40,
                        width: double.infinity,
                        radius: 15,
                        onPressed: () {
                           Services().showCustomSnackBar(context, "Check for devices...");
                           Future.delayed(Duration(seconds: 2), () {
                          // This code will execute after a delay of 2 seconds
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const HomeScreen(),
      ),
    );

    // After navigation, you can show the second snack bar
    Services().showCustomSnackBar(context, "Device fetching Completed.");
  });
                        },
                        iconWidget: Icon(Icons.add),
                        backgroundColor: Colors.grey,
                        label: "Add device",
                        labelColor: Colors.black,
                        labelSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


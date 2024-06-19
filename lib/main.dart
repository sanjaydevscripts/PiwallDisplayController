import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdc/screens/authentication/authentication_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
   await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyA-c349EgsnDLNsKBGgW1ExvyMSAvog4VQ',
    appId: '1:354542246892:android:ef9a31cb627a93c442fec9',
    messagingSenderId: 'sendid',
    projectId: 'pdcdb-ed421',
    storageBucket: 'pdcdb-ed421.appspot.com',
  )
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthenticationScreen(),
    );
  }
}

import 'dart:developer';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pdc/core/constants.dart';
import 'package:pdc/screens/widgets/custom_elevated_button.dart';
import 'package:pdc/screens/widgets/custom_text.dart';
import 'package:pdc/upload/upload.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:dio/dio.dart';

class ScreenWall extends StatefulWidget {
  const ScreenWall({super.key});

  @override
  State<ScreenWall> createState() => _ScreenWallState();
}

class _ScreenWallState extends State<ScreenWall> {
  // Initialize Firebase Storage
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  List<String> videoNames = [];
  List<String> videoUrls = [];
  String serverurl = '';

  String changeTcpToHttp(String url) {
    if (url.startsWith('tcp://')) {
      return url.replaceFirst('tcp://', 'http://');
    }
    return url;
  }

    Future<void> getUrlFromFireStore() async {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('ngrok_tunnels').doc('flask_app').get();
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        log(data.toString());
        serverurl = changeTcpToHttp(data['tunnel_url']);
        listVideoNames(); // Call listVideoNames after serverurl is set
      } catch (e) {
        log('Error getting URL from Firestore: $e');
      }
    }

  void downloadVideo(String videoName) async {
    final url = 'http://192.168.1.5:5000/download_video';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({'video_name': videoName}),
    );

    if (response.statusCode == 200) {
      // Video downloaded successfully
      // You can now handle the downloaded video file
    } else {
      // Error occurred while downloading video
      print('Failed to download video: ${response.body}');
    }
  }

  void listVideoNames() async {
    try {
      // Get a reference to the root of the storage bucket
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('videos/');

      // List all items in the root directory
      firebase_storage.ListResult result = await ref.listAll();

      videoNames.clear();
      videoUrls.clear();

      // Loop through each item in the result with an index
      for (int i = 0; i < result.items.length; i++) {
        firebase_storage.Reference item = result.items[i];
        // Extract the name of the item (video)
        videoNames.add(item.name);
        // Generate the URL for the video
        String videoUrl = '$serverurl/play/video${i + 1}';
        videoUrls.add(videoUrl);
        // Print the item number and video name to the console
        log('video${i + 1}: ${item.name}');
      }

      setState(() {});
    } catch (e) {
      // Handle any errors that occur during the process
      log('Error listing video names: $e');
    }
  }

  void deleteFile(String name) async {
    firebase_storage.Reference storageRef = storage.ref().child('videos/');
    // Create a reference to the file to delete
    final desertRef = storageRef.child(name);
    // Delete the file
    await desertRef.delete();
    videoNames.clear();
    listVideoNames();
  }

  void playItVideo(int index) async{
    try {
      if (index >= 0 && index < videoUrls.length) {
        String url = videoUrls[index];
        log('Playing video from URL: $url');
        // Logic to play the video using the URL
        final dio = Dio();
        final response = await dio.get('$url');
        print(response.data);
        print('Video selected successfully');
      } else {
        log('Invalid video index: $index');
      }
    } catch (e) {
      log('Error playing video: $e');
    }
  }

  void playit() async {
    final dio = Dio();
    final response = await dio.get('$serverurl/p');
    print(response.data);
    print("hi play successfully");
  }

  void pauseit() async {
    final dio = Dio();
    final response = await dio.get('$serverurl/pause');
    print(response.data);
    print("hi pause successfully");
  }

  @override
  void initState() {
    super.initState();
    getUrlFromFireStore(); // Call only getUrlFromFireStore here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(""),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomText(
              text: "Video Wall 1",
              fontSize: 30,
              fontweight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomText(
              text: "ACTIVE",
              fontSize: 20,
              fontweight: FontWeight.w600,
              fontColor: Colors.green,
            ),
          ),
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
                    Expanded(
                        child: ListView.builder(
                            itemCount: videoNames.length,
                            itemBuilder: (context, index) {
                              return videoTile(index);
                            })),
                    CustomElevatedButton(
                      height: 40,
                      width: double.infinity,
                      radius: 15,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const ScreenUpload()));
                      },
                      iconWidget: const Icon(Icons.add),
                      backgroundColor: Colors.grey,
                      label: "Add Video",
                      labelColor: Colors.black,
                      labelSize: 16,
                    ),
                    const SizedBox(height: 25),
                    CustomElevatedButton(
                      height: 40,
                      width: double.infinity,
                      radius: 15,
                      onPressed: () {
                        playit();
                      },
                      iconWidget: const Icon(Icons.play_arrow),
                      backgroundColor: Colors.grey,
                      label: "Play video",
                      labelColor: Colors.black,
                      labelSize: 16,
                    ),
                    const SizedBox(height: 25),
                    CustomElevatedButton(
                      height: 40,
                      width: double.infinity,
                      radius: 15,
                      onPressed: () {
                        pauseit();
                      },
                      iconWidget: const Icon(Icons.pause),
                      backgroundColor: Colors.grey,
                      label: "Pause Video",
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
    );
  }

  Widget videoTile(int index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: GestureDetector(
          onLongPress: () => deleteFile(videoNames[index]),
          child: CustomElevatedButton(
            height: 40,
            width: double.infinity,
            radius: 15,
            onPressed: () {
              playItVideo(index);
            },
            backgroundColor: Colors.grey,
            label: videoNames[index],
            labelColor: Colors.black,
            labelSize: 16,
          ),
        ),
      );
}

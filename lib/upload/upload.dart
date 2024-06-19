import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdc/core/constants.dart';
import 'package:pdc/screens/widgets/custom_elevated_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pdc/services/services.dart';
import 'package:dio/dio.dart';

class ScreenUpload extends StatefulWidget {
  const ScreenUpload({super.key});

  @override
  State<ScreenUpload> createState() => _ScreenUploadState();
}

class _ScreenUploadState extends State<ScreenUpload> {
  FilePickerResult? result;
  TextEditingController fileNameController = TextEditingController();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;



  @override
  void initState() {
    super.initState();
    getUrlFromFireStore();
  }
 String url = '';

  String changeTcpToHttp(String url) {
    if (url.startsWith('tcp://')) {
      return url.replaceFirst('tcp://', 'http://');
    }
    return url;
  }
  void selectVideo() async {
    // TO SELECT VIDEO
    result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result!.files.first;
      fileNameController.text = file.name;
      setState(() {});
    }
  }

  void fetchit() async {
    final dio = Dio();
    final response =
        await dio.get('$url/download_videos');
    print(response.data);
    print("hi fetched succesfully");
  }

  void getUrlFromFireStore() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('ngrok_tunnels')
        .doc('flask_app')
        .get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    log(data.toString());
    // url = data['tunnel_url'];
    url = changeTcpToHttp(data['tunnel_url']);
  }

  void uploadVideo() async {
    if (result != null) {
      PlatformFile file = result!.files.first;

      // Get a reference to the location you want to upload to in Firebase Storage
      firebase_storage.Reference ref =
          storage.ref().child('videos/${file.name}');
      Services().showCustomSnackBar(context, "video uploading....");
      // Upload the file to Firebase Storage
      try {
        await ref.putFile(File(file.path!));

        // Once the upload is complete, you can do something like showing a success message
        log('File uploaded successfully');
        Services().showCustomSnackBar(context, "Video uploaded successfully");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Video uploaded successfully'),
        //   ),
        // );
      } catch (e) {
        // Handle any errors that occur during the upload process
        log('Error uploading file: $e');
        // ScaffoldMessenger.of(context).showSnackBar(         SnackBar(
        //     content: Text('Error uploading video: $e'),
        //   ),
        // );
      }
    } else {
      // Handle the case when no file is selected
      log('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(""),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                TextField(
                  controller: fileNameController,
                  decoration: const InputDecoration(
                    hintText: "select a video",
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
                const SizedBox(height: 25),
                CustomElevatedButton(
                  height: 40,
                  width: double.infinity,
                  radius: 15,
                  onPressed: () {
                    selectVideo();
                  },
                  iconWidget: const Icon(Icons.add),
                  backgroundColor: Colors.grey,
                  label: "Select Video",
                  labelColor: Colors.black,
                  labelSize: 16,
                ),
                const SizedBox(height: 25),
                CustomElevatedButton(
                  height: 60,
                  width: double.infinity,
                  onPressed: () {
                    uploadVideo();
                  },
                  backgroundColor: mainAppThemeColor.withOpacity(0.5),
                  label: "Upload",
                  labelColor: Colors.white,
                  labelSize: 16,
                ),
                const SizedBox(height: 25),
                CustomElevatedButton(
                  height: 60,
                  width: double.infinity,
                  onPressed: () {
                    fetchit();
                  },
                  backgroundColor: mainAppThemeColor.withOpacity(0.5),
                  label: "Sync",
                  labelColor: Colors.white,
                  labelSize: 16,
                ),
                //edit
                //  const SizedBox(height: 25),
                // CustomElevatedButton(
                //   height: 60,
                //   width: double.infinity,
                //   onPressed: () {
                //     playitone();
                //   },
                //   backgroundColor: mainAppThemeColor.withOpacity(0.5),
                //   label: "Play video1",
                //   labelColor: Colors.white,
                //   labelSize: 16,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

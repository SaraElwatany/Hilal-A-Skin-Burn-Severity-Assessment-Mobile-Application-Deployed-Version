import 'dart:io';
import 'package:gp_app/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/clinical_data.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// Define your global variables here
int navigate = 0; // Flag to navigate to the chat screen

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);
  @override
  State<CameraScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CameraScreen> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const LocalizationIcon(),

      // AppBar(
      //   title: const Text('Image'),

      // ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            imageFile == null
                ? Image.asset(
                    'assets/images/burn-care.webp',
                    height: 300.0,
                    width: 300.0,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.file(
                      imageFile!,
                      height: 300.0,
                      width: 300.0,
                      fit: BoxFit.fill,
                    )),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.storage,
                      Permission.camera,
                    ].request();
                    if (statuses[Permission.storage]!.isGranted &&
                        statuses[Permission.camera]!.isGranted) {
                      showImagePicker(context);
                    } else {
                      print('no permission provided');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fixedSize: const Size(140, 45),
                    backgroundColor: const Color.fromARGB(255, 29, 49, 78),
                  ),
                  child: Text(
                    S.of(context).select_image,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 255, 251, 251),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {

                      Navigator.of(context).push(MaterialPageRoute(
                          // builder: (ctx) => const ChatScreen()));
                          builder: (ctx) =>  
                          ClinicalDataScreen(),),); //edittt recieverID
                      // Check if nullableFile is not null before casting
                      if (imageFile != null) {
                        File nonNullableFile = imageFile as File;
                        sendImageToServer(nonNullableFile, context);
                      } else {
                        // Handle the case when nullableFile is null
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fixedSize: const Size(140, 45),
                      backgroundColor: const Color.fromARGB(255, 29, 49, 78),
                    ),
                    child: Text(
                      S.of(context).upload,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 255, 251, 251),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: const Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });
      navigate = await sendImageToServer(File(croppedFile.path), context);
/*       if (navigate == 1) {
        // Navigate to ChatScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const ChatScreen()),
        ); 
      }*/
      // reload();
    }
  }

}

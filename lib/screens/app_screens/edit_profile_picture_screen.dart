import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/profile_picture.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class EditProfilePictureScreen extends StatefulWidget {
  @override
  _EditProfilePictureScreenState createState() =>
      _EditProfilePictureScreenState();
}

enum ImageSelected { currentImage, defaultImage, newImage }

class _EditProfilePictureScreenState extends State<EditProfilePictureScreen> {
  final ImagePicker imagePicker = ImagePicker();
  double imageRadius = 60;
  ImageSelected imageSelected = ImageSelected.currentImage;

  File _image;

  Future getImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);
    if (pickedFile == null) return;
    setState(() {
      imageSelected = ImageSelected.newImage;
      _image = File(pickedFile.path);
    });
  }

  CircleAvatar _getAvatar(String profilePicURL) {
    switch (imageSelected) {
      case ImageSelected.newImage:
        return CircleAvatar(
          radius: this.imageRadius,
          backgroundImage: FileImage(_image),
        );
      case ImageSelected.defaultImage:
        return CircleAvatar(
          radius: this.imageRadius,
          backgroundImage: AssetImage(
            'assets/images/userDefaultProfilePicture.png',
          ),
        );
      case ImageSelected.currentImage:
        return CircleAvatar(
          radius: this.imageRadius,
          child: ProfilePicture(
            profilePicURL,
            radius: this.imageRadius,
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return ModalProgressHUD(
          inAsyncCall: data.showLoadingScreen,
          progressIndicator: SpinKitChasingDots(
            color: Theme.of(context).accentColor,
          ),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getAvatar(data.profilePicURL),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            iconSize: 40,
                            color: Colors.grey[300],
                            onPressed: () => getImage(ImageSource.camera),
                          ),
                          IconButton(
                            icon: Icon(Icons.photo),
                            iconSize: 40,
                            color: Colors.grey[300],
                            onPressed: () => getImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      return RoundedButton(
                        text: "Upload Picture",
                        onPressed: () async {
                          if (_image != null) {
                            data.startLoadingScreen();
                            await data.updateProfilePicture(newImage: _image);
                            await _image.delete();
                            Navigator.pop(context);
                            data.stopLoadingScreen();
                          } else
                            Functions.showSnackBar(
                                context, "Please Select an Image !");
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10.0),
                  Builder(
                    builder: (context) {
                      return RoundedButton(
                        text: "Remove Picture",
                        onPressed: () async {
                          if (data.profilePicURL != kDefaultProfilePictureURL) {
                            data.startLoadingScreen();
                            await data.removeProfilePicture();
                            Navigator.pop(context);
                            data.stopLoadingScreen();
                          } else {
                            Functions.showSnackBar(context,
                                "Profile picture is already removed !");
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

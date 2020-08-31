import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/exceptions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email, _password, _firstName, _lastName;
  final ImagePicker imagePicker = ImagePicker();
  bool imageSelected = false;
  File _image;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future getImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);
    if (pickedFile == null) return;
    setState(() {
      imageSelected = true;
      _image = File(pickedFile.path);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return ModalProgressHUD(
          progressIndicator: SpinKitChasingDots(
            color: Theme.of(context).accentColor,
          ),
          inAsyncCall: data.showLoadingScreen,
          child: SafeArea(
            child: Scaffold(
              body: Center(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: imageSelected
                                ? FileImage(_image)
                                : AssetImage(
                              'assets/images/userDefaultProfilePicture.png',
                            ),
                            radius: 60,
                          ),
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
                      SizedBox(height: 30.0),
                      MyTextField(
                        labelText: "First Name",
                        controller: _firstNameController,
                        showTrailingWidget: false,
                        autofocus: true,
                        validator: (String firstName) {
                          if (firstName == null || firstName.trim() == "")
                            return "Please Enter First Name";

                          return null;
                        },
                        onChanged: (String firstName) {
                          _firstName =
                              Functions.capitalizeFirstLetter(firstName);
                        },
                      ),
                      SizedBox(height: 5.0),
                      MyTextField(
                        labelText: "Last Name",
                        controller: _lastNameController,
                        validator: (String lastName) {
                          if (lastName == null || lastName.trim() == "")
                            return "Please Enter Last Name";

                          return null;
                        },
                        showTrailingWidget: false,
                        onChanged: (String lastName) {
                          _lastName = Functions.capitalizeFirstLetter(lastName);
                        },
                      ),
                      SizedBox(height: 5.0),
                      MyTextField(
                        labelText: "Email",
                        controller: _emailController,
                        showTrailingWidget: false,
                        validator: (String email) {
                          if (email == null || email.trim() == "")
                            return "Please Enter Email";
                          else if (!(email.contains(".") &&
                              email.contains("@"))) return "Invalid Email";

                          return null;
                        },
                        onChanged: (String email) {
                          _email = email.trim().toLowerCase();
                        },
                      ),
                      SizedBox(height: 5.0),
                      MyTextField(
                        labelText: "Password",
                        controller: _passwordController,
                        validator: (String password) {
                          if (password == null || password.trim() == "")
                            return "Please Enter Password";
                          return null;
                        },
                        onChanged: (String password) {
                          _password = password;
                        },
                      ),
                      Builder(
                        builder: (context) {
                          return RoundedButton(
                            text: "Register",
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                Functions.popKeyboard(context);
                                data.startLoadingScreen();

                                bool registerSuccessful;

                                try {
                                  registerSuccessful =
                                  await FirebaseUtils.registerUser(
                                    _email,
                                    _password,
                                    fullName: "$_firstName $_lastName",
                                    image: _image,
                                  );

                                  if (registerSuccessful) {
                                    _firstNameController.clear();
                                    _lastNameController.clear();
                                    _emailController.clear();
                                    _passwordController.clear();
                                    setState(() {
                                      imageSelected = false;
                                    });
                                    await _image.delete();
                                    Functions.showSnackBar(
                                        context, "Verification Email Sent !");
                                  } else {
                                    Functions.showSnackBar(context,
                                        'Registering New User Failed !');
                                  }
                                } on RegisterException catch (e) {
                                  Functions.showSnackBar(context, e.message,
                                      duration: Duration(seconds: 3));
                                } catch (e) {
                                  print("REGISTER EXCEPTION : ${e.message}");
                                }

                                data.stopLoadingScreen();
                              }
                            },
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text("Login?"),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.id);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

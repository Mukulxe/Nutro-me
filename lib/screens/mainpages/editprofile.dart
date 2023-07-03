import 'dart:io';

import 'package:nutrome_user/screens/dashboards/home_screen.dart';
import 'package:nutrome_user/screens/mainpages/edit_address.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final bool firstTime;
  const EditProfile({Key? key, required this.firstTime}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  String name = '';
  String email = '';
  String phone = '';
  bool buttonTapped = false;

  void updateUserData() {
    unfocus();
    setState(() {
      buttonTapped = true;
    });
    if (nameController.text.isEmpty) {
      return;
    } else if (phoneController.text.isEmpty) {
      return;
    } else if (emailController.text.isEmpty) {
      return;
    }
    UserDB().addUserData(nameController.text, phoneController.text,
        emailController.text, context, widget.firstTime);
    if (widget.firstTime) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EditAddress(firstTime: true)),
          (route) => false);
    }
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  unfocus() {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void fetchUserData() async {
    try {
      nameController.text = UserSharedPreferences.getUserName();
      emailController.text = UserSharedPreferences.getUserEmail();
      phoneController.text = UserSharedPreferences.getUserPhone();
    } on Exception catch (_) {
      nameController.text = '';
      emailController.text = '';
      phoneController.text =
          FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    } catch (error) {
      nameController.text = '';
      emailController.text = '';
      phoneController.text =
          FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    }
  }

  @override
  void initState() {
    setState(() {
      fetchUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            if (widget.firstTime) {
              exit(0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text("Skip", style: TextStyle(color: Colors.white))),
          SizedBox(
            width: 10,
          ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 22, color: Theme.of(context).colorScheme.onTertiary),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (widget.firstTime) {
            exit(0);
          } else {
            Navigator.pop(context);
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EditProfileRow(
                    title: "Name",
                    buttonTapped: buttonTapped,
                    editingController: nameController,
                    placeholder: "e.g John Taylor"),
                EditProfileRow(
                    title: "Email",
                    buttonTapped: buttonTapped,
                    editingController: emailController,
                    placeholder: "e.g xyzabc@gmail.com"),
                EditProfileRow(
                    title: "Phone",
                    buttonTapped: buttonTapped,
                    editingController: phoneController,
                    placeholder: "e.g 77XXXXXXXX"),
                SizedBox(
                  height: 30,
                ),
                Button("Update", () {
                  updateUserData();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditProfileRow extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextEditingController editingController;
  final bool buttonTapped;
  const EditProfileRow(
      {Key? key,
      required this.title,
      required this.editingController,
      required this.buttonTapped,
      required this.placeholder})
      : super(key: key);

  @override
  State<EditProfileRow> createState() => _EditProfileRowState();
}

class _EditProfileRowState extends State<EditProfileRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: widget.editingController,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 88, 88, 88),
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: InputBorder.none,
            errorText: widget.buttonTapped
                ? widget.editingController.text.isEmpty
                    ? "Can't be empty"
                    : null
                : null,
            hintStyle: TextStyle(fontWeight: FontWeight.w700),
            suffixIcon: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
          ),
        ),
        Container(
          height: 1.5,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

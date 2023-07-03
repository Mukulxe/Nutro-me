import 'package:nutrome_user/screens/auth/otp.dart';
import 'package:nutrome_user/screens/auth/privacy_policy.dart';
import 'package:nutrome_user/screens/auth/terms_of_service.dart';
import 'package:nutrome_user/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nutrome_user/widgets/snackbar_toast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController number = TextEditingController();
  String countryCode = "91";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Welcome to NutroMe",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log in to your account.",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    IntlPhoneField(
                      initialCountryCode: "IN",
                      controller: number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (phone) {},
                      onCountryChanged: (country) {
                        countryCode = country.dialCode.toString();
                      },
                    ),
                    Text(
                      "You will recieve an sms verification for login.",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Button("GET OTP", () {
                      if (number.text.isEmpty) {
                        CustomToast().showToast(context, "Inavlid No.", true);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Otp(
                                  mobileNo:
                                      "+$countryCode${number.text.trim()}",
                                )),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const Text(
              "By Continuing,You Agree To Our",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TermsOfService())),
                      child: Text(
                        "Terms of Service",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.blue),
                      )),
                  Text(" & "),
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy())),
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.blue),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

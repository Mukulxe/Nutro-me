import 'package:nutrome_user/screens/dashboards/home_screen.dart';
import 'package:nutrome_user/screens/onboarding/welcome_screen1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Otp extends StatefulWidget {
  final String mobileNo;
  const Otp({Key? key, required this.mobileNo}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late String _verificationCode;
  get verificationFailed => null;
  String timer = "";
  String otp = "";
  TextEditingController otpController = TextEditingController();
  CountdownTimerController controller = CountdownTimerController(
      endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 120);
  bool firstTime = false;

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.mobileNo,
      verificationCompleted: (PhoneAuthCredential credentials) async {
        await FirebaseAuth.instance
            .signInWithCredential(credentials)
            .then((value) async {
          if (value.user != null) {
            if (value.additionalUserInfo!.isNewUser) {
              firstTime = true;
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        firstTime ? Boarding1() : HomeScreen()),
                (Route route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        FocusScope.of(context).unfocus();
        final snackBar =
            SnackBar(content: Text("Captcha Verification Failed!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      codeSent: (String verificatioID, int? resendToken) {
        setState(() {
          _verificationCode = verificatioID;
        });
      },
      codeAutoRetrievalTimeout: (String verificatioID) {
        setState(() {
          _verificationCode = verificatioID;
        });
      },
    );
  }

  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/mobile.png')),
              SizedBox(
                height: 30,
              ),
              Text(
                "We have sent a 6 digit code to \n${widget.mobileNo}",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter 6-Digit Otp",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: PinCodeTextField(
                  onSubmitted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        if (value.user != null) {
                          if (value.additionalUserInfo!.isNewUser) {
                            firstTime = true;
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      firstTime ? Boarding1() : HomeScreen()),
                              (Route route) => false);
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      final snackBar =
                          SnackBar(content: const Text('Invalid Otp!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 6) {
                      return "Enter all 6 digits!";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    inactiveFillColor: Colors.white,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    borderWidth: 0,
                    errorBorderColor: Colors.red,
                    selectedColor: Colors.transparent,
                    selectedFillColor: Colors.white,
                    inactiveColor: Colors.transparent,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        if (value.user != null) {
                          if (value.additionalUserInfo!.isNewUser) {
                            firstTime = true;
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      firstTime ? Boarding1() : HomeScreen()),
                              (Route route) => false);
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      final snackBar =
                          SnackBar(content: const Text('Invalid Otp!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      otp = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CountdownTimer(
                onEnd: () {},
                controller: controller,
                widgetBuilder: (_, CurrentRemainingTime? time) {
                  if (time == null) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Didn’t you receive the OTP? "),
                          InkWell(
                            onTap: () {
                              _verifyPhone();
                              controller.start();
                            },
                            child: Text(
                              "Resend Otp",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ]);
                  }
                  String seconds;
                  String minutes;
                  if (time.sec.toString().length == 1) {
                    seconds = "0" + time.sec.toString();
                  } else if (time.sec == null) {
                    seconds = "00";
                  } else {
                    seconds = time.sec.toString();
                  }
                  if (time.min.toString().length == 1) {
                    minutes = "0" + time.min.toString();
                  } else if (time.min == null) {
                    minutes = "00";
                  } else {
                    minutes = time.min.toString();
                  }
                  return Text(
                    "Didn’t you receive the OTP? Resend OTP in $minutes:$seconds",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

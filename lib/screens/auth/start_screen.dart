import 'package:nutrome_user/screens/auth/login.dart';
import 'package:nutrome_user/widgets/buttons.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/nutrome.png',
            height: 200,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "Nutro Me",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40),
            child: Text(
              '''Enjoy Homemade Food \nAt Your Fingertips.''',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Button("Continue", () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }),
          )
        ],
      ),
    );
  }
}

import 'package:nutrome_user/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PurchaseFailed extends StatefulWidget {
  final bool isMeal;
  const PurchaseFailed({Key? key, required this.isMeal}) : super(key: key);

  @override
  State<PurchaseFailed> createState() => _PurchaseFailedState();
}

class _PurchaseFailedState extends State<PurchaseFailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("assets/failed.json",
                  width: MediaQuery.of(context).size.width * 0.8,
                  repeat: false),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Payment Failed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "If the Amount has been deducted from your then you can contact us from the Help & Support section of the app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Button("Continue", () {
                Navigator.of(context)..pop();
              }),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

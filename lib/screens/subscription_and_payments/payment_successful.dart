import 'package:nutrome_user/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PurchaseSuccessful extends StatefulWidget {
  const PurchaseSuccessful({Key? key}) : super(key: key);

  @override
  State<PurchaseSuccessful> createState() => _PurchaseSuccessfulState();
}

class _PurchaseSuccessfulState extends State<PurchaseSuccessful> {
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
              Lottie.asset("assets/success.json",
                  width: MediaQuery.of(context).size.width * 0.8,
                  repeat: false),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Payment Successful!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Congratulations for your awesome purchase.You can view your current plan details in Subscriptions Screen.",
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

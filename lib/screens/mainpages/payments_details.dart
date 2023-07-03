import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentsDetails extends StatefulWidget {
  final String paymentId;
  final String paymentStatus;
  final String paymentTime;
  final String productType;
  final String productId;
  final double ammount;
  const PaymentsDetails({
    Key? key,
    required this.paymentId,
    required this.paymentStatus,
    required this.paymentTime,
    required this.productId,
    required this.productType,
    required this.ammount,
  }) : super(key: key);

  @override
  State<PaymentsDetails> createState() => _PaymentsDetailsState();
}

class _PaymentsDetailsState extends State<PaymentsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.paymentStatus.toLowerCase().contains("success")
                  ? Lottie.asset("assets/success.json", repeat: false)
                  : Lottie.asset("assets/failed.json", repeat: false),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: widget.paymentStatus.toLowerCase().contains("success")
                    ? Text(
                        "Payment Successful!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "Payment Failed!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SelectableText(
                      "Payment Id : ${widget.paymentId}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    SelectableText(
                      "Product ID : ${widget.productId}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SelectableText(
                      "Payment Time : ${widget.paymentTime.substring(11, 19)}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    SelectableText(
                      "Payment Date : ${widget.paymentTime.substring(0, 10)}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    SelectableText(
                      "Amount : ₹${widget.ammount}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    SelectableText(
                      "Product Type : ${widget.productType}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

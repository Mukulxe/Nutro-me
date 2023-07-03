import 'package:nutrome_user/screens/mainpages/payments_details.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/widgets/error.dart';
import "package:flutter/material.dart";
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

class PaymentsList extends StatefulWidget {
  const PaymentsList({Key? key}) : super(key: key);

  @override
  State<PaymentsList> createState() => _PaymentsListState();
}

class _PaymentsListState extends State<PaymentsList> {
  Iterable<Map<String, dynamic>>? data = ({});
  Widget placeHolder = Center(child: CircularProgressIndicator());
  bool connectionState = true;

  void checkConnection() async {
    connectionState = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  void getPayments() async {
    data = await PaymentHistoryDB().getPaymentsHistory();
    if (!mounted) {
      return;
    }
    setState(() {
      if (data!.isEmpty) {
        placeHolder = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Lottie.asset("assets/no_blue.json", height: 100),
              ),
              SizedBox(
                height: 15,
              ),
              Text("No Payments yet!"),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void initState() {
    checkConnection();
    getPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Payments History",
          style: TextStyle(
              fontSize: 22, color: Theme.of(context).colorScheme.onTertiary),
        ),
      ),
      body: connectionState
          ? data == null || data!.isEmpty
              ? placeHolder
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (BuildContext context, int position) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentsDetails(
                                          paymentId: data?.elementAt(
                                              position)["paymentId"],
                                          paymentStatus: data?.elementAt(
                                              position)["paymentStatus"],
                                          paymentTime: data?.elementAt(
                                              position)["paymentTime"],
                                          productId: data?.elementAt(
                                              position)["productId"],
                                          productType: data?.elementAt(
                                              position)["productType"],
                                          ammount: data
                                              ?.elementAt(position)["ammount"],
                                        )));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    data
                                            ?.elementAt(
                                                position)["paymentStatus"]
                                            .contains("success")
                                        ? Icon(
                                            Icons.done,
                                            size: 50,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        : Icon(
                                            Icons.error_outline,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        data
                                                ?.elementAt(
                                                    position)["paymentStatus"]
                                                .contains("success")
                                            ? Text(
                                                "Payment Successful!",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : Text(
                                                "Payment Failed!",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            "${data?.elementAt(position)['paymentTime'].toString().substring(0, 19)}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
          : ErrorOccured(),
    );
  }
}

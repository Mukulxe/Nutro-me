import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackMeal extends StatefulWidget {
  final String orderId;
  const TrackMeal({Key? key, required this.orderId}) : super(key: key);

  @override
  State<TrackMeal> createState() => _TrackMealState();
}

class _TrackMealState extends State<TrackMeal> {
  int currentstep = 0;
  List<bool> active = [false, false, false, false];
  DocumentSnapshot<Map<String, dynamic>>? orderData;
  String? orderStatus,
      orderTime,
      mealName,
      mealCost,
      imgUrl,
      deliveryAddress,
      deliveryBoyDetails,
      deliveredTime,
      dispatchedTime,
      preparingTime,
      receivedTime,
      otp;

  @override
  void initState() {
    print(DateTime.now().toString());
    super.initState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrderDetails() async {
    var snapshot;
    try {
      snapshot = await FirebaseFirestore.instance
          .collection("UserOrders")
          .doc(widget.orderId)
          .get();
      orderData = snapshot;
    } on Exception catch (ex) {
      print(ex.runtimeType);
    } catch (error) {
      print(error.runtimeType);
    }
    if (mounted) {
      setState(() {});
    }
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Track Your Order",
          style: TextStyle(
              fontSize: 22, color: Theme.of(context).colorScheme.onTertiary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            builder: (ctx, snapshot) {
              if (orderData == null) {
                return Column(
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }
              orderStatus = orderData!.data()!["orderStatus"];
              orderTime = orderData!.data()!["orderTime"];
              mealName = orderData!.data()!["mealName"];
              mealCost = orderData!.data()!["orderCost"];
              deliveryAddress = orderData!.data()!["deliveryAddress"];
              deliveryBoyDetails = orderData!.data()!["deliveryBoyDetails"];
              otp = orderData!.data()!["otp"];
              imgUrl = orderData!.data()!["imgUrl"];
              deliveredTime = orderData!.data()!["deliveredTime"];
              dispatchedTime = orderData!.data()!["dispatchedTime"];
              receivedTime = orderData!.data()!["receivedTime"];
              preparingTime = orderData!.data()!["preparingTime"];
              if (orderStatus!.toLowerCase().contains("received")) {
                currentstep = 0;
                active = [true, false, false, false];
              } else if (orderStatus!.toLowerCase().contains("preparing")) {
                currentstep = 1;
                active = [true, true, false, false];
              } else if (orderStatus!.toLowerCase().contains("dispatched")) {
                currentstep = 2;
                active = [true, true, true, false];
              } else if (orderStatus!.toLowerCase().contains("delivered")) {
                currentstep = 3;
                active = [true, true, true, true];
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                mealName!.split("*").first,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                mealName!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "₹ $mealCost",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: imgUrl!,
                            height: 80,
                            fit: BoxFit.cover,
                            width: 80,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Stepper(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      currentStep: currentstep,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails c) {
                        return Center();
                      },
                      steps: [
                        Step(
                          title: Text(
                            'Order Received',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: active[0]
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                          //   child: Text(receivedTime == " "
                          //       ? " "
                          //       : "[${receivedTime!.substring(0, 19).replaceAll(" ", " | ")}]"),
                          // ),
                          content: Text(
                            'Order Has Been Confirmed By The Chef.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: active[0]
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          isActive: active[0],
                        ),
                        Step(
                          title: Text(
                            'Preparing Your Order',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: active[1]
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                          //   child: Text(preparingTime == " "
                          //       ? " "
                          //       : "[${preparingTime!.substring(0, 19).replaceAll(" ", " | ")}]"),
                          // ),
                          content: Text(
                            'Your Order Is Being Cooked By Our Chef.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: active[1]
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          isActive: active[1],
                        ),
                        Step(
                          title: Text(
                            'Order Dispatched',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: active[2]
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // subtitle: Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                          //   child: Text(dispatchedTime == " "
                          //       ? " "
                          //       : "[${dispatchedTime!.substring(0, 19).replaceAll(" ", " | ")}]"),
                          // ),
                          content: Text(
                            'Your Order Has Been Handed Over To Our Delivery Partner : $deliveryBoyDetails',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: active[2]
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          isActive: active[2],
                        ),
                        Step(
                          title: Text(
                            'Delivered',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: active[3]
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                          //   child: Text(deliveredTime == " "
                          //       ? " "
                          //       : "[${deliveredTime!.substring(0, 19).replaceAll(" ", " | ")}]"),
                          // ),
                          content: Text(
                            'You Order Has Been Delivered To You!\nEnjoy! ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: active[3]
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          state: StepState.complete,
                          isActive: active[3],
                        ),
                      ],
                      type: StepperType.vertical,
                      onStepTapped: (step) {
                        setState(() {
                          currentstep = step;
                        });
                      },
                      onStepContinue: () {
                        setState(() {
                          if (currentstep < 4 - 1) {
                            currentstep = currentstep + 1;
                          } else {
                            currentstep = 0;
                          }
                        });
                      },
                      onStepCancel: () {
                        setState(() {
                          if (currentstep > 0) {
                            currentstep = currentstep - 1;
                          } else {
                            currentstep = 0;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      "Order ${widget.orderId}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  orderStatus!.contains("delivered")
                      ? SizedBox(
                          height: 0,
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: SelectableText(
                            "OTP : ${otp!}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Delivery Address",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$deliveryAddress",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Order Status",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$orderStatus",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Order Time",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${orderTime!.substring(0, 10)} | ${orderTime!.substring(11, 19)}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
            future: getOrderDetails(),
          ),
        ),
      ),
    );
  }
}

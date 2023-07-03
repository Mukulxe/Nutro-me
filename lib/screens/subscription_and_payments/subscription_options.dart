import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutrome_user/screens/subscription_and_payments/buy_subscription.dart';
import 'package:nutrome_user/utility/data_models.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/snackbar_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/current_plan_card.dart';

class SubscriptionOptions extends StatefulWidget {
  const SubscriptionOptions({
    Key? key,
  }) : super(key: key);

  @override
  State<SubscriptionOptions> createState() => _SubscriptionOptionsState();
}

class _SubscriptionOptionsState extends State<SubscriptionOptions> {
  String? userCurrentPlanEndTime;
  String? userCurrentPlanName;
  String? userCurrentPlanId;
  DateTime? currentPlanEndTime;
  double? actualCostSilver7;
  double? actualCostSilver15;
  double? discountSilver7;
  double? discountSilver15;
  String? offerName;
  bool? offer;
  String? offerBanner;
  OfferModel? offerModel;
  bool planDataLoaded = false;

  void loadOffer() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> offerData = await FirebaseFirestore
          .instance
          .collection("Offer")
          .doc("offer")
          .get();
      offer = offerData["enabled"];
      actualCostSilver7 = offerData["actualCostSilver7"].toDouble();
      actualCostSilver15 = offerData["actualCostSilver15"].toDouble();
      discountSilver7 = offerData["discountSilver7"].toDouble();
      discountSilver15 = offerData["discountSilver15"].toDouble();
      offerName = offerData["offerName"].toString();
    } catch (_) {}
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> loadCurrentPlan() async {
    var snapshot;
    try {
      snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .collection("SubscriptionPlans")
          .doc("subscriptionPlanDetails")
          .get();
      userCurrentPlanId = await snapshot.data()!["id"];
      userCurrentPlanName = await snapshot.data()!["planName"];
      userCurrentPlanEndTime = await snapshot.data()!["planEndTime"];
      currentPlanEndTime = DateTime.parse(userCurrentPlanEndTime!);
      DateTime currentTime = DateTime.now();
      if (currentTime.isAfter(currentPlanEndTime!)) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection("SubscriptionPlans")
            .doc("subscriptionPlanDetails")
            .delete();
        userCurrentPlanId = null;
      }
    } on Exception catch (ex) {
      print(ex.runtimeType);
    } catch (error) {
      print(error.runtimeType);
    }
    planDataLoaded = true;
    if (mounted) {
      setState(() {});
    }
    return snapshot;
  }

  @override
  void initState() {
    loadCurrentPlan();
    loadOffer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Subscription Plans",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                "Active Plan",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 74, 74)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FutureBuilder(
                builder: (ctx, snapshot) {
                  if (userCurrentPlanId == null) {
                    return planDataLoaded
                        ? CurrentSubscriptionCard(planActive: false)
                        : Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 90.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                  } else {
                    DateTime now = DateTime.now();
                    int hoursLeft = (DateTime.parse(userCurrentPlanEndTime!)
                            .difference(now))
                        .inHours;
                    return planDataLoaded
                        ? CurrentSubscriptionCard(
                            planName: userCurrentPlanName,
                            planEndTime: userCurrentPlanEndTime,
                            daysLeft: hoursLeft,
                            planActive: true,
                          )
                        : Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 90.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                  }
                },
                future: loadCurrentPlan(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Available Plans",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 74, 74)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: InkWell(
                onTap: () {
                  if (actualCostSilver7 == null) {
                    CustomToast().showToast(context, "loading...", false);
                    return;
                  }
                  if (userCurrentPlanId != null) {
                    CustomToast()
                        .showToast(context, "You Have A Plan Already!", false);
                    return;
                  }
                  if (!UserSharedPreferences.getPostalCode()
                      .contains(UserSharedPreferences.getAreaAvailable())) {
                    AlertDialog alert = AlertDialog(
                      title: Text("Confirm Order"),
                      content: Text("Currently Not Avaiable in Your Area."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                      ],
                    ); // show
                    showDialog(context: context, builder: ((context) => alert));
                    return;
                  }
                  OfferModel offerModel = OfferModel(
                      offer!,
                      actualCostSilver7!,
                      actualCostSilver15!,
                      discountSilver7!,
                      discountSilver15!,
                      offerName!);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuySubscription(
                                planName: "Silver",
                                offerModel: offerModel,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            HexColor("#24302e"),
                            HexColor("#24443b"),
                            HexColor("#2c443c"),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.asset("assets/layer1.png"),
                          Positioned(
                            top: -25,
                            right: -25,
                            child: Container(
                              height: 120,
                              clipBehavior: Clip.hardEdge,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000)),
                              child: Image.asset(
                                "assets/layer2.png",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 25,
                            left: 25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Silver\nSubscription",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Our offer lays out 2 options,\nproviding you with a regular supply\nof good health and happiness.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Amaze yourself by our delightful\nsilver subscription and get the\npleasure of our service.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

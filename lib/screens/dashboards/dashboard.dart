import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrome_user/screens/subscription_and_payments/subscription_options.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/meals_row.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:nutrome_user/widgets/snackbar_toast.dart';

class DashBoard extends StatefulWidget {
  final String? city;

  const DashBoard({Key? key, this.city}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String offerBanner = "loading";
  bool offer = false;
  int? portalOpenTime;
  int? portalCloseTime;

  Widget placeHolder = Center(
    child: CircularProgressIndicator(),
  );
  bool connectionState = true;
  Iterable<Map<String, dynamic>>? data = ({});

  List<int> numberList = [];

  bool portalStatus = false;

  String getWeekday() {
    switch (DateTime.now().weekday) {
      case 1:
        return "Tuesday";
      case 2:
        return "Wednesday";
      case 3:
        return "Thursday";
      case 4:
        return "Friday";
      case 5:
        return "Saturday";
      case 6:
        return "Sunday";
      case 7:
        return "Monday";
      default:
        return "null";
    }
  }

  void checkPortalTime() {
    DateTime dateNow = DateTime.now();
    if (dateNow.hour >= portalOpenTime! && dateNow.hour < portalCloseTime!) {
      portalStatus = true;
      setState(() {});
    } else {
      portalStatus = false;
      // if (UserSharedPreferences.getUserPhone().contains("7781036332")) {
      //   portalStatus = true;
      // }
    }
  }

  void getMeals() async {
    data = await MealsDB().getMealByDayAndType(getWeekday(), "Breakfast");
    data = data!
        .followedBy(await MealsDB().getMealByDayAndType(getWeekday(), "Lunch"));
    data = data!.followedBy(
        await MealsDB().getMealByDayAndType(getWeekday(), "Dinner"));

    if (mounted) {
      setState(() {
        if (data!.isEmpty) {
          placeHolder = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Lottie.asset("assets/no_blue.json", height: 100),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("No Meal Available At This Time"),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        }
      });
    }
  }

  void loadOffer() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> offerData = await FirebaseFirestore
          .instance
          .collection("Offer")
          .doc("offer")
          .get();
      offer = offerData["enabled"];
      offerBanner = offerData["banner"];
      UserSharedPreferences.setAreaAvailable(offerData["availability"]);
      portalOpenTime = offerData["portalOpenTime"];
      portalCloseTime = offerData["portalCloseTime"];
      print(portalCloseTime);
      UserSharedPreferences.setPortalOpenTime(portalOpenTime!);
      UserSharedPreferences.setPortalCloseTime(portalCloseTime!);
      checkPortalTime();
    } catch (_) {}
  }

  void checkConnection() async {
    connectionState = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    checkConnection();
    loadOffer();
    getMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Nutro Me",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          child: ClipRRect(
            child: Container(
              height: 15,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          preferredSize: Size.fromHeight(15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: offerBanner == "loading"
                        ? SizedBox(
                            height: 220,
                            child: Center(child: CircularProgressIndicator()))
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubscriptionOptions()));
                            },
                            child: CachedNetworkImage(
                              imageUrl: offerBanner,
                              progressIndicatorBuilder: (_, a, b) {
                                return SizedBox(
                                  height: 220,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                            ),
                          ),
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Trending Now",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              data == null || data!.isEmpty
                  ? placeHolder
                  : InkWell(
                      onTap: () {
                        CustomToast().showToast(
                            context,
                            "Available from ${portalOpenTime!} : 00 to ${(portalCloseTime!)} : 00",
                            true);
                      },
                      child: AbsorbPointer(
                        absorbing: !portalStatus,
                        child: Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data!.length,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return MealsRow(
                                  mealId: data?.elementAt(position)["mealId"],
                                  time: "",
                                  foodName:
                                      data?.elementAt(position)["mealName"],
                                  price: double.parse(
                                      data?.elementAt(position)["price"]),
                                  ingredients:
                                      data?.elementAt(position)["ingredients"],
                                  description:
                                      data?.elementAt(position)["description"],
                                  img1Url: data?.elementAt(position)["img1Url"],
                                  img2Url: data?.elementAt(position)["img2Url"],
                                  deliveryCharges: data
                                      ?.elementAt(position)["deliveryCharges"],
                                  taxes: double.parse(
                                      data?.elementAt(position)["taxes"]),
                                  mealType:
                                      data?.elementAt(position)["mealType"],
                                );
                              }),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}




//progress indicator optimize everything
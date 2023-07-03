import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/error.dart';
import 'package:nutrome_user/widgets/meals_row.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

class FoodsMenu extends StatefulWidget {
  const FoodsMenu({Key? key}) : super(key: key);

  @override
  State<FoodsMenu> createState() => _FoodsMenuState();
}

class _FoodsMenuState extends State<FoodsMenu> {
  Widget placeHolder = Center(
    child: CircularProgressIndicator(),
  );
  bool connectionState = true;
  bool portalStatus = false;
  Iterable<Map<String, dynamic>>? data = ({});
  Iterable<Map<String, dynamic>>? lData = ({});
  Iterable<Map<String, dynamic>>? dData = ({});
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  void checkPortalTime() {
    DateTime dateNow = DateTime.now();
    if (dateNow.hour >= UserSharedPreferences.getPortalOpenTime() &&
        dateNow.hour < UserSharedPreferences.getPortalCloseTime()) {
      portalStatus = true;
      setState(() {});
    } else {
      portalStatus = false;
    }
  }

  @override
  void initState() {
    checkPortalTime();
    checkConnection();
    getMeals();
    super.initState();
  }

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

  void checkConnection() async {
    connectionState = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      setState(() {});
    }
  }

  void getMeals() async {
    data = await MealsDB().getMealByDayAndType(getWeekday(), "Breakfast");
    lData = await MealsDB().getMealByDayAndType(getWeekday(), "Lunch");
    dData = await MealsDB().getMealByDayAndType(getWeekday(), "Dinner");
    if (mounted) {
      setState(() {
        if (data!.isEmpty || dData!.isEmpty || lData!.isEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelPadding: EdgeInsets.symmetric(vertical: 10),
            tabs: [
              Text(
                "Breakfast",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                "Lunch",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                "Dinner",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Choose ${getWeekday()} Meal",
            style: TextStyle(
                fontSize: 22, color: Theme.of(context).colorScheme.onTertiary),
          ),
        ),
        body: portalStatus
            ? LiquidPullToRefresh(
                backgroundColor: Colors.white,
                springAnimationDurationInMilliseconds: 400,
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  checkPortalTime();
                },
                key: _refreshIndicatorKey,
                child: TabBarView(
                  children: [
                    connectionState
                        ? data == null || data!.isEmpty
                            ? placeHolder
                            : ListView.builder(
                                itemCount: data?.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return MealsRow(
                                    mealId: data?.elementAt(position)["mealId"],
                                    time: " ",
                                    foodName:
                                        data?.elementAt(position)["mealName"],
                                    price: double.parse(
                                        data?.elementAt(position)["price"]),
                                    ingredients: data
                                        ?.elementAt(position)["ingredients"],
                                    description: data
                                        ?.elementAt(position)["description"],
                                    img1Url:
                                        data?.elementAt(position)["img1Url"],
                                    img2Url:
                                        data?.elementAt(position)["img2Url"],
                                    deliveryCharges: (data?.elementAt(
                                        position)["deliveryCharges"]),
                                    taxes: double.parse(
                                        data?.elementAt(position)["taxes"]),
                                    mealType: "breakfast",
                                  );
                                },
                              )
                        : ErrorOccured(),
                    connectionState
                        ? lData == null || lData!.isEmpty
                            ? placeHolder
                            : ListView.builder(
                                itemCount: lData?.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return MealsRow(
                                    mealId:
                                        lData?.elementAt(position)["mealId"],
                                    time: " ",
                                    foodName:
                                        lData?.elementAt(position)["mealName"],
                                    price: double.parse(
                                        lData?.elementAt(position)["price"]),
                                    ingredients: lData
                                        ?.elementAt(position)["ingredients"],
                                    description: lData
                                        ?.elementAt(position)["description"],
                                    img1Url:
                                        lData?.elementAt(position)["img1Url"],
                                    img2Url:
                                        lData?.elementAt(position)["img2Url"],
                                    deliveryCharges: lData?.elementAt(
                                        position)["deliveryCharges"],
                                    taxes: double.parse(
                                        lData?.elementAt(position)["taxes"]),
                                    mealType: "lunch",
                                  );
                                })
                        : ErrorOccured(),
                    connectionState
                        ? dData == null || dData!.isEmpty
                            ? placeHolder
                            : ListView.builder(
                                itemCount: dData?.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return MealsRow(
                                    mealId:
                                        dData?.elementAt(position)["mealId"],
                                    time: " ",
                                    foodName:
                                        dData?.elementAt(position)["mealName"],
                                    price: double.parse(
                                        dData?.elementAt(position)["price"]),
                                    ingredients: dData
                                        ?.elementAt(position)["ingredients"],
                                    description: dData
                                        ?.elementAt(position)["description"],
                                    img1Url:
                                        dData?.elementAt(position)["img1Url"],
                                    img2Url:
                                        dData?.elementAt(position)["img2Url"],
                                    deliveryCharges: dData?.elementAt(
                                        position)["deliveryCharges"],
                                    taxes: double.parse(
                                        dData?.elementAt(position)["taxes"]),
                                    mealType: "dinner",
                                  );
                                })
                        : ErrorOccured(),
                  ],
                ),
              )
            : LiquidPullToRefresh(
                backgroundColor: Colors.white,
                springAnimationDurationInMilliseconds: 400,
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  checkPortalTime();
                },
                key: _refreshIndicatorKey,
                child: Center(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "You Can Book Your Next Day Meal Between ${UserSharedPreferences.getPortalOpenTime()} : 00 to ${UserSharedPreferences.getPortalCloseTime()} : 00.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

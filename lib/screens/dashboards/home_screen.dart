import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrome_user/main.dart';
import 'package:nutrome_user/screens/dashboards/cart.dart';
import 'package:nutrome_user/screens/dashboards/dashboard.dart';
import 'package:nutrome_user/screens/dashboards/foods_menu.dart';
import 'package:nutrome_user/screens/dashboards/myaccount.dart';
import 'package:nutrome_user/screens/dashboards/orders_history.dart';
import 'package:nutrome_user/screens/mainpages/editprofile.dart';
import 'package:nutrome_user/screens/subscription_and_payments/subscription_options.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  List<bool> tabColor = [true, false, false, false];

  final PageStorageBucket bucket = PageStorageBucket();

  late Widget currentScreen;
  DocumentSnapshot<Map<String, dynamic>>? userBasicData;
  DocumentSnapshot<Map<String, dynamic>>? userAddressData;
  DateTime? currentPlanEndTime;

  Future<DocumentSnapshot<Map<String, dynamic>>> loadBasicData() async {
    var snapshot;
    try {
      snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .collection("UserDetails")
          .doc("basic_details")
          .get();
      userBasicData = snapshot;
    } on Exception catch (ex) {
      print(ex.runtimeType);
    } catch (error) {
      print(error.runtimeType);
    }
    return snapshot;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> loadAddressData() async {
    var snapshot;
    try {
      snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .collection("UserDetails")
          .doc("location_details")
          .get();
      userAddressData = snapshot;
    } on Exception catch (ex) {
      print(ex.runtimeType);
    } catch (error) {
      print(error.runtimeType);
    }
    return snapshot;
  }

  saveDataToLocal() async {
    try {
      // ignore: unused_local_variable
      String check = UserSharedPreferences.getPostalCode();
    } on Exception catch (_) {
      await loadAddressData();
      await loadBasicData();
      dynamic c1, c2;
      try {
        c1 = userAddressData!.data();
        c2 = userBasicData!.data();
      } on Exception catch (ex) {
        print(ex.runtimeType);
      } catch (error) {
        print(error.runtimeType);
      }
      if (c1 == null || c2 == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => EditProfile(firstTime: true)),
          );
        });
      } else {
        UserSharedPreferences.setUsername(userBasicData!.data()!["name"]);
        UserSharedPreferences.setUserEmail(userBasicData!.data()!["email"]);
        UserSharedPreferences.setUserPhone(userBasicData!.data()!["phone"]);
        UserSharedPreferences.setHouseNo(userAddressData!.data()!["houseNo"]);
        UserSharedPreferences.setPostalCode(
            userBasicData!.data()!["postalCode"]);
        UserSharedPreferences.setCity(userAddressData!.data()!["city"]);
        UserSharedPreferences.setStreet(userAddressData!.data()!["street"]);
      }
    } catch (error) {
      await loadAddressData();
      await loadBasicData();
      dynamic c1, c2;
      try {
        c1 = userAddressData!.data();
        c2 = userBasicData!.data();
      } on Exception catch (ex) {
        print(ex.runtimeType);
      } catch (error) {
        print(error.runtimeType);
      }
      if (c1 == null || c2 == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => EditProfile(firstTime: true)),
              (route) => false);
        });
      } else {
        UserSharedPreferences.setUsername(userBasicData!.data()!["name"]);
        UserSharedPreferences.setUserEmail(userBasicData!.data()!["email"]);
        UserSharedPreferences.setUserPhone(userBasicData!.data()!["phone"]);
        UserSharedPreferences.setHouseNo(userAddressData!.data()!["houseNo"]);
        UserSharedPreferences.setPostalCode(
            userAddressData!.data()!["postalCode"]);
        UserSharedPreferences.setCity(userAddressData!.data()!["city"]);
        UserSharedPreferences.setStreet(userAddressData!.data()!["street"]);
      }
    }
  }

  void enforceUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    bool show = false;
    bool important = true;
    String image =
        "https://images.indianexpress.com/2022/07/Google-Play-Store-new-logo.jpg";
    String text = "Please Update The App From PlayStore";
    String buttonText = "Updatex";
    String actionUrl = "cancel";
    String packageName = packageInfo.packageName;
    String version = "1.0.1";
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("EnforceUpdate")
          .doc("enforceUpdate")
          .get();
      image = snapshot.data()!["image"];
      buttonText = snapshot.data()!["buttonText"];
      important = snapshot.data()!["important"];
      actionUrl = snapshot.data()!["action"];
      show = snapshot.data()!["show"];
      text = snapshot.data()!["text"];
      version = snapshot.data()!["version"];
    } catch (error) {
      print(error.runtimeType);
    }
    if (show || !packageInfo.version.contains(version)) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              if (important) {
                exit(0);
              }
              return !important;
            },
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        image,
                        height: MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(child: Center()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (actionUrl.contains("play.google.com")) {
                                OpenStore.instance.open(
                                  androidAppBundleId: packageName,
                                );
                              } else if (actionUrl.contains("http") &&
                                  !actionUrl.contains("play.google.com")) {
                                try {
                                  launchUrl(Uri.parse(actionUrl));
                                } catch (error) {
                                  Navigator.pop(context);
                                }
                              } else if (actionUrl.toLowerCase() == "foods") {
                                Navigator.pop(context);
                                currentScreen = FoodsMenu();
                              } else if (actionUrl.toLowerCase() ==
                                  "subscriptions") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubscriptionOptions()));
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(buttonText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> loadCurrentPlan() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .collection("SubscriptionPlans")
          .doc("subscriptionPlanDetails")
          .get();
      String userCurrentPlanEndTime = await snapshot.data()!["planEndTime"];
      currentPlanEndTime = DateTime.parse(userCurrentPlanEndTime);
      DateTime currentTime = DateTime.now();
      if (currentTime.isAfter(currentPlanEndTime!)) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection("SubscriptionPlans")
            .doc("subscriptionPlanDetails")
            .delete();
      }
    } on Exception catch (ex) {
      print(ex.runtimeType);
    } catch (error) {
      print(error.runtimeType);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    enforceUpdate();
    currentScreen = DashBoard();
    loadCurrentPlan();
    saveDataToLocal();
    if (mounted) {
      setState(() {});
    }
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 20,
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Lottie.asset(
                          "assets/notification.json",
                          width: 90,
                          repeat: false,
                          height: 100,
                        ),
                      ),
                      Text(notification.body!)
                    ],
                  ),
                ),
              );
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 20,
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Lottie.asset(
                        "assets/notification.json",
                        width: 90,
                        repeat: false,
                        height: 100,
                      ),
                      Text(notification.body!)
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Cart()));
            });
          },
          child: Icon(CupertinoIcons.cart),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 20,
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                FutureBuilder(
                  builder: (context, snapshot) {
                    return SizedBox();
                  },
                  future: loadCurrentPlan(),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentScreen = DashBoard();
                        currentTab = 0;
                        tabColor = [false, false, false, false];
                        tabColor[currentTab] = true;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.home,
                          color: tabColor[0]
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onTertiary,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: tabColor[0]
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentScreen = FoodsMenu();
                        currentTab = 2;
                        tabColor = [false, false, false, false];
                        tabColor[currentTab] = true;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.food_bank_outlined,
                          color: tabColor[2]
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onTertiary,
                        ),
                        Text(
                          "Food",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: tabColor[2]
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentScreen = MyOrders();
                        currentTab = 1;

                        tabColor = [false, false, false, false];
                        tabColor[currentTab] = true;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delivery_dining_outlined,
                          color: tabColor[1]
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onTertiary,
                        ),
                        Text(
                          "Orders",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: tabColor[1]
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      currentScreen = MyAccount();
                      currentTab = 3;
                      tabColor = [false, false, false, false];
                      tabColor[currentTab] = true;
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.person,
                          color: tabColor[3]
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onTertiary,
                        ),
                        Text(
                          "Account",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: tabColor[3]
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (currentTab == 0) {
              setState(() {});
              return true;
            } else {
              currentScreen = DashBoard();
              currentTab = 0;
              tabColor = [false, false, false, false];
              tabColor[currentTab] = true;
              setState(() {});
              return false;
            }
          },
          child: currentTab == 0
              ? DoubleBackToCloseApp(
                  snackBar: SnackBar(
                    duration: Duration(milliseconds: 4000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    behavior: SnackBarBehavior.floating,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tap Again to Exit!",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  child: currentScreen,
                )
              : currentScreen,
        ));
  }
}

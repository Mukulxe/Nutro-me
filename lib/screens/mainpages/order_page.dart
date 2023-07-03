import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutrome_user/screens/dashboards/cart.dart';
import 'package:nutrome_user/screens/subscription_and_payments/subscription_options.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/utility/data_models.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/utility/sqlite_db.dart';
import 'package:nutrome_user/widgets/snackbar_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final String foodName;
  final double price;
  final double deliveryCharges;
  final double taxes;
  final String description;
  final String time;
  final String mealId;
  final String ingredients;
  final String img1Url;
  final String img2Url;
  final String mealType;

  const OrderPage({
    Key? key,
    required this.foodName,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.time,
    required this.mealId,
    required this.img1Url,
    required this.img2Url,
    required this.deliveryCharges,
    required this.taxes,
    required this.mealType,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int quantity = 0;
  CartDB cartDB = CartDB();

  String? userCurrentPlanId;
  String? userCurrentPlanName;
  DateTime? currentPlanEndTime;
  String? userCurrentPlanEndTime;
  bool planDataLoaded = false;
  bool? alreadyOrdered;

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

  Future<void> checkIfAlreadyOrdered() async {
    try {
      String dateTime = DateTime.now().toString().substring(0, 10);
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .collection("MyOrders")
          .where("orderTime",
              isEqualTo: DateTime.now().toString().substring(0, 10))
          .get();
      alreadyOrdered = ((data.docs.map((e) => e.data()))
              .toString()
              .toLowerCase()
              .contains(dateTime.toLowerCase())) &&
          (data.docs.map((e) => e.data()))
              .toString()
              .toLowerCase()
              .contains(widget.mealType);
      print(alreadyOrdered);
    } catch (_) {}
  }

  Future<int> mealQuantity() async {
    List<CartModel> cart = await cartDB.getCartItems();
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].mealId.contains(widget.mealId)) {
        quantity = cart[i].quantity;
      }
    }
    if (mounted) {
      setState(() {});
    }
    return quantity;
  }

  @override
  void initState() {
    mealQuantity();
    checkIfAlreadyOrdered();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()))
              .then((value) async {
            quantity = 0;
            await mealQuantity();
          });
        },
        child: Badge(
          toAnimate: true,
          animationType: BadgeAnimationType.scale,
          shape: BadgeShape.circle,
          showBadge: quantity != 0,
          badgeColor: Colors.green,
          borderRadius: BorderRadius.circular(8),
          badgeContent: Text('$quantity',
              style: TextStyle(color: Colors.white, fontSize: 10)),
          child: Icon(
            CupertinoIcons.cart,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(220),
        child: AppBar(
          flexibleSpace: SlidingImage(widget: widget),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.transparent,
              ),
            ),
          ),
          title: Text("Order Now"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                builder: (ctx, snapshot) {
                  return Container();
                },
                future: loadCurrentPlan(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<int>(
                        future: mealQuantity(),
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              widget.foodName,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.5,
                          color: Theme.of(context).primaryColor,
                        ),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Text(
                          widget.mealType,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[400],
                height: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "₹ " + widget.price.toString() + " /- \t" + widget.time,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Expanded(child: Center()),
                  quantity == 0
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Colors.black87,
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size(100, 41),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () async {
                            if (!UserSharedPreferences.getPostalCode().contains(
                                UserSharedPreferences.getAreaAvailable())) {
                              AlertDialog alert = AlertDialog(
                                title: Text("Confirm Order"),
                                content: Text(
                                    "Currently Not Avaiable in Your Area."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                ],
                              ); // show
                              showDialog(
                                  context: context,
                                  builder: ((context) => alert));
                              return;
                            }
                            if (planDataLoaded) {
                              if (userCurrentPlanId == null) {
                                mealQuantity();
                                CartModel cartModel = CartModel(
                                  mealId: widget.mealId,
                                  mealName: widget.foodName,
                                  imgUrl: widget.img1Url,
                                  quantity: 1,
                                  price: widget.price,
                                  taxes: widget.taxes,
                                  deliveryCharges: widget.deliveryCharges,
                                  mealType: widget.mealType,
                                );
                                await cartDB.update(cartModel, quantity, true);
                                mealQuantity();
                              } else {
                                if (alreadyOrdered == null) {
                                  CustomToast()
                                      .showToast(context, "loading...", false);
                                  return;
                                }
                                if (alreadyOrdered!) {
                                  CustomToast().showToast(context,
                                      "Already Ordered for today!", false);
                                  return;
                                }
                                OrderModel orderModel = OrderModel(
                                  orderId: OrderFood().generateOrderId(),
                                  orderTime: DateTime.now().toString(),
                                  mealId: widget.mealId,
                                  mealName: widget.foodName,
                                  img1Url: widget.img1Url,
                                  orderStatus: "pending",
                                  deliveryAddress:
                                      "${UserSharedPreferences.getHouseNo()},${UserSharedPreferences.getStreet()},${UserSharedPreferences.getPostalCode()},${UserSharedPreferences.getCity()}",
                                  orderCost: (widget.deliveryCharges +
                                          widget.price +
                                          widget.taxes)
                                      .toString(),
                                  instructions: "Under Subscription Plan",
                                  userUid: FirebaseAuth
                                      .instance.currentUser!.uid
                                      .toString(),
                                  quantity: 1,
                                  taxes: widget.taxes,
                                  deliveryCharges: widget.deliveryCharges,
                                  mealType: widget.mealType,
                                );
                                AlertDialog alert = AlertDialog(
                                  title: Text("Confirm Order"),
                                  content: Text(
                                      "The Meal is Covered under your current $userCurrentPlanName Plan! Do you want to continue?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel")),
                                    TextButton(
                                        onPressed: () {
                                          OrderFood()
                                              .orderMeal(orderModel, context);
                                        },
                                        child: Text("Confirm")),
                                  ],
                                ); // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }
                            } else {
                              CustomToast().showToast(
                                  context, "loading details...", false);
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: 41,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                padding: EdgeInsets.all(6),
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  if (quantity == 1) {
                                    await cartDB.delete(widget.mealId);
                                    setState(() {
                                      quantity = 0;
                                    });
                                    return;
                                  }
                                  mealQuantity();
                                  CartModel cartModel = CartModel(
                                    mealId: widget.mealId,
                                    mealName: widget.foodName,
                                    imgUrl: widget.img1Url,
                                    quantity: quantity,
                                    price: widget.price,
                                    taxes: widget.taxes,
                                    deliveryCharges: widget.deliveryCharges,
                                    mealType: widget.mealType,
                                  );
                                  await cartDB.update(
                                      cartModel, quantity, false);
                                },
                                icon: Container(
                                  width: 12,
                                  height: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                padding: EdgeInsets.all(6),
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  mealQuantity();
                                  CartModel cartModel = CartModel(
                                    mealId: widget.mealId,
                                    mealName: widget.foodName,
                                    imgUrl: widget.img1Url,
                                    quantity: quantity,
                                    price: widget.price,
                                    taxes: widget.taxes,
                                    deliveryCharges: widget.deliveryCharges,
                                    mealType: widget.mealType,
                                  );
                                  await cartDB.update(
                                      cartModel, quantity, true);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      "Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.description,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 88, 88, 88)),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      "Ingredients",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Text(
                      widget.ingredients,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 88, 88, 88),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
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
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionOptions()));
                  },
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/subscriptionOffer.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlidingImage extends StatelessWidget {
  const SlidingImage({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final OrderPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1,
          autoPlayAnimationDuration: Duration(seconds: 1),
          autoPlayInterval: Duration(seconds: 6),
          autoPlay: true,
          height: double.infinity,
        ),
        items: [widget.img1Url, widget.img2Url].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)),
                    child: CachedNetworkImage(
                      color: Color.fromARGB(255, 12, 12, 12).withOpacity(0.4),
                      imageUrl: i,
                      colorBlendMode: BlendMode.darken,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Icon(Icons.photo),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

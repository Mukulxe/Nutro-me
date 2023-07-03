import 'package:nutrome_user/screens/mainpages/edit_address.dart';
import 'package:nutrome_user/screens/subscription_and_payments/payment_failed.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/widgets/cart_row.dart';
import 'package:nutrome_user/utility/data_models.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/utility/sqlite_db.dart';
import 'package:nutrome_user/widgets/buttons.dart';
import 'package:nutrome_user/widgets/progress_dailog.dart';
import 'package:nutrome_user/widgets/snackbar_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  TextEditingController instructionsController = TextEditingController();
  CartDB cartDB = CartDB();
  List<CartModel> cart = [];
  List<Widget> items = [];
  String meals = "";
  String mealIds = "";
  double totalCost = 0;
  int totalQuantity = 0;
  String imgUrl = "";
  double taxes = 0;
  double deliveryCharges = 0;

  Future<List<CartModel>>? fetchCart() async {
    try {
      cart = await cartDB.getCartItems();
      items = [];
      totalCost = 0;
      meals = "";
      mealIds = "";
      deliveryCharges = 0;
      taxes = 0;
      totalQuantity = 0;
      imgUrl = cart[0].imgUrl;
      for (int i = 0; i < cart.length; i++) {
        items.add(CartRow(cartModel: cart[i]));
        totalCost =
            totalCost + (cart[i].price + cart[i].taxes) * cart[i].quantity;
        meals = meals +
            "${cart[i].mealName} [${cart[i].mealType}] * ${cart[i].quantity}" +
            (cart.length != 1 ? " | " : "");
        mealIds = mealIds + cart[i].mealId + (cart.length != 1 ? " + " : "");
        totalQuantity = totalQuantity + cart[i].quantity;
        taxes = taxes + (cart[i].taxes * cart[i].quantity);
      }
      deliveryCharges = deliveryCharges +
          (meals.split("breakfast").length - 1) * cart[0].deliveryCharges;
      deliveryCharges = deliveryCharges +
          (meals.split("lunch").length - 1) * cart[0].deliveryCharges;
      deliveryCharges = deliveryCharges +
          (meals.split("dinner").length - 1) * cart[0].deliveryCharges;
    } on Exception catch (_) {
    } catch (_) {}
    if (mounted) {
      setState(() {});
    }
    return cart;
  }

  late var _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    MyDialog().show(context);
    try {
      PaymentHistoryDB().addPaymentHistory(
          DateTime.now().toString(),
          response.paymentId.toString(),
          mealIds,
          "Meal",
          meals,
          "success",
          totalCost);
      String orderId = OrderFood().generateOrderId();
      OrderModel orderModel = OrderModel(
        orderId: orderId,
        orderTime: DateTime.now().toString(),
        mealId: mealIds,
        mealName: meals,
        img1Url: imgUrl,
        orderStatus: "pending",
        deliveryAddress:
            "${UserSharedPreferences.getHouseNo()},${UserSharedPreferences.getStreet()},${UserSharedPreferences.getPostalCode()},${UserSharedPreferences.getCity()}",
        orderCost: totalCost.toString(),
        instructions: instructionsController.text.isEmpty
            ? "No Instructions"
            : instructionsController.text.toString(),
        userUid: FirebaseAuth.instance.currentUser!.uid.toString(),
        quantity: totalQuantity,
        taxes: taxes,
        deliveryCharges: deliveryCharges,
        mealType: "",
      );
      OrderFood().orderMeal(orderModel, context);
      cartDB.clearCart();
    } on Exception catch (_) {
      PaymentHistoryDB().addPaymentHistory(
          DateTime.now().toString(),
          response.paymentId.toString(),
          mealIds,
          "Meal",
          meals,
          "failed",
          totalCost);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PurchaseFailed(
                    isMeal: true,
                  )));
    } catch (error) {
      PaymentHistoryDB().addPaymentHistory(
        DateTime.now().toString(),
        response.paymentId.toString(),
        mealIds,
        "Meal",
        meals,
        "failed",
        totalCost,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PurchaseFailed(
                    isMeal: true,
                  )));
    }
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    PaymentHistoryDB().addPaymentHistory(DateTime.now().toString(),
        "Payment Not Received", mealIds, "Meal", meals, "failed", totalCost);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PurchaseFailed(
                  isMeal: true,
                )));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          height: 350,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: totalCost == 0
                ? Center(
                    child: Text(
                      "Cart is Empty",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Amount : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(child: Center()),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.confirmation_num),
                            label: Text(
                              "Rs.$totalCost",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Delivery Charges : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(child: Center()),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.confirmation_num),
                            label: Text(
                              "Rs.$deliveryCharges",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Taxes and Charges : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(child: Center()),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.confirmation_num),
                            label: Text(
                              "Rs.0.00",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Total Amount : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(child: Center()),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.confirmation_num),
                            label: Text(
                              "Rs.${totalCost + deliveryCharges}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  UserSharedPreferences.getCity(),
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                      "${UserSharedPreferences.getHouseNo()},",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${UserSharedPreferences.getStreet()},",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${UserSharedPreferences.getPostalCode()}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              child: Button(
                                "Place Order",
                                () {
                                  if (totalCost == 0) {
                                    CustomToast().showToast(
                                        context, "Cart is Empty!", false);
                                    return;
                                  }
                                  var options = {
                                    'key': "rzp_live_XpTKa3EkP9CB1p",
                                    // amount will be multiple of 100
                                    'amount': (totalCost * 100)
                                        .toString(), //So its pay 500
                                    'name': '$meals',
                                    'description':
                                        'Product Ids : $mealIds'
                                            ' }',
                                    'timeout': 300, // in seconds
                                    'prefill': {
                                      'contact':
                                          '${UserSharedPreferences.getUserPhone()}',
                                      'email':
                                          '${UserSharedPreferences.getUserEmail()}'
                                    }
                                  };
                                  _razorpay.open(options);
                                },
                              ),
                            ),
                            Expanded(child: Center()),
                            TextButton.icon(
                                label: Text(
                                  "Change Location",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditAddress(firstTime: false)));
                                },
                                icon: Icon(
                                  Icons.navigation_outlined,
                                  size: 20,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<CartModel>>(
                future: fetchCart(),
                builder: (context, snapshot) {
                  return Column(
                    children: items,
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: instructionsController,
                decoration: InputDecoration(
                  hintText: "Write Instructions",
                  suffixIcon: Icon(Icons.edit_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

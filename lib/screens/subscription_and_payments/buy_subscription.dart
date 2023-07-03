import 'package:hexcolor/hexcolor.dart';
import 'package:nutrome_user/screens/subscription_and_payments/payment_failed.dart';
import 'package:nutrome_user/screens/subscription_and_payments/payment_successful.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/utility/data_models.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BuySubscription extends StatefulWidget {
  final String planName;
  final OfferModel offerModel;
  const BuySubscription(
      {Key? key, required this.planName, required this.offerModel})
      : super(key: key);

  @override
  State<BuySubscription> createState() => _BuySubscriptionState();
}

class _BuySubscriptionState extends State<BuySubscription> {
  late var _razorpay;
  var items = ["7 days", "15 days"];
  String dropDownValue = "7 days";
  double actualCost7 = 3099;
  double actualCost15 = 6199;
  double currentCost7 = 2499;
  double currentCost15 = 4999;

  @override
  void initState() {
    actualCost7 = widget.offerModel.actualCostSilver7;
    actualCost15 = widget.offerModel.actualCostSilver15;
    currentCost7 =
        (actualCost7 * (1 - (widget.offerModel.discountSilver7 * 0.01)))
            .roundToDouble();
    currentCost15 =
        (actualCost15 * (1 - (widget.offerModel.discountSilver15 * 0.01)))
            .roundToDouble();

    if (!widget.offerModel.enabled) {
      currentCost7 = actualCost7;
      currentCost15 = actualCost15;
    }
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    DateTime planStartTime = DateTime.now();
    DateTime planEndTime =
        planStartTime.add(Duration(days: dropDownValue.contains("7") ? 7 : 15));
    SubscriptionModel subscriptionModelNow = SubscriptionModel(
      id: "${widget.planName}${dropDownValue.contains("7") ? 7 : 15}",
      planName: widget.planName,
      days: dropDownValue.contains("7") ? 7 : 15,
      planStartTime: planStartTime.toString(),
      planEndTime: planEndTime.toString(),
      planCost: dropDownValue.contains("7") ? currentCost7 : currentCost15,
    );
    try {
      BuySubscriptionPlan().buyPlan(context, subscriptionModelNow);
      PaymentHistoryDB().addPaymentHistory(
          planStartTime.toString(),
          response.paymentId.toString(),
          subscriptionModelNow.id,
          "Subscription Plan",
          subscriptionModelNow.planName,
          "success",
          subscriptionModelNow.planCost);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PurchaseSuccessful()));
    } catch (e) {
      PaymentHistoryDB().addPaymentHistory(
        planStartTime.toString(),
        response.paymentId.toString(),
        subscriptionModelNow.id,
        "Subscription Plan",
        subscriptionModelNow.planName,
        "failed",
        dropDownValue.contains("7") ? currentCost7 : currentCost15,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PurchaseFailed(
                    isMeal: false,
                  )));
      print(e);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    PaymentHistoryDB().addPaymentHistory(
      DateTime.now().toString(),
      "Payment Not Received",
      "${widget.planName}${dropDownValue.substring(0, 1)}",
      "Subscription Plan",
      widget.planName,
      "failed",
      dropDownValue.contains("7") ? currentCost7 : currentCost15,
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PurchaseFailed(
                  isMeal: false,
                )));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    PaymentHistoryDB().addPaymentHistory(
      DateTime.now().toString(),
      "Payment Not Received",
      "${widget.planName}${dropDownValue.substring(0, 1)}",
      "Subscription Plan",
      widget.planName,
      "failed",
      dropDownValue.contains("7") ? currentCost7 : currentCost15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Buy Subscription",
        ),
        // iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: Button(
                    "Buy Plan",
                    () {
                      var options = {
                        'key': "rzp_live_XpTKa3EkP9CB1p",
                        // amount will be multiple of 100
                        'amount': (dropDownValue.contains("7")
                                ? currentCost7 * 100
                                : currentCost15 * 100)
                            .toString(), //So its pay 500
                        'name': '${widget.planName}',
                        'description':
                            'Product : Subscription Plan,Product Name : ${widget.planName},Product Id : ${widget.planName}${dropDownValue.substring(0, 1)}'
                                ' }',
                        'timeout': 300, // in seconds
                        'prefill': {
                          'contact': '${UserSharedPreferences.getUserPhone()}',
                          'email': '${UserSharedPreferences.getUserEmail()}'
                        }
                      };
                      _razorpay.open(options);
                    },
                  ),
                ),
                Expanded(child: SizedBox()),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.confirmation_num),
                  label: Text(
                    "Rs.${dropDownValue.contains("7") ? currentCost7 : currentCost15}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            HexColor("#3D5F45"),
            Colors.black,
          ],
        )),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "${widget.planName} Subscription",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Plan Benefits",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Plan Name : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  "${widget.planName}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Plan Duration : ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                DropdownButton(
                                  value: dropDownValue,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    dropDownValue = value.toString();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.offerModel.enabled
                                      ? "Actual Amount : "
                                      : "Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Stack(
                                  children: [
                                    Text(
                                      dropDownValue.contains("7")
                                          ? "₹$actualCost7"
                                          : "₹$actualCost15",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    widget.offerModel.enabled
                                        ? Positioned(
                                            top: 13,
                                            child: Container(
                                              height: 2,
                                              width: 120,
                                              color: Colors.black,
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            widget.offerModel.enabled
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Offer Discount : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        dropDownValue.contains("7")
                                            ? "- ₹${(actualCost7 - currentCost7).toString()}"
                                            : "- ₹${(actualCost15 - currentCost15).toString()}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${widget.offerModel.offerName} Offer Applied! : - ${dropDownValue.contains("7") ? widget.offerModel.discountSilver7.toString().substring(0, 5) : widget.offerModel.discountSilver15.toString().substring(0, 5)}%",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Amount to pay: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  dropDownValue.contains("7")
                                      ? "₹$currentCost7"
                                      : "₹$currentCost15",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
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

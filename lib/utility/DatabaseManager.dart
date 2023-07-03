import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrome_user/screens/mainpages/trackmeal.dart';
import 'package:nutrome_user/utility/data_models.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/progress_dailog.dart';
import 'package:nutrome_user/widgets/snackbar_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDB {
  void addUserData(String name, String phone, String email,
      BuildContext context, bool firstTime) async {
    MyDialog().show(context);
    try {
      UserBasicInfoModel userBasicInfoModel =
          UserBasicInfoModel(name: name, email: email, phone: phone);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .collection("UserDetails")
          .doc("basic_details")
          .set(userBasicInfoModel.toJson());
      UserSharedPreferences.setUsername(name);
      UserSharedPreferences.setUserEmail(email);
      UserSharedPreferences.setUserPhone(phone);
      CustomToast().showToast(context, "Updated Successfully!", false);
    } on Exception catch (_) {
      CustomToast().showToast(context, "Connection error", true);
    } catch (error) {
      CustomToast().showToast(context, "Failed! Try Again!", true);
    }
    if (!firstTime) {
      Navigator.pop(context);
    }
  }

  void addUserLocation(String postalCode, String street, String city,
      String houseNo, BuildContext context, bool firstTime) async {
    MyDialog().show(context);
    try {
      UserLocationModel userLocationModel = UserLocationModel(
          postalCode: postalCode, street: street, city: city, houseNo: houseNo);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .collection("UserDetails")
          .doc("location_details")
          .set(userLocationModel.toJson());
      UserSharedPreferences.setPostalCode(postalCode);
      UserSharedPreferences.setHouseNo(houseNo);
      UserSharedPreferences.setStreet(street);
      UserSharedPreferences.setCity(city);
      CustomToast().showToast(context, "Updated Successfully!", false);
    } on Exception catch (_) {
      CustomToast().showToast(context, "Connection error", true);
    } catch (error) {
      CustomToast().showToast(context, "Failed! Try Again!", true);
    }
    if (!firstTime) {
      Navigator.pop(context);
    }
  }
}

class MealsDB {
  Future<Iterable<Map<String, dynamic>>> getMealByDayAndType(
      String day, String mealsType) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("Meals")
        .where("mealDay", isEqualTo: day.toLowerCase())
        .where("mealType", isEqualTo: mealsType.toLowerCase())
        .get();
    return snapshot.docs.map((e) => e.data());
  }
}

class BuySubscriptionPlan {
  void buyPlan(
      BuildContext context, SubscriptionModel subscriptionModel) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection("SubscriptionPlans")
        .doc("subscriptionPlanDetails")
        .set(subscriptionModel.toJson());
  }
}

class PaymentHistoryDB {
  void addPaymentHistory(
      String paymentTime,
      String paymentId,
      String productId,
      String productType,
      String productName,
      String paymentStatus,
      double ammount) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection("paymentHistory")
        .doc("$paymentTime")
        .set({
      'paymentTime': paymentTime,
      'paymentId': paymentId,
      'productType': productType,
      'productId': productId,
      'productName': productName,
      'paymentStatus': paymentStatus,
      'ammount': ammount,
    });
  }

  Future<Iterable<Map<String, dynamic>>> getPaymentsHistory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection("paymentHistory")
        .orderBy("paymentTime", descending: true)
        .get();
    return snapshot.docs.map((e) => e.data());
  }
}

class OrderFood {
  String generateOrderId() {
    return "${UniqueKey().toString()}${UniqueKey().toString().replaceAll("#", "")}${DateTime.now().toString().replaceAll("-", "").substring(0, 8)}"
        .replaceAll("[", "")
        .replaceAll("]", "")
        .trim();
  }

  void orderMeal(
    OrderModel orderModel,
    BuildContext context,
  ) async {
    MyDialog().show(context);
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .collection("MyOrders")
          .doc(orderModel.orderId)
          .set({
        'orderId': orderModel.orderId,
        'orderTime': DateTime.now().toString().substring(0, 10),
        'orderType': orderModel.mealType,
      });
      await FirebaseFirestore.instance
          .collection("UserOrders")
          .doc(orderModel.orderId)
          .set(orderModel.toJson());
      CustomToast().showToast(context, "Order Sent!", false);
      Navigator.pop(context);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(
              builder: (context) => TrackMeal(
                    orderId: orderModel.orderId,
                  )))
          .then((value) => Navigator.pop(context));
    } on Exception catch (_) {
      CustomToast().showToast(context, "Order failed!", true);
    } catch (error) {
      CustomToast().showToast(context, "Order failed!", true);
    }
  }
}

class OrderHistory {
  Future<Iterable<Map<String, dynamic>>> getOrderHistory() async {
    String userUid = FirebaseAuth.instance.currentUser!.uid.toString();
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("UserOrders")
        .where("userUid", isEqualTo: userUid)
        .orderBy("orderTime", descending: true)
        .get();
    return snapshot.docs.map((e) => e.data());
  }
}

class SubscriptionDetails {
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchSilver(String id) async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection("Subscriptions")
        .doc("$id")
        .get();
    return data;
  }
}

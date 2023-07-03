class MealsModel {
  final String name;
  final String itemId;
  final String description;
  final String ingridients;
  final double price;
  final String subscriptionPlanId;
  final String day;
  final String mealsCatogary;
  MealsModel({
    required this.itemId,
    required this.price,
    required this.description,
    required this.ingridients,
    required this.name,
    required this.subscriptionPlanId,
    required this.day,
    required this.mealsCatogary,
  });
  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'itemName': name,
        'description': description,
        'ingridients': ingridients,
        'price': price,
        'subscriptionPlanId': subscriptionPlanId,
      };
}

class UserBasicInfoModel {
  final String name;
  final String phone;
  final String email;

  UserBasicInfoModel({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
      };
}

class UserLocationModel {
  final String postalCode;
  final String street;
  final String city;
  final String houseNo;

  UserLocationModel({
    required this.postalCode,
    required this.street,
    required this.city,
    required this.houseNo,
  });

  Map<String, dynamic> toJson() => {
        'postalCode': postalCode,
        'street': street,
        'city': city,
        'houseNo': houseNo,
      };
}

class SubscriptionModel {
  final String id;
  final String planName;
  final int days;
  final String planStartTime;
  final String planEndTime;
  final double planCost;

  SubscriptionModel({
    required this.id,
    required this.planName,
    required this.days,
    required this.planStartTime,
    required this.planEndTime,
    required this.planCost,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'planName': planName,
        'days': days,
        'planStartTime': planStartTime,
        'planEndTime': planEndTime,
        'planCost': planCost
      };
}

class SubscriptionModelLocal {
  final String id; //planId
  final String planName;
  final double planCost;
  final int days;
  final String phoneNo;
  final String email;
  final String name;

  SubscriptionModelLocal({
    required this.id,
    required this.planName,
    required this.planCost,
    required this.days,
    required this.email,
    required this.name,
    required this.phoneNo,
  });
}

class OrderModel {
  final String orderId;
  final String orderTime;
  final String mealId;
  final String mealName;
  final String orderStatus;
  final String img1Url;
  final String deliveryAddress;
  final String orderCost;
  final String instructions;
  final String userUid;
  final int quantity;
  final double taxes;
  final double deliveryCharges;
  final String mealType;

  OrderModel({
    required this.orderId,
    required this.orderTime,
    required this.mealId,
    required this.mealName,
    required this.img1Url,
    required this.orderStatus,
    required this.deliveryAddress,
    required this.orderCost,
    required this.instructions,
    required this.userUid,
    required this.quantity,
    required this.taxes,
    required this.deliveryCharges,
    required this.mealType,
  });
  String otp = DateTime.now().toString().substring(22, 26);

  Map<String, dynamic> toJson() => {
        'mealId': mealId,
        'mealName': mealName,
        'instructions': instructions,
        'orderId': orderId,
        'orderTime': orderTime,
        'imgUrl': img1Url,
        'orderStatus': orderStatus,
        'orderCost': orderCost,
        'deliveryAddress': deliveryAddress,
        'deliveryBoyDetails': "Not Assigned",
        'userUid': userUid,
        'quantity': quantity,
        'deliveryCharges': deliveryCharges,
        'taxes': taxes,
        'otp': otp,
        'deliveredTime': " ",
        'preparingTime': " ",
        'receivedTime': " ",
        'dispatchedTime': " ",
        'mealType': mealType,
      };
}

class CartModel {
  final String mealId;
  final String mealName;
  final String mealType;
  final String imgUrl;
  final int quantity;
  final double price;
  final double taxes;
  final double deliveryCharges;

  CartModel({
    required this.mealId,
    required this.mealName,
    required this.imgUrl,
    required this.quantity,
    required this.price,
    required this.taxes,
    required this.deliveryCharges,
    required this.mealType,
  });

  Map<String, dynamic> toJson() => {
        'mealId': mealId,
        'mealName': mealName,
        'imgUrl': imgUrl,
        'quantity': quantity,
        'price': price,
        'deliveryCharges': deliveryCharges,
        'taxes': taxes,
        'mealType': mealType,
      };

  static CartModel fromJson(Map<String, Object?> json) => CartModel(
        mealId: json["mealId"] as String,
        mealName: json["mealName"] as String,
        imgUrl: json["imgUrl"] as String,
        quantity: json["quantity"] as int,
        price: json["price"] as double,
        deliveryCharges: json["deliveryCharges"] as double,
        taxes: json["taxes"] as double,
        mealType: json["mealType"] as String,
      );
}

class OfferModel {
  final bool enabled;
  final double actualCostSilver7;
  final double actualCostSilver15;
  final double discountSilver7;
  final double discountSilver15;
  final String offerName;

  OfferModel(this.enabled, this.actualCostSilver7, this.actualCostSilver15,
      this.discountSilver7, this.discountSilver15, this.offerName);
}

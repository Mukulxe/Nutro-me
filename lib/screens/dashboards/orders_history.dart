import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/widgets/orders_row.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

//
class _MyOrdersState extends State<MyOrders> {
  Iterable<Map<String, dynamic>>? data = ({});
  Widget placeHolder = Center(
    child: CircularProgressIndicator(),
  );
  List list = [];
  void getMeals() async {
    data = await OrderHistory().getOrderHistory();
    if (!mounted) {
      return;
    }
    setState(() {
      if (data!.isEmpty) {
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
              Text("No Orders yet!"),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void initState() {
    getMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "My Order History",
          style: TextStyle(
              fontSize: 22, color: Theme.of(context).colorScheme.onTertiary),
        ),
      ),
      body: data == null || data!.isEmpty
          ? placeHolder
          : ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int position) {
                list.add(data?.elementAt(position)["orderId"]);
                print(list);
                return OrderRow(
                  imgUrl: data?.elementAt(position)["imgUrl"],
                  orderId: data?.elementAt(position)["orderId"],
                  dateTime: data?.elementAt(position)["orderTime"],
                  foodName: data?.elementAt(position)["mealName"],
                  price: data?.elementAt(position)["orderCost"],
                  status: data?.elementAt(position)["orderStatus"],
                );
              }),
    );
  }
}

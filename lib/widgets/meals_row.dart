import 'package:cached_network_image/cached_network_image.dart';
import 'package:nutrome_user/screens/mainpages/order_page.dart';
import 'package:flutter/material.dart';

class MealsRow extends StatefulWidget {
  const MealsRow({
    Key? key,
    required this.time,
    required this.foodName,
    required this.price,
    required this.ingredients,
    required this.description,
    required this.img1Url,
    required this.img2Url,
    required this.mealId,
    required this.deliveryCharges,
    required this.taxes,
    required this.mealType,
  }) : super(key: key);
  final String time;
  final String foodName;
  final double price;
  final double deliveryCharges;
  final double taxes;
  final String mealId;
  final String ingredients;
  final String description;
  final String img1Url;
  final String img2Url;
  final String mealType;

  @override
  State<MealsRow> createState() => _MealsRowState();
}

class _MealsRowState extends State<MealsRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5, 5.0, 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderPage(
                          mealId: widget.mealId,
                          foodName: widget.foodName,
                          price: widget.price,
                          description: widget.description,
                          ingredients: widget.ingredients,
                          time: widget.time,
                          img1Url: widget.img1Url,
                          img2Url: widget.img2Url,
                          deliveryCharges: widget.deliveryCharges,
                          taxes: widget.taxes,
                          mealType: widget.mealType,
                        )));
          }),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.img1Url,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Icon(Icons.photo),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.width * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          widget.foodName,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.green[400],
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          widget.ingredients,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          "Rs.${widget.price.toString()} /-",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(widget.time,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                      ),
                    ],
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

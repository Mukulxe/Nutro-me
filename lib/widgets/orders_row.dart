import 'package:cached_network_image/cached_network_image.dart';
import 'package:nutrome_user/screens/mainpages/trackmeal.dart';
import 'package:flutter/material.dart';

class OrderRow extends StatefulWidget {
  final String dateTime;
  final String foodName;
  final String price;
  final String status;
  final String orderId;
  final String imgUrl;
  const OrderRow(
      {Key? key,
      required this.dateTime,
      required this.foodName,
      required this.price,
      required this.orderId,
      required this.imgUrl,
      required this.status})
      : super(key: key);

  @override
  State<OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<OrderRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5, 5.0, 5),
      child: GestureDetector(
        onTap: () {
          if (widget.orderId.contains("#")) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrackMeal(orderId: widget.orderId)));
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.imgUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Icon(Icons.photo),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.width * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.dateTime.substring(0, 10),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[400],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          widget.foodName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Center()),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.status,
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Rs.${widget.price.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
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

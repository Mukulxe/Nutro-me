import 'package:cached_network_image/cached_network_image.dart';
import 'package:nutrome_user/utility/data_models.dart';
import 'package:nutrome_user/utility/sqlite_db.dart';
import 'package:flutter/material.dart';

class CartRow extends StatefulWidget {
  final CartModel cartModel;
  const CartRow({Key? key, required this.cartModel}) : super(key: key);

  @override
  State<CartRow> createState() => _CartRowState();
}

class _CartRowState extends State<CartRow> {
  int quantity = 0;
  CartDB cartDB = CartDB();

  void mealQuantity() async {
    List<CartModel> cart = await cartDB.getCartItems();
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].mealId.contains(widget.cartModel.mealId)) {
        quantity = cart[i].quantity;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    mealQuantity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.cartModel.imgUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(widget.cartModel.mealName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                            fontSize: 14,
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.cartModel.price.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.cartModel.mealType.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(child: Center()),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      if (quantity == 1) {
                        cartDB.delete(widget.cartModel.mealId);
                        return;
                      }
                      mealQuantity();
                      CartModel cartModel = CartModel(
                        mealId: widget.cartModel.mealId,
                        mealName: widget.cartModel.mealName,
                        imgUrl: widget.cartModel.imgUrl,
                        quantity: widget.cartModel.quantity,
                        price: widget.cartModel.price,
                        taxes: widget.cartModel.taxes,
                        deliveryCharges: widget.cartModel.deliveryCharges,
                        mealType: widget.cartModel.mealType,
                      );
                      await cartDB.update(cartModel, quantity, false);
                      mealQuantity();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 12,
                        height: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(quantity.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      mealQuantity();
                      CartModel cartModel = CartModel(
                        mealId: widget.cartModel.mealId,
                        mealName: widget.cartModel.mealName,
                        imgUrl: widget.cartModel.imgUrl,
                        quantity: quantity,
                        price: widget.cartModel.price,
                        taxes: widget.cartModel.taxes,
                        deliveryCharges: widget.cartModel.deliveryCharges,
                        mealType: widget.cartModel.mealType,
                      );
                      await cartDB.update(cartModel, quantity, true);
                      mealQuantity();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

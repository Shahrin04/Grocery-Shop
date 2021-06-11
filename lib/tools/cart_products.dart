import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  final String cart_name;
  final String cart_image;
  final String cart_quantity;
  final String cart_price;

  CartProducts(
      {Key key,
      this.cart_name,
      this.cart_image,
      this.cart_quantity,
      this.cart_price})
      : super(key: key);

  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

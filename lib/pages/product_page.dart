import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/db/cart_info.dart';
import 'package:grocery_app/pages/my_cart.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:grocery_app/wrapper.dart';
import 'package:intl/intl.dart';
import 'package:nonce/nonce.dart';

class ProductPage extends StatefulWidget {
  final String product_description;
  final String product_image;
  final String product_name;
  final String product_price;
  final String product_quantity;
  final String product_pid;

  ProductPage(
      {Key key,
      this.product_description,
      this.product_image,
      this.product_name,
      this.product_price,
      this.product_quantity,
      this.product_pid})
      : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  int quant = 1;
  List<String> date;
  String time;
  String dateTime = '';
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    CartInfo _cartInfo = CartInfo(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Product Page'),
      ),
      body: ListView(
        children: [
          Container(
            height: 300,
            child: Image.network(
              widget.product_image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    widget.product_name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.product_quantity,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${widget.product_price} TK',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Text(
                  widget.product_description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: MaterialButton(
                          onPressed: () {
                            time = DateFormat.jms().format(now);
                            date = [
                              now.day.toString(),
                              now.month.toString(),
                              now.year.toString()
                            ];
                            dateTime = '${date[0]}-${date[1]}-${date[2]},$time';

                            addToCart(_cartInfo);

                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Wrapper(1)));

                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Wrapper()));
                            //Navigator.pop(context);
                          },
                          color: Colors.green,
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        height: 35,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 35,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(4)),
                              child: IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      if (quant != null && quant >= 2) {
                                        quant = quant - 1;
                                      }
                                    });
                                  }),
                            ),
                            SizedBox(
                                width: 50,
                                child: Center(
                                  child: Text(
                                    '$quant',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )),
                            Container(
                              height: 35,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.lightGreen[700],
                                  borderRadius: BorderRadius.circular(4)),
                              child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      quant = quant + 1;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void addToCart(CartInfo _cartInfo) {
    try {
      _cartInfo.createCartInfo({
        'dateTime': dateTime,
        'id': _firebaseAuth.currentUser.uid,
        'email': _firebaseAuth.currentUser.email.replaceAll('.', ' '),
        'pid': widget.product_pid,
        'image': widget.product_image,
        'name': widget.product_name,
        'price': widget.product_price,
        'quantity': widget.product_quantity,
        'description': widget.product_description,
        'itemNumber': quant.toString(),
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

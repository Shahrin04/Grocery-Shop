import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/db/order_history.dart';
import 'package:grocery_app/model/cart_product_model.dart';
import 'package:grocery_app/model/confirm_order_model.dart';
import 'package:grocery_app/pages/profile.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:grocery_app/pages/statements.dart';
import 'package:grocery_app/tools/single_statement.dart';
import 'package:grocery_app/wrapper.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class ConfirmOrder extends StatefulWidget {
  final String totalPrice;

  //final String date;
  final String items;
  List<CartProductModel> cartProduct = [];

  ConfirmOrder({Key key, this.totalPrice, this.items, this.cartProduct})
      : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String name, mobile, address;
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('users');

  DateTime now = DateTime.now();
  String time = '';
  List<String> date = [];
  String dateTime = '';

  @override
  void initState() {
    super.initState();
//========================== User Info =================================
    reference
        .orderByKey()
        .equalTo('${_auth.currentUser.uid}')
        //  .child('${_auth.currentUser.uid}')
        .once()
        .then((DataSnapshot dataSnapshot) {
      var KEYS = dataSnapshot.value.keys;
      var DATA = dataSnapshot.value;

      name = '';
      mobile = '';
      address = '';
      for (var individualKey in KEYS) {
        ConfirmOrderModel confirmOrderModel = new ConfirmOrderModel(
          DATA[individualKey]['address'],
          DATA[individualKey]['mobile'],
          DATA[individualKey]['name'],
        );
        //orderList.add(confirmOrderModel);
        name = confirmOrderModel.name.toString();
        mobile = confirmOrderModel.mobile.toString();
        address = confirmOrderModel.address.toString();
      }
//========================== User Info =================================

      setState(() {
        print('cartProduct: ${widget.cartProduct.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderHistory _orderHistory = OrderHistory(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Confirm Order'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Statements',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 500,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.lightGreen[700], width: 2)),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    SizedBox(width: 45),
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    SizedBox(width: 28),
                                    Text(
                                      'Qty',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      'Price(Tk)',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Flexible(
                                child: ListView.builder(
                                    //shrinkWrap: true,
                                    itemCount: widget.cartProduct.length,
                                    itemBuilder: (context, index) {
                                      return SingleStatement(
                                        single_statement_prod_name:
                                            widget.cartProduct[index].name,
                                        single_statement_prod_amount:
                                            widget.cartProduct[index].quantity,
                                        single_statement_prod_quantity: widget
                                            .cartProduct[index].itemNumber,
                                        single_statement_prod_price:
                                            widget.cartProduct[index].price,
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

//=========================Customers Statements Part============================================

//=========================Customers Address Part============================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Total Amount: ${widget.totalPrice} Tk',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 500,
                      height: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.lightGreen[700], width: 2)),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Profile()));
                                    },
                                    child: Material(
                                        elevation: 0.5,
                                        color: Colors.lightGreen[700],
                                        borderRadius: BorderRadius.circular(5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        )),
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Text(
                                  'Name: $name',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Contact No: $mobile',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Address: $address',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    RaisedButton(
                      onPressed: () {
//===================Capturing Present Time=================================
                        time = DateFormat.jms().format(now);
                        date = [
                          now.day.toString(),
                          now.month.toString(),
                          now.year.toString()
                        ];
                        dateTime = '${date[0]}-${date[1]}-${date[2]}, $time';
//===================Capturing Present Time=================================

                        removeCartInfo();

                        orderHistory(_orderHistory);

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Order Confirmed'),
                                content: Text(
                                    'Your order has been placed Successfully, You can see them in the Statements Tab'),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Wrapper(0)));
                                      },
                                      child: Text('Ok'))
                                ],
                              );
                            });

                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => StartUpPage()));
                      },
                      color: Colors.lightGreen[700],
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void orderHistory(OrderHistory _orderHistory) {
    try {
      _orderHistory.createOrderHistory({
        'date': dateTime,
        'totalAmount': '${widget.totalPrice} Tk',
        'items': '${widget.items}',
      });
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  void removeCartInfo() {
    DatabaseReference removeRef =
        FirebaseDatabase.instance.reference().child('Cart Info');

    removeRef.child('${_auth.currentUser.uid}').remove();
  }
}

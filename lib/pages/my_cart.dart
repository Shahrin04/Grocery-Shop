import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/cart_product_model.dart';
import 'package:grocery_app/pages/HomePage.dart';
import 'package:grocery_app/pages/confirm_order.dart';
import 'package:grocery_app/pages/product_page.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:grocery_app/wrapper.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<CartProductModel> cartProduct = [];
  DatabaseReference cartReference =
      FirebaseDatabase.instance.reference().child('Cart Info');

  var items = '';
  var price = 0, quantity = 0, perItemPrice = 0;
  var totalPrice = 0;

  @override
  void initState() {
    super.initState();

    cartReference
        .child(
            '${_auth.currentUser.uid}/${_auth.currentUser.email.replaceAll('.', ' ')}')
        .once()
        .then((DataSnapshot dataSnapshot) {
      var KEYS = dataSnapshot.value.keys;
      var DATA = dataSnapshot.value;

      cartProduct.clear();
      for (var individualKey in KEYS) {
        CartProductModel cartProductModel = new CartProductModel(
          DATA[individualKey]['image'],
          DATA[individualKey]['itemNumber'],
          DATA[individualKey]['name'],
          DATA[individualKey]['price'],
          DATA[individualKey]['quantity'],
          DATA[individualKey]['pid'],
          DATA[individualKey]['description'],
          DATA[individualKey]['dateTime'],
        );
        cartProduct.add(cartProductModel);
      }

      for (int i = 0; i <= cartProduct.length; i++) {
        setState(() {
          price = int.parse(cartProduct[i].price);
          quantity = int.parse(cartProduct[i].itemNumber);

          perItemPrice = price * quantity;
          totalPrice = totalPrice + perItemPrice;

          items = items +
              '${cartProduct[i].name} (${cartProduct[i].itemNumber}) (${cartProduct[i].quantity}) - ${cartProduct[i].price} TK,  ';
        });
      }

      // setState(() {
      //   // print('Length: ${cartProduct.length}');
      //   // print('Length: ${_auth.currentUser.uid}');
      //   // print('Range: ${cartProduct.getRange(0, cartProduct.length)}');
      //
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: Container(
        child: cartProduct.length == 0
            ? Center(
                child: Container(child: Text('Currently No Product to Display'))
                // CircularProgressIndicator(
                //   valueColor:
                //       AlwaysStoppedAnimation<Color>(Colors.lightGreen[700]),
                // ),
              )
            : ListView.builder(
                itemCount: cartProduct.length,
                itemBuilder: (context, index) {
                  return SingleCartProduct(
                    single_cart_prod_name: cartProduct[index].name.toString(),
                    single_cart_prod_image: cartProduct[index].image.toString(),
                    single_cart_prod_quantity:
                        cartProduct[index].quantity.toString(),
                    single_cart_prod_itemNumber:
                        cartProduct[index].itemNumber.toString(),
                    single_cart_prod_price: cartProduct[index].price.toString(),
                    single_cart_prod_pid: cartProduct[index].pid.toString(),
                    single_cart_prod_description:
                        cartProduct[index].description.toString(),
                    single_cart_prod_dateTime:
                        cartProduct[index].dateTime.toString(),
                  );
                }),
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: ListTile(
              title: Text(
                'Total:',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                '$totalPrice Tk',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            )),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmOrder(
                                totalPrice: totalPrice.toString(),
                                //date: cartProduct[0].dateTime,
                                items: items,
                                cartProduct: cartProduct,
                              )));
                },
                color: Colors.lightGreen[700],
                child: Text(
                  'Check Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      //CartProducts(),
    );
  }
}

class SingleCartProduct extends StatefulWidget {
  final single_cart_prod_name;
  final single_cart_prod_image;
  final single_cart_prod_quantity;
  final single_cart_prod_itemNumber;
  final single_cart_prod_price;
  final single_cart_prod_pid;
  final single_cart_prod_description;
  final single_cart_prod_dateTime;

  SingleCartProduct(
      {this.single_cart_prod_name,
      this.single_cart_prod_image,
      this.single_cart_prod_quantity,
      this.single_cart_prod_itemNumber,
      this.single_cart_prod_price,
      this.single_cart_prod_pid,
      this.single_cart_prod_description,
      this.single_cart_prod_dateTime});

  @override
  _SingleCartProductState createState() => _SingleCartProductState();
}

class _SingleCartProductState extends State<SingleCartProduct> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
//        ==========this is leading part==========
        leading: Image.network(widget.single_cart_prod_image, width: 70),

//        ==========this is title part==========
        title: Text(widget.single_cart_prod_name),

//        ==========this is title part==========
        subtitle: Column(
          children: [
            Row(
              children: [
                Text(widget.single_cart_prod_quantity),
                SizedBox(
                  width: 20,
                ),
                Text('Quantity: ${widget.single_cart_prod_itemNumber}'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                '${widget.single_cart_prod_price} Tk',
                style: TextStyle(
                    color: Colors.lightGreen[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            FirebaseAuth removeAuth = FirebaseAuth.instance;

            DatabaseReference removeReference =
                FirebaseDatabase.instance.reference().child('Cart Info');

            removeReference
                .child('${removeAuth.currentUser.uid}')
                .child('${removeAuth.currentUser.email.replaceAll('.', ' ')}')
                .child('${widget.single_cart_prod_pid}')
                .remove()
                .whenComplete(() => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Wrapper(0))));
            // .whenComplete(() =>
            //     Navigator.of(context, rootNavigator: true).pop(context));
            // .then((value) => Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => StartUpPage())));
          },
          iconSize: 20,
          icon: Material(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
            child: Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// class SingleCartProduct extends StatelessWidget {
//   final single_cart_prod_name;
//   final single_cart_prod_image;
//   final single_cart_prod_quantity;
//   final single_cart_prod_itemNumber;
//   final single_cart_prod_price;
//   final single_cart_prod_pid;
//   final single_cart_prod_description;
//   final single_cart_prod_dateTime;
//
//   SingleCartProduct(
//       {this.single_cart_prod_name,
//       this.single_cart_prod_image,
//       this.single_cart_prod_quantity,
//       this.single_cart_prod_itemNumber,
//       this.single_cart_prod_price,
//       this.single_cart_prod_pid,
//       this.single_cart_prod_description,
//       this.single_cart_prod_dateTime});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
// //        ==========this is leading part==========
//         leading: Image.network(single_cart_prod_image, width: 70),
//
// //        ==========this is title part==========
//         title: Text(single_cart_prod_name),
//
// //        ==========this is title part==========
//         subtitle: Column(
//           children: [
//             Row(
//               children: [
//                 Text(single_cart_prod_quantity),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Text('Quantity: $single_cart_prod_itemNumber'),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 '$single_cart_prod_price Tk',
//                 style: TextStyle(
//                     color: Colors.lightGreen[700],
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//             )
//           ],
//         ),
//         trailing: IconButton(
//           onPressed: () {
//             FirebaseAuth removeAuth = FirebaseAuth.instance;
//
//             DatabaseReference removeReference =
//                 FirebaseDatabase.instance.reference().child('Cart Info');
//
//             removeReference
//                 .child('${removeAuth.currentUser.uid}')
//                 .child('${removeAuth.currentUser.email.replaceAll('.', ' ')}')
//                 .child('$single_cart_prod_pid')
//                 .remove()
//                 .then((value) => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => StartUpPage())));
//           },
//           iconSize: 20,
//           icon: Material(
//             color: Colors.red,
//             borderRadius: BorderRadius.circular(5),
//             child: Icon(
//               Icons.close_rounded,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

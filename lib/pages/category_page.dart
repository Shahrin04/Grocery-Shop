import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_app/pages/product_page.dart';

class CategoryPage extends StatefulWidget {
  final String catImage;
  final String title;
  final String tag;

  CategoryPage({Key key, this.catImage, this.title, this.tag})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference productRef =
        FirebaseDatabase.instance.reference().child('products');
    productRef
        .orderByChild('category')
        .equalTo(widget.title)
        .once()
        .then((DataSnapshot dataSnapshot) {
      var KEYS = dataSnapshot.value.keys;
      var DATA = dataSnapshot.value;

      products.clear();
      for (var individualKey in KEYS) {
        ProductModel productModel = new ProductModel(
          DATA[individualKey]['category'],
          DATA[individualKey]['description'],
          DATA[individualKey]['image'],
          DATA[individualKey]['name'],
          DATA[individualKey]['pid'],
          DATA[individualKey]['price'],
          DATA[individualKey]['quantity'],
          DATA[individualKey]['type'],
        );
        products.add(productModel);
      }
      setState(() {
        // print(products.length);
        // print('hello');
        // print(widget.title);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.white,
                  expandedHeight: 140,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(widget.catImage),
                            fit: BoxFit.cover),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.black.withOpacity(0.6),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
                child: products.length == 0
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.lightGreen[700]),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisSpacing: 14),
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return productUI(
                            products[index].category,
                            products[index].description,
                            products[index].image,
                            products[index].name,
                            products[index].pid,
                            products[index].price,
                            products[index].quantity,
                            products[index].type,
                          );
                        }))));
  }

  Widget productUI(String category, String description, String image,
      String name, String pid, String price, String quantity, String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(
                    product_description: description,
                    product_image: image,
                    product_name: name,
                    product_price: price,
                    product_quantity: quantity,
                    product_pid: pid)));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 140,
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
            // SizedBox(height: 4),
            // Text(
            //   quantity,
            //   style: TextStyle(fontSize: 14, color: Colors.black),
            // ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$price TK',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                SizedBox(width: 4),
                Text(
                  '($quantity)',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

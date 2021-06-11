import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:grocery_app/model/product.dart';
import 'package:grocery_app/pages/category_page.dart';
import 'package:grocery_app/pages/product_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Container(
                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(Radius.circular(22))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: SimpleAutoCompleteTextField(
                          key: key,
                          controller: _searchText,
                          textCapitalization: TextCapitalization.sentences,
                          suggestions: [
                            "Cherry Pineapple",
                            "Green Coconut (Daab)",
                            "Paka Pape",
                            "Banana Sagor",
                            "Tomatoes",
                            "Onion (Local)",
                            "Coriander Leaves",
                            "Long Lemon",
                            "White Bread",
                            "Savory Breadcrumbs",
                            "Mr.Cookie Butter Coconut Biscuits",
                            "Saffola Honey",
                            "Shrimp Golda",
                            "Kaski Fish",
                            "Whole Hilsha (Net Weight ± 50 gm)",
                            "Khaas Food Organic Loitta Dry Fish",
                            "Aarong Dairy Full Cream Liquid Milk",
                            "Pran Dhaka Cheese",
                            "Aarong Dairy Sour Yogurt",
                            "Purnava Vitamin E Egg",
                            "Meat Beef Bone In (Net Weight ± 50 gm)",
                            "Roast Chicken (Net Weight ± 20 gm)",
                            "Cow Liver",
                            "Mutton Brain",
                            "Rupchanda Soyabean Oil",
                            "Radhuni Pure Mustard Oil",
                            "Oillina Extra Virgin Olive Oil",
                            "Royal Chef Sunflower Oil",
                            "Radhuni Biryani Masala",
                            "Ahmed Firni Mix",
                            "Ahmed Haleem Mix",
                            "Radhuni Falooda Mix (Mango)",
                            "Chinigura Rice",
                            "Aarong Miniket Rice",
                            "Pran Nazirshail Rice",
                            "ACI Pure Miniket Rice",
                          ],
                          decoration: InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 0,
                        child: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              findProduct(_searchText);
                            })),
                  ],

                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            SizedBox(
              height: 150,
              //width: double.infinity,
              child: Carousel(
                boxFit: BoxFit.cover,
                indicatorBgPadding: 2.0,
                dotSize: 5.0,
                dotIncreasedColor: Colors.lightGreen[700],
                dotColor: Colors.grey[300],
                dotBgColor: Colors.transparent,
                autoplay: false,
                images: [
                  Image.asset('assets/images/caro5.png'),
                  Image.asset('assets/images/caro6.jpg'),
                  Image.asset('assets/images/caro4.png'),
                ],
              ),
            ),
            Flexible(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  makeCategory(
                      catImage: 'assets/images/category/fresh fruits.jpg',
                      title: 'Fresh Fruits',
                      tag: 'fruits'),
                  makeCategory(
                      catImage: 'assets/images/category/fresh vegetables.jpg',
                      title: 'Fresh Vegetables',
                      tag: 'vegetables'),
                  makeCategory(
                      catImage: 'assets/images/category/bakery.jpg',
                      title: 'Bakery',
                      tag: 'bakery'),
                  makeCategory(
                      catImage: 'assets/images/category/dairy.jpg',
                      title: 'Dairy',
                      tag: 'Dairy'),
                  makeCategory(
                      catImage: 'assets/images/category/fish.jpg',
                      title: 'Fish',
                      tag: 'fish'),
                  makeCategory(
                      catImage: 'assets/images/category/food oil.jpg',
                      title: 'Food Oil',
                      tag: 'food oil'),
                  makeCategory(
                      catImage: 'assets/images/category/meat.jpg',
                      title: 'Meat',
                      tag: 'Meat'),
                  makeCategory(
                      catImage: 'assets/images/category/redy mix.jpg',
                      title: 'Ready Mix',
                      tag: 'ready mix'),
                  makeCategory(
                      catImage: 'assets/images/category/rice.jpg',
                      title: 'Rice',
                      tag: 'rice'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeCategory({catImage, title, tag}) {
    return AspectRatio(
      aspectRatio: 2 / 2,
      child: Hero(
          tag: tag,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryPage(
                          catImage: catImage, title: title, tag: tag)));
            },
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: 80,
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(catImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void findProduct(TextEditingController searchText) {
    List<ProductModel> products = [];

    DatabaseReference productRef =
        FirebaseDatabase.instance.reference().child('products');
    productRef
        .orderByChild('name')
        .equalTo('${searchText.text}')
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
      // setState(() {
      //   // print(products.length);
      //   // print('hello');
      //   // print(widget.title);
      // });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductPage(
                  product_description: products[0].description,
                  product_image: products[0].image,
                  product_name: products[0].name,
                  product_price: products[0].price,
                  product_quantity: products[0].quantity,
                  product_pid: products[0].pid)));
    });
  }
}

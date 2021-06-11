import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/cart_product_model.dart';
import 'package:grocery_app/model/statements_model.dart';
import 'package:grocery_app/tools/single_statement.dart';

class Statements extends StatefulWidget {
  @override
  _StatementsState createState() => _StatementsState();
}

class _StatementsState extends State<Statements> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<StatementsModel> statementsList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference orderHistory =
        FirebaseDatabase.instance.reference().child('users');

    orderHistory
        //.orderByChild('${_auth.currentUser.uid}/Order History')
        .child('${_auth.currentUser.uid}/Order History')
        .once()
        .then((DataSnapshot dataSnapshot) {
      var KEYS = dataSnapshot.value.keys;
      var DATA = dataSnapshot.value;

      statementsList.clear();

      for (var individualKey in KEYS) {
        StatementsModel statementsModel = StatementsModel(
          DATA[individualKey]['date'],
          DATA[individualKey]['items'],
          DATA[individualKey]['totalAmount'],
        );
        statementsList.add(statementsModel);
      }

      setState(() {
        print('${statementsList[0].totalAmount}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Statements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: statementsList.length == 0
              ? Center(
                  child: Container(child: Text('Currently No Order to Display'))
                  // CircularProgressIndicator(
                  //   valueColor:
                  //       AlwaysStoppedAnimation<Color>(Colors.lightGreen[700]),
                  // ),
                )
              : ListView.builder(
                  itemCount: statementsList.length,
                  itemBuilder: (context, index) {
                    return SingleStatementCard(
                      statement_dateTime: statementsList[index].date.toString(),
                      statement_items: statementsList[index].items.toString(),
                      statement_totalAmount:
                          statementsList[index].totalAmount.toString(),
                    );
                  }),
        ),
      ),
    );
  }
}

class SingleStatementCard extends StatelessWidget {
  final statement_dateTime;
  final statement_items;
  final statement_totalAmount;

  SingleStatementCard(
      {this.statement_dateTime,
      this.statement_items,
      this.statement_totalAmount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        alertDialog(context, statement_items);
      },
      child: Card(
        color: Colors.lightGreen[400],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order Date & Time',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      'Total Amount',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      statement_dateTime,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      statement_totalAmount,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(Icons.menu, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void alertDialog(BuildContext context, statement_items) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Ordered items'),
          content: Text('$statement_items'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'))
          ],
        );
      });
}

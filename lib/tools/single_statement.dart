import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SingleStatement extends StatelessWidget {
  final single_statement_prod_name;
  final single_statement_prod_amount;
  final single_statement_prod_quantity;
  final single_statement_prod_price;

  SingleStatement(
      {this.single_statement_prod_name,
      this.single_statement_prod_amount,
      this.single_statement_prod_quantity,
      this.single_statement_prod_price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 95,
                    height: 40,
                    child: Text(
                      '$single_statement_prod_name',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 60,
                    height: 40,
                    child: Text(
                      '$single_statement_prod_amount',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(width: 35),
                  SizedBox(
                    width: 30,
                    height: 40,
                    child: Text(
                      '$single_statement_prod_quantity',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(width: 28),
                  SizedBox(
                    width: 50,
                    height: 40,
                    child: Text(
                      '$single_statement_prod_price',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

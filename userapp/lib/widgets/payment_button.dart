import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  String name, amount;
   PaymentButton({
    Key? key,
     required this.name,
     required this.amount
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
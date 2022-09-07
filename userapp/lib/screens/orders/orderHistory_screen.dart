import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/orders_model.dart';
import '../../providers/orders_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'orders_widget.dart';

class OrderHistory extends StatefulWidget {
  static const routeName = '/OrderHistory';
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const EmptyScreen(
            title: 'You didnt place any order yet',
            subtitle: 'order something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
              : Scaffold(
              appBar: AppBar(
                leading: const BackWidget(),
                elevation: 0,
                centerTitle: false,
                title: TextWidget(
                  text: 'Your orders (${ordersList.length})',
                  color: color,
                  textSize: 24.0,
                  isTitle: true,
                ),
                backgroundColor: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
              ),
              body: ListView.separated(
                itemCount: ordersList.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2, vertical: 6),
                    child: ChangeNotifierProvider.value(
                      value: ordersList[index],
                      child: const OrderWidget(),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: color,
                    thickness: 1,
                  );
                },
              ));
        });
  }
}
/*Container(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orderDateToShow,style: const TextStyle(fontSize: 18),),
                  Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green
                    ),
                    child: const Center(
                      child: Text('Paid',style: TextStyle(fontSize: 18),),
                    ),
                  )
                ],
              ),
              Center(
                child: Text('${getCurrProduct.price}',style: const TextStyle(fontSize: 18),),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orderDateToShow,style: const TextStyle(fontSize: 18),),
                  Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.red
                    ),
                    child: const Center(
                      child: Text('UnPaid',style: TextStyle(fontSize: 18),),
                    ),
                  )
                ],
              ),
              Center(
                child: Text('${getCurrProduct.price}',style: const TextStyle(fontSize: 18),),
              )
            ],
          ),
        ),*/
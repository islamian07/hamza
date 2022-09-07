import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/orders_model.dart';
import '../../providers/product_provider.dart';
import '../../services/utils.dart';

class InstallmentOrders extends StatefulWidget {
  const InstallmentOrders({Key? key}) : super(key: key);

  @override
  State<InstallmentOrders> createState() => _InstallmentOrdersState();
}

class _InstallmentOrdersState extends State<InstallmentOrders> {

  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/screens/bottom_bar_screen.dart';

import 'providers/product_provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
   @override
  void initState() {
   Future.delayed(const Duration(microseconds: 5),() async{
     final productProvider = Provider.of<ProductProvider>(context,listen: false);
     await productProvider.fetchProducts();

     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const BottomBarScreen()));
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

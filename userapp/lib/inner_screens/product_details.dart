import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:userapp/consts/firebase_consts.dart';
import 'package:userapp/providers/orders_provider.dart';
import 'package:userapp/services/global_methods.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';
import '../widgets/heart_btn.dart';
import '../widgets/payment_button.dart';
import '../widgets/text_widget.dart';

class ProductDetail extends StatefulWidget {
  static const routName = "/ProductDetail";

  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productProviders = Provider.of<ProductProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProviders.findProdById(productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final getCurrProduct = productProviders.findProdById(productId);

    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);

    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
            Navigator.canPop(context) ? Navigator.pop(context) : null,
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: Column(children: [
        Flexible(
          flex: 2,
          child: FancyShimmerImage(
            imageUrl: getCurrentProduct.imageUrl,
            boxFit: BoxFit.scaleDown,
            width: size.width,
            // height: screenHeight * .4,
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextWidget(
                          text: getCurrentProduct.title,
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                      ),
                     // const HeartBTN(),
                    ],
                  ),
                ),

          Padding(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: TextWidget(
              text: 'Total Price = ${totalPrice.toStringAsFixed(2)} Rs',
              color: Colors.red.shade300,
              textSize: 16,
              isTitle: true,
            ),
          ),
                /*Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: getCurrentProduct.salePrice.toStringAsFixed(2),
                        color: Colors.green,
                        textSize: 22,
                        isTitle: true,
                      ),

                      Visibility(
                        visible: getCurrentProduct.isOnSale? true: false,
                        child: Text(
                          getCurrentProduct.price.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 15,
                              color: color,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(63, 200, 101, 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextWidget(
                          text: 'Free delivery',
                          color: Colors.white,
                          textSize: 20,
                          isTitle: true,
                        ),
                      ),
                    ],
                  ),
                ),*/

                const Spacer(),
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'Total Price = ${totalPrice.toStringAsFixed(2)} Rs',
                              color: Colors.red.shade300,
                              textSize: 16,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Material(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () async{
                              User? user = authInstance.currentUser;
                              final orderId = const Uuid().v4();
                              final productProvider = Provider.of<ProductProvider>(context,listen: false);

                              final getCurrentProduct = productProvider.findProdById(productId);
                              try{
                                await FirebaseFirestore.instance.collection('orders')
                                    .doc(orderId).set({
                                  'orderId': orderId,
                                  'userId': user!.uid,
                                  'productId': productId,
                                  'price': getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price,
                                  'totalPrice': totalPrice,
                                  'imageUrl': getCurrentProduct.imageUrl,
                                  'userName': user.displayName,
                                  'orderDate': Timestamp.now(),
                                });
                                ordersProvider.fetchOrders();
                                await Fluttertoast.showToast(
                                  msg: "Your order has been placed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              }catch(error){
                                GlobalMethods.errorDialog(subtitle: error.toString(), context: context);
                              }finally{}
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextWidget(
                                    text: 'Order Now',
                                    color: Colors.white,
                                    textSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            )),
      ),
    );
  }
}
/*
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
            Navigator.canPop(context) ? Navigator.pop(context) : null,
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: SizedBox(
        width: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: FancyShimmerImage(
                imageUrl:
                    'https://www.androidauthority.com/wp-content/uploads/2022/02/Samsung-Galaxy-S22-family-range-camera-closeups.jpg',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Samsung Note 10 Plus On Installment',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            PaymentButton(name: 'Down Payment', amount: 'Rs 4.375'),
            PaymentButton(name: 'Per Month Installment', amount: 'Rs 4.375'),
            PaymentButton(name: 'Total Installments', amount: '11'),
            PaymentButton(name: 'Electronic Brand', amount: 'Samsung'),
            PaymentButton(name: 'Condition', amount: 'New'),
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Center(
                  child: TextButton(
                child: const Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () {},
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.chat,
          color: Colors.blue,
        ),
      ),
    );
  }
}
*/

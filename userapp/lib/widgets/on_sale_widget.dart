import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:userapp/widgets/text_widget.dart';
import '../inner_screens/product_details.dart';
import '../models/product_model.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'price_widget.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, ProductDetail.routName,arguments: productModel.id);
           /* GlobalMethods.navigateTo(
                ctx: context, routeName: ProductDetail.routName);*/
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FancyShimmerImage(
                    imageUrl: productModel.imageUrl,
                    height: size.width * 0.22,
                    width: size.width * 0.25,
                    boxFit: BoxFit.fill,
                  ),
                  /*GestureDetector(
                    onTap: () {
                      print('print heart button is pressed');
                    },
                    child: Icon(
                      IconlyLight.heart,
                      size: 22,
                      color: color,
                    ),
                  ),*/
                  const SizedBox(height: 5,),
                  PriceWidget(
                    salePrice: productModel.salePrice,
                    price: productModel.price,
                    textPrice: '1',
                    isOnSale: true,
                  ),
                  const SizedBox(height: 5),
                  TextWidget(text: productModel.title, color: color, textSize: 16, isTitle: true,),
                  const SizedBox(height: 5),
                ]),
          ),
        ),
      ),
    );
  }
}

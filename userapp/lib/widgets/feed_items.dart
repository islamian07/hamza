import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/inner_screens/product_details.dart';
import 'package:userapp/services/global_methods.dart';
import 'package:userapp/widgets/text_widget.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';
import 'heart_btn.dart';
import 'price_widget.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetail.routName,arguments: productModel.id);
            /*GlobalMethods.navigateTo(
                ctx: context, routeName: ProductDetail.routName);*/
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child:HeartBTN(
                    productId: productModel.id,
                    isInWishList: _isInWishlist,
                  ),
                ),
                FancyShimmerImage(
                  imageUrl: productModel.imageUrl,
                  height: size.width * 0.35,
                  width: size.width * 0.35,
                  boxFit: BoxFit.cover,
                ),
              ],
            ),
                const SizedBox(
                  height: 4,
                ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: TextWidget(
                text: productModel.title,
                color: color,
                textSize: 18,
                maxLine: 1,
                isTitle: true,
              ),
            ),

            const SizedBox(
              height: 8,
            ),
            PriceWidget(
              salePrice: productModel.salePrice,
              price: productModel.price,
              textPrice: _quantityTextController.text,
              isOnSale: productModel.isOnSale,
            )

            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PriceWidget(),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        FittedBox(
                          child: TextWidget(
                            text: 'KG',
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: TextFormField(
                          controller: _quantityTextController,
                          key: const ValueKey('10'),
                          style: TextStyle(color: color, fontSize: 18),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9.]'),
                            ),
                          ],
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),*/
            // const Spacer(),
            /* SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    )),
                child: TextWidget(
                  text: 'Add to cart',
                  maxLine: 1,
                  color: color,
                  textSize: 20,
                ),
              ),
            )*/
          ]),
        ),
      ),
    );
  }
}

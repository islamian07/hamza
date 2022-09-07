import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:userapp/consts/firebase_consts.dart';
import 'package:userapp/providers/product_provider.dart';
import 'package:userapp/providers/wishlist_provider.dart';
import 'package:userapp/services/global_methods.dart';

import '../services/utils.dart';

class HeartBTN extends StatelessWidget {
  const HeartBTN({Key? key, required this.productId, this.isInWishList = false})
      : super(key: key);
  final String productId;
  final bool isInWishList;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () async{
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.errorDialog(
                subtitle: 'No user found, Please login first',
                context: context);
            return;
          }
          if (isInWishList == false && isInWishList != null) {
            await GlobalMethods.addToWishlist(productId: productId, context: context);
          } else {
            wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
                productId: productId);
          }
        await  wishlistProvider.fetchWishlist();
        } catch (error) {
        } finally {}
        //wishListProvider.addRemoveProductToWishlist(productId: productId);
      },
      child: Icon(
        isInWishList ? IconlyBold.heart : IconlyLight.heart,
        size: 22,
        color: isInWishList ? Colors.red : color,
      ),
    );
  }
}

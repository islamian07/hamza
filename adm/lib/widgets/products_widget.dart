import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../inner_screens/edit_product.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id
  }) : super(key: key);

  final String id;

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {

  String title = '';
  String description = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;


  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {

    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        setState(() {
          title = productsDoc.get('title');
          description = productsDoc.get('description');
          productCat = productsDoc.get('productCategoryName');
          imageUrl = productsDoc.get('imageUrl');
          price = productsDoc.get('price');
          salePrice = productsDoc.get('salePrice');
          isOnSale = productsDoc.get('isOnSale');
        });
      }
    } catch (error) {

      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  id: widget.id,
                  title: title,
                  description : description,
                  price: price,
                  salePrice: salePrice,
                  productCat: productCat,
                  imageUrl: imageUrl == null
                      ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                      : imageUrl!,
                  isOnSale: isOnSale,

                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                       imageUrl == null ?
                       'https://www.maids.com/blog/wp-content/uploads/2011/09/Koelkast_open.jpg'
                        : imageUrl!,
                        fit: BoxFit.cover,
                        // width: screenWidth * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                child: const Text('Edit'),
                                value: 1,
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                value: 2,
                              ),
                            ])
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),TextWidget(
                  text: isOnSale
                      ? salePrice.toStringAsFixed(2)
                      : 'PKR $price',
                  color: color,
                  textSize: 18,
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: title,
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:userapp/models/product_model.dart';
import 'package:userapp/providers/product_provider.dart';
import '../services/utils.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/text_widget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductProvider>(context);
    List<ProductModel> productOnSale = productProviders.getOnSaleProducts;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Products on sale',
          color: color,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
      body: productOnSale.isEmpty
          ? const EmptyProdWidget(text: 'No Products onSale yet!',)
          : GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(productOnSale.length, (index) {
                return  ChangeNotifierProvider.value(
                    value: productOnSale[index],
                    child: const OnSaleWidget());
              }),
            ),
    );
  }
}

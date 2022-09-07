import 'package:flutter/material.dart';
import 'package:userapp/services/utils.dart';
import 'package:userapp/widgets/categories_widget.dart';
import 'package:userapp/widgets/text_widget.dart';

class CategoriesScreen extends StatelessWidget {
   CategoriesScreen({Key? key}) : super(key: key);
   List<Color> gridColors  = [
     const Color(0xff53B175),
     const Color(0xfff8A44C),
     const Color(0xfff7Af93),
     const Color(0xffD3B0E0),
     const Color(0xffFDE598),
     const Color(0xffB7DFF5),
   ];
  List<Map<String, dynamic>> catInfo = [
    {'imgPath': 'assets/images/accessories.jpg', 'catText':  'Fruits'},
    {'imgPath': 'assets/images/accessories.jpg', 'catText':  'Tv'},
    {'imgPath': 'assets/images/accessories.jpg', 'catText':  'Cars'},
    {'imgPath': 'assets/images/accessories.jpg', 'catText':  'Electronics'},
    {'imgPath': 'assets/images/accessories.jpg', 'catText':  'Electronics'},
    {'imgPath': 'assets/images/accessories.jpg', 'catText':  'Electronics'},
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(text: 'Categories',textSize: 24,isTitle: true,color: color,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 270/250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(6,  (index) {
            return CategoriesWidget(
              catText: catInfo[index]['catText'],
              imgPath: catInfo[index]['imgPath'],
              pColor: gridColors[index],
            );
          }),
        ),
      ),
    );
  }
}
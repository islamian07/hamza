import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/inner_screens/cat_screen.dart';
import 'package:userapp/widgets/text_widget.dart';

import '../providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key, required this.catText, required this.imgPath, required this.pColor}) : super(key: key);
  final String catText, imgPath;
  final Color pColor;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, CategoryScreen.routeName,arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: pColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: pColor.withOpacity(0.7),
            width: 2,
          )
        ),
        child: Column(
          children: [
            Container(
              height: _screenWidth * 0.3,
              width: _screenWidth * 0.3,
              decoration:  BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgPath),
                  fit: BoxFit.fill
                )
              ),
            ),SizedBox(height: 5,),
            TextWidget(text: catText, color: color, textSize: 20,isTitle: true,),
          ],
        ),
      ),
    );
  }
}

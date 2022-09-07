import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/consts/theme_data.dart';
import 'package:userapp/inner_screens/cat_screen.dart';
import 'package:userapp/inner_screens/feeds_screen.dart';
import 'package:userapp/inner_screens/on_sale_screen.dart';
import 'package:userapp/providers/dark_theme_provider.dart';
import 'package:userapp/providers/orders_provider.dart';
import 'package:userapp/providers/product_provider.dart';
import 'package:userapp/providers/wishlist_provider.dart';
import 'package:userapp/screens/auth/login.dart';
import 'package:userapp/screens/bottom_bar_screen.dart';
import 'package:userapp/screens/orders/orderHistory_screen.dart';
import 'package:userapp/screens/orders/orders_screen.dart';

import 'fetch_screen.dart';
import 'inner_screens/product_details.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/register.dart';
import 'screens/homepage.dart';
import 'screens/wishlist/wishlist_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentAppTheme();
  }
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if(snapshot.hasError){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('An Error occurred'),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(
              create: (_) => ProductProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => WishlistProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) =>  OrdersProvider(),
            ),
          ],
          child:
              Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: Styles.themeData(themeProvider.getDarkTheme, context),
              home: const FetchScreen(),
              routes: {
                OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                ProductDetail.routName: (ctx) => const ProductDetail(),
                RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                LoginScreen.routeName: (ctx) => const LoginScreen(),
                ForgetPasswordScreen.routeName: (ctx) => const ForgetPasswordScreen(),
                HomePage.routeName: (ctx) => const HomePage(),
                BottomBarScreen.routeName: (ctx) => const BottomBarScreen(),
                CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                OrderHistory.routeName: (ctx) => const OrderHistory(),
              },
            );
          }),
        );
      }
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'controllers/MenuController.dart';
import 'firebase_options.dart';
import 'inner_screens/add_prod.dart';
import 'providers/dark_theme_provider.dart';
import 'screens/main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    // options: DefaultFirebaseOptions.currentPlatform
     options: const FirebaseOptions(
       apiKey: "AIzaSyC7sP4yc4b3Ow6HmZfyuP3zbKsG6G8H-30",
       authDomain: "hamza-intallment.firebaseapp.com",
       projectId: "hamza-intallment",
       storageBucket: "hamza-intallment.appspot.com",
       messagingSenderId: "375357053678",
       appId: "1:375357053678:web:2c91081544e1fde76171ff",
     ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

 // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => MenuController(),
              ),
              ChangeNotifierProvider(
                create: (_) {
                  return themeChangeProvider;
                },
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Grocery',
                    theme: Styles.themeData(themeProvider.getDarkTheme, context),
                    home: const MainScreen(),
                    routes: {
                      UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                    });
              },
            ),
          );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:userapp/screens/auth/forget_pass.dart';
import 'package:userapp/screens/auth/login.dart';
import 'package:userapp/screens/loading_manager.dart';
import 'package:userapp/screens/orders/orderHistory_screen.dart';
import 'package:userapp/services/global_methods.dart';
import 'package:userapp/widgets/text_widget.dart';
import '../consts/firebase_consts.dart';
import '../providers/dark_theme_provider.dart';
import 'orders/orders_screen.dart';
import 'wishlist/wishlist_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: '');
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }
  String? _name, _email, _address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async{
    setState(() {
      _isLoading = true;
    });
    if(user == null){
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try{
      String _uid = user!.uid;

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if(userDoc == null){
        return;
      }else{
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        _address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    }catch(error){
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(
          subtitle: '$error', context: context);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Hi,   ',
                        style: const TextStyle(
                            color: Colors.cyan,
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: _name == null? 'user': _name,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('My name is pressed');
                                }),
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: _email == null? 'user': _email!,
                    textSize: 18,
                    color: color,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _listTile(
                    title: 'Address',
                    subtitle: _address,
                    icon: IconlyLight.profile,
                    onPressed: () async {
                      await showAddressDialog();
                    },
                    color: color,
                  ),
                  _listTile(
                      title: 'Orders',
                      icon: IconlyLight.bag,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: OrdersScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: 'Wishlist',
                      icon: IconlyLight.heart,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: WishlistScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: 'Orders History',
                      icon: IconlyLight.paper,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                          ctx: context, routeName: OrderHistory.routeName);
                      },
                      color: color),
                  _listTile(
                      title: 'Forget password',
                      icon: IconlyLight.unlock,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen()));
                      },
                      color: color),
                  SwitchListTile(
                    title: TextWidget(
                      text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                      textSize: 22,
                      color: color,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                    secondary: Icon(themeState.getDarkTheme
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined),
                  ),
                  _listTile(
                      title: user == null ? 'login' : 'Logout',
                      icon: user == null ? IconlyLight.login : IconlyLight.logout,
                      onPressed: () {
                        if (user == null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                          return;
                        }
                        GlobalMethods.warningDialog(
                            title: 'Sign out',
                            subtitle: 'Do you wanna sign out?',
                            fct: () async {
                              await authInstance.signOut();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                            },
                            context: context);
                      },
                      color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showLogoutDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/warning.png',
                  height: 20,
                  width: 20,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 8),
                const Text('Sign out')
              ],
            ),
            content: const Text('Do you wanna Sign out?'),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'Cancel',
                  textSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: TextWidget(
                  color: Colors.red,
                  text: 'Ok',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }

  Future<void> showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              /*onChanged: (value) {
                print('${_addressTextController.text}');
              },*/
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Your Address'),
            ),
            actions: [
              TextButton(onPressed: () async{
                String _uid = user!.uid;
                try{
                  await FirebaseFirestore.instance.collection('users').doc(_uid).update({
                    'shipping-address': _addressTextController.text,
                  });
                  Navigator.pop(context);
                  setState(() {
                    _address = _addressTextController.text;
                  });
                }catch(error){
                  GlobalMethods.errorDialog(subtitle: error.toString(), context: context);
                }
              }, child: const Text('Update'))
            ],
          );
        });
  }

  Widget _listTile(
      {required String title,
      String? subtitle,
      required IconData icon,
      required Function onPressed,
      required Color color}) {
    return ListTile(
      title: TextWidget(
        text: title,
        textSize: 22,
        color: color,
      ),
      subtitle: Text(subtitle ?? ''),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}

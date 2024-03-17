import 'package:chat_app_mozz_test/firebase_options.dart';
import 'package:chat_app_mozz_test/screens/chat_list_screen.dart';
import 'package:chat_app_mozz_test/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark, statusBarColor: Colors.white),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> isAuth() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('uid') != null) {
      return true;
    }
    return false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: FutureBuilder(
        future: isAuth(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return const ChatListScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}

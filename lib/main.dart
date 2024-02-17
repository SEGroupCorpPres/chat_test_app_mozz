import 'package:chat_app_mozz_test/firebase_options.dart';
import 'package:chat_app_mozz_test/screens/chat_list_screen.dart';
import 'package:chat_app_mozz_test/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print('${sharedPreferences.get('uid')}  user id');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const ChatListScreen(title: 'Flutter Demo Home Page'),
      home: SignInScreen(),
      // home: ChatRoomScreen(context: context, index:0, colorIndex: 2,),
    );
  }
}

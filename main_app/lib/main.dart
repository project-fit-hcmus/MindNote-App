import 'package:flutter/material.dart';
import 'package:main_app/screens/register.dart';
import 'package:main_app/screens/started.dart';
import 'screens/login.dart';
import 'Theme/mainTheme.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  runApp(const MyApp());
}

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   

    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/started': (context) => StartedScreen(),
      },

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:  ColorScheme.fromSeed(seedColor: AppThemeLight.primaryColor),      // light version
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: StartedScreen(),
    );
  }
}

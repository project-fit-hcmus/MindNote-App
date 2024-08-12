import 'package:flutter/material.dart';
import 'package:main_app/screens/addNewNote.dart';
import 'package:main_app/screens/calendar.dart';
import 'package:main_app/screens/editProfile.dart';
import 'package:main_app/screens/profile.dart';
import 'package:main_app/screens/register.dart';
import 'package:main_app/screens/search.dart';
import 'package:main_app/screens/setting.dart';
import 'package:main_app/screens/started.dart';
import 'package:main_app/screens/tasksManager.dart';
import 'screens/login.dart';
import 'Theme/mainTheme.dart';
import 'package:provider/provider.dart';

enum ThemeStyle{dark, light}

// void main() {
//   runApp(const MyApp());
// }

void main() async{
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModeProvider(),
      child: const MyApp(),
    )
  );
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

    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: false);
   

    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/started': (context) => const StartedScreen(),
        '/newNote': (context) => const AddNewNoteScreen(),
        '/search': (context) => const SearchScreen(),
        '/setting': (context) => const SettingScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit': (context) => const EditProfile(),
        '/calendar': (context) => const CalendarScreen(),
        '/tasks': (context) => const TasksScreen(),
      },

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:  ColorScheme.fromSeed(seedColor: themeModeProvider.themeMode.primaryColor),      // light version
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const StartedScreen(),
    );
  }
}

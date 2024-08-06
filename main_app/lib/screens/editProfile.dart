import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';


class EditProfile extends StatefulWidget{
  const EditProfile({super.key});
  @override
  State<StatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: Column(
        children: [],
      ),
    );
  }
} 
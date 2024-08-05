import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:provider/provider.dart';


class SettingScreen extends StatefulWidget{
  const SettingScreen({super.key});
  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>{
  ThemeStyle? curTheme = ThemeStyle.light;
  void updateCurrentThemeStyle(ThemeStyle? style){
    setState(() {
      curTheme = style;
    });
  }
  @override
  Widget build(BuildContext context) { 
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: CreateAndHandleSettingDialog(context, themeModeProvider.themeMode),
    );
  }
 

  Widget CreateAndHandleSettingDialog(BuildContext context, ThemeData theme){
    
    return 
       Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60,),
            Row(
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/started');
                  }, 
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: theme.canvasColor,
                  ),
                ),
                Container(
                  child: Text(
                    'Setting',
                    style: theme.textTheme.headlineLarge,
                  ),
                )
                
              ],
            ),
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Row(
              children: [
                Icon(
                  Icons.contrast,
                  color: theme.canvasColor,
                ),
                Text(
                  '   Theme',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  RadioListTile<ThemeStyle>(
                    title: Text(
                      'Light',
                      style: theme.textTheme.bodySmall,
                      ),
                    activeColor: theme.secondaryHeaderColor,
                    value: ThemeStyle.light, 
                    groupValue: curTheme, 

                    onChanged: (ThemeStyle? select){
                      updateCurrentThemeStyle(ThemeStyle.light);
                      print(curTheme);
                    },
                    selected: theme == ThemeStyle.light,

                  ),
                  RadioListTile<ThemeStyle>(
                    title: Text(
                      'Dark',
                      style: theme.textTheme.bodySmall,
                    ),
                    activeColor: theme.secondaryHeaderColor,
                    value: ThemeStyle.dark, 
                    groupValue: curTheme, 
                    onChanged: (ThemeStyle? select){
                      updateCurrentThemeStyle(ThemeStyle.dark);
                      print(curTheme);

                    },
                    selected: theme == ThemeStyle.dark,
                  ),
                  ElevatedButton(
                    onPressed: (){
                      final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: false);
                      themeModeProvider.updateThemeMode((curTheme == ThemeStyle.light) ? AppThemeLight : AppThemeDark);
                      // print('current mode: ${themeModeProvider.themeMode}' );
                      Navigator.pushNamed(context, '/started');
                    }, 
                    child: Text(
                      'Confirm',
                      style: theme.textTheme.labelMedium,
                      ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.cardColor,
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),  
                  ),
                ],
              ),
            )           
            
          ],
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:provider/provider.dart';


enum PopupChoice{itemOne, itemTwo}
enum ThemeStyle{dark, light}
class StartedScreen extends StatefulWidget{
  const StartedScreen({super.key});
  @override
  State<StatefulWidget> createState() => _StartedScreenState();
}

class _StartedScreenState extends State<StartedScreen>{
  PopupChoice? choice;
  ThemeStyle? curTheme ;
  ThemeData theme = AppThemeLight;

  void updateCurrentThemeStyle( ThemeStyle style){
    setState(() {
      curTheme = style;
    });
  }
  void updateThemeData(ThemeData themedata){
    setState(() {
      theme = themedata;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.sizeOf(context).width*1/2;
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    // print('started theme: ${themeModeProvider.themeMode}');
    // updateThemeData((themeModeProvider.themeMode == ThemeStyle.light) ? AppThemeLight : AppThemeDark);
    
    // print('after set theme: ${theme.primaryColor} ');

    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: Column(
        children: [
          SizedBox(height: 60,),
          CreateStartedHeader(themeModeProvider.themeMode),
          CreateGroupEmptyList(size, themeModeProvider.themeMode),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
        backgroundColor: themeModeProvider.themeMode.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }

  Widget CreateStartedHeader(ThemeData theme){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'Notes',
            style: theme.textTheme.headlineLarge,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => {}, 
              icon: Icon(
                Icons.search,
                color: theme.secondaryHeaderColor,
              )
            ),
            IconButton(
              onPressed: () => {}, 
              icon: Icon(
                Icons.account_circle_outlined,
                color: theme.secondaryHeaderColor,
              )
            ),
            CreatePopupMenuButton(context, theme),
          ],
        )
      ],
    );
  }

  Widget CreateGroupEmptyList(double size, ThemeData theme){
    return Center(
      child:  Column(
        children: [
          Image.asset(
            'images/started_image.png',
            height: size,
            fit: BoxFit.contain,
          ),
          Text(
            'Welcome To Mind Note!',
            style: theme.textTheme.bodyLarge,
          )
        ],
      ),
    );
    
   
  }

  Widget CreatePopupMenuButton(BuildContext context, ThemeData theme){
    return PopupMenuButton<PopupChoice>(
      initialValue: choice,
      iconColor: theme.secondaryHeaderColor,
      onSelected: (PopupChoice select){
        setState(() {
          choice = select;
        });
        //handle setting choice 
        if(choice == PopupChoice.itemOne){
          Navigator.pushNamed(context, '/setting');
        }else{
          //handle add friend choice 
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupChoice>>[
        const PopupMenuItem<PopupChoice>(
          value: PopupChoice.itemOne,
          child: Text('Setting')
        ),
        const PopupMenuItem<PopupChoice>(
          value: PopupChoice.itemTwo,
          child: Text('Add Friend'),
        ),
      ] ,
    );
  }

  Widget CreateAndHandleSettingDialog(ThemeData theme){
    return 
    Dialog(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Setting',
              style: theme.textTheme.headlineLarge,
            ),
            Text(
                  'Theme',
                  style: theme.textTheme.bodySmall,
            ),
            Column(
              children: [
                
                RadioListTile<ThemeStyle>(
                  title: Text('Light'),
                  activeColor: Colors.red,
                  value: ThemeStyle.light, 
                  groupValue: curTheme, 
                  // selected: curTheme == ThemeStyle.light,
                  onChanged: (ThemeStyle? select){
                    updateCurrentThemeStyle(ThemeStyle.light);
                    print(curTheme);
                  },
                  selected: curTheme == ThemeStyle.light,

                ),
                RadioListTile<ThemeStyle>(
                  title: Text('Dark'),
                  activeColor: Colors.red,
                  value: ThemeStyle.dark, 
                  groupValue: curTheme, 
                  onChanged: (ThemeStyle? select){
                    updateCurrentThemeStyle(ThemeStyle.dark);
                    print(curTheme);

                  },
                  selected: curTheme == ThemeStyle.dark,
                  
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
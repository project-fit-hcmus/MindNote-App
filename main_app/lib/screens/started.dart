import 'dart:js_interop';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:main_app/screens/noteDetail.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_app/database/entities/Note.dart';

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
  User? user;

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

    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: Column(
        children: [
          const SizedBox(height: 60,),
          CreateStartedHeader(themeModeProvider.themeMode),
          SizedBox(height: 30,),
          CreateGroupNote(context, themeModeProvider.themeMode),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushNamed(context, '/newNote'),
        },
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
          margin: const EdgeInsets.only(left: 20),
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
              onPressed: () => {
                Navigator.pushNamed(context, '/profile'),
              }, 
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

  Widget CreateGroupNote(BuildContext Context, ThemeData theme){
    DatabaseReference ref = FirebaseDatabase.instance.ref('notes');
    double size = MediaQuery.sizeOf(context).width*1/2;
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: ref.onValue, 
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data!.snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<GestureDetector> items = [];
          values.forEach((key, value){
            if(value['noteUser'].toString().contains(user!.uid))
              items.add(GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(
                        note: Note(
                          noteId: value['noteId'],
                          noteUser: value['noteUser'],
                          noteDate: value['noteDate'],
                          noteDetail: value['noteDetail'],
                          noteTitle: value['noteTitle'],
                          noteContent: value['noteContent'],
                          noteNumberCharacters: value['noteNumberOfCharacter'],
                        ),
                      )
                    ),
                  );
                },
                child: Card(
                  color: theme.secondaryHeaderColor,
                  child: ListTile(
                    title: Text(
                      '${value['noteTitle']}',
                      style: GoogleFonts.sofiaSansSemiCondensed(
                        color: Colors.white,
                      ),  
                    ),
                    subtitle: Text(
                      '${SupportFunction.ConvertDate(value['noteDate'])}',
                      style: GoogleFonts.sofiaSansSemiCondensed(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                      ),
                  ),
                ),
              )
            );
          });
          return ListView(
            
            shrinkWrap: true,
            children: <Widget>[
              for(var item in items) item
            ],
          );
        }else { 
          return CreateGroupEmptyList(size, theme);
        }
      }
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
        padding: const EdgeInsets.all(8),
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
                  title: const Text('Dark'),
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

  //NOT USED
  
} 
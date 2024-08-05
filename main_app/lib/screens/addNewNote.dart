import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:main_app/services/firebase_auth_helper.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:main_app/database/entities/Note.dart';

class AddNewNoteScreen extends StatefulWidget{
  const AddNewNoteScreen({super.key});
  @override
  State<StatefulWidget> createState() => _AddNewNoteScreenState();
}

class _AddNewNoteScreenState extends State<AddNewNoteScreen> {
  final TextEditingController _textEditingController = TextEditingController();       // NOTE CONTENT
  final TextEditingController _textTitleEditingController = TextEditingController();      // NOTE TITLE 
  int _wordCount = 0;       // NUMBER OF CHARACTER
  String _dateOfNote = SupportFunction.getFormatedDate();  // NOTE DATE
  String _dateDetail = SupportFunction.getCurrentTime() + "," + SupportFunction.getCurrentDayOfWeek();
  User? user = FirebaseAuth.instance.currentUser;

  void _updateWordCount(){
    String text = _textEditingController.text;
    setState(() {
      _wordCount = SupportFunction.countNumberOfCharacter(text);
    });
  }

  void _updateDateOfNote(String date){
    setState(() {
      _dateOfNote = date;  
    });
  }

  @override
  Widget build(BuildContext context) {
    print(SupportFunction.countNumberOfCharacter("Hello everyone,my name is Nhi Y."));
    double size = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: Column(
        children: [
          CreateHeaderNewNote(context,themeModeProvider.themeMode, size),
          SizedBox(height: 10,),
          CreateContentArea(context, themeModeProvider.themeMode, size, height),

        ],
      ),
    );
  }
  Widget CreateHeaderNewNote(BuildContext context, ThemeData theme, double realWidth){
    return Container(
      margin: EdgeInsets.only(top: 60, left: 10, right: 10),
      child: Row(
      children: [
        IconButton(
          onPressed: (){
            Navigator.pushNamed(context, '/started');
          }, 
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.canvasColor,
          )
        ),
        Container(
          width: realWidth*2/3,
          child: Text(
            'Notes',
            style: theme.textTheme.headlineLarge, 
          ),
        ),
        IconButton(
          onPressed: (){
            //TODO SOMETHING
          },
          icon:  Icon(
            Icons.send,
            color: theme.canvasColor,
          ),
        ),
        IconButton(
          onPressed:(){
            String title = _textTitleEditingController.text;
            if(title.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter title of the note!!!'),));
            }else{
              Note t = Note(
                noteId : SupportFunction.createRandomNoteId(),
                noteUser: user!.uid,
                noteContent: _textEditingController.text,
                noteDate: _dateOfNote,
                noteTitle: _textTitleEditingController.text,
                noteDetail: _dateDetail,
                noteNumberCharacters: _wordCount,
              );
              FirebaseAuthHelper.addANoteToFirebase(t);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add new note')));
              Navigator.pushNamed(context, '/started');
            }
          }, 
          icon: Icon(
            Icons.check,
            color: theme.canvasColor,
          )
        )
      ]
      ),
    );
  }

  Widget CreateContentArea(BuildContext context, ThemeData theme, double realWidth, double realHeight){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Material(
            color: theme.primaryColor,
            child:TextField(
              controller: _textTitleEditingController,
              style: theme.textTheme.headlineMedium,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: theme.textTheme.headlineMedium,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)
                )
              ),
            ),
          ),
        ),
        Container(
          width: realWidth,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            '${SupportFunction.ConvertDate(SupportFunction.getFormatedDate())} ${SupportFunction.getCurrentTime()} ${SupportFunction.getCurrentDayOfWeek()} | ${_wordCount} characters',
            style: theme.textTheme.displayMedium,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          height: realHeight*1.8/3,
          child: Material(
              color: theme.primaryColor,
              child:TextField(
                controller: _textEditingController,
                onChanged: (_) => {_updateWordCount()},
                maxLines: 30,
                style: theme.textTheme.displayMedium,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)
                  )
                ),
              ),
            ),
        ),
        Divider(),
        CreateBottomSetup(context, theme, realWidth, realHeight),
      ],
    );
  }
  Widget CreateBottomSetup(BuildContext context, ThemeData theme, double realWidth, double realHeight){
    return Container(
      child: Row(
        children: [
          //GROUP TEXT
          CreateGroupButton(Icons.text_fields, 'Text', theme),
          //GROUP TODO
          CreateGroupButton(Icons.task_alt, 'To-do', theme),
          //GROUP IMAGE
          CreateGroupButton(Icons.image, 'Image', theme),
          //GROUP REMINDER
          CreateGroupButton(Icons.notifications_none, 'Reminder', theme),
        ]
      ),
    );
  }
  Widget CreateGroupButton(IconData icon, String text, ThemeData theme){
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          IconButton(
            onPressed: (){
              //TODO SOMETHING
            }, 
            icon: Icon(
              icon,
              color: theme.secondaryHeaderColor,  
            )
          ),
          Container(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge,
            ),
          )
        ],
      ),
    );
  }
}
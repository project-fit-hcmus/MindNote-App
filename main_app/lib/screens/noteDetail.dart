import 'package:flutter/material.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:main_app/database/entities/Note.dart';


class NoteDetailScreen extends StatefulWidget{
  final Note note;
  NoteDetailScreen({
    required this.note,
  });
  @override
  State<StatefulWidget> createState()  => _NoteDetailScreenState();
  
}

class _NoteDetailScreenState extends State<NoteDetailScreen>{
  final TextEditingController _textEditingController = TextEditingController();       // NOTE CONTENT
  final TextEditingController _textTitleEditingController = TextEditingController();      // NOTE TITLE 
  int _wordCount = 0;       // NUMBER OF CHARACTER

  void _updateWordCount(){
    String text = _textEditingController.text;
    setState(() {
      _wordCount = SupportFunction.countNumberOfCharacter(text);
    });
  }
  void _updateTextController(String content){
    setState(() {
      _textEditingController.text = content;
    });
  }  

  @override
  void dispose() {
    _textTitleEditingController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('call init state');
    _textEditingController.text = widget.note.noteContent;
    _textTitleEditingController.text = widget.note.noteTitle;
    _updateWordCount();

  }

  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: Column(
        children: [
          CreateHeaderNewNote(context,themeModeProvider.themeMode, size),
          SizedBox(height: 10,),
          CreateContentArea(context, themeModeProvider.themeMode, size, height)
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
                // hintText: '${widget.note.noteTitle}',
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
            '${SupportFunction.ConvertDate(widget.note.noteDate)} ${widget.note.noteDetail.replaceAll(',', ' ')} | ${_wordCount} characters',
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
                onChanged: (_) => {
                  _updateWordCount()
                },
                maxLines: 30,
                style: theme.textTheme.displayMedium,
                decoration: InputDecoration(
                  // hintText: '${widget.note.noteContent}',
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

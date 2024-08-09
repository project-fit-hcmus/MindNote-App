import 'package:flutter/material.dart';
import 'package:main_app/services/firebase_auth_helper.dart';
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
  bool isChange = false;
  bool setSkin = false;
  int skinVersion = -1;

  void _updateSkinVersion(int i){
    setState(() {
      skinVersion = i;
    });
  }

  void _updateSetSkin(){
    setState(() {
      setSkin = !setSkin;
    });
  }

  void _updateChangeState(String title, String content){
    setState(() {
      if(title == widget.note.noteTitle && content == widget.note.noteContent)
        isChange = false;
      else isChange = true;
    });
  }

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
    skinVersion = SupportFunction.ConvertToIntSkinVersion(widget.note.noteSkin);
    _updateWordCount();

  }

  @override
  Widget build(BuildContext context) {
    List<String> skins = [
      'skins/leaf.jpg',
      'skins/linear_green.jpg',
      'skins/paper.jpg',
      'skins/sky.jpg',
      'skins/traditional.jpg',
      'skins/magic.jpg',
      'skins/stripe_pink.jpg',
      'skins/green_pen.jpg',
      'skins/pink_fabric.jpg',
      'skins/flower.jpg',
      'skins/fish_skin.jpg',
    ];
    double size = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: themeModeProvider.themeMode.primaryColor,
        body: Container(
          decoration: BoxDecoration(
            image:DecorationImage(
              image: AssetImage( (skinVersion != -1) ? skins[skinVersion] : ''),
              fit: BoxFit.cover,
            ),            
          ),
          child:  Column(
        children: [
          CreateHeaderNewNote(context,themeModeProvider.themeMode, size),
          SizedBox(height: 10,),
          CreateContentArea(context, themeModeProvider.themeMode, size, height)
        ],
        ),  
        ),
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
            Navigator.pop(context);
          }, 
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: (skinVersion == -1) ?  theme.canvasColor : AppThemeLight.canvasColor,
          )
        ),
        Container(
          width: realWidth*2/3,
          child: Text(
            'Notes',
            style: (skinVersion == -1) ? theme.textTheme.headlineLarge : AppThemeLight.textTheme.headlineLarge, 
          ),
        ),
        IconButton(
          onPressed: (){
            //TODO SOMETHING
            
          },
          icon:  Icon(
            Icons.send,
            color: (skinVersion == -1) ? theme.canvasColor : AppThemeLight.canvasColor,
          ),
        ),
        IconButton(

          onPressed:isChange ? (){
            FirebaseAuthHelper.updateNote(_textTitleEditingController.text, _textEditingController.text, widget.note.noteId);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update success!!')));
            Navigator.pushNamed(context, '/started');
          } : null,
           
          icon: Icon(
            Icons.check,
            color: (isChange) ? ( (skinVersion == -1 ) ? theme.canvasColor : AppThemeLight.canvasColor) : Colors.grey.shade800,
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
            // color: theme.primaryColor,
            color: Colors.transparent,
            child:TextField(
              controller: _textTitleEditingController,
              style: (skinVersion == -1) ? theme.textTheme.headlineMedium : AppThemeLight.textTheme.headlineMedium,
              maxLines: 1,
              onChanged: (text){
                _updateChangeState(text, _textEditingController.text);
              },
              
              decoration: InputDecoration(
                hintStyle: (skinVersion == -1) ?  theme.textTheme.headlineMedium : AppThemeLight.textTheme.headlineMedium,
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
            style: (skinVersion == -1) ? theme.textTheme.displayMedium : AppThemeLight.textTheme.displayMedium,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          height: (!setSkin) ? realHeight*1.8/3 : realHeight * 1.5/3,
          child: Material(
              color: Colors.transparent,
              child:TextField(
                controller: _textEditingController,
                onChanged: (text) => {
                  _updateWordCount(),
                  _updateChangeState(_textTitleEditingController.text, text),
                },
                maxLines: 30,
                style: (skinVersion == -1) ? theme.textTheme.displayMedium : AppThemeLight.textTheme.displayMedium,
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
        if(setSkin)
          createHorizontalSkin(),
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
          CreateGroupButton(Icons.wallpaper, 'Skin', theme),
          //GROUP REMINDER
          CreateGroupButton(Icons.notifications_none, 'Reminder', theme),
          //GROUP DELETE 
          CreateGroupButton(Icons.delete, 'Delete', theme),
        ]
      ),
    );
  }
  Widget CreateGroupButton(IconData icon, String text, ThemeData theme){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          IconButton(
            onPressed: (){
              //TODO SOMETHING
              if(text == 'Skin'){
                if(setSkin == true){
                  //updateSkin 
                  FirebaseAuthHelper.updateNoteSkin(SupportFunction.ConvertToStringSkinVersion(skinVersion), widget.note.noteId);
                }
                _updateSetSkin();
              }

            }, 
            icon: Icon(
              icon,
              color: (skinVersion == -1) ? theme.secondaryHeaderColor : AppThemeLight.secondaryHeaderColor,  
            )
          ),
          Container(
            child: Text(
              text,
              style: (skinVersion == -1) ? theme.textTheme.bodyLarge : AppThemeLight.textTheme.bodyLarge,
            ),
          )
        ],
      ),
    );
  }

  Widget createHorizontalSkin(){
    List<String> skins = [
      'skins/none.png',
      'skins/leaf_icon.jpg',
      'skins/linear_green_icon.jpg',
      'skins/paper_icon.jpg',
      'skins/sky_icon.jpg',
      'skins/traditional_icon.jpg',
      'skins/magic_icon.jpg',
      'skins/stripe_pink_icon.jpg',
      'skins/green_pen_icon.jpg',
      'skins/pink_fabric_icon.jpg',
      'skins/flower_icon.jpg',
      'skins/fish_skin_icon.jpg',
    ];
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: skins.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              _updateSkinVersion(index-1);
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Image.asset(
                skins[index],
                width: 70,
                height: 70,
                fit: BoxFit.cover,),
            )
          );
        },
      )    
    );
  }
}

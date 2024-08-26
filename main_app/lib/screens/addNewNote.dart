import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool setSkin = false;
  bool setText = false;
  bool formatBold = false;
  bool formatItalic = false;
  bool formatLine = false;
  int skinVersion = -1;
  double curTextSize = 15.0;

  void _updateFormatBold(){
    setState(() {
      formatBold = !formatBold;
    });
  }
  void _updateFormatItalic(){
    setState(() {
      formatItalic = !formatItalic;
    });
  }
  void _updateFormatLine(){
    setState(() {
      formatLine = !formatLine;
    });
  }
  void _updateTextSize(double size){
    setState(() {
      curTextSize = size;
    });
  }
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
  void _updateSetText(){
    setState(() {
      setText = !setText;
    });
  }

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
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image:DecorationImage(
                image: AssetImage( (skinVersion != -1) ? skins[skinVersion] : ''),
                fit: BoxFit.cover,
              ),            
            ),
            child: Column(
              children: [
                SizedBox(height: 60,),
                CreateHeaderNewNote(context,themeModeProvider.themeMode, size),
                SizedBox(height: 10,),
                CreateContentArea(context, themeModeProvider.themeMode, size, height),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget CreateHeaderNewNote(BuildContext context, ThemeData theme, double realWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
              // width: realWidth*2/3,
              child: Text(
                'Notes',
                style: theme.textTheme.headlineLarge, 
              ),
            ),
          ],
        ),
        Row(
          children: [
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
                    noteSkin: SupportFunction.ConvertToStringSkinVersion(skinVersion),
                    noteFormatBold: formatBold,
                    noteFormatItalic: formatItalic,
                    noteFormatLine: formatLine,
                    noteFormatSize: curTextSize,
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
          ],
        )
      ],
    );
  
  }

  Widget CreateContentArea(BuildContext context, ThemeData theme, double realWidth, double realHeight){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Material(
            color: Colors.transparent,
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
          height: (!setSkin && !setText) ? realHeight*1.8/3 : realHeight*1.5/3,
          child: Material(
              color: Colors.transparent,
              child:TextField(
                controller: _textEditingController,
                onChanged: (_) => {_updateWordCount()},
                maxLines: 30,
                // style: theme.textTheme.displayMedium,
                style: TextStyle(
                  fontSize: curTextSize,
                  fontStyle: (formatItalic ? FontStyle.italic : FontStyle.normal),
                  fontWeight: (formatBold ? FontWeight.bold : FontWeight.normal),
                  decoration: (formatLine ? TextDecoration.lineThrough : TextDecoration.none),
                ),
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
        if(setSkin)
          createHorizontalSkin(),
        if(setText)
          CreateHorizontalTextSetup(theme),
        CreateBottomSetup(context, theme, realWidth, realHeight),
      ],
    );
  }
  Widget CreateBottomSetup(BuildContext context, ThemeData theme, double realWidth, double realHeight){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //GROUP TEXT
          CreateGroupButton(Icons.text_fields, 'Text', theme),
          //GROUP TODO
          CreateGroupButton(Icons.task_alt, 'To-do', theme),
          //GROUP IMAGE
          CreateGroupButton(Icons.wallpaper, 'Skin', theme),
          //GROUP REMINDER
          CreateGroupButton(Icons.notifications_none, 'Reminder', theme),
        ]
      ),
    );
  }
  Widget CreateGroupButton(IconData icon, String text, ThemeData theme){
    return Container(
      // padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          IconButton(
            onPressed: (){
              if(text == 'Skin'){
                
                _updateSetSkin();
              }
              if(text == 'Text'){
                _updateSetText();
              }
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

  Widget CreateHorizontalTextSetup(ThemeData theme){
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                
                style: IconButton.styleFrom(
                  backgroundColor: (formatBold ? theme.secondaryHeaderColor : Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                onPressed: (){
                  _updateFormatBold();
                }, 
                icon: Icon(
                  Icons.format_bold_outlined,
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: (formatItalic ? theme.secondaryHeaderColor : Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                onPressed: (){
                  _updateFormatItalic();
                }, 
                icon: Icon(
                  Icons.format_italic_outlined,
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: (formatLine ? theme.secondaryHeaderColor : Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                onPressed: (){
                  _updateFormatLine();
                }, 
                icon: Icon(
                  Icons.format_clear,
                ),
              )
            ], 
          ),
          Slider(
              value: curTextSize,
              onChanged: (double value){
                _updateTextSize(value);
              },
              divisions: 4,
              max: 25,
              min: 15,
              label: curTextSize.round().toString(),
            ),
        ],
      ),
      
    );
  }
}
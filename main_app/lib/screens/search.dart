import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:main_app/screens/noteDetail.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:main_app/database/entities/Note.dart';
class SearchScreen extends StatefulWidget{
  const SearchScreen ({super.key});
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textSearchController = TextEditingController();
  String keyword = '';

  void _updateKeyword(){
    setState(() {
      keyword = _textSearchController.text;
    });
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
          CreateSearchHeader(themeModeProvider.themeMode, size),
          SizedBox(height: 20,),
          ShowSearchResult(keyword, themeModeProvider.themeMode, height),
        ],
      ),
    );
  }
  Widget CreateSearchHeader(ThemeData theme, double realWidth){
    return Container(
      margin: EdgeInsets.only(top: 60),
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
          Stack(
            alignment: Alignment.centerRight,
            children: [
              // TEXT FIELD ~ SEARCH BOX
              Container(
                color: Colors.transparent,
                width: realWidth * 2.2/3,
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: _textSearchController,
                    style: GoogleFonts.sofiaSansSemiCondensed(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      fillColor: theme.secondaryHeaderColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '  Enter your keyword',
                      hintStyle: GoogleFonts.sofiaSansSemiCondensed(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              // CLEAR TEXTFIELD BUTTON
              IconButton(
                onPressed: (){
                  setState(() {
                    _textSearchController.text = '';
                  });
                }, 
                icon: Icon(Icons.close),
              )
            ],
          ),
          // SEARCH BUTTON
          IconButton(
            onPressed: (){
              if(_textSearchController.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter keyword to seach!')));
                setState(() {
                  _textSearchController.text = '';
                });
              }else{
                //TODO SOMETHING
                _updateKeyword();
                setState(() {
                  _textSearchController.text = '';
                });
                
              }
            }, 
            icon: Icon(
              Icons.search,
              color: theme.canvasColor,            
            ), 
          )
          
          

        ],
      ),
    );
  }
  Widget ShowSearchResult(String keyword, ThemeData theme, double height){
    if(keyword == '')
      return CreateEmptyNotification(theme, height);
    DatabaseReference ref = FirebaseDatabase.instance.ref('notes/');
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: ref.onValue, 
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data!.snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<GestureDetector> items = [];
          values.forEach((key, value){
            if(value['noteUser'] == user!.uid && value['noteContent'].toString().contains(keyword)){
              // print('Result of the function ---> ' + SupportFunction.getDisplayTitle(value['noteContent'], keyword));
              items.add(GestureDetector(
                onTap: (){
                  //TODO SOMETHING
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
                          noteSkin: value['noteSkin'],
                          noteFormatBold: value['noteFormatBold'],
                          noteFormatItalic: value['noteFormatItalic'],
                          noteFormatLine: value['noteFormatLine'],
                          noteFormatSize: value['noteFormatSize'],
                        ),
                      )
                    ),
                  );
                },
                child: Card(
                  color: theme.secondaryHeaderColor,
                  child: ListTile(
                    title: DisplayRichText(SupportFunction.getDisplayTitle(value['noteContent'], keyword), keyword) ,

                    subtitle: Text(
                      '${SupportFunction.ConvertDate(value['noteDate'])}',
                      style: GoogleFonts.sofiaSansSemiCondensed(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ));              
            }
          });
          if(!items.isEmpty)
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                for(var item in items) item
              ],
            );
          else return CreateEmptyNotification(theme, height);
        }else
          return CreateEmptyNotification(theme, height);
      }
    );
  }

  Widget CreateEmptyNotification(ThemeData theme, double height){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: height*1/5),
      child: Center(
        child: Column(
          children: [
            Image.asset('images/not_found.png'),
            Container(
              child: Text(
                'Not Found. Try searching again!',
              ),
            )
          ],)
      ),
    );
  }
  Widget DisplayRichText(String content, String keyword){
    List<TextSpan> textSpan = [];
    int pos = content.indexOf(keyword);
    textSpan.add(TextSpan(
      text: content.substring(0, pos),
      style: GoogleFonts.sofiaSansSemiCondensed( 
        color: Colors.white,
        fontSize: 18,
      )
    ));
    textSpan.add(TextSpan(
      text: keyword,
      style: GoogleFonts.sofiaSansSemiCondensed(
        background: Paint()..color = Color.fromARGB(255, 255, 247, 0),
        fontSize: 18,
      )
    ));
    textSpan.add(TextSpan(
      text: content.substring(pos + keyword.length, content.length),
      style: GoogleFonts.sofiaSansSemiCondensed( 
        color: Colors.white,
        fontSize: 18,
      )
    ));
    return RichText(
      text: TextSpan(children: textSpan),
    );
  }
}
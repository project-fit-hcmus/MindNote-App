import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main_app/services/firebase_auth_helper.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{

  User? user = FirebaseAuth.instance.currentUser;
  bool editMode = false;
  // late String photoUrl ;
  File? choosen = null;
  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textMailController = TextEditingController();
  final TextEditingController _textBioController = TextEditingController();
  String? UserName = '';
  String? UserMail = '';
  String? UserBio = '';


  void _updateChoosenImage(File? img){
    setState(() {
      choosen = img;
    });
  }

  void _updateEditMode(){
    setState(() {
      editMode = !editMode;
    });
  }
  void _updateBioController(String initial){
    setState(() {
      _textBioController.text = initial;
    });
  }

  @override
  void initState() {
    super.initState();
    _textNameController.text = user!.displayName!;
    _textMailController.text = user!.email!;
    UserName = user!.displayName;
    UserMail = user!.email;

    Future<DataSnapshot> event = FirebaseDatabase.instance.ref('users/${user!.uid}/accBio').get();
    event.then((value){
      _textBioController.text = value.value.toString();
      UserBio = value.value.toString();
    });
  }
  

  @override
  Widget build(BuildContext context) {
  print(user!.displayName);
  final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
  double width = MediaQuery.sizeOf(context).width;
  double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreateHeaderProfile(context, themeModeProvider.themeMode, width),
            CreateGroupAvatar(context, themeModeProvider.themeMode),
            CreateGroupInformation(context, themeModeProvider.themeMode),
          ],),
        )    ,
    );
  }

  Widget CreateHeaderProfile(BuildContext context, ThemeData theme, double realWidth){
    return Container(
      margin: EdgeInsets.only(top: 60,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (!editMode) ? 
            Row(
              children: [
                IconButton(
                  onPressed: ()=>{
                    Navigator.pushNamed(context, '/started'),
                  }, 
                  icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: theme.canvasColor,
                  ),
                ),
                Container(
                  // width: realWidth* 2/3,
                  child: Text(
                    'Profile',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ],
            ) : TextButton(
              onPressed: (){
                _updateEditMode();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cancel Action!!')));
              }, 
              child: Text(
                'Cancel',
                style: theme.textTheme.bodySmall,
              ),
            ),
            
            (!editMode) ? 
            IconButton(
              onPressed: (){
                _updateEditMode();
              }, 
              icon: Icon(
                Icons.border_color,
                color: theme.canvasColor,
              ),
            )  :
            TextButton(
              onPressed: (){
                //TODO SOMETHING TO SAVE PROFILE
                FirebaseAuthHelper.updateUserInfo(_textNameController.text, _textBioController.text, user);
                setState(() {
                  UserName = _textNameController.text;
                  UserBio = _textBioController.text;
                });
                _updateEditMode();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save Information!!')));
              }, 
              child: Text(
                'Save',
              style: theme.textTheme.bodySmall,
              ),
            )
        ],
      ),
    );
  }
  
  Widget CreateGroupAvatar(BuildContext context, ThemeData theme){
    return Container(
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            child: CircleAvatar(
              // backgroundImage: user!.photoURL != null ? NetworkImage(user!.photoURL!): const AssetImage('images/avatar_default.jpg'),
              backgroundImage: (choosen == null) ? AssetImage('images/avatar_default.jpg') : FileImage(choosen!), 
            ),
          ),
          Container(
            child: Text(
              '${user!.displayName}',
              style: theme.textTheme.labelLarge,
            ),
          ),
          TextButton(
            onPressed: () async {
              File? imageChoosen;
              try{
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if(image != null){
                  imageChoosen = File(image.path);
                  _updateChoosenImage(imageChoosen);
                }
              }catch(e){
                if(e is PlatformException){
                  if(e.code == 'photo_access_denied'){
                    print('PlatformException: photo access is denied!');
                  } else if(e.code == 'camera_access_denied'){
                    print('PlatformException: camera access is denied!!!');
                  }else {
                    print('PlatformException: Another Exception!!');
                  }
                }else {
                  print('Another Exception!!' + e.toString());
                }
              }
              
            }, 
            child: Text(
              'Edit Profile Photo',
              style: theme.textTheme.labelSmall,
            ))
          
        ],
      ),
    );
  }
  Widget CreateGroupInformation(BuildContext context, ThemeData theme){
    double realsize = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
          width: realsize,
          child: Text(
            'Name',
            style: theme.textTheme.bodySmall,
          ),
        ),
        Container(
          padding: (!editMode) ? EdgeInsets.all(14) : EdgeInsets.all(0),
          width: realsize,
          child: (!editMode)?
          Text(
            // '${user!.displayName}',
            '$UserName',
          ) :
          Material(
            color: theme.primaryColor,
            child:TextField(
              maxLines: 1,
              controller: _textNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.highlightColor,
                
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: theme.highlightColor,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only( left: 20, right: 20),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          width: realsize,
          child: Text(
            'Mail',
            style: theme.textTheme.bodySmall,
          ),
        ),
        Container(
          padding: EdgeInsets.all(14),
          width: realsize,
          child:  Text(
            '$UserMail',
          ),
          decoration: BoxDecoration(
            color: theme.highlightColor,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only( left: 20, right: 20),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          width: realsize,
          child: Text(
            'Bio',
            style: theme.textTheme.bodySmall,
          ),
        ),
        Container(
          padding: (!editMode) ? EdgeInsets.all(14) : EdgeInsets.all(0),
          width: realsize,
          child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref('users/${user!.uid}').onValue, 
            builder: (context,snapshot){
              if(snapshot.hasData && snapshot.data?.snapshot.value != null){
                Object? values = snapshot.data!.snapshot.value;
                String bio = getExactData(values.toString());
                return (!editMode) ? Text('$bio') : 
                Material(
                    color: theme.primaryColor,
                    child:TextField(
                      maxLines: 1,
                      controller: _textBioController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.highlightColor,
                        
                      ),
                    ),
                  );
              }else{
                return Text('[EMPTY]');
              }
            }),
          decoration: BoxDecoration(
            color: theme.highlightColor,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only( left: 20, right: 20),
        ),
        SizedBox(height: 30,),
        (!editMode) ? 
        ElevatedButton(
          onPressed: () async{
            //TODO SOMETHING
            if(!editMode){ 
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/login');
            }else{
              // cancel edit mode version 
              _updateEditMode();
            }
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemeLight.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )
          ),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Text(
              'Logout',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ) : Padding(padding: EdgeInsets.all(0),),
      ],
    );
  }
  static String getExactData(String raw){
    int start = raw.indexOf(':');
    int end = raw.indexOf("accId");
    String output = raw.substring(start+1,end-2);
    return output;
  }
}


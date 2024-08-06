import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:main_app/services/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_app/database/entities/Account.dart';



class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{

  User? user = FirebaseAuth.instance.currentUser;
  

  @override
  Widget build(BuildContext context) {
  final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreateHeaderProfile(context, themeModeProvider.themeMode),
            CreateGroupAvatar(context, themeModeProvider.themeMode),
            CreateGroupInformation(context, themeModeProvider.themeMode),
          ],),
        )    ,
    );
  }

  Widget CreateHeaderProfile(BuildContext context, ThemeData theme){
    return Container(
      margin: EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Row(
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
              child: Text(
                'Profile',
                style: theme.textTheme.headlineLarge,
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
              backgroundImage: AssetImage('images/avatar.png'),
            ),
          ),
          Container(
            child: Text(
              '${user!.displayName}',
              style: theme.textTheme.labelLarge,
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/edit'); 
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
    // String data; 
    // data  =  DatabaseHelper.getBioOfUser(user!.uid).then((key){data = key;});
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
          padding: EdgeInsets.all(7),
          width: realsize,
          child: Text(
            '${user!.displayName}',
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
          padding: EdgeInsets.all(7),
          width: realsize,
          child: Text(
            '${user!.email}',
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
          padding: EdgeInsets.all(7),
          width: realsize,
          child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref('users/${user!.uid}').onValue, 
            builder: (context,snapshot){
              if(snapshot.hasData && snapshot.data?.snapshot.value != null){
                Object? values = snapshot.data!.snapshot.value;
                // List<String> bio = [];
                // bio.add(values['accBio']);
                String bio = getExactData(values.toString());
                return Text('$bio',);
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
        ElevatedButton(
          onPressed: () async{
            //TODO SOMETHING
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, '/login');
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
        )
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


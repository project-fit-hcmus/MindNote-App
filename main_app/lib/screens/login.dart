import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:main_app/firebase_options.dart';
import 'package:main_app/services/firebase_auth_helper.dart';
class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool isShowPassword = false;
  IconData showIcon = Icons.visibility_outlined;
  IconData hideIcon = Icons.visibility_off_outlined;
  final _mailKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passKey = GlobalKey<FormState>();
  final _passController = TextEditingController();

  User? user = null;
  void updateShowPassword(){
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }
  
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      //go to home screen of the app 
      print('login: user is not null!');
    }
    return firebaseApp;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(), 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CreateGroupIntroduce(),
                  Image.asset(
                    'images/logo_full.png',
                    fit: BoxFit.contain,
                    ),
                  CreateGroupLogin(context),
                  CreateOtherMethodGroup(context),
                ],
              ),
            )
          );
        }
        else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        } 
      },
    );
    
  }

  Widget CreateGroupIntroduce(){
    return
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Login Account',
                      style: GoogleFonts.sofiaSansSemiCondensed( 
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        
                      ),
                    ),
                  ),
                  Icon(
                    Icons.person_2_outlined
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  child: Text(
                    'Welcome back Mindnote!',
                    style: GoogleFonts.sofiaSansSemiCondensed(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        );
  }

  Widget CreateGroupLogin(BuildContext context){
        
    double realWidth = MediaQuery.sizeOf(context).width*4/5;

    return Column(
      children: [
        //EMAIL ADDRESS
        Container(
          margin: EdgeInsets.only(top: 10),
          width: realWidth,
          child: Form(
            key: _mailKey,
            child: TextFormField(
              controller: _mailController,
              validator: (mail){
                if(mail == null || mail.isEmpty)
                  return 'Please enter email!';
                else return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: Text('Enter Your Email'),
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppThemeLight.primaryColor,
              ),
            ),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: realWidth,
          child: Form(
            key: _passKey,
            child: TextFormField(
              controller: _passController,
              validator: (password){
                if(password == null || password.isEmpty)
                  return 'Please enter password!';
                else return null;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: !isShowPassword,
              decoration: InputDecoration(
                label: Text('Enter Your Password'),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isShowPassword ? showIcon : hideIcon,
                    color: AppThemeLight.cardColor,
                  ),
                  onPressed: ()=>{
                    updateShowPassword()
                  }, 
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppThemeLight.primaryColor,
              ),
            ),
          )
        ),
        
        SizedBox(height: 15,),
        ElevatedButton(
          onPressed: () async => {
            if(_mailKey.currentState!.validate()){
              print('email : ${_mailController.text}')
            },
            if(_passKey.currentState!.validate()){
              print('password: ${_passController.text}' )
            },
            if(_passKey.currentState!.validate() && _mailKey.currentState!.validate()){
              user = await FirebaseAuthHelper.signInUsingEmailAndPassword(email: _mailController.text, password: _passController.text),
              if(user != null){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('login successful!'))),
                Navigator.pushNamed(context, '/started'),
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There are something wrong!'))),
              }
            }

          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemeLight.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )
          ),
          child: Padding(
            padding: EdgeInsets.only(left: (realWidth-85)/2, right: (realWidth-85)/2, top: 5, bottom: 5),
            child: Text(
              'Login',
              style: AppThemeLight.textTheme.bodyMedium,
            ),
          ),
        )
      ],
    );
  }

  Widget CreateOtherMethodGroup(BuildContext context){
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 50),
          width: MediaQuery.sizeOf(context).width*2/3,
          child: Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                Text(
                  ' Or sign up with ',
                  style: GoogleFonts.sofiaSansSemiCondensed(

                  ),  
                ),
                Expanded(
                  child: Divider(),
                )
              ],
            ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           ElevatedButton(
            onPressed: () => {}, 
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            child: Image.asset(
              'images/google_icon.png',
              fit: BoxFit.contain,
              height: 20,
            ),
          ),
          SizedBox(width: 10,),
          ElevatedButton(
            onPressed: () => {}, 
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(top: 18, bottom: 18),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            child: Image.asset(
              'images/facebook_icon.png',
              fit: BoxFit.contain,
              height: 25,
            ),
          )
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Not register yet?',
              style: GoogleFonts.sofiaSansSemiCondensed(),
            ),
            InkWell(
              onTap: ()=>{
                Navigator.pushNamed(context, '/register')
              },
              child:  Text(
                ' Create Account',
                style: GoogleFonts.sofiaSansSemiCondensed(
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
           
          ],
        )
      ],
    );
  }
}
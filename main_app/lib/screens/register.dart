import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:main_app/services/firebase_auth_helper.dart';


class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  IconData showIcon = Icons.remove_red_eye_outlined;
  IconData hideIcon = Icons.visibility_off_outlined;
  bool isPasswordShow = false;
  bool isRepeatPassShow = false;
  bool isAgreeWithPolicy = false;
  User? user ;

  final _nameKey =  GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mailKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _repeatKey = GlobalKey<FormState>();
  final _repeatController = TextEditingController();
  void updatePasswordShow(){
    setState(() {
      isPasswordShow = !isPasswordShow;
    });
  }
  void updateRepeatPassShow(){
    setState(() {
      isRepeatPassShow = !isRepeatPassShow;
    });
  }
  void updatePolicyRight(){
    setState(() {
      isAgreeWithPolicy = !isAgreeWithPolicy;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreateHeaderRegister(),
            CreateGroupInfoRegister(context),
            CreateOtherMethodGroup(),
          ],
        ),
      ),
    );  
  }

  Widget CreateHeaderRegister(){
    return Container(
      margin: const EdgeInsets.only(top: 60, bottom: 10, left: 10, right: 10),
      child: Row(
        children: [
          Container(
            child: Image.asset('images/logo_icon.png'),
            margin: const EdgeInsets.only(right: 10),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create new Account',
                style: GoogleFonts.sofiaSansSemiCondensed( 
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                'Welcome back MindNote!',
                style: GoogleFonts.sofiaSansSemiCondensed(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          )
        ],
      ),
    );
    
  }

  Widget CreateGroupInfoRegister(BuildContext context){
    double realWidth = MediaQuery.sizeOf(context).width*4/5;

    return Column(
      children: [
        // FORM NAME
        Container(
          margin: const EdgeInsets.only(top: 60),
          width: realWidth,
          child: Form(
            key: _nameKey,
            child: TextFormField(
              validator: (name){
                if(name == null || name.isEmpty)
                  return 'Please fill your name!';
                else return null;
              },
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                label: const Text('Name'),
                prefixIcon: const Icon(Icons.account_circle_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppThemeLight.primaryColor,
              ),
            ),
          ),
          
        ),
        // FORM EMAIL ADDRESS
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: realWidth,
          child: Form(
            key: _mailKey,
            child: TextFormField(
              validator: (mail){
                if(mail == null || mail.isEmpty){
                  return 'Please enter email!';
                }
                else return null;
              },
              controller: _mailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: const Text('Email Address'),
                prefixIcon: const Icon(Icons.mail_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppThemeLight.primaryColor,
              ),
            ),
          )
        ),
        //FORM PASSWORD
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: realWidth,
          child: Form(
            key: _passKey,
            child: TextFormField(
              validator: (pass){
                if(pass == null || pass.isEmpty){
                  return 'Please enter password';
                }
                else return null;
              },
              controller: _passController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !isPasswordShow,
              decoration: InputDecoration(
                label: const Text('Password'),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () => {
                    updatePasswordShow()
                  },
                  icon: Icon(
                    (isPasswordShow) ? showIcon : hideIcon,
                    color: AppThemeLight.cardColor,),
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
        //FORM REPEAT PASSWORD
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: realWidth,
          child: Form(
            key: _repeatKey,
            child: TextFormField(
              validator: (repeatPass){
                if(repeatPass == null || repeatPass.isEmpty)
                  return 'Please enter repeat pass';
                else if(_passController.text != null && _passController.text.isNotEmpty && !(_passController.text.contains(repeatPass) && _passController.text.length == repeatPass.length))
                  return 'Password do not match';
                else return null;
              },
              controller: _repeatController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !isRepeatPassShow,
              decoration: InputDecoration(
                label: const Text('Confirm Password'),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () => {
                    updateRepeatPassShow(),
                  },
                  icon: Icon(
                    isRepeatPassShow ? showIcon : hideIcon,
                    color: AppThemeLight.cardColor,),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppThemeLight.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: isAgreeWithPolicy, 
              onChanged: (value) => {
                updatePolicyRight(),
              },
              activeColor: AppThemeLight.cardColor,
            ),
            Container(
              width: realWidth-20,
              child: const Text(
                'By registering, you are agreeing with our Terms of Use and Privacy Policy',
                maxLines: 2,
                softWrap: true,
              ),
            )
            
          ],
        ),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () async=> {
            if(_nameKey.currentState!.validate()){
              print("name: ${_nameController.text}")
            },
            if(_mailKey.currentState!.validate()){
              print("email: ${_mailController.text}")
            },
            if(_passKey.currentState!.validate()){
              print("password: ${_passController.text}")
            },
            if(_repeatKey.currentState!.validate()){
              print("Repeat pass: ${_repeatController.text}")
            },
            if(!isAgreeWithPolicy){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please check on private policy to register!'),)),
            },
            if(_nameKey.currentState!.validate() && _mailKey.currentState!.validate() && _passKey.currentState!.validate() && _repeatKey.currentState!.validate())
            {
              //REGISTER NEW ACCOUNT
              user = await FirebaseAuthHelper.registerUsingEmailAndPassword(name: _nameController.text, email: _mailController.text, password: _passController.text, context: context),
              if(user != null){
                await FirebaseAuthHelper.updateFirebaseDatabase(user),
                Navigator.pushNamed(context, '/started'),
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to register new account!'))),
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
            padding: EdgeInsets.only(left: (realWidth-100)/2, right: (realWidth-100)/2, top: 5, bottom: 5),
            child: Text(
              'Register',
              style: AppThemeLight.textTheme.bodyMedium,
            ),
          ),
        )
      ],
    );
  }

  Widget CreateOtherMethodGroup(){
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 50),
          width: MediaQuery.sizeOf(context).width*2/3,
          child: Row(
              children: [
                const Expanded(
                  child: Divider(),
                ),
                Text(
                  ' Or connect via ',
                  style: GoogleFonts.sofiaSansSemiCondensed(

                  ),  
                ),
                const Expanded(
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
              padding: const EdgeInsets.only(top: 20, bottom: 20),
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
          const SizedBox(width: 10,),
          ElevatedButton(
            onPressed: () => {}, 
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(top: 18, bottom: 18),
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
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: GoogleFonts.sofiaSansSemiCondensed(),
            ),
            InkWell(
              onTap: ()=>{
                Navigator.pushNamed(context, '/login')
              },
              child:  Text(
                ' Login',
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

  Future<Null> RegisterWithEmailAndPassword(String email, String password, BuildContext context) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      print('Register successfull!!');
    }on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text('The password provided is too weak!')));
      }else if(e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text('The account already exists for that email!')));
      }
    }catch(e){
      print(e);
    }
  }
}
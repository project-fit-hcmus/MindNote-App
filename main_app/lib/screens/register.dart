import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/Theme/mainTheme.dart';

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
    return Column(
      children: [
        CreateHeaderRegister(),
        CreateGroupInfoRegister(context),
        CreateOtherMethodGroup(),
      ],
    );    
  }

  Widget CreateHeaderRegister(){
    return Container(
      margin: EdgeInsets.only(top: 60, bottom: 10, left: 10, right: 10),
      child: Row(
        children: [
          Container(
            child: Image.asset('images/logo_icon.png'),
            margin: EdgeInsets.only(right: 10),
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
          margin: EdgeInsets.only(top: 60),
          width: realWidth,
          child: TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: Text('Name'),
              prefixIcon: Icon(Icons.account_circle_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppThemeLight.primaryColor,
            ),
          ),
        ),
        // FORM EMAIL ADDRESS
        Container(
          margin: EdgeInsets.only(top: 10),
          width: realWidth,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              label: Text('Email Address'),
              prefixIcon: Icon(Icons.mail_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppThemeLight.primaryColor,
            ),
          ),
        ),
        //FORM PASSWORD
        Container(
          margin: EdgeInsets.only(top: 10),
          width: realWidth,
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: !isPasswordShow,
            decoration: InputDecoration(
              label: Text('Password'),
              prefixIcon: Icon(Icons.lock),
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
        ),
        //FORM REPEAT PASSWORD
        Container(
          margin: EdgeInsets.only(top: 10),
          width: realWidth,
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: !isRepeatPassShow,
            decoration: InputDecoration(
              label: Text('Confirm Password'),
              prefixIcon: Icon(Icons.lock),
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
        SizedBox(height: 20,),
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
              child: Text(
                'By registering, you are agreeing with our Terms of Use and Privacy Policy',
                maxLines: 2,
                softWrap: true,
              ),
            )
            
          ],
        ),
        SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () => {}, 
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
          margin: EdgeInsets.only(top: 10, bottom: 50),
          width: MediaQuery.sizeOf(context).width*2/3,
          child: Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                Text(
                  ' Or connect via ',
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
              'Already have an account?',
              style: GoogleFonts.sofiaSansSemiCondensed(),
            ),
            Text(
              ' Login',
              style: GoogleFonts.sofiaSansSemiCondensed(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        )
      ],
    );
  }
}
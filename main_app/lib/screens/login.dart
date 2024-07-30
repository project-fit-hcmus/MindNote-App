import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/Theme/mainTheme.dart';
class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool isShowPassword = false;
  IconData showIcon = Icons.visibility_outlined;
  IconData hideIcon = Icons.visibility_off_outlined;
  void updateShowPassword(){
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateGroupIntroduce(),
        Image.asset(
          'images/logo_full.png',
          fit: BoxFit.contain,
          ),
        CreateGroupLogin(context),
        CreateOtherMethodGroup(context),
      ],

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
        Container(
          margin: EdgeInsets.only(top: 10),
          width: realWidth,
          child: TextFormField(
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
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: realWidth,
          child: TextFormField(
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
        ),
        
        SizedBox(height: 15,),
        ElevatedButton(
          onPressed: () => {}, 
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
            Text(
              ' Create Account',
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
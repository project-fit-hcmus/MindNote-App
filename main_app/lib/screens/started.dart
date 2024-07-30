import 'package:flutter/material.dart';
import 'package:main_app/Theme/mainTheme.dart';

class StartedScreen extends StatefulWidget{
  const StartedScreen({super.key});
  @override
  State<StatefulWidget> createState() => _StartedScreenState();
}

class _StartedScreenState extends State<StartedScreen>{
  
  @override
  Widget build(BuildContext context) {
  double size = MediaQuery.sizeOf(context).width*1/2;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60,),
          CreateStartedHeader(),
          CreateGroupEmptyList(size),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
        backgroundColor: AppThemeLight.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }

  Widget CreateStartedHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'Notes',
            style: AppThemeLight.textTheme.headlineLarge,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => {}, 
              icon: Icon(
                Icons.search,
                color: AppThemeLight.secondaryHeaderColor,
              )
            ),
            IconButton(
              onPressed: () => {}, 
              icon: Icon(
                Icons.account_circle_outlined,
                color: AppThemeLight.secondaryHeaderColor,
              )
            ),
            IconButton(
              onPressed: () => {}, 
              icon: Icon(
                Icons.more_vert_sharp,
                color: AppThemeLight.secondaryHeaderColor,
              )
            )
          ],
        )
      ],
    );
  }

  Widget CreateGroupEmptyList(double size){
    return Center(
      child:  Column(
        children: [
          Image.asset(
            'images/started_image.png',
            height: size,
            fit: BoxFit.contain,
          ),
          Text(
            'Welcome To Mind Note!',
            style: AppThemeLight.textTheme.bodyLarge,
          )
        ],
      ),
    );
    
   
  }
}
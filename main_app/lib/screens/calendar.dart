import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget{
  const CalendarScreen({super.key});
  @override
  State<StatefulWidget> createState() => _CalendarScreenState();
}
class _CalendarScreenState extends State<CalendarScreen>{
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60,),
            CreateCalendarHeader(themeModeProvider.themeMode),
            SizedBox(height: 10,),
            CreateCalendar(themeModeProvider.themeMode),
          ],
        ),
      ),
    );
  }
  Widget CreateCalendarHeader(ThemeData theme){
    return Row(  
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
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
                  child: Text(
                    'Calendar',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
          ],
        ),
        Row(
          children: [

          ],
        )
      ],
     );

  }

  Widget CreateCalendar(ThemeData theme){
    return TableCalendar(
      focusedDay: DateTime.now(), 
      firstDay: DateTime.utc(2000,1,1), 
      lastDay: DateTime.utc(2050,31,12),
    );
  }
}
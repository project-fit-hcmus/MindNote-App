import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_app/database/entities/Event.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget{
  const CalendarScreen({super.key});
  @override
  State<StatefulWidget> createState() => _CalendarScreenState();
}
class _CalendarScreenState extends State<CalendarScreen>{
  DateTime _focused = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  TextEditingController _eventController = TextEditingController();
  int _currentChoosenSkin = 1;

  void _updateChoosenSkin(int value){
    setState(() {
      _currentChoosenSkin = value;
    });
  }
  
  late Map<DateTime, List<dynamic>> _events;
  void _updateFocusedDay(DateTime day){
    setState(() {
      _focused = day;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _events = {
      DateTime(2024,8,10) : ['Meeting URUS', 'Testing Danai Mobile','Weekly Repo'],
    };
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    List<Color> skinTypes = [AppThemeDark.hintColor, AppThemeDark.hoverColor, AppThemeDark.focusColor];
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
            SizedBox(height: 10,),
            CreateListEvent(themeModeProvider.themeMode),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                scrollable: true,
                title: Text('Event Name'),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                      children: [
                        TextField(
                          controller: _eventController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Event Content',
                          ),
                        ),
                        Container(
                          height: 100,
                          width: width*2/3,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: skinTypes.length,
                            ), 
                            itemBuilder: (BuildContext context, int index){
                              return GestureDetector(
                                onTap: (){
                                  //TODO: HANDLE CHOOSEN COLORS ACTION
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  color: skinTypes[index],
                                  width: 20,
                                  height: 20,
                                ),
                              );
                            }
                          ),
                        )
                        
                      ],
                    ),
                  ),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      //TODO: HANDLE ADD NEW EVENT ACTION
                      
                      Navigator.of(context).pop();
                    }, 
                    child: Text('Submit')
                  )
                ],
              );
            }
          );
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: themeModeProvider.themeMode.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
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
      ],
     );

  }

  Widget CreateCalendar(ThemeData theme){
    User? user = FirebaseAuth.instance.currentUser;
    return TableCalendar(
      focusedDay: _focused,
      currentDay: DateTime.now(), 
      firstDay: DateTime.utc(2000,1,1), 
      lastDay: DateTime.utc(2050,31,12),
      //CALENDAR STYLE 
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedTextStyle: (theme == AppThemeDark) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.white),
        todayDecoration: (theme == AppThemeDark) ? BoxDecoration(color: Color.fromARGB(255, 255, 213, 200) ,shape: BoxShape.circle) : BoxDecoration(color: Color.fromARGB(255, 171, 187, 188) ,shape: BoxShape.circle) ,
        defaultTextStyle: (theme == AppThemeDark) ? TextStyle(color: Colors.white) : TextStyle(),
        selectedDecoration: (theme == AppThemeDark) ? BoxDecoration(color: AppThemeDark.cardColor, shape: BoxShape.circle) : BoxDecoration(color: AppThemeLight.cardColor, shape: BoxShape.circle),
        todayTextStyle: (theme == AppThemeDark) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.white), 
        weekendTextStyle: TextStyle(color: theme.cardColor),
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: (theme == AppThemeDark) ? TextStyle(color: Colors.white) : TextStyle(color:  Colors.black),
        formatButtonTextStyle: (theme == AppThemeDark) ? TextStyle(color: Colors.white) : TextStyle(color:  Colors.black),
        leftChevronIcon: Icon(Icons.chevron_left, color: (theme == AppThemeDark ? Colors.white : Colors.black),),
        rightChevronIcon: Icon(Icons.chevron_right, color: (theme == AppThemeDark ? Colors.white : Colors.black),),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: (theme == AppThemeDark) ? TextStyle(color: Colors.white) : TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: theme.cardColor), 
      ),
      
      // handle click on a day event 
      selectedDayPredicate: (day){
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay){
        setState(() {
          _selectedDay = selectedDay;
          _focused = focusedDay;
        });
      },
      //HANDLE CHANGE FORMAT 
      calendarFormat: _calendarFormat,
      onFormatChanged: (format){
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay){
        _focused = focusedDay;
      },
    );
  }

  Widget CreateListEvent(ThemeData theme){
    DatabaseReference ref = FirebaseDatabase.instance.ref('events');
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: ref.onValue, 
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data!.snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<GestureDetector> items = [];
          values.forEach((key, value){
            if(value['eventUser'].toString() == user!.uid && SupportFunction.convertDateTimeToString(_selectedDay) == value['eventDate'].toString()){
              items.add(GestureDetector(
                onTap: (){
                  //TODO: SHOW DIALOG CHO PHÉP CHỈNH SỬA NỘI DUNG EVENT
                },
                child: Card(
                  color: (value['eventSkinType'].toString().contains('1')) ? theme.hintColor : (value['eventSkinType'].toString().contains('2')) ? theme.hoverColor : theme.focusColor,
                  child: ListTile(
                    title: Text(
                      '${SupportFunction.editContentOfEvent(value['eventDetail'].toString())}',
                      style: GoogleFonts.sofiaSansSemiCondensed(
                        color: Colors.black,
                      ),
                    ),  
                  ),
                ),

              ));
            }
          });
          print(items.length);
          if(!items.isEmpty)
            return ListView(
              shrinkWrap: true,
              children: [
                for(var item in items) item
              ],
            );
          else return SizedBox(height: 0,);
        } else{
          return SizedBox(height: 0,);
        }
      }
    );
  }
}
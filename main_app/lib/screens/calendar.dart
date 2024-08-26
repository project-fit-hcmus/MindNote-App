import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/services/firebase_auth_helper.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_app/database/entities/Event.dart';

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
  int _currentChosenSkin = 0;
  List<Color> skinTypes = [outside.colorScheme.surfaceContainer, outside.colorScheme.surfaceContainerLow, outside.colorScheme.surfaceContainerLowest];
  IconData choosenIcon = Icons.check;
  List<Event> fullData = [];

  void _updateChosenSkin(int value){
    setState(() {
      _currentChosenSkin = value;
      choosenIcon = Icons.check;
    });
  }
  
  void _updateFocusedDay(DateTime day){
    setState(() {
      _focused = day;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _isSelected[0] = true;
  }
  
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
              return MyAlertDialog(
                selectedDate: _selectedDay
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
      //DISPLAY NUMBER EVENTS OF A DAY
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, event){
          if(SupportFunction.CountNumberEventOfADay(fullData, day) > 0 && (SupportFunction.convertDateTimeToString(day) != SupportFunction.convertDateTimeToString(_selectedDay))){
            return Container(
              width: 5,
              height: 5,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 5,),
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.circle,
              ),
            );
          } 
        }
      ),

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
            if(value['eventUser'].toString() == user!.uid){
              fullData.add(Event(
                eventId: value['eventId'], 
                eventUser: value['eventUser'], 
                eventDate: SupportFunction.convertStringToDateTime(value['eventDate'].toString()),
                eventSkinType: value['eventSkinType'], 
                eventDetail: value['eventDetail'],
              ));
            }
            if(value['eventUser'].toString() == user!.uid && SupportFunction.convertDateTimeToString(_selectedDay) == value['eventDate'].toString()){
              items.add(GestureDetector(
                onTap: (){
                  //TODO: SHOW DIALOG CHO PHÉP CHỈNH SỬA NỘI DUNG EVENT
                },
                child: Card(
                  color: skinTypes[int.parse(value['eventSkinType'].toString())],
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
          // print(items.length);
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


class MyAlertDialog extends StatefulWidget{
  DateTime selectedDate;
  MyAlertDialog({
    required this.selectedDate,
  });
  @override
  State<StatefulWidget> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog>{
  TextEditingController _eventController = TextEditingController();
  int _currentChosenSkin = 0;
  List<Color> skinTypes = [outside.colorScheme.surfaceContainer, outside.colorScheme.surfaceContainerLow, outside.colorScheme.surfaceContainerLowest];
  IconData choosenIcon = Icons.check;
  User? user = FirebaseAuth.instance.currentUser;

  void _updateChosenSkin(int value){
    setState(() {
      _currentChosenSkin = value;
      choosenIcon = Icons.check;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return AlertDialog(
      scrollable: true,
      title: Text('Event Information'),
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
              width: width*2/3,
              height: 80,
              child: CreateGroupChooseColor(),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            //TODO: HANDLE ADD NEW EVENT ACTION
            Event e = Event(
              eventId: SupportFunction.createRandomNoteId(), 
              eventUser: user!.uid, 
              eventDate: widget.selectedDate, 
              eventSkinType: _currentChosenSkin, 
              eventDetail: _eventController.text,
            );
            FirebaseAuthHelper.addEventToFirebase(e);
            Navigator.of(context).pop();
          }, 
          child: Text('Submit'),
        )
      ],
    ) ;   
  }
  Widget CreateGroupChooseColor(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: skinTypes.length),
      itemCount: skinTypes.length,
      itemBuilder: (BuildContext context, int index){
        return GestureDetector(
          onTap: (){
            //TODO: HANDLE CHOSEN COLORS ACTION IN REALTIME 
            _updateChosenSkin(index);
          },
          child: Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: CircleAvatar(
              backgroundColor: skinTypes[index],
              child: (_currentChosenSkin == index)? Icon(choosenIcon) : null,
            ),
          )
          
        );
      },
    );
  }
}



// THIS CLASS IS FOR OBSEVER AND EDIT EVENTS 
class CardDialog extends StatefulWidget{
  const CardDialog({super.key});
  @override
  State<StatefulWidget> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog>{
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}





import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/database/entities/Task.dart';
import 'package:main_app/screens/taskDetail.dart';
import 'package:main_app/services/firebase_auth_helper.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'package:main_app/database/entities/TaskDetail.dart';
import 'dart:math' as math;
class TasksScreen extends StatefulWidget{
  const TasksScreen({super.key});
  @override
  State<StatefulWidget> createState() => _TasksScreenState();

}

class _TasksScreenState extends State<TasksScreen>{
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
            CreateHeaderTask(themeModeProvider.themeMode, width),
            SizedBox(height: 20,),
            CreateListTask(themeModeProvider.themeMode, width),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return TaskAlertDialog();
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

  Widget CreateHeaderTask(ThemeData theme, double width){
    return Column(
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
                'Task Manager',
                style: theme.textTheme.headlineLarge,
              ),
            ),
          ]
        ),
        Container(
          width: width,
          margin: EdgeInsets.only(left: 30),
          child: Text(
            'Master your time, achieve your goals.',
            style: GoogleFonts.sofiaSansSemiCondensed(
              fontSize: 15,
              color: (theme == AppThemeLight) ? theme.secondaryHeaderColor : theme.highlightColor,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: theme.highlightColor,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      child: Text(
                        'Your daily objectives',
                        style: GoogleFonts.sofiaSansSemiCondensed(
                          color:  Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: width * 1.2/3,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Designed to make your life more effective',
                        style: GoogleFonts.sofiaSansSemiCondensed(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                Image.asset(
                  'images/task_icon.png',
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          )
        ),
      ],
    );
  }

  Widget CreateListTask(ThemeData theme, double width){
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference ref = FirebaseDatabase.instance.ref('tasks');
    return StreamBuilder(
      stream: ref.onValue, 
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data!.snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<GestureDetector> items = [];
          values.forEach((key,value){
            if(value['taskUser'] == user!.uid){
              items.add(GestureDetector(
                onTap: (){
                  Task t = Task(
                    taskId: value['taskId'], 
                    taskUser: value['taskUser'], 
                    taskTitle: value['taskTitle'], 
                    taskNumberOfComplete: value['taskNumberOfComplete'], 
                    taskNumberOfDetail: value['taskNumberOfDetail'], 
                  );
                  // TODO: VIEW DETAIL OF A TASK
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailScreen(task: t)));
                  
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 100,
                  child: Card(
                    elevation: 4,
                    color: theme.focusColor,
                    child: Row(
                      children: [
                        //A LINE OF COLOR 
                        Container(
                          height: 100,  
                          width: 15,
                          decoration: BoxDecoration(
                            color: (value['taskNumberOfComplete'] == value['taskNumberOfDetail']) ? outside.colorScheme.secondary : (value['taskNumberOfComplete'] == 0 ? outside.colorScheme.surface : outside.colorScheme.primary), 
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          ),
                        ),

                        //A GROUP OF MAIN CONTENT (TAG + TASK TITLE)
                        Container(
                          alignment: Alignment.centerLeft,
                          width: width*2/3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              // TAG
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                child: Text(
                                  (value['taskNumberOfComplete'] == value['taskNumberOfDetail']) ? 'Finish' : (value['taskNumberOfComplete'] == 0 ? 'Planed' : 'On Going'),   
                                  style: GoogleFonts.sofiaSansSemiCondensed(
                                    fontSize: 13,
                                    color:  (value['taskNumberOfComplete'] == value['taskNumberOfDetail']) ? outside.colorScheme.secondary : (value['taskNumberOfComplete'] == 0 ? outside.colorScheme.surface : outside.colorScheme.primary),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color:  (value['taskNumberOfComplete'] == value['taskNumberOfDetail']) ? outside.colorScheme.onSecondary : (value['taskNumberOfComplete'] == 0 ? outside.colorScheme.onSurface : outside.colorScheme.onPrimary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // TITLE 
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  '${value['taskTitle']}',
                                  style: GoogleFonts.sofiaSansSemiCondensed(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),  
                                ),
                              ),
                            ],
                          ),
                        ),
                        // PROGRESS BAR (PERCENTAGE)
                        CreateProgressDisplay(theme, value['taskNumberOfComplete'] * 100 / value['taskNumberOfDetail']),
                      ],
                    ),
                  ),
                ),
                
              ));
            }
          });
          if(!items.isEmpty) 
            return ListView(
              shrinkWrap: true,
              children: [
                for(var item in items) item
              ],
            );
          else return SizedBox(height: 0,);
        }else return SizedBox(height: 0,);
      }
    );
  }

  Widget CreateProgressDisplay(ThemeData theme, double percentage){
    return Center(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: CustomPaint(
                size: Size(50,50),
                painter: CirclePainter(percentage),
              )
            ),
            Center(
              child: Text(
                '${percentage.toStringAsFixed(1)} %',
                style: GoogleFonts.sofiaSansSemiCondensed(
                  fontSize: 12,
                  color: Color.fromARGB(255,150,187,124),
                ),  
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class support for create pie chart 
class CirclePainter extends CustomPainter {
  final double percentage;

  CirclePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255,150,187,124)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint anotherPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;


    double radius = size.width / 2;
    double startAngle1 = math.pi * 1.5;                         // start từ 0%
    double endAngle1  = math.pi * 2 * (percentage / 100);       // end ở percentage %
    double startAngle2 = math.pi * (1.5 + 2*(percentage / 100));// start ở percentage %
    double endAngle2 = math.pi * 2;                             // end ở 100%
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      startAngle2,
      endAngle2,
      false,
      anotherPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      startAngle1,
      endAngle1,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// class support for add a new task 
class TaskAlertDialog extends StatefulWidget{
  const TaskAlertDialog({super.key});
  @override
  State<StatefulWidget> createState() => _TaskAlertDialogState();
}

class _TaskAlertDialogState extends State<TaskAlertDialog>{
  TextEditingController _taskTitleControler = TextEditingController();
  List<TaskDetail> list  = [];
  List<TextEditingController> _listController = [];

  
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return AlertDialog(
      scrollable: true,
      title: Text('Task Information'),
      content: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _taskTitleControler,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter title of task',
              ),
            ),
            if(list != null && list.length > 0)
              ...list.asMap().entries.map((item){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.check_box_outlined),
                    Container(
                      width: 200,
                      height: 40,
                      child: TextField(
                        autofocus: true,
                        controller: _listController[item.key],
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          list.removeAt(item.key);
                          _listController.removeAt(item.key);
                        });
                      }, 
                      icon: Icon(Icons.close),
                    ),
                  ],
                );
              }
            ),
            IconButton(
              onPressed: (){
                setState(() {
                  list.add(TaskDetail(taskDetailContent: "", taskDetailStatus: false, taskDetailId: '', taskId: ''));       
                  _listController.add(TextEditingController());           
                });
              }, 
              icon: Icon(Icons.add)
            ),
            
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            String taskId = SupportFunction.createRandomNoteId();
            print( _taskTitleControler.text);
            for(int i = 0; i < _listController.length; ++i){
              print(_listController[i].text);
              list[i].setTaskDetailContent(_listController[i].text);
              list[i].setTaskId(taskId);
              list[i].setTaskDetailId(SupportFunction.CreateRandomIdForTaskChild(taskId, i));
            }
            Task t = Task(
              taskId: taskId, 
              taskUser: user!.uid, 
              taskTitle: _taskTitleControler.text, 
              taskNumberOfComplete: 0,
              taskNumberOfDetail: list.length,
            );
            FirebaseAuthHelper.addTaskToFirebase(t,list);
            

            Navigator.of(context).pop();
          }, 
          child: Text('Submit'),
        )
      ],
    );  
  }
}
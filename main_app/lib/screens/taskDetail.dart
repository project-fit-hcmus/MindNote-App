import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_app/database/entities/Task.dart';
import 'package:main_app/database/entities/TaskDetail.dart';
import 'package:main_app/services/firebase_auth_helper.dart';
import 'package:main_app/services/support_function.dart';
import 'package:provider/provider.dart';
import 'package:main_app/Theme/mainTheme.dart';
import 'dart:math' as math;


class TaskDetailScreen extends StatefulWidget{
  Task task;
  TaskDetailScreen({
    required Task this.task,
  });
  @override
  State<StatefulWidget> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen>{
  List<TextEditingController> _listController = [];
  List<TaskDetail> _listCheck = [];
  // int originData = 0;
  
  
  @override
  Widget build(BuildContext context) {
  final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
  double width = MediaQuery.sizeOf(context).width;
  User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: themeModeProvider.themeMode.primaryColor,
      body: CustomScrollView(
        shrinkWrap: true,
        
        slivers: [
          //  STABLE PART (DO NOT SCROLL)
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 60,),
                CreateHeaderDetail(themeModeProvider.themeMode),
                SizedBox(height: 10,),
                (widget.task.taskNumberOfComplete == widget.task.taskNumberOfDetail) ? 
                  CreateOveralFinish(themeModeProvider.themeMode, width) : CreateOveralCard(themeModeProvider.themeMode, width, user!.displayName), 
              ],
            ),
          ),
          // SCROLL PART
          
          SliverFixedExtentList(
            itemExtent: 200,
            
            delegate: SliverChildBuilderDelegate(
              (context, index){
              return CreateListOfData(themeModeProvider.themeMode);
              },
              childCount: 1,
            ), 
            
          )
        ],
        
      ),
      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       SizedBox(height: 60,),
      //       CreateHeaderDetail(themeModeProvider.themeMode),
      //       SizedBox(height: 10,),
      //       (widget.task.taskNumberOfComplete == widget.task.taskNumberOfDetail) ? 
      //         CreateOveralFinish(themeModeProvider.themeMode, width) : CreateOveralCard(themeModeProvider.themeMode, width, user!.displayName),
      //       SizedBox(height: 10,),
      //       CreateListOfData(themeModeProvider.themeMode),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //TODO: ADD A NEW SINGLE TASK
            String before = _listCheck[_listCheck.length-1].taskDetailId;
            before = before.substring(before.length-3, before.length);
            TaskDetail t = TaskDetail(
              taskDetailId: SupportFunction.CreateRandomIdForTaskChild(widget.task.taskId, int.parse(before) + 1), 
              taskId: widget.task.taskId, 
              taskDetailContent: '', 
              taskDetailStatus:false,
            );
            FirebaseAuthHelper.addANewTaskDetail(t, widget.task.taskId, widget.task.taskNumberOfDetail+1);
        },
        child: Icon(Icons.add),
        backgroundColor: themeModeProvider.themeMode.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      
      ),
    );
  }
  Widget CreateHeaderDetail(ThemeData theme){
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: (){
              FirebaseAuthHelper.updateTaskNumberOfComplete(widget.task.taskId, widget.task.taskNumberOfComplete);
              Navigator.of(context).pop();
            }, 
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.canvasColor,
            ),
          ),
          Text(
            'Back',
            style: theme.textTheme.headlineLarge,
          )
        ],
      ),
    );
  }
  
  Widget CreateOveralCard(ThemeData theme, double width, String? userName){
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: width * 5.5 / 6 ,
        height: width * 4.9 / 6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [outside.colorScheme.primary, outside.colorScheme.onPrimary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              '${widget.task.taskTitle}',
              style: GoogleFonts.sofiaSansSemiCondensed(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ), 
            ),
            SizedBox(height: 20,),
            Container(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(150, 150),
                    painter: CirclePainter(double.parse((widget.task.taskNumberOfComplete * 100 / widget.task.taskNumberOfDetail).toStringAsFixed(2))),
                    
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: Text(
                      '${(widget.task.taskNumberOfComplete * 100 / widget.task.taskNumberOfDetail).toStringAsFixed(2)} %',
                      style: GoogleFonts.sofiaSansSemiCondensed(
                      fontSize: 30,
                      color: Color.fromARGB(255,150,187,124),
                    ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 40, right: 40),
              child: Text(
                '${SupportFunction.getTimeOfDay()}, $userName! let us monitor and manage the implementation process of your plan.',
                maxLines: 5,
                style: GoogleFonts.sofiaSansSemiCondensed(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            )

            
            
          ],
        ),
      ),
    );
  }
 
  Widget CreateOveralFinish(ThemeData theme, double width){
    return Card(
      margin: EdgeInsets.only(left: 20, right: 20),
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [outside.colorScheme.primary, outside.colorScheme.onPrimary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/congrate_icon.png',
                  width: 30,
                  height: 30,
                ),
                
                Text(
                  ' Goal Achived!',
                  style: GoogleFonts.sofiaSansSemiCondensed(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),  
                ),
              ],
            ),
            Image.asset(
              'images/congratulation.png',
              width: 200,
              height: 200,
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
              child: Text(
                textAlign: TextAlign.center,
                'Congratulations! You have finish you plan successfully! Now, you can start a new plan for your life',
                maxLines: 5,
                style: GoogleFonts.sofiaSansSemiCondensed(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
  
  Widget CreateListOfData(ThemeData theme){
    DatabaseReference ref = FirebaseDatabase.instance.ref('taskDetails');
    return StreamBuilder(
      stream: ref.onValue, 
      builder: (context, snapshot){
        // print('CHECK HERE');
        if(snapshot.hasData && snapshot.data!.snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Container> items = [];
          int i = 0;
          values.forEach((key, value){
            if(value['taskId'] == widget.task.taskId){
              TextEditingController curController = TextEditingController(text: value['taskDetailContent']);
              _listController.add(curController);
              _listCheck.add(TaskDetail(
                taskDetailId: value['taskDetailId'],
                taskId: value['taskId'], 
                taskDetailContent: value['taskDetailContent'], 
                taskDetailStatus: value['taskDetailStatus']
              ));
              ++i;
              items.add(Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Checkbox(
                      value: value['taskDetailStatus'], 
                      onChanged: (check){
                        //TODO: UPDATE TASK DETAIL STATUS
                        // print(_listCheck);
                        // print(widget.task.taskNumberOfComplete);
                        // print(check);
                        FirebaseAuthHelper.updateTaskDetailStatus(value['taskDetailId'],check!);
                        
                        setState(() {
                          if(check == true)
                            widget.task.taskNumberOfComplete += 1;
                          else 
                            widget.task.taskNumberOfComplete -= 1;
                          
                        });
                      }
                    ),
                    Container(
                      width: 200,
                      height: 40,
                      child: TextField(
                        autofocus: (value['taskDetailContent'] == '') ,
                        readOnly: value['taskDetailStatus'],
                        style: GoogleFonts.sofiaSansSemiCondensed(
                          decoration: (value['taskDetailStatus'] == true) ? TextDecoration.lineThrough : TextDecoration.none,
                          decorationColor: (theme == AppThemeLight) ? outside.colorScheme.secondary : Colors.grey.shade800,
                          decorationThickness: 2,
                          color: (theme == AppThemeLight) ? theme.secondaryHeaderColor : theme.highlightColor,
                        ),
                        controller: _listController[_listController.length-1],
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    //CONFIRM CHANGE BUTTON
                    IconButton(
                      onPressed: (){
                        //TODO: HANDLE CONFIRM CHANGE DATA BUTTON
                        if(value['taskDetailStatus'] != true){
                          print('update information');
                          FirebaseAuthHelper.updateTaskDetailContent(value['taskDetailId'], curController.text);
                        }
                      }, 
                      icon: Icon(Icons.check)
                    ),
                    //REMOVE TASK BUTTON
                    IconButton(
                      onPressed: (){
                        //TODO: HANDLE REMOVE A TASK BUTTON
                        if(value['taskDetailStatus'] != true){
                          print('delete information');
                          FirebaseAuthHelper.deleteATaskDetail(value['taskDetailId'], widget.task.taskId, widget.task.taskNumberOfDetail - 1);
                          print(_listController.length);
                          print(_listCheck.length);
                        }
                      }, 
                      icon: Icon(Icons.close_rounded),
                    )
                  ],
                ),
              ));
            }
          });
          if(!items.isEmpty)
            return 
            ListView(
              shrinkWrap:  false,
              children: [
                for(var item in items) item
              ],
            );
          else return SizedBox(height: 0,);
        }else return SizedBox(height: 0,); 
      }
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
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint anotherPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 30
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

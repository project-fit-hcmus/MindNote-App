import 'package:floor/floor.dart';

class Task{
  @primaryKey
  @ColumnInfo(name: 'taskId')
  final String taskId;
  @ColumnInfo(name: 'taskUser')
  final String taskUser;
  @ColumnInfo(name: 'taskTitle')
  final String taskTitle;
  @ColumnInfo(name: 'taskNumberOfDetail')
  int taskNumberOfDetail;
  @ColumnInfo(name: 'taskNumberOfComplete')
  int taskNumberOfComplete;

  
  Task({
    required String this.taskId,
    required String this.taskUser,
    required String this.taskTitle,
    required int this.taskNumberOfComplete,
    required int this.taskNumberOfDetail,
  });
}

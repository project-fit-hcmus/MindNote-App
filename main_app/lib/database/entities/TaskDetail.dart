import 'package:floor/floor.dart';

@entity
class TaskDetail{
  @primaryKey
  @ColumnInfo(name: 'taskDetailId')
  String taskDetailId;
  @ColumnInfo(name: 'taskId')
  String taskId;
  @ColumnInfo(name: 'taskDetailContent')
  String taskDetailContent;
  @ColumnInfo(name: 'taskDetailStatus')
  bool taskDetailStatus;

  TaskDetail({
    required String this.taskDetailId,
    required String this.taskId,
    required String this.taskDetailContent,
    required bool this.taskDetailStatus,
  });
  setTaskDetailContent(String content){
    this.taskDetailContent = content;
  }
  setTaskDetailStatus(bool status){
    this.taskDetailStatus = status;
  }
  setTaskId(String id){
    this.taskId = id;
  }
  setTaskDetailId(String id){
    this.taskDetailId = id;
  }
}
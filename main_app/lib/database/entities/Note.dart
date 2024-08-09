import 'package:floor/floor.dart';

@entity
class Note{
  @primaryKey
  @ColumnInfo(name: 'noteId')
  final String noteId;
  @ColumnInfo(name: 'noteUser')
  final String noteUser;
  @ColumnInfo(name: 'noteTitle')
  final String noteTitle;
  @ColumnInfo(name: 'noteDate')
  final String noteDate;
  @ColumnInfo(name: 'noteContent')
  final String noteContent;
  @ColumnInfo(name: 'noteNumberCharacters')
  final int noteNumberCharacters;
  @ColumnInfo(name: 'noteDetail')
  final String noteDetail;
  @ColumnInfo(name: 'noteSkin')
  final String noteSkin;
  Note( {
    required String this.noteId,
    required String this.noteUser,
    required String this.noteTitle,
    required String this.noteDate,
    required String this.noteContent,
    required int this.noteNumberCharacters,
    required String this.noteDetail,
    required String this.noteSkin,
  });
  
  //convert Note into Map
  Map<String, Object?> toMap(){
    return{
      'noteId': this.noteId,
      'noteTitle': this.noteTitle,
      'noteUser': this.noteUser,
      'noteDate': this.noteDate,
      'noteContent': this.noteContent,
      'noteNumberCharacters': this.noteNumberCharacters,
      'noteDetail': this.noteDetail,
      'noteSkin': this.noteSkin,
    };
  } 
  String getNoteUser(){return this.noteUser;}

}
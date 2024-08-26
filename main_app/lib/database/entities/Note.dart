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
  @ColumnInfo(name: 'noteFormatBold')
  final bool noteFormatBold;
  @ColumnInfo(name: 'noteFormatItalic')
  final bool noteFormatItalic;
  @ColumnInfo(name: 'noteFormatLine')
  final bool noteFormatLine;
  @ColumnInfo(name: 'noteFormatSize')
  final double noteFormatSize;

  Note( {
    required String this.noteId,
    required String this.noteUser,
    required String this.noteTitle,
    required String this.noteDate,
    required String this.noteContent,
    required int this.noteNumberCharacters,
    required String this.noteDetail,
    required String this.noteSkin,
    required bool this.noteFormatBold,
    required bool this.noteFormatItalic,
    required bool this.noteFormatLine,
    required double this.noteFormatSize,
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
      'noteFormatBold': this.noteFormatBold,
      'noteFormatItalic': this.noteFormatItalic,
      'noteFormatLine': this.noteFormatLine,
      'noteFormatSize': this.noteFormatSize,
    };
  } 
  String getNoteUser(){return this.noteUser;}

}
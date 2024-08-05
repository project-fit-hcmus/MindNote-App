import 'package:intl/intl.dart';
import 'dart:math';


class SupportFunction{
  static String getFormatedDate(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }
  static String ConvertDate(String date){
    int pos = date.indexOf('/');
    int day = int.parse(date.substring(0,pos));
    date = date.substring(pos+1);
    pos = date.indexOf('/');
    int month = int.parse(date.substring(0,pos));
    date = date.substring(pos+1);
    int year = int.parse(date);
    String output = day.toString() ;
    switch(month){
      case 1:
        output += ' January';
        break;
      case 2: 
        output += ' Febuary';
        break;
      case 3: 
        output += ' March';
        break;
      case 4:
        output += ' April';
        break;
      case 5:
        output += ' May';
        break;
      case 6:
        output += ' June';
        break;
      case 7:
        output += ' July';
        break;
      case 8:
        output += ' August';
        break;
      case 9:
        output += ' September';
        break;
      case 10: 
        output += ' October';
        break;
      case 11:
        output += ' November';
        break;
      case 12:
        output += ' December';
        break;
      }
    DateTime now = DateTime.now();
    int curYear = now.year;
    if(year != curYear)
      output += " " +year.toString();
    return output;
  }
  static String getCurrentTime(){
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);     // định dạng giờ theo hh:mm
    return formattedTime;
  }
  static String getCurrentDayOfWeek(){
    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat.EEEE().format(now);
    return dayOfWeek;
  }
  static int countNumberOfCharacter(String input){
    if(input.isEmpty)
      return 0;
    //sử dụng regular expression để tìm các từ (phân tách bởi khoảng trắng hoặc ký tự đặc biệt)
    final RegExp wordRegExp = RegExp(r'\S+');
    Iterable<Match> matches = wordRegExp.allMatches(input);
    return matches.length;
  }
  static String createRandomNoteId(){
    String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String number = '0123456789';
    String result = '';
    for(int i = 0; i < 3; ++i){
      result += alphabet[Random().nextInt(alphabet.length)];
    }
    for(int i = 0; i < 2; ++i){
      result += number[Random().nextInt(number.length)];
    }
    return result;
  }
}
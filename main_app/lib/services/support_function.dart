import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:sqflite/utils/utils.dart';


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

  static int ConvertToIntSkinVersion(String input){
    if(input == 'skins/leaf.jpg')
      return 0;
    else if(input == 'skins/linear_green.jpg')
      return 1;
    else if(input == 'skins/paper.jpg')
      return 2;
    else if(input == 'skins/sky.jpg')
      return 3;
    else if(input == 'skins/traditional.jpg')
      return 4;
    else if(input == 'skins/magic.jpg')
      return 5;
    else if(input == 'skins/stripe_pink.jpg')
      return 6;
    else if(input == 'skins/green_pen.jpg')
      return 7;
    else if(input == 'skins/pink_fabric_icon.jpg')
      return 8;
    else if(input == 'skins/flower_icon.jpg')
      return 9;
    else if(input == 'skins/fish_skin_icon.jpg')
      return 10;
    else return -1;
  }

  static String ConvertToStringSkinVersion(int input){
    switch(input){
      case 0:
        return 'skins/leaf.jpg';
      case 1:
        return 'skins/linear_green.jpg';
      case 2:
        return 'skins/paper.jpg';
      case 3:
        return 'skins/sky.jpg';
      case 4: 
        return 'skins/traditional.jpg';
      case 5:
        return 'skins/magic.jpg';
      case 6:
        return 'skins/stripe_pink.jpg';
      case 7:
        return 'skins/green_pen.jpg';
      case 8:
        return 'skins/pink_fabric_icon.jpg';
      case 9: 
        return 'skins/flower_icon.jpg'; 
      case 10:
        return 'skins/fish_skin_icon.jpg';
      default:
        return 'null';
    }
  }

  static String getDisplayTitle(String content, String keyword){
    String temp = content.replaceAll('\n', ' ');
    String result = '';
    int pos = content.indexOf(keyword);
    int before = pos - 15;
    int after  = pos + keyword.length + 15;
    bool check = false;
    if(before < 0) {
      before = 0;
    }else result += '...';
    if(after >= temp.length){
      after = temp.length - 1;
      check = true;
    }
    result += temp.substring(before, after);
    if(!check) result += '...';
    return result;
  }

  static DateTime convertStringToDateTime(String input){
    List<String> dateParts = input.split('/');      // extract day, month and year value
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime(year, month, day);      // create DateTime instance from day, month and year.
  }

  static String convertDateTimeToString(DateTime input){
    String day = input.day.toString().padLeft(2,'0');     // ensure having 2 number for day 
    String month = input.month.toString().padLeft(2,'0');
    String year = input.year.toString();
    return '$day/$month/$year';
  }

  static String editContentOfEvent(String input){
    String result = '';
    if(input.length > 30){
      result = input.substring(0,27);
      result += '...';
    }
    else result = input;
    return input;
  }
}


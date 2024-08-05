import 'package:floor/floor.dart';
import 'package:main_app/database/entities/Note.dart';
import 'package:main_app/database/entities/Account.dart';
import 'package:main_app/database/dao/NoteDAO.dart';
import 'package:main_app/database/dao/AccountDAO.dart';
import 'package:sqflite/sqflite.dart' as sqflite;   
import 'dart:async';

// part 'database.g.dart'; // the generated code will be there
part 'database.g.dart';

//THERE ARE SOME ERROR
@Database(version: 1, entities:[Note, Account])
abstract class AppDatabase extends FloorDatabase{
  AccountDAO get userDAO;
  NoteDAO get noteDAO;

}
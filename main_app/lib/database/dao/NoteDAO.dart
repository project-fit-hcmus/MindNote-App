import 'package:floor/floor.dart';
import 'package:main_app/database/entities/Note.dart';
@dao
abstract class NoteDAO{
  @Query('SELECT * FROM Note')
  Future<List<Note>> getAllNote();
  @Query('SELECT * FROM Note WHERE noteUser = :Uid')
  Future<List<Note>> getAllNoteByUserId(String Uid);
  // @Query('SELECT * FROM Note WHERE noteId = :id')
  // Future<Note> getNoteById(String id);
  @insert
  Future<void> insertANote(Note note);
  @delete
  Future<void> deleteANote(Note note);
}
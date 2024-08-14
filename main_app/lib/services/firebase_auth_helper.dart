import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:main_app/database/entities/Note.dart';
import 'package:main_app/database/entities/Event.dart';
import 'package:main_app/database/entities/Task.dart';
import 'package:main_app/database/entities/TaskDetail.dart';
import 'package:main_app/services/support_function.dart';

class FirebaseAuthHelper{
  //AUTHENTICATION 
  static Future<User?> registerUsingEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
      return user;
    } on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        print('The password is too weak!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password is too weak!')));
      }else if(e.code == 'email-already-in-use'){
        print('The account already exists for tha email!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for tha email!')));
      }else {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      return null;
    }catch(e){
      print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error here -- $e')));
      return null;
    }
    // return user;
  }
  static Future<User?> signInUsingEmailAndPassword({
    required String email,
    required String password,
  }) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        print('No user found for that email!');
      }else if(e.code == 'wrong-password'){
        print('Wrong password provided!');
      }
    }catch(e){
      print(e);
    }
    return user;
  }
  static Future<UserCredential?> signInUsingGoogle() async{
    //trigger authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    //create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    //once signed in, return the UserCredential 
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  static Future<void> updateFirebaseDatabase(User? user) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/' + user!.uid);
      await ref.set({
        'accId': user!.uid.toString(),
        'accUserName' : user!.displayName.toString(),
        'accMail' : user!.email.toString(),
        'accBio' : '',
      });

    }catch(e){
      print(e);
    }
  }


  //NOTE HANDLE IN FIREBASE
  static Future<void> addANoteToFirebase(Note note) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('notes/' + note.noteId);
      await ref.set({
        'noteId': note.noteId,
        'noteUser': note.noteUser,
        'noteDate':note.noteDate,
        'noteContent': note.noteContent,
        'noteTitle': note.noteTitle,
        'noteNumberOfCharacter': note.noteNumberCharacters,
        'noteDetail': note.noteDetail,
        'noteSkin': note.noteSkin,
      });
    }catch(e){
      print(e);
    }
  }
  static Future<void> updateNote(String title, String content, String id) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('notes/${id}');
      await ref.update({
        'noteTitle': title,
        'noteContent': content,
      });
    }catch(e){
      print(e);
    }
  }
  static Future<void> updateNoteSkin(String skin, String noteId) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('notes/$noteId');
      await ref.update({
        'noteSkin' : skin,
      });
    }catch(e){
      print(e);
    }
  }

  //EVENT HANDLE IN FIREBASE
  static Future<void> addEventToFirebase(Event event) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('events/${event.eventId}');
      await ref.set({
        'eventId': event.eventId,
        'eventUser': event.eventUser,
        'eventSkinType': event.eventSkinType,
        'eventDate': SupportFunction.convertDateTimeToString(event.eventDate),
        'eventDetail': event.eventDetail,
      });
    }catch(e){
      print(e);
    }
  }

  //USER INFORMATION HANDLE IN FIREBASE
  static Future<void> updateUserInfo(String name, String bio, User? user) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user!.uid}');
      await ref.update({
        'accUserName': name,
        'accBio': bio,
      });
      user.updateDisplayName(name);
    }catch(e){
      print(e);
    }
  }

  //TASK HANDLE IN FIREBASE 
  static Future<void> addTaskToFirebase(Task task, List<TaskDetail> list) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('tasks/${task.taskId}');
      await ref.set({
        'taskId': task.taskId,
        'taskUser': task.taskUser,
        'taskTitle': task.taskTitle,
        'taskNumberOfDetail' : task.taskNumberOfDetail,
        'taskNumberOfComplete': task.taskNumberOfComplete,

      });
      DatabaseReference ref2 = FirebaseDatabase.instance.ref('taskDetails/');
      for(int i = 0 ; i < list.length; ++i){
        await ref2.child('/${list[i].taskDetailId}').set({
          'taskDetailId': list[i].taskDetailId,
          'taskId': task.taskId,
          'taskDetailContent': list[i].taskDetailContent,
          'taskDetailStatus': list[i].taskDetailStatus,
        }); 
      }
    }catch(e){
      print(e);
    }
  }
  static Future<void> updateTaskDetailStatus(String id, bool value) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('taskDetails/${id}');
        await ref.update({
          'taskDetailStatus': value,
        });
    }catch(e){
      print(e);
    }
  }
  static Future<void> updateTaskNumberOfComplete(String taskId, int value) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('tasks/${taskId}');
      await ref.update({
        'taskNumberOfComplete': value,
      });
    }catch(e){
      print(e);
    }
  }
  static Future<void> updateTaskDetailList(List<TaskDetail> list) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('taskDetails');
      for(int i = 0; i < list.length; ++i){
        await ref.child(list[i].taskDetailId).update({
          'taskDetailContent': list[i].taskDetailContent,
        });
      }
    }catch(e){
      print(e);
    }
  }
  static Future<void> addANewTaskDetail(TaskDetail t, String taskId, int value) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('taskDetails/${t.taskDetailId}');
      await ref.set({
        'taskDetailId': t.taskDetailId,
        'taskId': t.taskId,
        'taskDetailContent': t.taskDetailContent,
        'taskDetailStatus': t.taskDetailStatus,
      });
      DatabaseReference ref2 = FirebaseDatabase.instance.ref('tasks/$taskId');
      await ref2.update({
        'taskNumberOfDetail': value,
      });
    }catch(e){
      print(e);
    }
  }
  static Future<void> updateTaskDetailContent(String taskDetailId, String newContent) async{
    print('update task detail content -- ' + taskDetailId);
    print('upadte task detail content --' + newContent);
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('taskDetails/$taskDetailId');
      await ref.update({
       'taskDetailContent': newContent, 
      });
    }catch(e){
      print(e);
    }
  }
  static Future<void> deleteATaskDetail(String id, String taskId, int value) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('taskDetails/$id');
      print(id);
      await ref.remove().then((_){
        print('delete successful!!!');
      })
      .catchError((e){
        print('there is something wrong $e ');
      });
      DatabaseReference ref2 = FirebaseDatabase.instance.ref('tasks/$taskId');
      await ref2.update({
        'taskNumberOfDetail': value,
      });
    }catch(e){
      print(e);
    }
  }
}
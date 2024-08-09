import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:main_app/database/entities/Note.dart';
import 'package:main_app/services/support_function.dart';


class FirebaseAuthHelper{
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

  // static Future<UserCredential?> signUnUsingFacebook() async{
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }
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

  static Future<void> addANoteToFirebase(Note note) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('notes/' + SupportFunction.createRandomNoteId());
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
  

}
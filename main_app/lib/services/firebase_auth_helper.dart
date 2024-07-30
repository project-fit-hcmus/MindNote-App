import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password is too weak!')));
      }else if(e.code == 'email-already-in-use'){
        print('The account already exists for tha email!');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for tha email!')));
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

}
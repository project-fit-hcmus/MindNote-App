import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:main_app/database/database.dart';
import 'package:main_app/database/entities/Account.dart';
class DatabaseHelper{
  static void initialLocalDatabase(User? user) async{
    // final database = await $FloorAppDatabase.databaseBuilder('mind_note_database.db').build();
    // final userdao = database.userDAO;
    //ERROR
    final snapshot = await FirebaseDatabase.instance.ref('users').get();
    if(snapshot.exists){
      print(snapshot.value);
    }
    else{
      print('no data available!');
    }
  }
  static Future<String> getBioOfUser(String uid) async{
    final snapshot = await FirebaseDatabase.instance.ref('users/${uid}/accBio').get();
    if(snapshot.exists){
      print('get bio:' + snapshot.value.toString());
      return snapshot.value.toString();
    }
    else return '';
  }
  
}


//CREATE LOCAL DATABASE
                  // final database = await $FloorAppDatabase.databaseBuilder('mind_note_database.db').build();
                  // final userdao  = database.userDAO;
                  // final List<Account> result = await userdao.findAllUser();
                  // if(result.isEmpty){
                  //   print('list account is empty');
                  // }else{
                  //   print('list account is not empty');
                  //   for(Account acc in result){
                  //     print('login id: ' + acc.accId);
                  //     print('login name: ' + acc.accName);
                  //     print('login mail: ' + acc.accMail);
                  //     String id = acc.accId;
                  //     String name = acc.accName;
                  //     String mail = acc.accMail;
                      
                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('login id: $id ---- login name: $name ---- login mail: $mail')));
// 
                    // }
                  // }
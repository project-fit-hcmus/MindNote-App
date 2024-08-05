import 'package:floor/floor.dart';
import 'package:main_app/database/entities/Account.dart';
@dao
abstract class AccountDAO{
  @Query('SELECT * FROM User')
  Future<List<Account>> findAllUser();
  // @Query('SELECT * FROM User WHERE accId = :id')
  // Future<User> getUserById(String id);
  @insert
  Future<void> insertAUser(Account user);
  @delete
  Future<void> deleteAUser(Account user);
} 
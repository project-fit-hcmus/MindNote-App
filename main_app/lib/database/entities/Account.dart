import 'package:floor/floor.dart';
@entity
class Account{
  @primaryKey
  @ColumnInfo(name: 'accId')
  final String accId;
  @ColumnInfo(name: 'accName')
  final String accName;
  @ColumnInfo(name: 'accBio')
  final String accBio;
  @ColumnInfo(name: 'accMail')
  final String accMail;
  const Account({
    required this.accId,
    required this.accName,
    required this.accBio,
    required this.accMail,
  });
  String getBio(){return this.accBio;}
  
}
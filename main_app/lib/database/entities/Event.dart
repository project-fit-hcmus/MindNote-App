import 'package:floor/floor.dart';

@entity
class Event{
  @primaryKey
  @ColumnInfo(name: 'eventId')
  final String eventId;
  @ColumnInfo(name: 'eventUser')
  final String eventUser;
  @ColumnInfo(name: 'eventDate')
  final DateTime eventDate;
  @ColumnInfo(name: 'eventSkinType')
  final int eventSkinType;
  @ColumnInfo(name: 'eventDetail')
  final String eventDetail;
  Event({
    required String this.eventId,
    required String this.eventUser,
    required DateTime this.eventDate,
    required int this.eventSkinType,
    required String this.eventDetail,
  });
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AccountDAO? _userDAOInstance;

  NoteDAO? _noteDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Note` (`noteId` TEXT NOT NULL, `noteUser` TEXT NOT NULL, `noteTitle` TEXT NOT NULL, `noteDate` TEXT NOT NULL, `noteContent` TEXT NOT NULL, `noteNumberCharacters` INTEGER NOT NULL, PRIMARY KEY (`noteId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Account` (`accId` TEXT NOT NULL, `accName` TEXT NOT NULL, `accBio` TEXT NOT NULL, `accMail` TEXT NOT NULL, PRIMARY KEY (`accId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AccountDAO get userDAO {
    return _userDAOInstance ??= _$AccountDAO(database, changeListener);
  }

  @override
  NoteDAO get noteDAO {
    return _noteDAOInstance ??= _$NoteDAO(database, changeListener);
  }
}

class _$AccountDAO extends AccountDAO {
  _$AccountDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _accountInsertionAdapter = InsertionAdapter(
            database,
            'Account',
            (Account item) => <String, Object?>{
                  'accId': item.accId,
                  'accName': item.accName,
                  'accBio': item.accBio,
                  'accMail': item.accMail
                }),
        _accountDeletionAdapter = DeletionAdapter(
            database,
            'Account',
            ['accId'],
            (Account item) => <String, Object?>{
                  'accId': item.accId,
                  'accName': item.accName,
                  'accBio': item.accBio,
                  'accMail': item.accMail
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Account> _accountInsertionAdapter;

  final DeletionAdapter<Account> _accountDeletionAdapter;

  @override
  Future<List<Account>> findAllUser() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => Account(
            accId: row['accId'] as String,
            accName: row['accName'] as String,
            accBio: row['accBio'] as String,
            accMail: row['accMail'] as String));
  }

  @override
  Future<void> insertAUser(Account user) async {
    await _accountInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAUser(Account user) async {
    await _accountDeletionAdapter.delete(user);
  }
}

class _$NoteDAO extends NoteDAO {
  _$NoteDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _noteInsertionAdapter = InsertionAdapter(
            database,
            'Note',
            (Note item) => <String, Object?>{
                  'noteId': item.noteId,
                  'noteUser': item.noteUser,
                  'noteTitle': item.noteTitle,
                  'noteDate': item.noteDate,
                  'noteContent': item.noteContent,
                  'noteNumberCharacters': item.noteNumberCharacters
                }),
        _noteDeletionAdapter = DeletionAdapter(
            database,
            'Note',
            ['noteId'],
            (Note item) => <String, Object?>{
                  'noteId': item.noteId,
                  'noteUser': item.noteUser,
                  'noteTitle': item.noteTitle,
                  'noteDate': item.noteDate,
                  'noteContent': item.noteContent,
                  'noteNumberCharacters': item.noteNumberCharacters
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final DeletionAdapter<Note> _noteDeletionAdapter;

  @override
  Future<List<Note>> getAllNote() async {
    return _queryAdapter.queryList('SELECT * FROM Note',
        mapper: (Map<String, Object?> row) => Note(
            noteId: row['noteId'] as String,
            noteUser: row['noteUser'] as String,
            noteTitle: row['noteTitle'] as String,
            noteDate: row['noteDate'] as String,
            noteContent: row['noteContent'] as String,
            noteNumberCharacters: row['noteNumberCharacters'] as int,
            noteDetail: row['noteDetail'] as String));
  }

  @override
  Future<List<Note>> getAllNoteByUserId(String Uid) async {
    return _queryAdapter.queryList('SELECT * FROM Note WHERE noteUser = ?1',
        mapper: (Map<String, Object?> row) => Note(
            noteId: row['noteId'] as String,
            noteUser: row['noteUser'] as String,
            noteTitle: row['noteTitle'] as String,
            noteDate: row['noteDate'] as String,
            noteContent: row['noteContent'] as String,
            noteNumberCharacters: row['noteNumberCharacters'] as int,
            noteDetail: row['noteDetail'] as String),
        arguments: [Uid]);
  }

  @override
  Future<void> insertANote(Note note) async {
    await _noteInsertionAdapter.insert(note, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteANote(Note note) async {
    await _noteDeletionAdapter.delete(note);
  }
}

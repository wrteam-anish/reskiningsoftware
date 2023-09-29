// import 'package:sqflite/sqflite.dart';
//
// class DB {
//   static String databasePath = "";
//
//   initDatabase() async {
//     String dpath = await getDatabasesPath();
//     String path = "${dpath}config.db";
//     databasePath = path;
//   }
//
//   static createDatabase() async {
//     Database database = await openDatabase(
//       databasePath,
//       version: 1,
//       onCreate: (Database db, int version) {
//         db.execute(
//             "CREATE TABLE appConfiguration (id INTEGER PRIMARY KEY, data TEXT, value INTEGER, num REAL)");
//       },
//     );
//   }
// }

import 'dart:io';
import 'package:mad_project/model/projectItem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ProjectDB {
  String dbName;

  ProjectDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(ProjectItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('project');

    Future<int> keyID = store.add(db, {
      'title': item.title,
      'description': item.description,
      'startDate': item.startDate?.toIso8601String(),
      'endDate': item.endDate?.toIso8601String(),
      'responsiblePerson': item.responsiblePerson, // เพิ่มฟิลด์นี้
    });
    db.close();
    return keyID;
  }

  Future<List<ProjectItem>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('project');

    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder('startDate', false)]));
    List<ProjectItem> projects = [];

    for (var record in snapshot) {
      ProjectItem item = ProjectItem(
        keyID: record.key,
        title: record['title'].toString(),
        description: record['description'].toString(),
        startDate: record['startDate'] != null ? DateTime.parse(record['startDate'].toString()) : null,
        endDate: record['endDate'] != null ? DateTime.parse(record['endDate'].toString()) : null,
        responsiblePerson: record['responsiblePerson']?.toString() ?? 'ไม่ระบุ', // แก้ให้รองรับค่าที่ไม่มี
      );
      projects.add(item);
    }
    db.close();
    return projects;
  }

  deleteData(ProjectItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('project');
    store.delete(db, finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
    db.close();
  }

  updateData(ProjectItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('project');

    store.update(
      db,
      {
        'title': item.title,
        'description': item.description,
        'startDate': item.startDate?.toIso8601String(),
        'endDate': item.endDate?.toIso8601String(),
        'responsiblePerson': item.responsiblePerson, // เพิ่มฟิลด์นี้
      },
      finder: Finder(filter: Filter.equals(Field.key, item.keyID)),
    );
    db.close();
  }
}

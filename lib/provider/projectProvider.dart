import 'package:mad_project/model/projectItem.dart';
import 'package:flutter/foundation.dart';
import 'package:mad_project/database/projectDB.dart';

class ProjectProvider with ChangeNotifier {
  List<ProjectItem> projects = [];

  List<ProjectItem> getProjects() {
    return projects;
  }

  void initData() async {
    var db = ProjectDB(dbName: 'projects.db');
    projects = await db.loadAllData();
    notifyListeners();
  }

  void addProject(ProjectItem project) async {
    var db = ProjectDB(dbName: 'projects.db');
    await db.insertDatabase(project);
    projects = await db.loadAllData();
    notifyListeners();
  }

  void deleteProject(ProjectItem project) async {
    var db = ProjectDB(dbName: 'projects.db');
    await db.deleteData(project);
    projects = await db.loadAllData();
    notifyListeners();
  }

  void updateProject(ProjectItem project) async {
    var db = ProjectDB(dbName: 'projects.db');
    await db.updateData(project);
    projects = await db.loadAllData();
    notifyListeners();
  }
}

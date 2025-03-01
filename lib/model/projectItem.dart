class ProjectItem {
  int? keyID;
  String title;          // ชื่อโครงการ
  String description;    // รายละเอียดของโครงการ
  DateTime? startDate;   // วันที่เริ่มโครงการ
  DateTime? endDate;     // วันที่สิ้นสุดโครงการ
  String responsiblePerson; // ผู้รับผิดชอบโครงการ

  ProjectItem({
    this.keyID,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    required this.responsiblePerson,
  });
}

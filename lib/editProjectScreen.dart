import 'package:flutter/material.dart';
import 'package:mad_project/provider/projectProvider.dart';
import 'package:mad_project/model/projectItem.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final ProjectItem item;
  const EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final responsiblePersonController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    descriptionController.text = widget.item.description;
    responsiblePersonController.text = widget.item.responsiblePerson;
    startDate = widget.item.startDate;
    endDate = widget.item.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโครงการ'),
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('ยืนยันการลบ'),
                  content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบโครงการนี้?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ยกเลิก'),
                    ),
                    TextButton(
                      onPressed: () {
                        var provider = Provider.of<ProjectProvider>(context, listen: false);
                        provider.deleteProject(widget.item);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'ชื่อโครงการ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    controller: titleController,
                    validator: (value) => value!.isEmpty ? 'กรุณาป้อนชื่อโครงการ' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'รายละเอียดโครงการ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    controller: descriptionController,
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'กรุณาป้อนรายละเอียด' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'ผู้รับผิดชอบโครงการ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    controller: responsiblePersonController,
                    validator: (value) => value!.isEmpty ? 'กรุณาป้อนชื่อผู้รับผิดชอบ' : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(startDate == null
                        ? 'เลือกวันที่เริ่มโครงการ'
                        : 'วันที่เริ่ม: ${dateFormat.format(startDate!)}'),
                    trailing: const Icon(Icons.calendar_today, color: Colors.green),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() => startDate = picked);
                      }
                    },
                  ),
                  ListTile(
                    title: Text(endDate == null
                        ? 'เลือกวันที่สิ้นสุดโครงการ'
                        : 'วันที่สิ้นสุด: ${dateFormat.format(endDate!)}'),
                    trailing: const Icon(Icons.calendar_today, color: Colors.red),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          var provider = Provider.of<ProjectProvider>(context, listen: false);
                          ProjectItem project = ProjectItem(
                            keyID: widget.item.keyID,
                            title: titleController.text,
                            description: descriptionController.text,
                            startDate: startDate,
                            endDate: endDate,
                            responsiblePerson: responsiblePersonController.text,
                          );
                          provider.updateProject(project);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.green.shade700,
                      ),
                      child: const Text('บันทึกการแก้ไข', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

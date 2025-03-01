import 'package:flutter/material.dart';
import 'package:mad_project/provider/projectProvider.dart';
import 'package:mad_project/model/projectItem.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final responsiblePersonController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มโครงการใหม่'),
        backgroundColor: Colors.green.shade700,
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
                            title: titleController.text,
                            description: descriptionController.text,
                            responsiblePerson: responsiblePersonController.text,
                            startDate: startDate,
                            endDate: endDate,
                          );
                          provider.addProject(project);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.green.shade700,
                      ),
                      child: const Text('เพิ่มโครงการ', style: TextStyle(fontSize: 16, color: Colors.white)),
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

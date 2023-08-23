import 'package:exam_database/models/annual_students_model.dart';
import 'package:hive_flutter/adapters.dart';

import 'term_model.dart';

part 'class_model.g.dart';

@HiveType(typeId: 0)
class Class {
  @HiveField(0)
  String className;
  @HiveField(1)
  String session;
  @HiveField(2)
  List<TermClass> terms = [];
  @HiveField(3)
  List<StudentAnnual> studentsAnnual = [];
  Class(this.className, this.session);
}

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:exam_database/models/annual_students_model.dart';
import 'package:exam_database/models/annual_subjects_model.dart';
import 'package:exam_database/models/class_model.dart';
import 'package:exam_database/models/student_model.dart';
import 'package:exam_database/models/subject_model.dart';
import 'package:exam_database/models/term_model.dart';
import 'package:exam_database/pages/home.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

const String classBox = "name";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(ClassAdapter());
  Hive.registerAdapter(TermClassAdapter());
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(StudentAnnualAdapter());
  Hive.registerAdapter(SubjectAnnualAdapter());
  await Hive.openBox<Class>(classBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Results System',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: AnimatedSplashScreen(
        splashIconSize: 130,
        backgroundColor: Colors.white,
        splash: Image.asset("assets/logo.jpg"),
        duration: 3000,
        nextScreen: const Home(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:exam_database/models/class_model.dart';
import 'package:exam_database/models/subject_model.dart';
import 'package:exam_database/store/colors.dart';
import 'package:exam_database/store/store.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'assessments.dart';
import 'results.dart';
import 'students.dart';
import 'subjects.dart';

class ClassPage extends StatefulWidget {
  final String name;
  final int classKey;
  final int classIndex;
  final String termName;

  final int termIndex;

  const ClassPage(
      {Key key,
      this.name,
      this.classKey,
      this.classIndex,
      this.termName,
      this.termIndex})
      : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  Box<Class> classBox;

  @override
  void initState() {
    super.initState();
    classBox = Hive.box<Class>("name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 25, left: 25, bottom: 25, right: 10),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name + " " + widget.termName,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 51, 48, 48),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
                  Expanded(child: Container()),
                  /*  const Icon(
                    Icons.more_vert_rounded,
                    size: 24,
                  ), */
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            height: 1,
            width: double.maxFinite,
            color: Colors.blue,
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentsPage(
                            className: widget.name,
                            classKey: widget.classKey,
                            classIndex: widget.classIndex,
                            termIndex: widget.termIndex,
                          )));
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 0.5, spreadRadius: 0.5)
                  ],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColors,
                  ),
                  color: Colors.white),
              child: Row(
                children: [
                  const Text(
                    "Students",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 38,
                    width: 38,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: borderColors,
                        )),
                    child: Center(
                        child: Text(
                      MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].students.isNotEmpty
                          ? MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].students.length
                              .toString()
                          : "0",
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    )),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubjectPage(
                            className: widget.name,
                            classKey: widget.classKey,
                            classIndex: widget.classIndex,
                            termIndex: widget.termIndex,
                          )));
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColors,
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 0.5, spreadRadius: 0.5)
                  ],
                  color: Colors.white),
              child: Row(
                children: [
                  const Text(
                    "Subjects",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 38,
                    width: 38,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: borderColors,
                        )),
                    child: Center(
                        child: Text(
                      MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects.isNotEmpty
                          ? MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects.length
                              .toString()
                          : "0",
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    )),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  for (int i = 0;
                      i <
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].students.length;
                      i++) {
                    for (int j = 0;
                        j <
                            MainStore.classes[widget.classIndex]
                                .terms[widget.termIndex].subjects.length;
                        j++) {
                      MainStore.classes[widget.classIndex]
                          .terms[widget.termIndex].students[i].subjects
                          .add(Subject(MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects[j]));
                    }
                  }

                  classBox.put(
                      widget.classKey, MainStore.classes[widget.classIndex]);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Assessments(
                                className: widget.name,
                                classKey: widget.classKey,
                                classIndex: widget.classIndex,
                                termIndex: widget.termIndex,
                              )));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: borderColors),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 0.5,
                          spreadRadius: 0.5)
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Assesments",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Results(
                                className: widget.name,
                                classKey: widget.classKey,
                                classIndex: widget.classIndex,
                                termIndex: widget.termIndex,
                              )));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: borderColors),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 0.5,
                          spreadRadius: 0.5)
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Results",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

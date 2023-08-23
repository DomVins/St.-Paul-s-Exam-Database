import 'package:exam_database/models/class_model.dart';
import 'package:exam_database/models/student_model.dart';
import 'package:exam_database/store/colors.dart';
import 'package:exam_database/store/store.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentsPage extends StatefulWidget {
  final String className;
  final int classKey;
  final int classIndex;
  final int termIndex;

  const StudentsPage(
      {Key key, this.className, this.classKey, this.classIndex, this.termIndex})
      : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  String variableN = "";
  String variableA = "";

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
                    widget.className + " Students",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 51, 48, 48),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      if (MainStore.classes[widget.classIndex].terms[0].students
                              .isNotEmpty &&
                          widget.termIndex != 0 &&
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].students.isEmpty) {
                        setState(() {
                          addToTerm(0);
                          classBox.put(widget.classKey,
                              MainStore.classes[widget.classIndex]);
                        });
                      } else if (MainStore.classes[widget.classIndex].terms[1]
                              .students.isNotEmpty &&
                          widget.termIndex != 1 &&
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].students.isEmpty) {
                        setState(() {
                          addToTerm(1);
                          classBox.put(widget.classKey,
                              MainStore.classes[widget.classIndex]);
                        });
                      } else if (MainStore.classes[widget.classIndex].terms[2]
                              .students.isNotEmpty &&
                          widget.termIndex != 2 &&
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].students.isEmpty) {
                        setState(() {
                          addToTerm(2);
                          classBox.put(widget.classKey,
                              MainStore.classes[widget.classIndex]);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Either students data is not found on any of the other terms or the current students list is not empty.'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, top: 20, bottom: 20),
                      child: const Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ),
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
          Expanded(
            child: MainStore.classes[widget.classIndex].terms[widget.termIndex]
                    .students.isEmpty
                ? const Center(
                    child: Text(
                      "You have not added any student's info yet.\nClick on the button below to add.",
                      style: TextStyle(fontSize: 15, height: 1.25),
                    ),
                  )
                : ListView(
                    children: _listWidgets(MainStore.classes[widget.classIndex]
                        .terms[widget.termIndex].students),
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Store.sex = "Male";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(43, 173, 172, 172),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: borderColors)),
                            child: TextFormField(
                              onChanged: ((value) {
                                variableN = value;
                              }),
                              cursorColor: Colors.black,
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Enter Student's Name"),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(43, 173, 172, 172),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: borderColors)),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: ((value) {
                                    variableA = value;
                                  }),
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: "Age"),
                                ),
                              ),
                              Expanded(child: Container()),
                              const Drop()
                            ],
                          ),
                        ]),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            MainStore.classes[widget.classIndex]
                                .terms[widget.termIndex].students
                                .add(Student(variableN, Store.sex, variableA));

                            classBox.put(widget.classKey,
                                MainStore.classes[widget.classIndex]);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'ADD',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                });
          },
          label: const Text("Add Student",
              style: TextStyle(
                color: Colors.white,
              )),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: appColor),
    );
  }

  addToTerm(int termIndex) {
    for (int i = 0;
        i <
            MainStore
                .classes[widget.classIndex].terms[termIndex].students.length;
        i++) {
      MainStore.classes[widget.classIndex].terms[widget.termIndex].students.add(
          Student(
              MainStore
                  .classes[widget.classIndex].terms[termIndex].students[i].name,
              MainStore.classes[widget.classIndex].terms[termIndex].students[i]
                  .gender,
              MainStore.classes[widget.classIndex].terms[termIndex].students[i]
                  .age));
    }
  }

  _listWidget(String item, String sex, String age, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        width: double.maxFinite,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: Colors.grey, blurRadius: 0.5, spreadRadius: 0.5)
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColors),
            color: Colors.white),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Sex: $sex",
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "|",
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Age: $age",
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(child: Container()),
            InkWell(
              onLongPress: () {
                setState(() {
                  MainStore.classes[widget.classIndex].terms[widget.termIndex]
                      .students
                      .removeAt(index);

                  classBox.put(
                      widget.classKey, MainStore.classes[widget.classIndex]);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    border: Border.all(color: borderColors),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _listWidgets(List<Student> students) {
    List<Widget> temp = [];

    for (int i = 0; i < students.length; i++) {
      temp.add(_listWidget(
          students[i].name, students[i].gender, students[i].age, i));
    }
    return temp;
  }
}

class Store {
  static String sex = "Male";
}

class Drop extends StatefulWidget {
  const Drop({Key key}) : super(key: key);

  @override
  State<Drop> createState() => _DropState();
}

class _DropState extends State<Drop> {
  String dropdownvalue = 'Male';
  var items = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        underline: Container(),
        value: dropdownvalue,
        icon: const Icon(Icons.arrow_drop_down_rounded),
        items: items.map((String items) {
          return DropdownMenuItem(
            child: Text(
              items,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            value: items,
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            dropdownvalue = newValue;
            Store.sex = newValue;
          });
        });
  }
}

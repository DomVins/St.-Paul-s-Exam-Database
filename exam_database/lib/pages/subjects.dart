import 'package:exam_database/models/class_model.dart';
import 'package:exam_database/store/colors.dart';
import 'package:exam_database/store/store.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SubjectPage extends StatefulWidget {
  final String className;
  final int classKey;
  final int classIndex;
  final int termIndex;

  const SubjectPage(
      {Key key, this.className, this.classKey, this.classIndex, this.termIndex})
      : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  String variable = "";

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
                    widget.className + " Subjects",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 51, 48, 48),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      if (MainStore.classes[widget.classIndex].terms[0].subjects
                              .isNotEmpty &&
                          widget.termIndex != 0 &&
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects.isEmpty) {
                        setState(() {
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects
                              .addAll(MainStore.classes[widget.classIndex]
                                  .terms[0].subjects);
                          classBox.put(widget.classKey,
                              MainStore.classes[widget.classIndex]);
                        });
                      } else if (MainStore.classes[widget.classIndex].terms[1]
                              .subjects.isNotEmpty &&
                          widget.termIndex != 1 &&
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects.isEmpty) {
                        setState(() {
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects
                              .addAll(MainStore.classes[widget.classIndex]
                                  .terms[1].subjects);
                          classBox.put(widget.classKey,
                              MainStore.classes[widget.classIndex]);
                        });
                      } else if (MainStore.classes[widget.classIndex].terms[2]
                              .subjects.isNotEmpty &&
                          widget.termIndex != 2 &&
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects.isEmpty) {
                        setState(() {
                          MainStore.classes[widget.classIndex]
                              .terms[widget.termIndex].subjects
                              .addAll(MainStore.classes[widget.classIndex]
                                  .terms[2].subjects);
                          classBox.put(widget.classKey,
                              MainStore.classes[widget.classIndex]);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Either subjects data is not found on any of the other terms or the current subjects list is not empty.'),
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
                    .subjects.isEmpty
                ? const Center(
                    child: Text(
                      "You have not added any subject yet.\nTap the button below to add a subject.",
                      style: TextStyle(fontSize: 15, height: 1.25),
                    ),
                  )
                : ListView(
                    children: _listWidgets(MainStore.classes[widget.classIndex]
                        .terms[widget.termIndex].subjects),
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: ListView(shrinkWrap: true, children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(43, 173, 172, 172),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColors)),
                        child: TextFormField(
                          onChanged: ((value) {
                            variable = value;
                          }),
                          cursorColor: Colors.black,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Enter Subject Name"),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                .terms[widget.termIndex].subjects
                                .add(variable);

                            classBox.put(widget.classKey,
                                MainStore.classes[widget.classIndex]);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'SAVE',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                });
          },
          label: const Text("Add Subject",
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

  _listWidget(String item, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(9),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.maxFinite,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: Colors.grey, blurRadius: 0.5, spreadRadius: 0.5)
            ],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColors),
            color: Colors.white),
        child: Row(
          children: [
            Text(
              item,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2),
            ),
            Expanded(child: Container()),
            InkWell(
              onLongPress: () {
                setState(() {
                  MainStore.classes[widget.classIndex].terms[widget.termIndex]
                      .subjects
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

  _listWidgets(List<String> items) {
    List<Widget> temp = [];

    for (int i = 0; i < items.length; i++) {
      temp.add(_listWidget(items[i], i));
    }
    return temp;
  }
}

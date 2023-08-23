import 'package:exam_database/models/class_model.dart';
import 'package:exam_database/models/term_model.dart';
import 'package:exam_database/store/colors.dart';
import 'package:exam_database/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'term.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String variable = "";
  String variableSess = "";
  List<int> keys;

  Box<Class> classBox;

  @override
  void initState() {
    super.initState();
    classBox = Hive.box<Class>("name");
    keys = classBox.keys.cast<int>().toList();
    for (int i = 0; i < keys.length; i++) {
      MainStore.classes.add(classBox.get(keys[i]));
    }
  }

  updateKeys() {
    keys.clear();
    keys = classBox.keys.cast<int>().toList();
  }

  @override
  void dispose() {
    super.dispose();
    classBox.close();
  }

  Future<bool> _onBack() async {
    bool goBack = true;
    SystemNavigator.pop();
    classBox.close();
    return goBack;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.maxFinite,
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'SPC Database', 
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 48, 48),
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                          ),
                          SizedBox(height: 1),
                          Text(
                            "St. Paul's College Ahule Results System . . .",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
                height: 1,
                width: double.maxFinite,
                color: Colors.blue,
              ),
              Expanded(
                  child: MainStore.classes.isEmpty
                      ? const Center(
                          child: Text(
                            "You have not added any class yet.\nTap the button below to add a class.",
                            style: TextStyle(fontSize: 15, height: 1.25),
                          ),
                        )
                      : ListView(
                          children: _listWidgets(),
                        ))
            ],
          ),
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
                                hintText: "Enter Class Name"),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(43, 173, 172, 172),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: borderColors)),
                              child: TextFormField(
                                onChanged: ((value) {
                                  variableSess = value;
                                }),
                                cursorColor: Colors.black,
                                decoration: const InputDecoration.collapsed(
                                    hintText: "Session"),
                              ),
                            ),
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
                              Class newClass = Class(variable, variableSess);
                              MainStore.classes.add(newClass);
                              classBox.add(newClass);
                              updateKeys();
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
            label: const Text("Add Class",
                style: TextStyle(
                  color: Colors.white,
                )),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: appColor),
      ),
    );
  }

  _listWidget(String item, String session, int index) {
    for (int i = 0; i < 3; i++) {
      switch (i) {
        case 0:
          MainStore.classes[index].terms.add(TermClass("First Term"));
          break;
        case 1:
          MainStore.classes[index].terms.add(TermClass("Second Term"));
          break;
        case 2:
          MainStore.classes[index].terms.add(TermClass("Third Term"));
          break;
      }
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Term(
                      className: item,
                      classKey: keys[index],
                      index: index,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.maxFinite,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: Colors.grey, blurRadius: 0.5, spreadRadius: 0.0)
            ],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColors),
            color: Colors.white),
        child: Row(
          children: [
            Text(
              item + " ($session)",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(child: Container()),
            InkWell(
              onLongPress: () {
                setState(() {
                  MainStore.classes.removeAt(index);
                  classBox.delete(keys[index]);
                  updateKeys();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(5),
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

  _listWidgets() {
    List<Widget> temp = [];

    for (int i = 0; i < MainStore.classes.length; i++) {
      temp.add(_listWidget(
          MainStore.classes[i].className, MainStore.classes[i].session, i));
    }
    return temp;
  }
}

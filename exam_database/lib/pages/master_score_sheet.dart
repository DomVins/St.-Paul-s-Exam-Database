import 'package:exam_database/models/student_model.dart';
import 'package:exam_database/store/store.dart';
import 'package:flutter/material.dart';

class Master extends StatefulWidget {
  final int index;
  final int termIndex;
  const Master({Key key, this.index, this.termIndex}) : super(key: key);

  @override
  State<Master> createState() => _MasterState();
}

class _MasterState extends State<Master> {
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
                    const Text(
                      "Master Score Sheet",
                      style: TextStyle(
                          color: Color.fromARGB(255, 51, 48, 48),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                    Expanded(child: Container()),
                    const Icon(
                      Icons.more_vert_rounded,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SpecialTable(index: widget.index, termIndex: widget.termIndex),
          ],
        ));
  }
}

class SpecialTable extends StatefulWidget {
  final int index;
  final int termIndex;
  SpecialTable(
      {Key key,
      this.index,
      this.termIndex,
      this.initialScrollOffsetX = 0.0,
      this.initialScrollOffsetY = 0.0,
      this.onEndScrolling,
      ScrollControllers scrollControllers})
      : scrollControllers = scrollControllers ?? ScrollControllers(),
        super(key: key);

  final ScrollControllers scrollControllers;
  final Function(double x, double y) onEndScrolling;
  final double initialScrollOffsetX;
  final double initialScrollOffsetY;

  @override
  State<SpecialTable> createState() => _SpecialTableState();
}

class _SpecialTableState extends State<SpecialTable> {
  _SyncScrollController _horizontalSyncController;
  _SyncScrollController _verticalSyncController;

  double _scrollOffsetX;
  double _scrollOffsetY;

  @override
  Widget build(BuildContext context) {
    _scrollOffsetX = widget.initialScrollOffsetX;
    _scrollOffsetY = widget.initialScrollOffsetY;
    _verticalSyncController = _SyncScrollController([
      widget.scrollControllers._verticalTitleController,
      widget.scrollControllers._verticalBodyController,
    ]);
    _horizontalSyncController = _SyncScrollController([
      widget.scrollControllers._horizontalTitleController,
      widget.scrollControllers._horizontalBodyController,
    ]);

    return Expanded(
      child: Column(
        children: [
          // Horiontal header . . .
          Row(
            children: [
              // Legend . . .
              _nt(),
              // Sticky Row . . .
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: _subjectsList(MainStore.classes[widget.index]
                          .terms[widget.termIndex].subjects)),
                  controller:
                      widget.scrollControllers._horizontalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                      _horizontalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._horizontalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetX = widget
                        .scrollControllers._horizontalTitleController.offset;
                    widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              )),
            ],
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sticky Column . . .
              NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  child: Column(
                      children: _namesList(MainStore.classes[widget.index]
                          .terms[widget.termIndex].students)),
                  controller: widget.scrollControllers._verticalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                      _verticalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._verticalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetY = widget
                        .scrollControllers._verticalTitleController.offset;
                    widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ),

              // Contents . . .
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller:
                      widget.scrollControllers._horizontalBodyController,
                  child: NotificationListener<ScrollNotification>(
                    child: SingleChildScrollView(
                        controller:
                            widget.scrollControllers._verticalBodyController,
                        child: _studentsScoresColumn()),
                    onNotification: (ScrollNotification notification) {
                      final didEndScrolling =
                          _verticalSyncController.processNotification(
                        notification,
                        widget.scrollControllers._verticalBodyController,
                      );
                      if (widget.onEndScrolling != null && didEndScrolling) {
                        _scrollOffsetX = widget
                            .scrollControllers._verticalBodyController.offset;
                        widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                      }
                      return true;
                    },
                  ),
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                      _horizontalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._horizontalBodyController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetX = widget
                        .scrollControllers._horizontalBodyController.offset;
                    widget.onEndScrolling(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ))
            ],
          ))
        ],
      ),
    );
  }

  _nt() {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        height: 50,
        child: const Center(
            child: Text('Names',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ))),
      ),
    );
  }

  _names(String name) {
    return SizedBox(
      height: 25,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        padding: const EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        height: 25,
        child: Text(name),
      ),
    );
  }

  _scoreHeaders(String subject, int index) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: 60,
      width: 510,
      child: Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            SizedBox(
              height: 25,
              child: Center(
                  child: Text(subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
            )
          ]),
          TableRow(children: [
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 35,
                    child: const Center(
                        child: Text(
                      "1st ASS TEST(10)",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  )),
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: const Center(
                        child: Text(
                      "2nd ASS TEST(10)",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  )),
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: const Center(
                        child: Text(
                      "3rd ASS TEST(10)",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  )),
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: const Center(
                        child: Text(
                      "TERM EXAM(70)",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  )),
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: const Center(
                        child: Text(
                      "TOTAL SCORE",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  )),
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: const Center(
                        child: Text(
                      "AVERAGE",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  )),
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: const Center(
                        child: Text(
                      "POSITION",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  )),
                  TableCell(
                      child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: const Center(
                        child: Text(
                      "GRADE",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )),
                  ))
                ])
              ],
            )
          ])
        ],
      ),
    );
  }

  _subjectScores(int stdIndex, int subIndex) {
    return SizedBox(
      height: 25,
      width: 510,
      child: Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            _textField(1, stdIndex, subIndex),
            _textField(2, stdIndex, subIndex),
            _textField(3, stdIndex, subIndex),
            _textField(4, stdIndex, subIndex),
            _textField(5, stdIndex, subIndex),
            _textField(6, stdIndex, subIndex),
            _textField(7, stdIndex, subIndex),
            _textField(8, stdIndex, subIndex),
          ])
        ],
      ),
    );
  }

  _textField(int id, int stdIndex, int subIndex) {
    return TableCell(
        child: Container(
      padding: const EdgeInsets.all(4),
      height: 25,
      child: Center(child: Text(_textFormValue(id, stdIndex, subIndex))),
    ));
  }

  String _textFormValue(int id, int stdIndex, int subIndex) {
    String cont;
    switch (id) {
      case 1:
        MainStore.classes[widget.index].terms[widget.termIndex]
                    .students[stdIndex].subjects[subIndex].ass[0] ==
                -1
            ? cont = ""
            : cont = MainStore.classes[widget.index].terms[widget.termIndex]
                .students[stdIndex].subjects[subIndex].ass[0]
                .toString();
        break;
      case 2:
        MainStore.classes[widget.index].terms[widget.termIndex]
                    .students[stdIndex].subjects[subIndex].ass[1] ==
                -1
            ? cont = ""
            : cont = MainStore.classes[widget.index].terms[widget.termIndex]
                .students[stdIndex].subjects[subIndex].ass[1]
                .toString();

        break;
      case 3:
        MainStore.classes[widget.index].terms[widget.termIndex]
                    .students[stdIndex].subjects[subIndex].ass[2] ==
                -1
            ? cont = ""
            : cont = MainStore.classes[widget.index].terms[widget.termIndex]
                .students[stdIndex].subjects[subIndex].ass[2]
                .toString();

        break;
      case 4:
        MainStore.classes[widget.index].terms[widget.termIndex]
                    .students[stdIndex].subjects[subIndex].ass[3] ==
                -1
            ? cont = ""
            : cont = MainStore.classes[widget.index].terms[widget.termIndex]
                .students[stdIndex].subjects[subIndex].ass[3]
                .toString();

        break;
      case 5:
        cont = MainStore.classes[widget.index].terms[widget.termIndex]
            .students[stdIndex].subjects[subIndex].total
            .toString();
        break;
      case 6:
        cont = MainStore.classes[widget.index].terms[widget.termIndex]
            .students[stdIndex].subjects[subIndex].average
            .toStringAsFixed(2);

        break;
      case 7:
        cont = MainStore.classes[widget.index].terms[widget.termIndex]
            .students[stdIndex].subjects[subIndex].pos
            .toString();

        break;
      case 8:
        cont = MainStore.classes[widget.index].terms[widget.termIndex]
            .students[stdIndex].subjects[subIndex].grade
            .toString();

        break;
      default:
        cont = "";
        break;
    }

    return cont;
  }

// One Student . . .
  _studentScoresRow(int stdIndex) {
    return Row(
      children: _scoreRowList(stdIndex),
    );
  }

// Row widget list . . .
  _scoreRowList(int stdIndex) {
    List<Widget> temp = [];

    for (int i = 0;
        i <
            MainStore
                .classes[widget.index].terms[widget.termIndex].subjects.length;
        i++) {
      temp.add(_subjectScores(stdIndex, i));
    }
    return temp;
  }

// All Students . . .
  _studentsScoresColumn() {
    return Column(
      children: _scoreColumnList(),
    );
  }

// Column widget list . . .
  _scoreColumnList() {
    List<Widget> temp = [];

    for (int i = 0;
        i <
            MainStore
                .classes[widget.index].terms[widget.termIndex].students.length;
        i++) {
      temp.add(_studentScoresRow(i));
    }
    return temp;
  }

  _namesList(List<Student> students) {
    List<Widget> temp = [];

    for (int i = 0; i < students.length; i++) {
      temp.add(_names(MainStore
          .classes[widget.index].terms[widget.termIndex].students[i].name));
    }
    return temp;
  }

// Score headers widget list . . .
  _subjectsList(List<String> subects) {
    List<Widget> temp = [];

    for (int i = 0; i < subects.length; i++) {
      temp.add(_scoreHeaders(
          MainStore.classes[widget.index].terms[widget.termIndex].subjects[i],
          i));
    }
    return temp;
  }
}

class ScrollControllers {
  final ScrollController _verticalTitleController;
  final ScrollController _verticalBodyController;

  final ScrollController _horizontalBodyController;
  final ScrollController _horizontalTitleController;

  ScrollControllers({
    ScrollController verticalTitleController,
    ScrollController verticalBodyController,
    ScrollController horizontalBodyController,
    ScrollController horizontalTitleController,
  })  : _verticalTitleController =
            verticalTitleController ?? ScrollController(),
        _verticalBodyController = verticalBodyController ?? ScrollController(),
        _horizontalBodyController =
            horizontalBodyController ?? ScrollController(),
        _horizontalTitleController =
            horizontalTitleController ?? ScrollController();
}

// SyncScrollController keeps scroll controllers in sync.
class _SyncScrollController {
  _SyncScrollController(List<ScrollController> controllers) {
    for (var controller in controllers) {
      _registeredScrollControllers.add(controller);
    }
  }

  final List<ScrollController> _registeredScrollControllers = [];

  ScrollController _scrollingController;
  bool _scrollingActive = false;

  /// Returns true if reached scroll end
  bool processNotification(
    ScrollNotification notification,
    ScrollController controller,
  ) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = controller;
      _scrollingActive = true;
      return false;
    }

    if (identical(controller, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return true;
      }

      if (notification is ScrollUpdateNotification) {
        for (ScrollController controller in _registeredScrollControllers) {
          if (identical(_scrollingController, controller)) continue;
          controller.jumpTo(_scrollingController.offset);
        }
      }
    }
    return false;
  }
}

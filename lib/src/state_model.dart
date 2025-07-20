import 'package:flutter/material.dart';

// STATION 1:
class StateModel extends ChangeNotifier {
  bool station1TaskCompleted = false;
  bool station1Checked = false;
  String station1ImageFileName = "original.png";

  void reset() {
    // station 1:
    station1TaskCompleted = false;
    station1Checked = false;
    station1ImageFileName = "original.png";
    optionASelections = [false, false];
    optionBSelections = [false, false];
    optionCSelections = [false, false];

    // station 2:
    station2TaskCompleted = false;
    station2Checked = false;
    numberOfWindmills = 0;

    // station 3:
    station3TaskCompleted = false;
    station3CanBeMarkedDone = false;
    station3Checked = false;
    numberOfErrors = 5;
    items = [
      // Title, Color, Icon path, Correct rank
      [
        'Bananen (Südfrüchte)',
        const Color.fromARGB(255, 240, 233, 39),
        'banana.png',
        2,
      ],
      [
        'Blumen',
        const Color.fromARGB(255, 195, 65, 166),
        'flowers.png',
        4,
      ],
      [
        'Kaffee',
        const Color.fromARGB(255, 123, 74, 31),
        'coffee.png',
        0,
      ],
      [
        'Kakao',
        const Color.fromARGB(255, 160, 125, 93),
        'cocoa.png',
        1,
      ],
      [
        'Textilien',
        const Color.fromARGB(255, 170, 184, 201),
        'textiles.png',
        3,
      ],
    ];

    notifyListeners();
  }

  int numberOfTasksToDo() {
    int n = 3;
    if (station1Checked) n--;
    if (station2Checked) n--;
    if (station3Checked) n--;
    return n;
  }

  // Sation 1 stuff:

  void station1SetTaskCompleted() {
    station1TaskCompleted = true;
    notifyListeners();
  }

  void station1SetChecked(bool value, String imageFileName) {
    station1Checked = value;
    notifyListeners();
  }

  List<bool> optionASelections = [false, false];
  setOption1Selection(int index) {
    optionASelections = [false, false];
    optionASelections[index] = true;
    notifyListeners();
  }

  // Sation 2 stuff:

  List<bool> optionBSelections = [false, false];
  setOption2Selection(int index) {
    optionBSelections = [false, false];
    optionBSelections[index] = true;
    notifyListeners();
  }

  List<bool> optionCSelections = [false, false];
  setOption3Selection(int index) {
    optionCSelections = [false, false];
    optionCSelections[index] = true;
    notifyListeners();
  }

  // STATION 2:

  bool station2TaskCompleted = false;
  bool station2Checked = false;
  int numberOfWindmills = 0;

  void station2SetTaskCompleted() {
    station2TaskCompleted = true;
    notifyListeners();
  }

  void station2SetChecked(bool value) {
    station2Checked = value;
    notifyListeners();
  }

  bool canCheckInTask() {
    return optionASelections.contains(true) &&
        optionBSelections.contains(true) &&
        optionCSelections.contains(true);
  }

  String makeImageNameFromOptions() {
    return (optionASelections[0] ? "1A" : "1B") +
        (optionBSelections[0] ? "2A" : "2B") +
        (optionCSelections[0] ? "3A" : "3B");
  }

  void station2SetNumberOfWindmillsBuilt(int newNumber) {
    numberOfWindmills = newNumber;
    notifyListeners();
  }

  String station2GetNumberOfWindmillsText() {
    if (numberOfWindmills == 0) {
      return " noch keine Windräder gebaut.";
    } else if (numberOfWindmills == 1) {
      return " ein Windrad gebaut.";
    } else {
      return " $numberOfWindmills Windräder gebaut";
    }
  }

  // STATION 3:

  bool station3TaskCompleted = false;
  bool station3CanBeMarkedDone = false;
  bool station3Checked = false;

  List<List> items = [
    // Title, Color, Icon path, Correct rank
    [
      'Bananen (Südfrüchte)',
      const Color.fromARGB(255, 240, 233, 39),
      'banana.png',
      2,
    ],
    [
      'Blumen',
      const Color.fromARGB(255, 195, 65, 166),
      'flowers.png',
      4,
    ],
    [
      'Kaffee',
      const Color.fromARGB(255, 123, 74, 31),
      'coffee.png',
      0,
    ],
    [
      'Kakao',
      const Color.fromARGB(255, 160, 125, 93),
      'cocoa.png',
      1,
    ],
    [
      'Textilien',
      const Color.fromARGB(255, 170, 184, 201),
      'textiles.png',
      3,
    ],
  ];

  int numberOfErrors = 5;

  void reorderItems(int first, int second) {
    if (first < second) {
      second -= 1;
    }
    final List item = items.removeAt(first);
    items.insert(second, item);

    numberOfErrors = 0;
    for (var it in items) {
      if (items.indexOf(it) != it[3]) {
        numberOfErrors = numberOfErrors + 1;
      }
    }
    notifyListeners();
  }

  void station3SetTaskCompleted() {
    station3TaskCompleted = true;
    notifyListeners();
  }

  void station3SetCanBeMarkedAsDone(bool value) {
    station3CanBeMarkedDone = value;
    notifyListeners();
  }

  void station3SetChecked(bool value) {
    station3Checked = value;
    notifyListeners();
  }

  // FINAL SITUATION:
  bool s1InteractionFinished = false;
  bool s2InteractionFinished = false;
  bool s3InteractionFinished = false;

  void station1SetInteractionFinished() {
    s1InteractionFinished = true;
  }

  void station2SetInteractionFinished() {
    s2InteractionFinished = true;
  }

  void station3SetInteractionFinished() {
    s3InteractionFinished = true;
  }

  bool allStationsFinishedInteractions() {
    return (s1InteractionFinished &&
        s2InteractionFinished &&
        s3InteractionFinished);
  }

  void showFinalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Super, ihr habt alle Stationen geschafft!"),
        content: const Text(
          'Und jetzt bitte schnell zurück zum Start und die Welt retten!',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('Angekommen'),
          ),
        ],
      ),
    );
  }
}

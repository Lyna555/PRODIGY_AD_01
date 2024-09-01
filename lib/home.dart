import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> itemTexts = [
    'AC',
    '(',
    ')',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'DEL',
    '=',
  ];

  final List<Color> backgroundColors = [
    Colors.indigoAccent,
    Colors.blueGrey,
    Colors.blueGrey,
    Colors.blueGrey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.blueGrey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.blueGrey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.blueGrey,
    Colors.grey,
    Colors.grey,
    Colors.redAccent,
    Colors.teal,
  ];

  final TextEditingController _textController = TextEditingController();

  RegExp delimiterPatternSum = RegExp(r'[+\-]+');
  RegExp delimiterPatternProd = RegExp(r'[x÷]+');

  late Iterable<RegExpMatch> matches;

  var numbers = [];
  var subNumbers = [];
  var delimiters = [];
  var subDelimiters = [];

  double result = 0;
  double subResult = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: TextField(
                  showCursor: true,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                  controller: _textController,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
            // Grid View
            Expanded(
              flex: 8,
              child: GridView.builder(
                itemCount: itemTexts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if ((itemTexts[index] == "+" ||
                                itemTexts[index] == "-" ||
                                itemTexts[index] == "x" ||
                                itemTexts[index] == "÷" ||
                                itemTexts[index] == ".") &&
                            _textController.text.isEmpty) {
                        } else if (itemTexts[index] == "DEL") {
                          _textController.text = _textController.text
                              .replaceRange(_textController.text.length - 1,
                                  _textController.text.length, "");
                        } else if (itemTexts[index] == "AC") {
                          _textController.text = "";
                        } else if (itemTexts[index] == "+" ||
                            itemTexts[index] == "-" ||
                            itemTexts[index] == "÷" ||
                            itemTexts[index] == "x" ||
                            itemTexts[index] == ".") {
                          if (_textController.text.endsWith("+") ||
                              _textController.text.endsWith("-") ||
                              _textController.text.endsWith("x") ||
                              _textController.text.endsWith("÷") ||
                              _textController.text.endsWith(".")) {
                          } else {
                            _textController.text =
                                _textController.text + itemTexts[index];
                          }
                        } else if (itemTexts[index] == "=") {
                          if (_textController.text.endsWith("+") ||
                              _textController.text.endsWith("-") ||
                              _textController.text.endsWith("x") ||
                              _textController.text.endsWith("÷") ||
                              _textController.text.endsWith("(")) {
                          } else {
                            if (!_textController.text.contains("+") &&
                                !_textController.text.contains("-")) {
                              numbers = _textController.text
                                  .split(delimiterPatternProd);
                              matches = delimiterPatternProd
                                  .allMatches(_textController.text);
                            } else {
                              numbers = _textController.text
                                  .split(delimiterPatternSum);
                              matches = delimiterPatternSum
                                  .allMatches(_textController.text);
                            }

                            delimiters = matches
                                .map((match) => match.group(0)!)
                                .toList();

                            if (numbers[0].toString().contains("x") ||
                                numbers[0].toString().contains("÷")) {
                              subNumbers =
                                  numbers[0].split(delimiterPatternProd);
                              matches = delimiterPatternProd
                                  .allMatches(_textController.text);
                              subDelimiters = matches
                                  .map((match) => match.group(0)!)
                                  .toList();

                              subResult = double.parse(subNumbers[0]);

                              for (int j = 0; j < subDelimiters.length; j++) {
                                if (subDelimiters[j] == "x") {
                                  subResult = subResult *
                                      double.parse(subNumbers[j + 1]);
                                  print(subResult);
                                } else {
                                  subResult = subResult /
                                      double.parse(subNumbers[j + 1]);
                                }
                              }
                              result = subResult;
                            } else {
                              result = double.parse(numbers[0]);
                            }

                            for (int i = 0; i < delimiters.length; i++) {
                              if (delimiters[i] == "+" ||
                                  delimiters[i] == "-") {
                                if (numbers[i + 1].toString().contains("x") ||
                                    numbers[i + 1].toString().contains("÷")) {
                                  subNumbers = numbers[i + 1]
                                      .split(delimiterPatternProd);
                                  matches = delimiterPatternProd
                                      .allMatches(_textController.text);
                                  subDelimiters = matches
                                      .map((match) => match.group(0)!)
                                      .toList();

                                  subResult = double.parse(subNumbers[0]);

                                  for (int j = 0;
                                      j < subDelimiters.length;
                                      j++) {
                                    if (subDelimiters[j] == "x") {
                                      subResult = subResult *
                                          double.parse(subNumbers[j + 1]);
                                      print(subResult);
                                    } else {
                                      subResult = subResult /
                                          double.parse(subNumbers[j + 1]);
                                    }
                                  }
                                  if (delimiters[i] == "+") {
                                    result = result + subResult;
                                  } else {
                                    result = result - subResult;
                                  }
                                } else {
                                  if (delimiters[i] == "+") {
                                    result =
                                        result + double.parse(numbers[i + 1]);
                                  } else {
                                    result =
                                        result - double.parse(numbers[i + 1]);
                                  }
                                }
                              } else if (delimiters[i] == "x") {
                                result = result * double.parse(numbers[i + 1]);
                              } else if (delimiters[i] == "÷") {
                                result = result / double.parse(numbers[i + 1]);
                              }
                            }

                            _textController.text = result.toString();
                          }
                        } else {
                          _textController.text =
                              _textController.text + itemTexts[index];
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: backgroundColors[index],
                      onPrimary: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    child: Text(
                      itemTexts[index],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

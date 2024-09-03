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
  final ScrollController _scrollController = ScrollController();

  RegExp delimiterPatternSum = RegExp(r'[+\-]+');
  RegExp delimiterPatternProd = RegExp(r'[x÷]+');

  late Iterable<RegExpMatch> matches;

  late List<String> numbers;
  late List<String> subNumbers;
  late List<String> delimiters;
  late List<String> subDelimiters;

  late double result;
  late double subResult;

  late String operation;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

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
                  scrollController: _scrollController,
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
                        _pressedButton(index);
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

  void _pressedButton(int index) {
    if ((itemTexts[index] == "+" ||
            itemTexts[index] == "-" ||
            itemTexts[index] == "x" ||
            itemTexts[index] == "÷" ||
            itemTexts[index] == ".") &&
        _textController.text.isEmpty) {
    } else if (itemTexts[index] == "DEL") {
      _handleDelete();
    } else if (itemTexts[index] == "AC") {
      _textController.text = "";
    } else if (itemTexts[index] == "+" ||
        itemTexts[index] == "-" ||
        itemTexts[index] == "÷" ||
        itemTexts[index] == "x" ||
        itemTexts[index] == ".") {
      _handleRepeatedCharacter(index);
    } else if (itemTexts[index] == "=") {
      _handleEquals(index);
    } else {
      _textController.text = _textController.text + itemTexts[index];
    }
  }

  void _handleDelete() {
    final cursorPosition = _textController.selection.baseOffset;

    if (cursorPosition == -1) {
      _textController.text = _textController.text.replaceRange(
          _textController.text.length - 1, _textController.text.length, "");
    } else {
      _textController.text =
          _textController.text.substring(0, cursorPosition - 1) +
              _textController.text.substring(cursorPosition);

      _textController.selection =
          TextSelection.fromPosition(TextPosition(offset: cursorPosition - 1));
    }
  }

  void _handleRepeatedCharacter(int index) {
    if (_textController.text.endsWith("+") ||
        _textController.text.endsWith("-") ||
        _textController.text.endsWith("x") ||
        _textController.text.endsWith("÷") ||
        _textController.text.endsWith(".")) {
    } else {
      _textController.text = _textController.text + itemTexts[index];
    }
  }

  String _handleExpression(String expression) {
    if (expression.endsWith("+") ||
        expression.endsWith("-") ||
        expression.endsWith("x") ||
        expression.endsWith("÷") ||
        expression.endsWith("(")) {
    } else {
      if (!expression.contains("+") && !expression.contains("-")) {
        numbers = expression.split(delimiterPatternProd);
        matches = delimiterPatternProd.allMatches(expression);
      } else {
        numbers = expression.split(delimiterPatternSum);
        matches = delimiterPatternSum.allMatches(expression);
      }

      delimiters = matches.map((match) => match.group(0)!).toList();

      if (numbers[0].toString().contains("x") ||
          numbers[0].toString().contains("÷")) {
        subNumbers = numbers[0].split(delimiterPatternProd);
        matches = delimiterPatternProd.allMatches(expression);
        subDelimiters = matches.map((match) => match.group(0)!).toList();

        subResult = double.parse(subNumbers[0]);

        for (int j = 0; j < subDelimiters.length; j++) {
          if (subDelimiters[j] == "x") {
            subResult = subResult * double.parse(subNumbers[j + 1]);
          } else {
            subResult = subResult / double.parse(subNumbers[j + 1]);
          }
        }
        result = subResult;
      } else {
        result = double.parse(numbers[0]);
      }

      for (int i = 0; i < delimiters.length; i++) {
        if (delimiters[i] == "+" || delimiters[i] == "-") {
          if (numbers[i + 1].toString().contains("x") ||
              numbers[i + 1].toString().contains("÷")) {
            subNumbers = numbers[i + 1].split(delimiterPatternProd);
            matches = delimiterPatternProd.allMatches(expression);
            subDelimiters = matches.map((match) => match.group(0)!).toList();

            subResult = double.parse(subNumbers[0]);

            for (int j = 0; j < subDelimiters.length; j++) {
              if (subDelimiters[j] == "x") {
                subResult = subResult * double.parse(subNumbers[j + 1]);
              } else {
                subResult = subResult / double.parse(subNumbers[j + 1]);
              }
            }
            if (delimiters[i] == "+") {
              result = result + subResult;
            } else {
              result = result - subResult;
            }
          } else {
            if (delimiters[i] == "+") {
              result = result + double.parse(numbers[i + 1]);
            } else {
              result = result - double.parse(numbers[i + 1]);
            }
          }
        } else if (delimiters[i] == "x") {
          result = result * double.parse(numbers[i + 1]);
        } else if (delimiters[i] == "÷") {
          result = result / double.parse(numbers[i + 1]);
        }
      }
    }
    return result.toString();
  }

  void _handleEquals(int index) {
    if (_textController.text.contains("(") ||
        _textController.text.contains(")")) {
      if ((RegExp(r'\(').allMatches(_textController.text).length) ==
          (RegExp(r'\)').allMatches(_textController.text).length)) {
        operation = _textController.text;
        while (operation.contains("(") || operation.contains(")")) {
          operation =
              _textController.text.substring(0, operation.lastIndexOf("(")) +
                  _handleExpression(operation.substring(
                      operation.lastIndexOf("(") + 1, operation.indexOf(")"))) +
                  operation.substring(operation.indexOf(")") + 1);
        }
        _textController.text = _handleExpression(operation);
      }
    }
    _textController.text = _handleExpression(_textController.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

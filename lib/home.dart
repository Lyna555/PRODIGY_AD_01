import 'dart:math';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> itemTexts = [
    '√',
    '^',
    'cos',
    'sin',
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
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
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
  RegExp delimiterPatternProd = RegExp(r'[x÷^]+');

  late Iterable<RegExpMatch> matches;

  late List<String> numbers;
  late List<String> subNumbers;
  late List<String> delimiters;
  late List<String> subDelimiters;

  late double result = 0;
  late double subResult = 0;
  String _selectedItem = "Deg";

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // Aligns the whole button to the right
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedItem,
                    items: <String>['Deg', 'Rad', 'Grad'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedItem = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextField(
                  showCursor: true,
                  readOnly: true,
                  autofocus: true,
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
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
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
                      textStyle: const TextStyle(fontSize: 30),
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
    final cursorPosition = _textController.selection.baseOffset;

    if ((itemTexts[index] == "+" ||
            itemTexts[index] == "-" ||
            itemTexts[index] == "x" ||
            itemTexts[index] == "÷" ||
            itemTexts[index] == "." ||
            itemTexts[index] == "^") &&
        _textController.text.isEmpty) {
    } else if (itemTexts[index] == "DEL") {
      _handleDelete();
    } else if (itemTexts[index] == "AC") {
      _textController.text = "";

      _textController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 0),
      );
    } else if (itemTexts[index] == "cos") {
      _textController.text = _textController.text.substring(0, cursorPosition) +
          "cos(" +
          _textController.text.substring(cursorPosition);

      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + itemTexts[index].length + 1),
      );
    } else if (itemTexts[index] == "sin") {
      _textController.text = _textController.text.substring(0, cursorPosition) +
          "sin(" +
          _textController.text.substring(cursorPosition);

      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + itemTexts[index].length + 1),
      );
    } else if (itemTexts[index] == "+" ||
        itemTexts[index] == "-" ||
        itemTexts[index] == "÷" ||
        itemTexts[index] == "x" ||
        itemTexts[index] == "." ||
        itemTexts[index] == "^") {
      _handleRepeatedCharacter(index);
    } else if (itemTexts[index] == "=") {
      _handleEquals(index);
    } else {
      _textController.text = _textController.text.substring(0, cursorPosition) +
          itemTexts[index] +
          _textController.text.substring(cursorPosition);

      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + itemTexts[index].length),
      );
    }
  }

  void _handleDelete() {
    final cursorPosition = _textController.selection.baseOffset;

    if (cursorPosition == -1) {
      if (_textController.text.endsWith("cos(") ||
          _textController.text.endsWith("sin(")) {
        _textController.text = _textController.text.replaceRange(
            _textController.text.length - 4, _textController.text.length, "");
      } else {
        _textController.text = _textController.text.replaceRange(
            _textController.text.length - 1, _textController.text.length, "");
      }
    } else {
      if (_textController.text.substring(0, cursorPosition).endsWith("cos(") ||
          _textController.text.substring(0, cursorPosition).endsWith("sin(")) {
        _textController.text =
            _textController.text.substring(0, cursorPosition - 4) +
                _textController.text.substring(cursorPosition);

        _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPosition - 4));
      } else {
        _textController.text =
            _textController.text.substring(0, cursorPosition - 1) +
                _textController.text.substring(cursorPosition);

        _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPosition - 1));
      }
    }
  }

  void _handleRepeatedCharacter(int index) {
    final cursorPosition = _textController.selection.baseOffset;

    if (_textController.text.endsWith("+") ||
        _textController.text.endsWith("-") ||
        _textController.text.endsWith("x") ||
        _textController.text.endsWith("÷") ||
        _textController.text.endsWith(".") ||
        _textController.text.endsWith("^")) {
    } else {
      _textController.text = _textController.text.substring(0, cursorPosition) +
          itemTexts[index] +
          _textController.text.substring(cursorPosition);

      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + itemTexts[index].length),
      );
    }
  }

  String _handleExpression(String expression) {
    if (expression.endsWith("+") ||
        expression.endsWith("-") ||
        expression.endsWith("x") ||
        expression.endsWith("÷") ||
        expression.endsWith("(") ||
        expression.endsWith("^")) {
    } else {
      if (!expression.contains("+") && !expression.contains("-")) {
        numbers = expression.split(delimiterPatternProd);
        matches = delimiterPatternProd.allMatches(expression);
      } else {
        numbers = expression.split(delimiterPatternSum);
        matches = delimiterPatternSum.allMatches(expression);
      }

      delimiters = matches.map((match) => match.group(0)!).toList();

      if (numbers[0].startsWith("√") && !numbers[0].contains("(")) {
        numbers[0] = _handleSquareRoot(result, numbers[0]);
      } else if (numbers[0].startsWith("cos")) {
        numbers[0] = _handleCos(result, numbers[0]);
      } else if (numbers[0].startsWith("sin")) {
        numbers[0] = _handleSin(result, numbers[0]);
      }

      if (numbers[0].toString().contains("x") ||
          numbers[0].toString().contains("÷") ||
          numbers[0].toString().contains("^")) {
        subNumbers = numbers[0].split(delimiterPatternProd);
        matches = delimiterPatternProd.allMatches(expression);
        subDelimiters = matches.map((match) => match.group(0)!).toList();

        if (subNumbers[0].contains("√")) {
          subNumbers[0] = _handleSquareRoot(subResult, subNumbers[0]);
        }

        if (subNumbers[0].contains("cos")) {
          subNumbers[0] = _handleCos(subResult, subNumbers[0]);
        }

        if (subNumbers[0].contains("sin")) {
          subNumbers[0] = _handleSin(subResult, subNumbers[0]);
        }

        subResult = double.parse(subNumbers[0]);

        for (int j = 0; j < subDelimiters.length; j++) {
          if (subDelimiters[j] == "x") {
            subResult *= double.parse(subNumbers[j + 1]);
          } else if (subDelimiters[j] == "^") {
            subResult =
                pow(subResult, double.parse(subNumbers[j + 1])) as double;
          } else {
            subResult /= double.parse(subNumbers[j + 1]);
          }
        }
        result = subResult;
      } else {
        result = double.parse(numbers[0]);
      }

      for (int i = 0; i < delimiters.length; i++) {
        if (numbers[i + 1].startsWith("√") && !numbers[i + 1].contains("(")) {
          numbers[i + 1] = _handleSquareRoot(result, numbers[i + 1]);
        }

        if (numbers[i + 1].startsWith("cos") && !numbers[i + 1].contains("(")) {
          numbers[i + 1] = _handleCos(result, numbers[i + 1]);
        }

        if (numbers[i + 1].startsWith("sin") && !numbers[i + 1].contains("(")) {
          numbers[i + 1] = _handleSin(result, numbers[i + 1]);
        }

        if (delimiters[i] == "+" || delimiters[i] == "-") {
          if (numbers[i + 1].toString().contains("x") ||
              numbers[i + 1].toString().contains("÷") ||
              numbers[i + 1].toString().contains("^")) {
            subNumbers = numbers[i + 1].split(delimiterPatternProd);
            matches = delimiterPatternProd.allMatches(expression);
            subDelimiters = matches.map((match) => match.group(0)!).toList();

            if (subNumbers[0].contains("√")) {
              subNumbers[0] = _handleSquareRoot(subResult, subNumbers[0]);
            }

            if (subNumbers[0].contains("cos")) {
              subNumbers[0] = _handleCos(subResult, subNumbers[0]);
            }

            if (subNumbers[0].contains("sin")) {
              subNumbers[0] = _handleSin(subResult, subNumbers[0]);
            }

            subResult = double.parse(subNumbers[0]);

            for (int j = 0; j < subDelimiters.length; j++) {
              if (subNumbers[j + 1].startsWith("√") &&
                  !subNumbers[j + 1].contains("(")) {
                subNumbers[j + 1] =
                    _handleSquareRoot(subResult, subNumbers[j + 1]);
              }

              if (subNumbers[j + 1].startsWith("cos") &&
                  !subNumbers[j + 1].contains("(")) {
                subNumbers[j + 1] = _handleCos(subResult, subNumbers[j + 1]);
              }

              if (subNumbers[j + 1].startsWith("sin") &&
                  !subNumbers[j + 1].contains("(")) {
                subNumbers[j + 1] = _handleSin(subResult, subNumbers[j + 1]);
              }

              if (subDelimiters[j] == "x") {
                subResult *= double.parse(subNumbers[j + 1]);
              } else if (subDelimiters[j] == "^") {
                subResult =
                    pow(subResult, double.parse(subNumbers[j + 1])) as double;
              } else {
                subResult /= double.parse(subNumbers[j + 1]);
              }
            }
            if (delimiters[i] == "+") {
              result += subResult;
            } else {
              result -= subResult;
            }
          } else {
            if (delimiters[i] == "+") {
              result += double.parse(numbers[i + 1]);
            } else {
              result -= double.parse(numbers[i + 1]);
            }
          }
        } else if (delimiters[i] == "x") {
          result *= double.parse(numbers[i + 1]);
        } else if (delimiters[i] == "÷") {
          result /= double.parse(numbers[i + 1]);
        } else if (delimiters[i] == "^") {
          result = pow(result, double.parse(numbers[i + 1])) as double;
        }
      }
    }

    return result.toString();
  }

  String _handleSquareRoot(double result, String number) {
    result = double.parse(number.replaceAll("√", ""));
    for (int i = 0; i < "√".allMatches(number).length; i++) {
      result = sqrt(result);
    }
    return result.toString();
  }

  String _handleCos(double result, String number) {
    result = double.parse(number.replaceAll("cos", ""));
    if (_selectedItem == "Rad") {
      for (int i = 0; i < "cos".allMatches(number).length; i++) {
        result = cos(result);
      }
    } else if (_selectedItem == "Deg") {
      for (int i = 0; i < "cos".allMatches(number).length; i++) {
        result = cos(result * (pi / 180));
      }
    } else {
      for (int i = 0; i < "cos".allMatches(number).length; i++) {
        result = cos(result * (pi / 200));
      }
    }
    return result.toString();
  }

  String _handleSin(double result, String number) {
    result = double.parse(number.replaceAll("sin", ""));
    if (_selectedItem == "Rad") {
      for (int i = 0; i < "sin".allMatches(number).length; i++) {
        result = sin(result);
      }
    } else if (_selectedItem == "Deg") {
      for (int i = 0; i < "sin".allMatches(number).length; i++) {
        result = sin(result * (pi / 180));
      }
    } else {
      for (int i = 0; i < "sin".allMatches(number).length; i++) {
        result = sin(result * (pi / 200));
      }
    }
    return result.toString();
  }

  String _handleParentheses(String expression) {
    String operation = expression;
    while (operation.contains("(") || operation.contains(")")) {
      operation = expression.substring(0, operation.lastIndexOf("(")) +
          _handleExpression(operation.substring(
              operation.lastIndexOf("(") + 1, operation.indexOf(")"))) +
          operation.substring(operation.indexOf(")") + 1);
    }
    return operation;
  }

  String optimizeOperation(String operation) {
    for (int i = 0; i <= 9; i++) {
      String number = i.toString();
      if (_textController.text.contains("$number(")) {
        operation = operation.replaceAll("$number(", "${number}x(");
      }
      if (_textController.text.contains("$number√")) {
        operation = operation.replaceAll("$number√", "${number}x√");
      }
      if (_textController.text.contains("${number}cos")) {
        operation = operation.replaceAll("${number}cos", "${number}xcos");
      }
      if (_textController.text.contains("${number}sin")) {
        operation = operation.replaceAll("${number}sin", "${number}xsin");
      }
    }
    return operation;
  }

  void _handleEquals(int index) {
    if (_textController.text.endsWith("+") ||
        _textController.text.endsWith("-") ||
        _textController.text.endsWith("x") ||
        _textController.text.endsWith("÷") ||
        _textController.text.endsWith("cos(") ||
        _textController.text.endsWith("sin(") ||
        _textController.text.endsWith("^") ||
        _textController.text.endsWith("√")) {
    } else {
      if (_textController.text.contains("(") ||
          _textController.text.contains(")")) {
        if ((RegExp(r'\(').allMatches(_textController.text).length) ==
            (RegExp(r'\)').allMatches(_textController.text).length)) {
          String operation = optimizeOperation(_textController.text);

          _textController.text =
              _handleExpression(_handleParentheses(operation));
        }
      }
      _textController.text = _handleExpression(_textController.text);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

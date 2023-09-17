enum Operator {
  plus("+", "plus"),
  minus("-", "minus"),
  multiply("×", "multiplied by"),
  divide("÷", "divided by");

  const Operator(this.standaloneText, this.operatorText);

  final String standaloneText;
  final String operatorText;

  int operate(int operand1, int operand2) {
    switch (this) {
      case Operator.plus:
        return operand1 + operand2;
      case Operator.minus:
        int result = operand1 - operand2;
        if (result < 0) {
          throw Exception("Negative result not allowed");
        }
        return result;
      case Operator.multiply:
        return operand1 * operand2;
      case Operator.divide:
        if (operand1 % operand2 != 0) {
          throw Exception("Division must be exact");
        }

        return operand1 ~/ operand2;
    }
  }

  static fromString(String operatorText) {
    switch (operatorText) {
      case "+":
        return Operator.plus;
      case "-":
        return Operator.minus;
      case "×":
        return Operator.multiply;
      case "÷":
        return Operator.divide;
    }
  }
}

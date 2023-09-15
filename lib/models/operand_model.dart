import 'operator_model.dart';

class Operand implements Comparable<Operand> {
  int id;
  late int value;
  int initialValue;
  late List<int> previousValues;
  bool hidden = false;

  Operand(this.id, this.initialValue) {
    value = initialValue;
    previousValues = [initialValue];
  }

  OperationResult operate(Operator operator, Operand operand) {
    final tempValue = operand.value;
    operand.value = operator.operate(value, operand.value);
    operand.previousValues.add(tempValue);
    hidden = true;
    return OperationResult(value, id, tempValue, operand.id, operator, operand.value);
  }

  void undo() {
    value = previousValues.removeLast();
  }

  void unhide() {
    hidden = false;
  }

  void reset() {
    value = initialValue;
    previousValues = [initialValue];
    hidden = false;
  }

  @override
  int compareTo(Operand other) {
    return id.compareTo(other.id);
  } // 5, 2, 22, 14, 17, 20

  @override
  String toString() {
    return "Operand: $id: $value";
  }
}

class OperationResult {
  final int operand1;
  final int operand1Id;
  final int operand2;
  final int operand2Id;
  final Operator operator;
  final int result;

  OperationResult(this.operand1, this.operand1Id, this.operand2, this.operand2Id, this.operator, this.result);

  @override
  String toString() {
    return "$operand1 ${operator.standaloneText} $operand2 = $result";
  }
}

import 'package:it_figures/models/operand_model.dart';

import 'operator_model.dart';

class OperationSelection {
  Operand? operand1;
  Operand? operand2;
  Operator? operator;
  OperationResult? result;
  String? error;

  OperationSelection setOperand1(Operand? operand) {
    final result = OperationSelection();
    result.operand1 = operand;
    result.operator = null;
    return result;
  }

  OperationSelection setOperand2(Operand operand) {
    final result = OperationSelection();
    result.operand1 = operand1;
    result.operator = operator;
    result.operand2 = operand;
    return result;
  }

  OperationSelection setOperator(Operator? operator) {
    final result = OperationSelection();
    result.operand1 = operand1;
    result.operator = operator;
    return result;
  }

  OperationSelection setResult(OperationResult result) {
    final selection = OperationSelection();
    selection.operand1 = operand1;
    selection.operator = operator;
    selection.operand2 = operand2;
    selection.result = result;
    return selection;
  }

  OperationSelection setError(String error) {
    final result = OperationSelection();
    result.operand1 = operand1;
    result.operator = operator;
    result.error = error;
    return result;
  }
}

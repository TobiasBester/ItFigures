import 'package:flutter_test/flutter_test.dart';
import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/models/possible_solution.dart';
import 'package:it_figures/services/solution_checker.dart';

void main() {
  test('simple postfix test', () {
    final tokenizedSolution = TokenizedSolution(['10', '+', '2']);
    expect(tokenizedSolution.evaluate(), 12);
  });

  test('harder postfix test', () {
    final tokenizedSolution = TokenizedSolution(['10', '-', '2', '×', '4']);
    expect(tokenizedSolution.evaluate(), 32);
  });

  test('invalid postfix test', () {
    final tokenizedSolution = TokenizedSolution(['10', '-', '2', '÷', '7']);
    expect(tokenizedSolution.evaluate(), null);
  });

  test('long postfix test', () {
    final tokenizedSolution = TokenizedSolution(['10', '-', '2', '×', '4', '-', '10', '+', '20', '÷', '2']);
    expect(tokenizedSolution.evaluate(), 21);
  });

  test('evaluateAllPossibilities simple test', () {
    final possibleSolution = PossibleSolution([Operand(1, 10), Operand(2, 2)], 12);
    final tokenizedSolution = possibleSolution.evaluateAllPossibilities();
    expect(tokenizedSolution?.evaluate(), 12);
  });

  test('evaluateAllPossibilities harder test', () {
    final possibleSolution = PossibleSolution([Operand(1, 10), Operand(2, 2), Operand(3, 4)], 32);
    final tokenizedSolution = possibleSolution.evaluateAllPossibilities();
    expect(tokenizedSolution?.evaluate(), 32);
  });

  test('evaluateAllPossibilities impossible test', () {
    final possibleSolution = PossibleSolution([Operand(1, 10), Operand(2, 2), Operand(3, 4)], 30);
    final tokenizedSolution = possibleSolution.evaluateAllPossibilities();
    expect(tokenizedSolution?.evaluate(), null);
  });

  test('evaluateAllPossibilities possibly impossible test', () {
    final possibleSolution = PossibleSolution([Operand(1, 10), Operand(2, 2), Operand(3, 7)], 140);
    final tokenizedSolution = possibleSolution.evaluateAllPossibilities();
    expect(tokenizedSolution?.evaluate(), 140);
  });

  test('checkSolution simple test', () {
    final gameSolution = SolutionChecker.trySolve([Operand(1, 10), Operand(2, 2), Operand(3, 7)], 12);
    final tokenizedSolution = gameSolution?.tokenizedSolution;
    expect(tokenizedSolution?.evaluate(), 12);
  });

  test('checkSolution harder test', () {
    final gameSolution = SolutionChecker.trySolve(
        [Operand(1, 57), Operand(2, 21), Operand(3, 9), Operand(4, 5), Operand(5, 17)], 3);
    final tokenizedSolution = gameSolution?.tokenizedSolution;
    expect(tokenizedSolution?.evaluate(), 186);
  });
}

import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/models/possible_solution.dart';

class GameSolution {
  final int target;
  final List<Operand> operands;
  final TokenizedSolution tokenizedSolution;

  GameSolution(this.target, this.operands, this.tokenizedSolution);
}

import 'package:copy_with_extension/copy_with_extension.dart';

import '../../core/core.dart';

part 'check_folds_state.g.dart';

abstract class CheckFoldsState {
  const CheckFoldsState();
}

class CheckFoldsInitialState extends CheckFoldsState {}

@CopyWith()
class CheckFoldsLoadedState extends CheckFoldsState {
  List<PlayerModel> listOfPlayers;
  final int round;
  final int rounds;
  final int turn;
  final int displayedFold;
  final int pointPerFold;
  final bool increasePointPerFold;

  CheckFoldsLoadedState({
    required this.listOfPlayers,
    required this.round,
    required this.rounds,
    this.turn = 0,
    required this.displayedFold,
    required this.pointPerFold,
    required this.increasePointPerFold,
  });

  int get playerAnnouncedFold =>
      listOfPlayers[turn].folds[round].announcedFolds;

  bool get isLastPlayer => turn == listOfPlayers.length - 1;

  int get playerMakedFold => listOfPlayers[turn].folds[round].madeFolds;

  int get totalCheckedFolds => listOfPlayers.fold(
      0,
      (previousValue, element) =>
          previousValue + element.folds[round].madeFolds);

  int getPlayerFoldWithIndex(int index) =>
      listOfPlayers[index].folds[round].announcedFolds;

  void setPlayerFold(int fold, [int? index]) {
    listOfPlayers[index ?? turn].folds[round].madeFolds = fold;
    _setPlayerPoint(index);
  }

  void _setPlayerPoint([int? index]) {
    final bool isCheck = (playerMakedFold - playerAnnouncedFold) == 0;

    if (isCheck) {
      listOfPlayers[index ?? turn].point = 10 +
          (playerMakedFold *
              (increasePointPerFold
                  ? getRound(rounds: rounds, round: round)
                  : pointPerFold));
    } else {
      listOfPlayers[index ?? turn].point =
          ((playerAnnouncedFold - playerMakedFold).abs()) *
              ((increasePointPerFold
                      ? getRound(rounds: rounds, round: round)
                      : pointPerFold) *
                  -1);
    }
  }

  bool isFoldAllowed(int fold) {
    final currentRound = getRound(rounds: rounds, round: round);
    if (isLastPlayer && (fold - (currentRound - totalCheckedFolds)) != 0) {
      return false;
    }

    return fold <= (currentRound - totalCheckedFolds);
  }
}

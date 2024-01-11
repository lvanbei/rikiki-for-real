import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rikiki_for_real/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_players.dart';

class AddPlayersCubit extends Cubit<AddPlayersState> {
  AddPlayersCubit() : super(AddPlayersInitialState());

  void onWidgetDidInit(
      SharedPreferences prefs, List<PlayerModel> players) async {
    emit(AddPlayersLoadedState(
      listOfPlayers: players,
      prefs: prefs,
      controller: TextEditingController(),
    ));
  }

  void onSubmitPlayer() {
    final currentState = state as AddPlayersLoadedState;
    final newPlayer = currentState.controller.text;

    final currentPlayers = currentState.listOfPlayers;
    currentState.controller.text = '';
    currentPlayers.add(PlayerModel(
      name: newPlayer,
      folds: [FoldsModel()],
    ));
    emit(currentState.copyWith(listOfPlayers: currentPlayers));
    currentState.prefs.setString(
        "players", jsonEncode(currentPlayers.map((e) => e.toJson()).toList()));
  }

  void onDeletePlayer(int index) {
    final currentState = state as AddPlayersLoadedState;
    final currentPlayers = currentState.listOfPlayers;
    currentPlayers.removeAt(index);
    emit(currentState.copyWith(listOfPlayers: currentPlayers));
    currentState.prefs.setString(
        "players", jsonEncode(currentPlayers.map((e) => e.toJson()).toList()));
  }

  String? playerNameValidator(String? playerName) {
    if (playerName != null) {
      final currentState = state as AddPlayersLoadedState;

      if (playerName.isNotEmpty && currentState.playersLimit) {
        return "Max 10 players.";
      }
      if (currentState.playerAlreadyExist) {
        return "Player already in list.";
      }
    }
    return null;
  }
}

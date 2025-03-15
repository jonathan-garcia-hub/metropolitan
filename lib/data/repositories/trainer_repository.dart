import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/trainer_model.dart';

class TrainerRepository {
  Future<Trainer> getTrainer(int id) async {
    final String response = await rootBundle.loadString('assets/list_trainers.json');
    final List<dynamic> data = json.decode(response);
    final trainer = data.firstWhere((trainer) => trainer['idTrainer'] == id);
    return Trainer.fromJson(trainer);
  }
}
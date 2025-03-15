import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/trainer_model.dart';
import '../../data/repositories/trainer_repository.dart';
import '../../domain/usecases/get_user_activities.dart';
import '../../domain/usecases/get_all_activities.dart';

class ActivityProvider with ChangeNotifier {

  final GetUserActivities getUserActivities;
  final GetAllActivities getAllActivities;

  ActivityProvider(this.getUserActivities, this.getAllActivities);

  final TrainerRepository _trainerRepository = TrainerRepository();
  List<Activity> _userActivities = [];
  List<Activity> _allActivities = [];
  Map<int, Trainer> _trainers = {}; //

  List<Activity> get userActivities => _userActivities;
  List<Activity> get allActivities => _allActivities;
  Map<int, Trainer> get trainers => _trainers;

  Future<void> loadUserActivities(int userId) async {
    _userActivities = await getUserActivities(userId);
    sortActivities(_userActivities); // Ordenar las actividades del usuario
    notifyListeners();
  }

  Future<void> loadAllActivities() async {
    _allActivities = await getAllActivities();
    sortActivities(_allActivities); // Ordenar todas las actividades
    notifyListeners();

    // Cargar los entrenadores después de cargar las actividades
    await loadTrainers();
  }

  Future<void> loadTrainers() async {
    _trainers = await _loadTrainers(_allActivities); //en este punto _allActivities no esta cargado
    notifyListeners();
  }

  Future<Map<int, Trainer>> _loadTrainers(List<Activity> activities) async {
    final trainers = <int, Trainer>{};
    for (final activity in activities) {
      if (!trainers.containsKey(activity.trainerId)) {
        print('Cargando entrenador con ID: ${activity.trainerId}');
        final trainer = await _trainerRepository.getTrainer(activity.trainerId);
        trainers[activity.trainerId] = trainer;
      }
    }
    return trainers;
  }


  // Devuelve `true` si la inscripción fue exitosa, `false` si hubo un conflicto
  bool enrollInActivity(int activityId, int userId) {
    final activity = _allActivities.firstWhere((activity) => activity.id == activityId);

    // Verificar si el usuario ya está inscrito en otra actividad a la misma hora y día
    final hasConflict = _userActivities.any((userActivity) =>
    userActivity.day == activity.day && userActivity.time == activity.time);

    if (hasConflict) {
      return false; // Hay un conflicto de horario
    }

    if (!activity.membersEnrolled.contains(userId)) {
      // Agregar el usuario a la lista de inscritos en la actividad
      activity.membersEnrolled.add(userId);

      // Si la actividad no está en la lista de actividades del usuario, agregarla
      if (!_userActivities.any((activity) => activity.id == activityId)) {
        _userActivities.add(activity);
        sortActivities(_userActivities); // Ordenar las actividades del usuario
      }

      notifyListeners();
      return true; // Inscripción exitosa
    }

    return false; // El usuario ya estaba inscrito
  }

  void cancelEnrollment(int activityId, int userId) {
    final activity = _allActivities.firstWhere((activity) => activity.id == activityId);
    if (activity.membersEnrolled.contains(userId)) {
      // Remover el usuario de la lista de inscritos en la actividad
      activity.membersEnrolled.remove(userId);

      // Remover la actividad de la lista de actividades del usuario
      _userActivities.removeWhere((activity) => activity.id == activityId);
      sortActivities(_userActivities); // Ordenar las actividades del usuario

      notifyListeners();
    }
  }

  // Método para ordenar las actividades por día y hora
  void sortActivities(List<Activity> activities) {
    activities.sort((a, b) {
      final dayComparison = getDayIndex(a.day).compareTo(getDayIndex(b.day));
      if (dayComparison != 0) return dayComparison;
      return b.time.compareTo(a.time); // Ordenar de más temprano a más tarde
    });
  }

  // Método para convertir el día de la semana en un índice numérico
  int getDayIndex(String day) {
    final days = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'];
    return days.indexOf(day);
  }
}

import '../../data/models/activity_model.dart';
import '../../data/repositories/activity_repository.dart';

class GetAllActivities {
  final ActivityRepository repository;

  GetAllActivities(this.repository);

  Future<List<Activity>> call() async {
    return await repository.getActivities();
  }
}
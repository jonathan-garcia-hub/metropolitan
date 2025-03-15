
import '../../data/models/activity_model.dart';
import '../../data/repositories/activity_repository.dart';

class GetUserActivities {
  final ActivityRepository repository;

  GetUserActivities(this.repository);

  Future<List<Activity>> call(int userId) async {
    return await repository.getUserActivities(userId);
  }
}
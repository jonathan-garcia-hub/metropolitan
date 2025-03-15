import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/activity_model.dart';

class ActivityRepository {
  Future<List<Activity>> getActivities() async {
    final String response = await rootBundle.loadString('assets/list_activities.json');
    final List<dynamic> data = json.decode(response);
    return data.map((activity) => Activity.fromJson(activity)).toList();
  }

  Future<List<Activity>> getUserActivities(int userId) async {
    final activities = await getActivities();
    return activities.where((activity) => activity.membersEnrolled.contains(userId)).toList();
  }
}
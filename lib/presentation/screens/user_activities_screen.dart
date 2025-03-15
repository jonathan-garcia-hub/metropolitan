import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_list.dart';

class UserActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final userActivities = provider.userActivities;
    final trainers = provider.trainers;

    return userActivities.isEmpty
        ? Padding(
      padding: const EdgeInsets.all(35.0),
      child: Center(
        child: Text(
          'No te has inscrito a ninguna actividad aún',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    )
        : ActivityList(
      activities: userActivities,
      trainers: trainers,
    );
  }
}
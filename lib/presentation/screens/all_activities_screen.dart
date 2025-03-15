import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_list.dart';

class AllActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final allActivities = provider.allActivities;
    final trainers = provider.trainers;

    return ActivityList(
      activities: allActivities,
      trainers: trainers,
      showEnrollStatus: true,
      onEnroll: (activityId) {
        final success = provider.enrollInActivity(activityId, 1); // Asumimos que el usuario tiene ID 1
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No puedes inscribirte en dos clases a la misma hora y día.'),
            ),
          );
        }
      },
      onCancelEnrollment: (activityId) {
        provider.cancelEnrollment(activityId, 1); // Asumimos que el usuario tiene ID 1
      },
    );
  }
}
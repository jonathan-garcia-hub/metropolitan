import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/trainer_model.dart';
import '../widgets/activity_detail_screen.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Map<int, Trainer> trainers;
  final bool showEnrollStatus;
  final Function(int)? onEnroll;
  final Function(int)? onCancelEnrollment;

  const ActivityList({
    required this.activities,
    required this.trainers,
    this.showEnrollStatus = false,
    this.onEnroll,
    this.onCancelEnrollment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final trainer = trainers[activity.trainerId] ?? Trainer(id: 0, name: 'Desconocido', lastName: '', dni: '', cv: '', activities: []);
        final isEnrolled = activity.membersEnrolled.contains(1);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailScreen(activity: activity),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 100, // Altura del card
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(activity.image),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), // Filtro oscuro
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${activity.day} - ${activity.time}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (showEnrollStatus && isEnrolled)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[100], // Color de fondo verde claro
                              borderRadius: BorderRadius.circular(12), // Bordes redondeados
                            ),
                            child: Text(
                              'INSCRITO',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[800], // Color del texto (verde oscuro para mejor contraste)
                              ),
                            ),
                          )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          activity.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${trainer.name} ${trainer.lastName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
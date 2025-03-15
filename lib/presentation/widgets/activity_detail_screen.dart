import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/trainer_model.dart';
import '../providers/activity_provider.dart';
import '../../data/repositories/trainer_repository.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;

  ActivityDetailScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final userId = 1; // Asumimos que el usuario logueado tiene ID 1
    final trainerRepository = TrainerRepository();
    final isEnrolled = activity.membersEnrolled.contains(userId);

    // Verificar si hay un choque de horarios
    final hasConflict = provider.userActivities.any((userActivity) =>
    userActivity.day == activity.day && userActivity.time == activity.time);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activity.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Trainer>(
        future: trainerRepository.getTrainer(activity.trainerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el entrenador'));
          } else {
            final trainer = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Día y hora en la misma fila
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        '${activity.day} - ${activity.time}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Imagen de la actividad
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(activity.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Descripción
                  Text(
                    'Descripción:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    activity.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  // Entrenador
                  Text(
                    'Entrenador:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${trainer.name} ${trainer.lastName}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  // Botón de inscripción o cancelación
                  Center(
                    child: isEnrolled
                        ? ElevatedButton(
                      onPressed: () {
                        provider.cancelEnrollment(activity.id, userId);
                        Navigator.pop(context); // Regresar a la pantalla anterior
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color rojo para cancelar
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text(
                        'Cancelar Inscripción',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: hasConflict
                          ? null // Deshabilitar el botón si hay conflicto
                          : () {
                        final success = provider.enrollInActivity(activity.id, userId);
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No puedes inscribirte en dos clases a la misma hora y día.'),
                            ),
                          );
                        }
                        Navigator.pop(context); // Regresar a la pantalla anterior
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasConflict ? Colors.grey : Colors.green, // Color gris si hay conflicto
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text(
                        'Inscribirse',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
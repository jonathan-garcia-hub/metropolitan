import 'package:flutter/material.dart';
import 'package:metropolitan/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/activity_provider.dart';
import 'data/repositories/activity_repository.dart';
import 'domain/usecases/get_user_activities.dart';
import 'domain/usecases/get_all_activities.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(
            GetUserActivities(ActivityRepository()),
            GetAllActivities(ActivityRepository()),
          )..loadAllActivities()
            ..loadUserActivities(1)// Cargar actividades del usuario con ID 1,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Color primario
        colorScheme: ColorScheme.light(
          primary: Colors.blue, // Color primario
          secondary: Colors.blueAccent, // Color secundario
        ),
        cardTheme: CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue, // Color de los botones
          textTheme: ButtonTextTheme.primary,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // La aplicación inicia en la pantalla de inicio
      debugShowCheckedModeBanner: false, // Ocultar el banner de debug
    );
  }
}
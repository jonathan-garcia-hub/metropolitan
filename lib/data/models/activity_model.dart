class Activity {
  final int id;
  final String name;
  final String description;
  final String image;
  final int trainerId;
  final List<int> membersEnrolled;
  final String day;
  final String time;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.trainerId,
    required this.membersEnrolled,
    required this.day,
    required this.time,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['idActividadColectiva'],
      name: json['nombreActividadColectiva'],
      description: json['descripcion'],
      image: json['imagen'],
      trainerId: json['entrenadorResponsable'],
      membersEnrolled: List<int>.from(json['sociosInscritos']),
      day: json['diaClase'],
      time: json['horaClase'],
    );
  }
}
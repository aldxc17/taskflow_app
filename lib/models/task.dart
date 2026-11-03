
class Task {
  // Propiedades de cada tarea.
  final int id;
  final String tituloTarea;
  final String fecha;
  final String hora;
  final String prioridad;

  // Constructor del modelo.
  const Task({
    required this.id,
    required this.tituloTarea,
    required this.fecha,
    required this.hora,
    required this.prioridad,
  });

  // Convierte los datos del JSON a un objeto Task.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      tituloTarea: json['tituloTarea'] as String,
      fecha: json['fecha'] as String,
      hora: json['hora'] as String,
      prioridad: json['prioridad'] as String,
    );
  }
}


import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskService {

  // Función encargada de leer el archivo JSON.
  Future<List<Task>> leerJson() async {

    // Lee el contenido del archivo como texto.
    final String response = await rootBundle.loadString(
      'assets/data/data_tareas.json',
    );

    // Convierte el JSON a una lista de Dart.
    final List<dynamic> data = jsonDecode(response);

    // Convierte cada elemento de la lista en un objeto Task.
    final List<Task> tareas = data.map((item) {
      return Task.fromJson(
        item as Map<String, dynamic>,
      );
    }).toList();

    // Imprime la cantidad de tareas en la terminal.
    debugPrint('Total de tareas cargadas: ${tareas.length}');

    // Devuelve las tareas al HomeScreen.
    return tareas;
  }
}

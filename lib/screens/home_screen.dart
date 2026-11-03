
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Servicio encargado de leer el JSON.
  final TaskService _taskService = TaskService();

  // Guarda el resultado de la lectura del archivo.
  late final Future<List<Task>> _tareasFuture;

  @override
  void initState() {
    super.initState();

    // Lee el JSON una sola vez al crear la pantalla.
    _tareasFuture = _taskService.leerJson();
  }

  // Determina el color dependiendo de la prioridad.
  Color _colorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo de TaskFlow.
      backgroundColor: const Color(0xFFF5F3F2),

      // Evita superponer contenido con las barras del sistema.
      body: SafeArea(
        child: FutureBuilder<List<Task>>(
          future: _tareasFuture,

          builder: (context, snapshot) {
            // Muestra un indicador mientras carga el JSON.
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Muestra un error si falla la lectura.
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Error al cargar el JSON:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            }

            // Recuperamos la lista de tareas.
            final List<Task> tareas = snapshot.data ?? [];

            // Pantalla principal.
            return ListView(
              padding: const EdgeInsets.all(16),

              children: [
                const SizedBox(height: 12),

                // ENCABEZADO
                _buildHeader(),

                const SizedBox(height: 28),

                // MENSAJE PRINCIPAL
                const Text(
                  '¡Hagamos que hoy sea productivo!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF252525),
                  ),
                ),

                const SizedBox(height: 24),

                // TARJETA INFORMATIVA
                _buildResumen(tareas.length),

                const SizedBox(height: 25),

                // TÍTULO DE LA LISTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mis tareas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '${tareas.length} tareas',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // MOSTRAMOS LAS TAREAS DEL JSON.
                if (tareas.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No hay tareas disponibles',
                      ),
                    ),
                  )
                else
                  ...tareas.map(
                    (tarea) => _buildTaskCard(tarea),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==========================================
  // ENCABEZADO
  // ==========================================
  Widget _buildHeader() {
    return Row(
      children: [
        // Imagen de perfil.
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/avatar.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Texto del encabezado.
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, Aldo!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              Text(
                'TaskFlow',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Botón visual para agregar.
        IconButton(
          onPressed: null,
          icon: const Icon(
            Icons.add_outlined,
            size: 28,
          ),
          style: IconButton.styleFrom(
            disabledBackgroundColor: Colors.white,
            disabledForegroundColor: Colors.black,
            minimumSize: const Size(48, 48),
            padding: EdgeInsets.zero,
          ),
        ),

        const SizedBox(width: 8),

        // Botón visual de notificaciones.
        IconButton(
          onPressed: null,
          icon: const Icon(
            Icons.notifications_outlined,
            size: 28,
          ),
          style: IconButton.styleFrom(
            disabledBackgroundColor: Colors.white,
            disabledForegroundColor: Colors.black,
            minimumSize: const Size(48, 48),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TARJETA DE RESUMEN
  // ==========================================
  Widget _buildResumen(int totalTareas) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de tareas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: Color(0xFFCBDD80),
                size: 34,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  '$totalTareas tareas registradas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Organiza tus actividades y pendientes.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TARJETA DE TAREA
  // ==========================================
  Widget _buildTaskCard(Task tarea) {
    // Obtenemos el color correspondiente.
    final Color color = _colorPrioridad(
      tarea.prioridad,
    );

    return Card(
      color: Colors.white,
      elevation: 0,

      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícono de la tarea.
            const Icon(
              Icons.task_alt,
              size: 24,
            ),

            const SizedBox(width: 10),

            // Indicador vertical de prioridad.
            Container(
              width: 3,
              height: 55,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 10),

            // Información principal de la tarea.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de la tarea.
                  Text(
                    tarea.tituloTarea,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Fecha y hora.
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 16,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            tarea.fecha,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            tarea.hora,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Etiqueta de prioridad.
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                tarea.prioridad,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

// AGREGADO: Librería oficial de Google AdMob.
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Pantalla principal de TaskFlow.
import 'package:taskflow/screens/home_screen.dart';

// AGREGADO: Servicio que administra los anuncios.
import 'package:taskflow/services/app_open_ad_service.dart';

// MODIFICADO: main ahora es async.
Future<void> main() async {

  // AGREGADO: Inicializa Flutter antes de usar plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // AGREGADO: Inicializa Google AdMob.
  await MobileAds.instance.initialize();

  // Inicia nuestra aplicación.
  runApp(const MyApp());
}

// MODIFICADO: StatefulWidget permite observar
// el ciclo de vida de la aplicación.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with WidgetsBindingObserver {

  // AGREGADO: Servicio de anuncios App Open.
  final AppOpenAdService _adService = AppOpenAdService();

  // AGREGADO: Detecta cuando la app estuvo en segundo plano.
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();

    // AGREGADO: Escucha cambios del ciclo de vida.
    WidgetsBinding.instance.addObserver(this);

    // AGREGADO: Solicita anticipadamente un anuncio.
    _adService.loadAd();
  }

  // AGREGADO: Detecta cuando la aplicación
  // pasa a segundo plano o vuelve a estar activa.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // La aplicación pasó a segundo plano.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _wasInBackground = true;
    }

    // El usuario regresó a TaskFlow.
    if (state == AppLifecycleState.resumed &&
        _wasInBackground) {

      _wasInBackground = false;

      // Muestra el anuncio si ya está cargado.
      _adService.showAdIfAvailable();
    }
  }

  @override
  void dispose() {

    // AGREGADO: Deja de escuchar el ciclo de vida.
    WidgetsBinding.instance.removeObserver(this);

    // AGREGADO: Libera los recursos del anuncio.
    _adService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,

      // Conservamos el tema de tu aplicación.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      // Conservamos tu Home Screen.
      home: const HomeScreen(),
    );
  }
}

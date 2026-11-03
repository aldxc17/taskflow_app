
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdService {

  // ID de prueba del anuncio App Open para Android.
  static const String adUnitId =
      'ca-app-pub-3940256099942544/9257395921';

  // Almacena el anuncio que se cargó.
  AppOpenAd? _appOpenAd;

  // Evita cargar varios anuncios al mismo tiempo.
  bool _isLoading = false;

  // Evita mostrar varios anuncios al mismo tiempo.
  bool _isShowing = false;

  // Indica si el servicio ya se cerró.
  bool _disposed = false;

  // Guarda cuándo se cargó el anuncio.
  DateTime? _loadTime;

  // Guarda cuándo se intentó mostrar.
  DateTime? _lastShowTime;

  // 1. CARGAR EL ANUNCIO.
  void loadAd() {

    if (_disposed || _isLoading || _appOpenAd != null) {
      return;
    }

    _isLoading = true;

    debugPrint('AdMob: Solicitando anuncio...');

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),

      adLoadCallback: AppOpenAdLoadCallback(

        // El anuncio se cargó correctamente.
        onAdLoaded: (ad) {
          _isLoading = false;

          if (_disposed) {
            ad.dispose();
            return;
          }

          _appOpenAd = ad;
          _loadTime = DateTime.now();

          debugPrint('AdMob: Anuncio cargado correctamente');
        },

        // Ocurrió un error al cargar el anuncio.
        onAdFailedToLoad: (error) {
          _isLoading = false;

          debugPrint('AdMob: Error al cargar: $error');
        },
      ),
    );
  }

  // 2. COMPROBAR SI EL ANUNCIO ESTÁ DISPONIBLE.
  bool get isAdAvailable {

    if (_appOpenAd == null || _loadTime == null) {
      return false;
    }

    final tiempoTranscurrido =
        DateTime.now().difference(_loadTime!);

    // Un anuncio cargado es válido durante 4 horas.
    return tiempoTranscurrido < const Duration(hours: 4);
  }

  // 3. MOSTRAR EL ANUNCIO.
  void showAdIfAvailable() {

    if (_disposed || _isShowing) {
      return;
    }

    // Evita mostrar otro anuncio inmediatamente.
    if (_lastShowTime != null) {
      final diferencia =
          DateTime.now().difference(_lastShowTime!);

      if (diferencia < const Duration(seconds: 60)) {
        return;
      }
    }

    // Si no está disponible, solicita uno nuevo.
    if (!isAdAvailable) {
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _loadTime = null;

      debugPrint('AdMob: Anuncio no disponible');
      loadAd();
      return;
    }

    final ad = _appOpenAd!;

    // Detecta los eventos del anuncio.
    ad.fullScreenContentCallback =
        FullScreenContentCallback(

      // Cuando el anuncio aparece.
      onAdShowedFullScreenContent: (ad) {
        debugPrint('AdMob: Anuncio visible');
      },

      // Cuando el usuario cierra el anuncio.
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdMob: Anuncio cerrado');

        _isShowing = false;
        _appOpenAd = null;
        _loadTime = null;

        ad.dispose();

        // Prepara el siguiente anuncio.
        loadAd();
      },

      // Si ocurre un error al mostrarlo.
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdMob: Error al mostrar: $error');

        _isShowing = false;
        _appOpenAd = null;
        _loadTime = null;

        ad.dispose();
        loadAd();
      },
    );

    _isShowing = true;
    _lastShowTime = DateTime.now();

    // Muestra el anuncio a pantalla completa.
    ad.show();
  }

  // 4. LIBERAR LOS RECURSOS.
  void dispose() {
    _disposed = true;
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }
}

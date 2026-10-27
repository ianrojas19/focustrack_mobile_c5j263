
// App by Ian Rojas - C5J263
import 'package:flutter/material.dart';

void main() {
  runApp(const FocusTrackApp());
}

enum Prioridad {
  baja,
  media,
  alta,
}

extension PrioridadInfo on Prioridad {
  String get nombre {
    switch (this) {
      case Prioridad.baja:
        return 'Baja';
      case Prioridad.media:
        return 'Media';
      case Prioridad.alta:
        return 'Alta';
    }
  }

  Color get color {
    switch (this) {
      case Prioridad.baja:
        return const Color(0xFF90A4AE);
      case Prioridad.media:
        return const Color(0xFFFFB74D);
      case Prioridad.alta:
        return const Color(0xFFF06292);
    }
  }

  IconData get icono {
    switch (this) {
      case Prioridad.baja:
        return Icons.low_priority;
      case Prioridad.media:
        return Icons.flag;
      case Prioridad.alta:
        return Icons.priority_high;
    }
  }

  String get descripcion {
    switch (this) {
      case Prioridad.baja:
        return 'Sesión tranquila: avanzá a tu propio ritmo.';
      case Prioridad.media:
        return 'Prioridad media: mantené el enfoque en tus objetivos.';
      case Prioridad.alta:
        return 'Prioridad alta: concentrá tus esfuerzos en esta sesión.';
    }
  }
}

class FocusTrackApp extends StatelessWidget {
  const FocusTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusTrack Móvil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121318),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          color: Color(0xFF1E2028),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const PantallaPrincipalMetas(),
    );
  }
}

class PantallaPrincipalMetas extends StatefulWidget {
  const PantallaPrincipalMetas({super.key});

  @override
  State<PantallaPrincipalMetas> createState() =>
      _PantallaPrincipalMetasState();
}

class _PantallaPrincipalMetasState
    extends State<PantallaPrincipalMetas> {
  static const int _metaObjetivo = 5;
  static const int _maximoMetas = 10;

  int _metasCompletadas = 0;
  Prioridad _prioridadSeleccionada = Prioridad.media;

  String get _nivelProductividad {
    if (_metasCompletadas == 0) {
      return 'Inicial';
    } else if (_metasCompletadas < _metaObjetivo) {
      return 'En progreso';
    } else if (_metasCompletadas == _metaObjetivo) {
      return '¡Objetivo alcanzado!';
    } else {
      return '¡Sobresaliente (+${_metasCompletadas - _metaObjetivo})!';
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  void _incrementarMeta() {
    if (_metasCompletadas >= _maximoMetas) {
      _mostrarMensaje(
        'Ha alcanzado el límite máximo diario de metas (10/10). '
            '¡Excelente jornada!',
      );
      return;
    }

    setState(() {
      _metasCompletadas++;
    });

    if (_metasCompletadas == _metaObjetivo) {
      _mostrarMensaje('¡Excelente! Alcanzaste tu objetivo diario.');
    } else {
      _mostrarMensaje('Meta completada correctamente.');
    }
  }

  void _decrementarMeta() {
    if (_metasCompletadas == 0) {
      _mostrarMensaje('El contador ya se encuentra en cero.');
      return;
    }

    setState(() {
      _metasCompletadas--;
    });
  }

  Future<void> _reiniciarContadores() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.restart_alt),
          title: const Text('Confirmar reinicio'),
          content: const Text(
            '¿Deseás restablecer todas las metas completadas a cero?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Reiniciar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmar != true) {
      return;
    }

    setState(() {
      _metasCompletadas = 0;
    });

    _mostrarMensaje('Metas restablecidas exitosamente.');
  }

  void _cambiarPrioridad(Set<Prioridad> seleccion) {
    if (seleccion.isEmpty) {
      return;
    }

    setState(() {
      _prioridadSeleccionada = seleccion.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    final ColorScheme colores = tema.colorScheme;

    final double porcentaje =
    (_metasCompletadas / _metaObjetivo).clamp(0.0, 1.0).toDouble();

    final bool objetivoAlcanzado =
        _metasCompletadas >= _metaObjetivo;

    final Color colorPrioridad = _prioridadSeleccionada.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusTrack Móvil'),
        backgroundColor: colores.primaryContainer,
        foregroundColor: colores.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reiniciar sesión de metas',
            onPressed: _reiniciarContadores,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Resumen del progreso diario.
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.track_changes,
                        size: 52,
                        color: colores.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Progreso del día',
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_metasCompletadas / $_metaObjetivo',
                        style: tema.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colores.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: porcentaje,
                          minHeight: 10,
                          backgroundColor:
                          colores.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            objetivoAlcanzado
                                ? const Color(0xFF4DB6AC)
                                : colores.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Chip(
                        avatar: Icon(
                          objetivoAlcanzado
                              ? Icons.emoji_events
                              : Icons.bolt,
                          color: colores.onSecondaryContainer,
                        ),
                        label: Text(
                          _nivelProductividad,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: colores.secondaryContainer,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        objetivoAlcanzado
                            ? '¡Seguí así! Ya cumpliste tu objetivo.'
                            : 'Te faltan '
                            '${_metaObjetivo - _metasCompletadas} '
                            'metas para alcanzar tu objetivo.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Selector de prioridad del reto autónomo.
              Text(
                'Prioridad de la sesión',
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              SegmentedButton<Prioridad>(
                segments: Prioridad.values.map((Prioridad prioridad) {
                  return ButtonSegment<Prioridad>(
                    value: prioridad,
                    label: Text(prioridad.nombre),
                    icon: Icon(prioridad.icono),
                  );
                }).toList(),
                selected: <Prioridad>{_prioridadSeleccionada},
                onSelectionChanged: _cambiarPrioridad,
                showSelectedIcon: false,
                expandedInsets: EdgeInsets.zero,
              ),

              const SizedBox(height: 12),

              // Panel informativo que cambia según la prioridad.
              Card(
                color: colorPrioridad.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorPrioridad.withValues(alpha: 0.6),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    _prioridadSeleccionada.icono,
                    color: colorPrioridad,
                    size: 32,
                  ),
                  title: Text(
                    'Prioridad ${_prioridadSeleccionada.nombre}',
                    style: TextStyle(
                      color: colorPrioridad,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    _prioridadSeleccionada.descripcion,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Información técnica.
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colores.outlineVariant,
                  ),
                ),
                child: const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Sesión Móvil Activa'),
                  subtitle: Text(
                    'Interfaz construida con Flutter y Material 3. '
                        'Hot Reload disponible durante el desarrollo.',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Límite de metas de la sesión.
              Card(
                child: ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Límite diario de productividad'),
                  subtitle: Text(
                    'Metas completadas: '
                        '$_metasCompletadas/$_maximoMetas',
                  ),
                  trailing: const Icon(Icons.verified_user_outlined),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // Botones para restar y completar metas.
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn_decrementar',
            onPressed: _decrementarMeta,
            tooltip: 'Restar meta completada',
            backgroundColor: colores.surfaceContainerHighest,
            foregroundColor: colores.onSurfaceVariant,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 14),
          FloatingActionButton.extended(
            heroTag: 'btn_incrementar',
            onPressed: _incrementarMeta,
            tooltip: 'Completar meta',
            backgroundColor: colores.primary,
            foregroundColor: colores.onPrimary,
            icon: const Icon(Icons.check),
            label: const Text('Completar meta'),
          ),
        ],
      ),
    );
  }
}

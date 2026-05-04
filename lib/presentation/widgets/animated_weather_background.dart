import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/utils/weather_helper.dart';

/// 날씨 상태에 따른 동적 백그라운드 애니메이션
class AnimatedWeatherBackground extends StatefulWidget {
  final int weatherCode;
  final bool isDay;
  final Widget child;

  const AnimatedWeatherBackground({
    super.key,
    required this.weatherCode,
    required this.isDay,
    required this.child,
  });

  @override
  State<AnimatedWeatherBackground> createState() => _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _initParticles();
  }

  @override
  void didUpdateWidget(covariant AnimatedWeatherBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherCode != widget.weatherCode || oldWidget.isDay != widget.isDay) {
      _initParticles();
    }
  }

  void _initParticles() {
    _particles.clear();
    final type = _getEffectType();
    final count = _getParticleCount(type);

    for (int i = 0; i < count; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.2 + _random.nextDouble() * 0.8,
        size: 1.0 + _random.nextDouble() * 3.0,
        opacity: 0.1 + _random.nextDouble() * 0.4,
      ));
    }
  }

  _EffectType _getEffectType() {
    final code = widget.weatherCode;
    if (!widget.isDay) return _EffectType.stars;
    if (code == 0 || code == 1) return _EffectType.sunshine;
    if (code == 2 || code == 3) return _EffectType.clouds;
    if (code >= 51 && code <= 67) return _EffectType.rain;
    if (code >= 71 && code <= 86) return _EffectType.snow;
    if (code >= 95) return _EffectType.rain;
    return _EffectType.sunshine;
  }

  int _getParticleCount(_EffectType type) {
    switch (type) {
      case _EffectType.stars:
        return 60;
      case _EffectType.sunshine:
        return 20;
      case _EffectType.clouds:
        return 8;
      case _EffectType.rain:
        return 80;
      case _EffectType.snow:
        return 50;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = WeatherHelper.getGradientColors(widget.weatherCode, isDay: widget.isDay);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WeatherEffectPainter(
              particles: _particles,
              progress: _controller.value,
              effectType: _getEffectType(),
              isDay: widget.isDay,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

enum _EffectType { stars, sunshine, clouds, rain, snow }

class Particle {
  double x;
  double y;
  double speed;
  double size;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class _WeatherEffectPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final _EffectType effectType;
  final bool isDay;

  _WeatherEffectPainter({
    required this.particles,
    required this.progress,
    required this.effectType,
    required this.isDay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (effectType) {
      case _EffectType.stars:
        _paintStars(canvas, size);
        break;
      case _EffectType.sunshine:
        _paintSunshine(canvas, size);
        break;
      case _EffectType.clouds:
        _paintClouds(canvas, size);
        break;
      case _EffectType.rain:
        _paintRain(canvas, size);
        break;
      case _EffectType.snow:
        _paintSnow(canvas, size);
        break;
    }
  }

  void _paintStars(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final twinkle = 0.5 + 0.5 * sin((progress * 2 * pi * p.speed) + i);
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * twinkle)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size * twinkle,
        paint,
      );
    }
  }

  void _paintSunshine(Canvas canvas, Size size) {
    // 부드러운 빛 입자
    for (final p in particles) {
      final driftX = sin(progress * 2 * pi * p.speed) * 10;
      final driftY = cos(progress * 2 * pi * p.speed * 0.7) * 10;
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(
        Offset(p.x * size.width + driftX, p.y * size.height + driftY),
        p.size * 3,
        paint,
      );
    }

    // 태양 글로우 (우상단)
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow.withOpacity(0.15 * (0.8 + 0.2 * sin(progress * 2 * pi))),
          Colors.yellow.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.8, size.height * 0.15),
        radius: size.width * 0.4,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.15),
      size.width * 0.4,
      sunPaint,
    );
  }

  void _paintClouds(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final cloudX = ((p.x + progress * p.speed * 0.1) % 1.2 - 0.1) * size.width;
      final cloudY = p.y * size.height * 0.5;

      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cloudX, cloudY),
          width: 120 + p.size * 20,
          height: 40 + p.size * 10,
        ),
        paint,
      );
    }
  }

  void _paintRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (final p in particles) {
      final dropY = ((p.y + progress * p.speed) % 1.0) * size.height;
      final dropX = p.x * size.width;
      final length = 15.0 + p.size * 5;

      canvas.drawLine(
        Offset(dropX, dropY),
        Offset(dropX - 2, dropY + length),
        paint,
      );
    }
  }

  void _paintSnow(Canvas canvas, Size size) {
    for (final p in particles) {
      final snowY = ((p.y + progress * p.speed * 0.5) % 1.0) * size.height;
      final sway = sin(progress * 2 * pi * p.speed + p.x * 10) * 10;
      final snowX = p.x * size.width + sway;

      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

      canvas.drawCircle(
        Offset(snowX, snowY),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherEffectPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.effectType != effectType;
  }
}

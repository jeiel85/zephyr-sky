import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// 오프라인 상태 배너 위젯
class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final bool isCacheExpired;
  final DateTime? lastUpdated;

  const OfflineBanner({
    super.key,
    required this.isOffline,
    this.isCacheExpired = false,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!isOffline && !isCacheExpired) {
      return const SizedBox.shrink();
    }

    String message;
    Color backgroundColor;
    IconData icon;

    if (isOffline) {
      message = l10n.offlineMode;
      backgroundColor = Colors.orange.withOpacity(0.9);
      icon = Icons.wifi_off;
    } else if (isCacheExpired) {
      message = l10n.cacheExpired;
      backgroundColor = Colors.yellow.shade700.withOpacity(0.9);
      icon = Icons.access_time;
    } else {
      return const SizedBox.shrink();
    }

    // 마지막 업데이트 시간 추가
    if (lastUpdated != null) {
      final timeDiff = DateTime.now().difference(lastUpdated!);
      String timeText;
      if (timeDiff.inMinutes < 60) {
        timeText = l10n.minutesAgo(timeDiff.inMinutes);
      } else if (timeDiff.inHours < 24) {
        timeText = l10n.hoursAgo(timeDiff.inHours);
      } else {
        timeText = l10n.daysAgo(timeDiff.inDays);
      }
      message = '$message • $timeText';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

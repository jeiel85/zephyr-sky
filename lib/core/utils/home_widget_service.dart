import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weather.dart';
import '../../l10n/app_localizations.dart';

class HomeWidgetService {
  static const String _appGroupId = 'group.com.jeiel.zephyr_sky';
  static const String _androidWidgetName = 'HomeWidgetReceiver';

  /// 위젯 초기화
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// 날씨 정보를 위젯에 업데이트
  static Future<void> updateWidget(Weather weather, AppLocalizations l10n) async {
    try {
      // 위젯 데이터 저장
      await HomeWidget.saveWidgetData<String>('location', weather.locationName);
      await HomeWidget.saveWidgetData<String>('temperature', '${weather.temperature.round()}°');
      await HomeWidget.saveWidgetData<String>('description', weather.weatherDescription);
      await HomeWidget.saveWidgetData<String>(
        'updated', 
        l10n.lastUpdate(DateFormat('HH:mm').format(DateTime.now()))
      );

      // 위젯 업데이트 요청
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
      );
    } catch (e) {
      // 위젯 업데이트 실패 시 무시
    }
  }
}

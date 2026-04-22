package com.jeiel.zephyr_sky

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetReceiver : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget_layout).apply {
                val location = widgetData.getString("location", "위치 없음") ?: "위치 없음"
                val temperature = widgetData.getString("temperature", "--°") ?: "--°"
                val description = widgetData.getString("description", "날씨 상태") ?: "날씨 상태"
                val updated = widgetData.getString("updated", "") ?: ""

                setTextViewText(R.id.widget_location, location)
                setTextViewText(R.id.widget_temperature, temperature)
                setTextViewText(R.id.widget_description, description)
                setTextViewText(R.id.widget_updated, updated)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
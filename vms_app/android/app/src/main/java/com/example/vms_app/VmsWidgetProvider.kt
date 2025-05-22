package com.example.vms_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetPlugin

class VmsWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.vms_widget_layout)
            
            // Lấy dữ liệu từ SharedPreferences
            val prefs = HomeWidgetPlugin.getData(context)
            val text = prefs.getString("widget_text", "VMS Widget") ?: "VMS Widget"
            views.setTextViewText(R.id.widget_text, text)

            // Thiết lập PendingIntent để mở ứng dụng
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("vmsapp://open"))
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_button, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
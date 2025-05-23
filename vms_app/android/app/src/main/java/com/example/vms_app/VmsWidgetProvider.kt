package com.example.vms_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import io.reactivex.disposables.CompositeDisposable
import org.json.JSONObject
import ua.naiksoftware.stomp.Stomp
import ua.naiksoftware.stomp.StompClient

class VmsWidgetProvider : AppWidgetProvider() {
    private var stompClient: StompClient? = null
    private val disposables = CompositeDisposable()
    private val TAG = "VmsWidgetProvider"
    private val WEBSOCKET_URL = "ws://10.0.2.2:8080/ws"

    data class FormData(val username: String, val title: String, val content: String, val type: String)

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = HomeWidgetPlugin.getData(context)
        val username = prefs.getString("username", null)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.vms_widget_layout)
            if (username.isNullOrEmpty()) {
                Log.e(TAG, "Username is null or empty, cannot send message")
                views.setTextViewText(R.id.widget_text, "No username set")
            } else {
                views.setTextViewText(R.id.widget_text, "Sending SOS...")
                sendMessage(context, appWidgetManager, intArrayOf(appWidgetId), username)
            }

            val intent = Intent(context, VmsWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_button, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun sendMessage(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        username: String
    ) {
        stompClient?.disconnect()
        disposables.clear()

        stompClient = Stomp.over(Stomp.ConnectionProvider.OKHTTP, WEBSOCKET_URL).apply {
            withClientHeartbeat(10000)
            withServerHeartbeat(10000)
        }

        val lifecycleDisposable = stompClient?.lifecycle()?.subscribe { event ->
            when (event.type) {
                ua.naiksoftware.stomp.dto.LifecycleEvent.Type.OPENED -> {
                    Log.i(TAG, "WebSocket connected")
                    val formData = FormData(
                        username = username,
                        title = "SOS from $username",
                        content = "Driver $username needs urgent assistance.",
                        type = "Alert"
                    )

                    val json = JSONObject().apply {
                        put("username", formData.username)
                        put("title", formData.title)
                        put("content", formData.content)
                        put("type", formData.type)
                    }

                    stompClient?.send("/app/chat/admin123", json.toString())?.subscribe(
                        {
                            Log.i(TAG, "SOS sent successfully")
                            updateWidget(context, appWidgetManager, appWidgetIds, "SOS sent successfully")
                            stompClient?.disconnect()
                        },
                        { error ->
                            Log.e(TAG, "Failed to send SOS: ${error.message}")
                            updateWidgetWithError(context, appWidgetManager, appWidgetIds, "Failed to send SOS")
                            stompClient?.disconnect()
                        }
                    )
                }

                ua.naiksoftware.stomp.dto.LifecycleEvent.Type.ERROR -> {
                    Log.e(TAG, "WebSocket error: ${event.exception?.message}")
                    updateWidgetWithError(context, appWidgetManager, appWidgetIds, "Connection failed")
                }

                ua.naiksoftware.stomp.dto.LifecycleEvent.Type.CLOSED -> {
                    Log.i(TAG, "WebSocket disconnected")
                    this@VmsWidgetProvider.stompClient = null
                }

                ua.naiksoftware.stomp.dto.LifecycleEvent.Type.FAILED_SERVER_HEARTBEAT -> {
                    Log.e(TAG, "Server heartbeat failed")
                    updateWidgetWithError(context, appWidgetManager, appWidgetIds, "Server unreachable")
                }
            }
        }

        lifecycleDisposable?.let { disposables.add(it) }
        stompClient?.connect()
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        text: String
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.vms_widget_layout)
            views.setTextViewText(R.id.widget_text, text)

            val intent = Intent(context, VmsWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_button, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun updateWidgetWithError(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        errorMessage: String
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.vms_widget_layout)
            views.setTextViewText(R.id.widget_text, "Error: $errorMessage")

            val intent = Intent(context, VmsWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_button, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        stompClient?.disconnect()
        disposables.clear()
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        stompClient?.disconnect()
        disposables.clear()
    }
}

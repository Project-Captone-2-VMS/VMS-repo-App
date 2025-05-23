package com.example.vms_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.os.Handler
import android.os.Looper
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
    private val WEBSOCKET_URL = "ws://10.0.2.2:8080/ws/websocket"
    private val ACTION_SEND_SOS = "com.example.vms_app.ACTION_SEND_SOS"

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
                views.setTextViewText(R.id.widget_text, "Press to send SOS")
            }

            val intent = Intent(context, VmsWidgetProvider::class.java).apply {
                action = ACTION_SEND_SOS
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
                putExtra("username", username)
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

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_SEND_SOS) {
            val appWidgetIds = intent.getIntArrayExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS)
            val username = intent.getStringExtra("username")
            val appWidgetManager = AppWidgetManager.getInstance(context)

            if (username.isNullOrEmpty()) {
                Log.e(TAG, "Username is null or empty in onReceive")
                if (appWidgetIds != null) {
                    updateWidgetWithError(context, appWidgetManager, appWidgetIds, "No username set")
                }
            } else if (appWidgetIds != null) {
                updateWidget(context, appWidgetManager, appWidgetIds, "Sending SOS...")
                sendMessage(context, appWidgetManager, appWidgetIds, username)
            }
        }
    }

    private fun sendMessage(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        username: String
    ) {
        Log.d(TAG, "Attempting to connect to WebSocket: $WEBSOCKET_URL")
        stompClient?.disconnect()
        disposables.clear()

        stompClient = Stomp.over(Stomp.ConnectionProvider.OKHTTP, WEBSOCKET_URL).apply {
            withClientHeartbeat(10000)
            withServerHeartbeat(10000)
        }

        val lifecycleDisposable = stompClient?.lifecycle()?.subscribe { event ->
            Log.d(TAG, "WebSocket event: ${event.type}, message: ${event.message}, exception: ${event.exception?.message}")
            when (event.type) {
                ua.naiksoftware.stomp.dto.LifecycleEvent.Type.OPENED -> {
                    Log.i(TAG, "WebSocket connected successfully")
                    val formData = FormData(
                        username = username,
                        title = "SOS from $username",
                        content = "Driver $username needs urgent assistance.",
                        type = "ALERT"
                    )

                    val json = JSONObject().apply {
                        put("username", formData.username)
                        put("title", formData.title)
                        put("content", formData.content)
                        put("type", formData.type)
                    }
                    Log.d(TAG, "Sending JSON: $json")

                    stompClient?.send("/app/chat/admin123", json.toString())?.subscribe(
                        {
                            Log.i(TAG, "SOS sent successfully")
                            updateWidget(context, appWidgetManager, appWidgetIds, "SOS sent successfully")
                            Handler(Looper.getMainLooper()).postDelayed({
                                updateWidget(context, appWidgetManager, appWidgetIds, "Press to send SOS")
                            }, 10000)
                            stompClient?.disconnect()
                        },
                        { error ->
                            Log.e(TAG, "Failed to send SOS: ${error.message}", error)
                            updateWidgetWithError(context, appWidgetManager, appWidgetIds, "Failed to send SOS: ${error.message}")
                            stompClient?.disconnect()
                        }
                    )
                }
                ua.naiksoftware.stomp.dto.LifecycleEvent.Type.ERROR -> {
                    Log.e(TAG, "WebSocket error: ${event.exception?.message}", event.exception)
                    updateWidgetWithError(context, appWidgetManager, appWidgetIds, "Connection failed: ${event.exception?.message}")
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
        Log.d(TAG, "Initiating WebSocket connection")
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
                action = ACTION_SEND_SOS
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
                putExtra("username", HomeWidgetPlugin.getData(context).getString("username", null))
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
                action = ACTION_SEND_SOS
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
                putExtra("username", HomeWidgetPlugin.getData(context).getString("username", null))
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
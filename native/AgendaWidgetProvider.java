package com.mihan.personalmanager;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;

public class AgendaWidgetProvider extends AppWidgetProvider {
    @Override
    public void onUpdate(Context c, AppWidgetManager m, int[] ids) {
        for (int id : ids) m.updateAppWidget(id, build(c));
    }

    static RemoteViews build(Context c) {
        RemoteViews v = new RemoteViews(c.getPackageName(), R.layout.agenda_widget);
        String t = c.getSharedPreferences("agenda_widget", Context.MODE_PRIVATE)
                .getString("text", "برنامه را یک بار باز کنید تا دستور کار امروز نمایش داده شود");
        v.setTextViewText(R.id.wtext, t);
        Intent i = new Intent(c, MainActivity.class);
        PendingIntent p = PendingIntent.getActivity(c, 0, i, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        v.setOnClickPendingIntent(R.id.wroot, p);
        return v;
    }

    static void refresh(Context c) {
        AppWidgetManager m = AppWidgetManager.getInstance(c);
        int[] ids = m.getAppWidgetIds(new ComponentName(c, AgendaWidgetProvider.class));
        for (int id : ids) m.updateAppWidget(id, build(c));
    }
}

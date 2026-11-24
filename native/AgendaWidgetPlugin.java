package com.mihan.personalmanager;

import android.content.Context;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "AgendaWidget")
public class AgendaWidgetPlugin extends Plugin {
    @PluginMethod
    public void update(PluginCall call) {
        String text = call.getString("text", "");
        Context c = getContext();
        c.getSharedPreferences("agenda_widget", Context.MODE_PRIVATE).edit().putString("text", text).apply();
        AgendaWidgetProvider.refresh(c);
        call.resolve();
    }
}

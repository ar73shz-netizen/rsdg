#!/usr/bin/env bash
set -euo pipefail
APP_ID="com.mihan.personalmanager"
P="android/app/src/main/java/${APP_ID//.//}"
R="android/app/src/main/res"
M="android/app/src/main/AndroidManifest.xml"

mkdir -p "$P" "$R/layout" "$R/xml" "$R/drawable"
cp native/AgendaWidgetPlugin.java native/AgendaWidgetProvider.java native/MainActivity.java "$P/"
cp native/agenda_widget.xml "$R/layout/agenda_widget.xml"
cp native/agenda_widget_info.xml "$R/xml/agenda_widget_info.xml"
cp native/widget_bg.xml "$R/drawable/widget_bg.xml"

python - "$M" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text(encoding='utf-8')
receiver='''\n        <receiver
            android:name="com.mihan.personalmanager.AgendaWidgetProvider"
            android:label="دستور کار"
            android:exported="true">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/agenda_widget_info" />
        </receiver>\n'''
if 'AgendaWidgetProvider' not in s:
    if '</application>' not in s:
        raise SystemExit('ERROR: </application> not found in AndroidManifest.xml')
    s=s.replace('</application>', receiver+'    </application>', 1)
perms='''    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
'''
if 'android.permission.POST_NOTIFICATIONS' not in s and '</manifest>' in s:
    s=s.replace('</manifest>', perms+'</manifest>', 1)
p.write_text(s, encoding='utf-8')
PY

# Fail the build early if any native widget component is missing.
test -f "$P/AgendaWidgetProvider.java"
test -f "$P/AgendaWidgetPlugin.java"
test -f "$R/layout/agenda_widget.xml"
test -f "$R/xml/agenda_widget_info.xml"
grep -q 'AgendaWidgetProvider' "$M"
grep -q 'android.appwidget.provider' "$M"
echo 'Native agenda widget registered successfully.'

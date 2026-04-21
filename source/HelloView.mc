import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Math;
using Toybox.Time;
using Toybox.SensorHistory;

class HelloView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function getHeartRate() as String {
        var hr_history = SensorHistory.getHeartRateHistory(null);
        var hr = hr_history.next();
        if (hr == null) {
            return "--";
        }
        return hr.data.format("%d");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var day = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT).day.format("%d");
        var batPercent = System.getSystemStats().battery / 100.0;
        var hb = getHeartRate();

        // Get and show the current time
        var clockTime = System.getClockTime();
        var decMin = clockTime.min / 60.0 + clockTime.sec / 3600.0;
        var decHour = (clockTime.hour + decMin) / 12.0;

        // Get center coordinate
        var penWidth = 6;
        var xc = dc.getWidth()/2;
        var yc = dc.getHeight()/2;
        var l = xc - penWidth/2;

        // Get hour offset
        var aHour = decHour * 2.0 * Math.PI;
        var xHour = l * Math.sin(aHour);
        var yHour = -l * Math.cos(aHour);
        
        // Get minute offset
        var aMin = decMin * 2.0 * Math.PI;
        var xMin = l * Math.sin(aMin);
        var yMin = -l * Math.cos(aMin);

        dc.setPenWidth(penWidth);

        // Ensure background color is black before clear()
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // draw 12h mark
        dc.setColor(0x08a093, Graphics.COLOR_BLACK);
        dc.fillCircle(
            xc - (0.4*xMin).toNumber(),
            yc - (0.4*yMin).toNumber() - 0.6*l + 10,
            4
        );

        // draw minute circle
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawCircle(
            xc - (0.4*xMin).toNumber(),
            yc - (0.4*yMin).toNumber(),
            0.6*l
        );

        // draw hour hand
        dc.drawLine(
            xc - (0.4*xMin).toNumber(),
            yc - (0.4*yMin).toNumber(),
            xc - (0.4*xMin).toNumber() + (0.5*xHour).toNumber(),
            yc - (0.4*yMin).toNumber() + (0.5*yHour).toNumber()
        );

        // draw minute hand
        dc.setPenWidth(8);
        dc.drawLine(
            xc + (xMin/3).toNumber(),
            yc + (yMin/3).toNumber(),
            xc + (xMin).toNumber(),
            yc + (yMin).toNumber()
        );

        dc.setPenWidth(4);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawLine(
            xc + (xMin/3 + xMin*2/3*batPercent).toNumber(),
            yc + (yMin/3 + yMin*2/3*batPercent).toNumber(),
            xc + (xMin).toNumber(),
            yc + (yMin).toNumber()
        );

        var aDay = (decMin+1.0/6.0) * 2.0 * Math.PI;
        var xDay = l * Math.sin(aDay);
        var yDay = -l * Math.cos(aDay);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            xc + 0.8*xDay,
            yc + 0.8*yDay,
            Graphics.FONT_SMALL,
            day,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );


        var aHB = (decMin-1.0/6.0) * 2.0 * Math.PI;
        var xHB = l * Math.sin(aHB);
        var yHB = -l * Math.cos(aHB);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            xc + 0.8*xHB,
            yc + 0.8*yHB,
            Graphics.FONT_SMALL,
            hb,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}

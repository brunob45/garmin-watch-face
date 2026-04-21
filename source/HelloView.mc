import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Math;

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

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var batPercent = System.getSystemStats().battery / 100.0;

        // Get and show the current time
        var clockTime = System.getClockTime();
        var decMin = clockTime.min / 60.0 + clockTime.sec / 3600.0;
        var decHour = (clockTime.hour + decMin) / 12.0;

        // Get center coordinate
        var penWidth = 6.0;
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
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // draw minute circle
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

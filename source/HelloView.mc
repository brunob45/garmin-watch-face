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
        // Get and show the current time
        var clockTime = System.getClockTime();
        var decMin = clockTime.min / 60.0;
        var decHour = (clockTime.hour + decMin) / 12.0;

        // Get center coordinate
        var penWidth = 6.0;
        var xc = 0.5 * dc.getWidth();
        var yc = 0.5 * dc.getHeight();
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

        // draw hour hand
        dc.drawLine(
            xc + xHour/3,
            yc + yHour/3,
            xc + xHour,
            yc + yHour
        );

        // draw hour circle
        dc.drawCircle(
            xc - xHour/2,
            yc - yHour/2,
            l/2
        );

        // draw minute hand
        dc.drawLine(
            xc - xHour/2,
            yc - yHour/2,
            xc + xMin/2.2 - xHour/2,
            yc + yMin/2.2 - yHour/2
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

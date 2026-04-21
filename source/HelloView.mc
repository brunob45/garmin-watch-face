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

    function drawHand(dc as Dc, time as Float, r1 as Float, r2 as Float) as Void {
        var angle = time * 2.0 * Math.PI;
        var x = 0.5 * dc.getWidth() * Math.sin(angle);
        var y = -0.5 * dc.getWidth() * Math.cos(angle);
        dc.drawLine(dc.getWidth()/2 + r1*x, dc.getHeight()/2 + r1*y, dc.getWidth()/2 + r2*x, dc.getHeight()/2 + r2*y);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setPenWidth(5);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Get and show the current time
        var clockTime = System.getClockTime();
        var decMin = clockTime.min / 60.0;
        var decHour = (clockTime.hour + decMin) / 12.0;

        drawHand(dc, decMin, 0.0, 1.0);
        drawHand(dc, decHour, 0.0, 0.75);
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

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
        dc.clear();

        var circle_offset = 0.45;

        // draw 12h mark
        dc.setColor(0x08a093, Graphics.COLOR_BLACK);
        {
            var r = (1.0-circle_offset)*l - 10;
            for (var i = 0; i < 12; i++) {
                var angle = i * Math.PI / 6;
                var x = r * Math.sin(angle);
                var y = -r * Math.cos(angle);
                dc.fillCircle(
                    xc - (circle_offset*xMin).toNumber() + x,
                    yc - (circle_offset*yMin).toNumber() + y,
                    4
                );
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
            }
        }

        // draw minute circle
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawCircle(
            xc - (circle_offset*xMin).toNumber(),
            yc - (circle_offset*yMin).toNumber(),
            (1.0-circle_offset) * l
        );

        // draw hour hand
        dc.drawLine(
            xc - (circle_offset*xMin).toNumber(),
            yc - (circle_offset*yMin).toNumber(),
            xc - (circle_offset*xMin).toNumber() + (0.45*xHour).toNumber(),
            yc - (circle_offset*yMin).toNumber() + (0.45*yHour).toNumber()
        );

        // draw minute hand
        var min_offset = 0.25;
        dc.setPenWidth(8);
        dc.drawLine(
            xc + (min_offset*xMin).toNumber(),
            yc + (min_offset*yMin).toNumber(),
            xc + (xMin).toNumber(),
            yc + (yMin).toNumber()
        );

        // draw battery indicator in minute hand
        dc.setPenWidth(4);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawLine(
            xc + (min_offset*xMin + (1.0-min_offset)*xMin*batPercent).toNumber(),
            yc + (min_offset*yMin + (1.0-min_offset)*yMin*batPercent).toNumber(),
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

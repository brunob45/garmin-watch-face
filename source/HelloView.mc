import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Math;

class HelloView extends WatchUi.WatchFace {

    const COLOR_CUSTOM = 0x08a093;

    private var _hand as WatchUi.BitmapResource;

    function initialize() {
        WatchFace.initialize();
        _hand = WatchUi.loadResource($.Rez.Drawables.MinuteHand);
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

    // Wrapper for easy bitmap drawing
    function drawBitmap(dc as Dc, bm as Graphics.BitmapType, t as Graphics.AffineTransform) as Void {
        dc.drawBitmap2(
            0,
            0,
            bm,
            {
                :bitmapX=>0,
                :bitmapY=>0,
                :bitmapWidth=>bm.getWidth(),
                :bitmapHeight=>bm.getHeight(),
                :transform=>t,
            }
        );
    }

    function drawBattery(dc as Dc, a as Lang.Float) {
        // draw battery indicator
        var batPercent = System.getSystemStats().battery;
        var xc = dc.getWidth()/2;
        var yc = dc.getHeight()/2;

        var x = xc + 0.7 * xc * Math.sin(a);
        var y = yc - 0.7 * xc * Math.cos(a);
        var r = 0.2 * xc;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            x, y,
            Graphics.FONT_TINY,
            batPercent.toNumber(),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setPenWidth(1);
        dc.drawCircle(x, y, r+5);
        dc.setPenWidth(4);
        dc.drawArc(
            x, y, r,
            Graphics.ARC_CLOCKWISE,
            90,
            3.6 * (125-batPercent)
        );
    }

    function drawDate(dc as Dc, a as Lang.Float) {
        // draw date
        var info = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var xc = dc.getWidth()/2;
        var yc = dc.getHeight()/2;

        var x = xc + 0.7 * xc * Math.sin(a);
        var y = yc - 0.7 * xc * Math.cos(a);
        var r = 0.2 * xc;

        var f = Graphics.FONT_XTINY;
        var h = dc.getFontHeight(f);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, y-0.4*h,
            f,
            info.day_of_week,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
            x, y+0.4*h,
            f,
            info.day,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setPenWidth(1);
        dc.drawCircle(x, y, r+5);
        dc.setPenWidth(4);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Get and show the current time
        var clockTime = System.getClockTime();
        var decMin = clockTime.min / 60.0 + clockTime.sec / 3600.0;
        var decHour = (clockTime.hour + decMin) / 12.0;

        // Get center coordinate
        var penWidth = 6;
        var xc = dc.getWidth()/2;
        var yc = dc.getHeight()/2;
        var l = xc - penWidth/2;

        // Get hour angle
        var aHour = decHour * 2.0 * Math.PI;
        
        // Get minute angle
        var aMin = decMin * 2.0 * Math.PI;

        // Get minute offset
        var xMin = l * Math.sin(aMin);
        var yMin = -l * Math.cos(aMin);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var circle_offset = 0.45;

        // draw 12h mark
        dc.setColor(COLOR_CUSTOM, Graphics.COLOR_BLACK);
        {
            var r = (1.0-circle_offset)*l - 10;
            for (var i = 0; i < 12; i++) {
                var angle = i * Math.PI / 6;
                var x = r * Math.sin(angle);
                var y = -r * Math.cos(angle);
                dc.fillCircle(
                    xc - circle_offset*xMin + x,
                    yc - circle_offset*yMin + y,
                    4
                );
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
            }
        }

        // draw minute circle
        dc.setPenWidth(penWidth);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawCircle(
            xc-circle_offset*xMin,
            yc-circle_offset*yMin,
            (1.0-circle_offset) * l
        );

        {
            // draw minute hand
            var t = new Graphics.AffineTransform();
            t.translate(xc.toFloat(), yc.toFloat());
            t.rotate(aMin);
            t.translate(-_hand.getWidth()/2.0, -_hand.getHeight()-38.0);
            drawBitmap(dc, _hand, t);

            // draw hour hand
            t = new Graphics.AffineTransform();
            t.translate(xc-circle_offset*xMin, yc-circle_offset*yMin);
            t.rotate(aHour);
            t.scale(0.6, 0.6);
            t.translate(-_hand.getWidth()/2.0, -_hand.getHeight()+_hand.getWidth()/2.0);
            drawBitmap(dc, _hand, t);
        }

        drawDate(dc, aMin + 2*Math.PI*2/12); // align with 2-hour mark
        drawBattery(dc, aMin + 2*Math.PI*10/12); // align with 10-hour mark

        if (System.getDeviceSettings().notificationCount) {
            dc.setColor(COLOR_CUSTOM, Graphics.COLOR_BLACK);
        }
        else {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        }
        dc.fillCircle(dc.getWidth()/2, 8, 8);
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

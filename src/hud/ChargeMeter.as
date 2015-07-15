/**
 * Created by adm on 14.07.15.
 */
package hud {
import starling.display.Quad;
import starling.display.Sprite;

public class ChargeMeter extends Sprite{

    private var _background:Quad;
    private var _fill:Quad;

    public function ChargeMeter() {
        _background = new Quad(200,40,0x000000, false);
        _fill = new Quad(200, 40, 0xFF00000, false);

        addChild(_background);
        addChild(_fill)
    }

    public function updateFill(value:uint):void
    {
        _fill.width = value;
    }
}
}

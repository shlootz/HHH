/**
 * Created by adm on 16.07.15.
 */
package obstacles {
import starling.display.DisplayObject;

public class TimerWall extends Wall{
    public function TimerWall(x:int, y:int, w:uint = 2, h:uint = 9, brickW:uint = 10, brickH:uint = 10, mass:int = .5,brickView:DisplayObject = null) {
        super(x,y,w,h,brickW, brickH, mass, brickView);
    }
}
}

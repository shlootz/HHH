/**
 * Created by adm on 13.07.15.
 */
package obstacles {
import citrus.objects.NapePhysicsObject;

import starling.display.DisplayObject;

import starling.display.DisplayObject;

import starling.display.Quad;

public class Wall {

    private var _objects:Vector.<NapePhysicsObject> = new Vector.<NapePhysicsObject>();

    public function Wall(x:int, y:int, w:uint = 2, h:uint = 9, brickW:uint = 10, brickH:uint = 10, mass:int = .5,brickView:DisplayObject = null) {
        for(var i:uint = 0; i<w; i++)
        {
            for(var j:uint = 0; j<h; j++) {
                var obj:NapePhysicsObject = new NapePhysicsObject("o1", {x: x+i*brickW, y: y+j*brickH, width: brickW, height: brickH, view: new Quad(10, 10, 0xFF1234)});
                _objects.push(obj)
            }
        }
    }

    public function get objects():Vector.<NapePhysicsObject> {
        return _objects;
    }
}
}

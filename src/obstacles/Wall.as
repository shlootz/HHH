/**
 * Created by adm on 13.07.15.
 */
package obstacles {
import citrus.objects.NapePhysicsObject;

import starling.display.DisplayObject;

import starling.display.DisplayObject;

import starling.display.Quad;

public class Wall extends NapePhysicsObject {

    private var _objects:Vector.<NapePhysicsObject> = new Vector.<NapePhysicsObject>();
    private var _innerObjects:Vector.<NapePhysicsObject>;

    public function Wall(name:String, params:Object = null) {
        super(name, {x:params.x, y:params.y, width:2, height:2});
    }

    override public function addPhysics():void {
        super.addPhysics();

        _innerObjects = new Vector.<NapePhysicsObject>();

        addBricks();
    }

    public function get objects():Vector.<NapePhysicsObject> {
        return _objects;
    }

    private function addBricks():void
    {
        for(var i:uint = 0; i<3; i++)
        {
            for(var j:uint = 0; j<5; j++) {
                var obj:NapePhysicsObject = new NapePhysicsObject("o1", {x: x+i*20, y: y+j*20, width: 20, height: 20, view: new Quad(20, 20, 0xFF1234)});
                _ce.state.add(obj)
                _innerObjects.push(obj);
            }
        }
    }

    override public function destroy():void {

        for(var i:uint = 0; i<_innerObjects.length; i++)
        {
            _ce.state.remove(_innerObjects[i]);
        }
        super.destroy();
    }
}
}

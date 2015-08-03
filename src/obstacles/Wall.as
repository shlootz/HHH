/**
 * Created by adm on 13.07.15.
 */
package obstacles {
import citrus.objects.NapePhysicsObject;

import nape.callbacks.CbType;

import nape.phys.BodyType;

import starling.display.DisplayObject;

import starling.display.DisplayObject;

import starling.display.Quad;

import states.physicsStage.Collisions;

public class Wall extends MapItem {


    public function Wall(name:String, params:Object = null) {
        super(name, params);
    }

    override protected function initialize():void {

        super.initialize();
        addBricks();
    }

    private function addBricks():void
    {
        for(var i:uint = 0; i<3; i++)
        {
            for(var j:uint = 0; j<5; j++) {
                var obj:NapePhysicsObject = new NapePhysicsObject("o1", {x: _params.x+i*20, y: _params.y+j*20, width: 20, height: 20, view: new Quad(20, 20, 0xFF1234)});
                EngineSingleton.citrusCore.state.add(obj)
                obj.body.cbTypes.add(Collisions.OBSTACLE_COLLISION_TYPE);
                innerObjects.push(obj);
            }
        }
    }

    override public function destroy():void {

        for(var i:uint = 0; i<innerObjects.length; i++)
        {
            EngineSingleton.citrusCore.state.remove(innerObjects[i]);
        }
        super.destroy();
    }
}
}

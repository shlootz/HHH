/**
 * Created by adm on 29.07.15.
 */
package obstacles {
import citrus.objects.NapePhysicsObject;
import citrus.objects.platformer.nape.Platform;

import starling.display.Quad;

import states.physicsStage.Collisions;

public class Collectible1 extends MapItem
{
    public function Collectible1(name:String, params:Object = null) {
        super(name, params);
    }

    override protected function initialize():void
    {
        var obj:NapePhysicsObject = new NapePhysicsObject("o", {x: _params.x, y: _params.y, width: 40, height: 40, view: new Quad(40, 40, 0xFF0000)});
        var platf:Platform = new Platform("p", {x: _params.x, y: _params.y, width: 40, height: 40, view: new Quad(40, 40, 0xFF0000)});

        EngineSingleton.citrusCore.state.add(obj);
        EngineSingleton.citrusCore.state.add(platf);

        obj.body.cbTypes.add(Collisions.WALL_COLLISION_TYPE);
        innerObjects.push(obj);
        innerObjects.push(platf);
    }

    override public function destroy():void {

        for(var i:uint = 0; i<innerObjects.length; i++)
        {
            EngineSingleton.citrusCore.state.remove(innerObjects[i]);
        }

    }
}
}

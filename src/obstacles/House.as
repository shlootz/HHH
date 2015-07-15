/**
 * Created by adm on 13.07.15.
 */
package obstacles {
import citrus.objects.NapePhysicsObject;

import starling.display.Quad;

public class House {

    private var _objects:Vector.<NapePhysicsObject> = new Vector.<NapePhysicsObject>();

    private var _wall1:Wall;
    private var _wall2:Wall;
    private var _roof:NapePhysicsObject;

    public function House(x:uint, y:uint) {
        _wall1 = new Wall(x, y, 2, 2, 20);
        _wall2 = new Wall(x + 100, y, 2, 2, 20);

        _roof = new NapePhysicsObject("Roof", {x: x, y: y-30, width: 70, height: 40, view: new Quad(70, 40, 0xCCCCCC)});

        _objects.concat(_wall1.objects);
        _objects.concat(_wall2.objects);
        _objects.push(_roof);
    }

    public function get objects():Vector.<NapePhysicsObject> {
        return _objects;
    }
}
}

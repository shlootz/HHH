/**
 * Created by adm on 03.08.15.
 */
package obstacles {
import citrus.objects.NapePhysicsObject;

public class MapItem {

    public var innerObjects:Vector.<NapePhysicsObject>;

    protected var _params:Object;
    protected var _name:String;

    public function MapItem(name:String, params:Object) {
        _name = name;
        _params = params;
        innerObjects = new Vector.<NapePhysicsObject>();
        initialize();
    }

    protected function initialize():void
    {

    }

    public function destroy():void
    {

    }
}
}

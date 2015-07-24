/**
 * Created by adm on 24.07.15.
 */
package maps {
import citrus.objects.NapePhysicsObject;
import citrus.objects.platformer.nape.Platform;
import citrus.objects.vehicle.nape.Car;

import obstacles.Wall;

import starling.display.Quad;

public class ItemsValidator {
    public function ItemsValidator() {
    }

    public static function validateItem(element:LayoutPhysicsElement):NapePhysicsObject
    {
        var toReturn:NapePhysicsObject;
        var type:String = element.type;
        switch(type){
            case LayoutElements.COLLECTIBLE_TYPE_1:
                    var collectible:NapePhysicsObject = new NapePhysicsObject(type, element.params);
                    toReturn = collectible;
                break;

            case LayoutElements.PLATFORM:
                    var platform:Platform = new Platform(type, element.params);
                    toReturn = platform;
                break;

            case LayoutElements.WALL:
//                    var wall:Wall = new Wall()
                trace("WALL");

                break;

            case LayoutElements.CAR:
                var car:Car = new Car(type, element.params);
                toReturn = car;
        }

        return toReturn;
    }
}
}

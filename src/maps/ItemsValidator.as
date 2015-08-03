/**
 * Created by adm on 24.07.15.
 */
package maps {
import citrus.objects.NapePhysicsObject;
import citrus.objects.platformer.nape.Platform;
import citrus.objects.vehicle.nape.Car;

import obstacles.Collectible1;

import obstacles.NonDestructibleWall;

import obstacles.Wall;

import starling.display.Quad;

import states.physicsStage.Collisions;

public class ItemsValidator {
    public function ItemsValidator() {
    }

    public static function validateItem(element:LayoutPhysicsElement):void
    {
//        var toReturn:NapePhysicsObject;
        var type:String = element.type;
        switch(type){
            case LayoutElements.COLLECTIBLE_TYPE_1:
                    var collectible:Collectible1 = new Collectible1(type, element.params);
//                    toReturn = new Platform(type, element.params);
                break;

            case LayoutElements.PLATFORM:
                    var platform:Platform = new Platform(type, element.params);
//                    toReturn = platform;
                    EngineSingleton.citrusCore.state.add(platform);
                break;

            case LayoutElements.WALL:
                    var wall:Wall = new Wall(type, element.params);
//                    toReturn = wall;
                break;

            case LayoutElements.NON_DESTRUCTIBLE_WALL:
//                var nonDestructibleWall:NonDestructibleWall = new NonDestructibleWall("non_wall", element.params);
//                toReturn = nonDestructibleWall;
                break;

            case LayoutElements.CAR:
                var car:Car = new Car(type, element.params);
//                toReturn = car;
        }

//        return toReturn;
    }
}
}

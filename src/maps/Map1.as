/**
 * Created by adm on 23.07.15.
 */
package maps {

import flash.utils.Dictionary;

import starling.display.Quad;

public class Map1 extends Map{

    public var distribution:Dictionary = new Dictionary(true);

    private var _positions:Vector.<int> = new Vector.<int>();

    public function Map1() {

        length = 10000;

        addFloor();
        addCollectibles();
        addWalls();
//        addCars();
//        addNonDestructibleWall();

        _positions.sort(Array.NUMERIC);
        _positions.reverse();
    }

    private function addFloor():void
    {
        var collection:ElementsCollection = new ElementsCollection();

        var element:LayoutPhysicsElement = new LayoutPhysicsElement("p1", LayoutElements.PLATFORM, {x:4500, y:400, width:11000, height:75, view:new Quad(10000,75,0x000000)})

        collection.elements.push(element);

        distribution[400] = collection;
        _positions.push(400);
    }

    private function addCollectibles():void
    {
        for(var i:uint = 0; i<50; i++)
        {
            var collection:ElementsCollection = new ElementsCollection();
            var pos:int = 800+100*i*2;
            var element:LayoutPhysicsElement = new LayoutPhysicsElement("c"+i, LayoutElements.COLLECTIBLE_TYPE_1, {x:400+pos, y:0, width:50, height:50, view:new Quad(50,50,0xFF0000)})
            collection.elements.push(element);
            if(!distribution[pos])
            distribution[pos] = collection;

            _positions.push(pos);
        }
    }

    private function addWalls():void
    {
        for(var i:uint = 0; i<2; i++)
        {
            var collection:ElementsCollection = new ElementsCollection();
            var pos:int = 605+100*i;
            var element:LayoutPhysicsElement = new LayoutPhysicsElement("w"+i, LayoutElements.WALL, {x:400+pos, y:300})
            collection.elements.push(element);
            if(!distribution[pos])
                distribution[pos] = collection;
            _positions.push(pos);
        }
    }

    private function addNonDestructibleWall():void
    {
        for(var i:uint = 0; i<2; i++)
        {
            var collection:ElementsCollection = new ElementsCollection();
            var pos:int = 415+100*i*3;
            var element:LayoutPhysicsElement = new LayoutPhysicsElement("nonw"+i, LayoutElements.NON_DESTRUCTIBLE_WALL, {x:400+pos, y:300, width:50, height:200})
            collection.elements.push(element);
            if(!distribution[pos])
                distribution[pos] = collection;
            _positions.push(pos);
        }
    }

    private function addCars():void
    {
        for(var i:uint = 0; i<100; i++) {
            var collection:ElementsCollection = new ElementsCollection();
            var pos:int = 1150 + 100 * i;
            var element:LayoutPhysicsElement = new LayoutPhysicsElement("car", LayoutElements.CAR, {x: 800, y: 200, nmbrNuggets: 5, view: new Quad(50, 50, 0xFF0000), backWheelArt: new Quad(50, 50, 0xFF0000), frontWheelArt: new Quad(50, 50, 0xFF0000), particleArt: new Quad(5, 5, 0xFF0000)});
            _positions.push(pos);
        }
    }

    override public function getElement(position:int):ElementsCollection
    {
        var index:int = _positions.length -1;
        var elementIndex:int = 0;
        var collection:ElementsCollection = _emptyCollection;
        if(_positions.length > 0) {
            if (position >= _positions[index]) {
                elementIndex = _positions.pop();
            }

            if (distribution[elementIndex] != null) {
                collection = distribution[elementIndex];
                delete distribution[elementIndex];
            }
        }

        return collection;
    }
}
}

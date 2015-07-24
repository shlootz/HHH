/**
 * Created by adm on 23.07.15.
 */
package maps {

import flash.utils.Dictionary;

import starling.display.Quad;

public class Map1 extends Map{

    public var distribution:Dictionary = new Dictionary(true);

    public function Map1() {

        length = 10000;

        addFloor();
        addCollectibles();
        addWalls();
        addCars();
    }

    private function addFloor():void
    {
        var collection:ElementsCollection = new ElementsCollection();

        var element:LayoutPhysicsElement = new LayoutPhysicsElement("p1", LayoutElements.PLATFORM, {x:5000, y:400, width:10000, height:75, view:new Quad(10000,75,0x000000)})

        collection.elements.push(element);

        distribution[400] = collection;
    }

    private function addCollectibles():void
    {
        for(var i:uint = 0; i<100; i++)
        {
            var collection:ElementsCollection = new ElementsCollection();
            var pos:int = 800+100*i;
            var element:LayoutPhysicsElement = new LayoutPhysicsElement("c"+i, LayoutElements.COLLECTIBLE_TYPE_1, {x:400+pos, y:0, width:50, height:50, view:new Quad(50,50,0xFF0000)})
            collection.elements.push(element);
            if(!distribution[pos])
            distribution[pos] = collection;
        }
    }

    private function addWalls():void
    {
        for(var i:uint = 0; i<100; i++)
        {
            var collection:ElementsCollection = new ElementsCollection();
            var pos:int = 600+100*i;
            var element:LayoutPhysicsElement = new LayoutPhysicsElement("w"+i, LayoutElements.WALL, {x:400+pos, y:0, width:100, height:100, brickW:20, brickH:20, view:new Quad(100,100,0xFF0000)})
            collection.elements.push(element);
            if(!distribution[pos])
                distribution[pos] = collection;
        }
    }

    private function addCars():void
    {
        for(var i:uint = 0; i<100; i++) {
            var collection:ElementsCollection = new ElementsCollection();
            var pos:int = 600 + 100 * i;
            var element:LayoutPhysicsElement = new LayoutPhysicsElement("car", LayoutElements.CAR, {x: 800, y: 200, nmbrNuggets: 5, view: new Quad(50, 50, 0xFF0000), backWheelArt: new Quad(50, 50, 0xFF0000), frontWheelArt: new Quad(50, 50, 0xFF0000), particleArt: new Quad(5, 5, 0xFF0000)});
        }
    }

    override public function getElement(position:int):ElementsCollection
    {
        var collection:ElementsCollection = _emptyCollection;

        if(distribution[position] != null)
        {
            collection = distribution[position];
            delete distribution[position];
        }

        return collection;
    }
}
}

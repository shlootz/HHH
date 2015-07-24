/**
 * Created by adm on 23.07.15.
 */
package maps {

public class Map {

    public var length:Number = 10000;
    public var height:Number = 400;
    public var layout:Array = new Array();

    protected var _emptyCollection:ElementsCollection = new ElementsCollection();

    public function Map() {

    }

    public function getElement(position:int):ElementsCollection
    {
        return _emptyCollection;
    }
}
}

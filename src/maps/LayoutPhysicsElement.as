/**
 * Created by adm on 23.07.15.
 */
package maps {

public class LayoutPhysicsElement {

    public var type:String;
    public var name:String;
    public var params:Object;

    public function LayoutPhysicsElement(name:String, type:String, params:Object) {
        this.name = name;
        this.params = params;
        this.type = type;
    }
}
}

/**
 * Created by adm on 29.07.15.
 */
package states.physicsStage {
import nape.callbacks.CbType;

public class Collisions {

    public static var WALL_COLLISION_TYPE:CbType=new CbType();
    public static var BALL_COLLISION_TYPE:CbType=new CbType();
    public static var OBSTACLE_COLLISION_TYPE:CbType = new CbType();
    public static var CLEANER_COLLISION_TYPE:CbType = new CbType();

    public function Collisions() {
    }
}
}

/**
 * Created by adm on 26.01.15.
 */
package {

import signals.ISignalsHub;
import signals.SignalsHub;

public class EngineSingleton {

    private static var _instance:EngineSingleton;
    private static var _signalsManager:SignalsHub;

    public function EngineSingleton(s:SingletonEnforcer) {
        if (s == null) throw new Error("Singleton, use MySingleton.instance");
    }

    public static function get instance():EngineSingleton {
        if (_instance == null)
        {
            _instance = new EngineSingleton(new SingletonEnforcer());
            _signalsManager = new SignalsHub();
        }
        return _instance;
    }

    public function get signalsManager():ISignalsHub {
        return _signalsManager;
    }
}
}

class SingletonEnforcer {}

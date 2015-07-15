package {

import citrus.core.starling.StarlingCitrusEngine;

import flash.display.Sprite;
import flash.text.TextField;

import org.osflash.signals.Signal;

import states.physicsStage.PhysicsState;

[SWF(frameRate = 60)]

public class Main extends StarlingCitrusEngine {
    public function Main() {
        setUpStarling(true);
    }

    override public function  handleStarlingReady():void
    {
        super.handleStarlingReady();

        EngineSingleton.instance.signalsManager.addSignal(GameSignals.GAME_OVER, new Signal(), new Vector.<Function>());
        EngineSingleton.instance.signalsManager.addListenerToSignal(GameSignals.GAME_OVER, _gameOver);

        startOver();
    }

    private function _gameOver(type:String, obj:Object):void
    {
        startOver();
    }

    private function startOver():void
    {
        state = new PhysicsState();
    }
}
}

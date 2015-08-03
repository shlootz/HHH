/**
 * Created by adm on 13.07.15.
 */
package states.physicsStage {
import VO.ChargeVO;

import actors.MobileHero;

import citrus.core.starling.StarlingState;
import citrus.objects.NapePhysicsObject;
import citrus.objects.platformer.nape.Platform;
import citrus.objects.platformer.nape.Sensor;
import citrus.objects.platformer.simple.StaticObject;
import citrus.physics.nape.Nape;
import citrus.physics.nape.NapeUtils;
import citrus.physics.simple.SimpleCitrusSolver;

import flash.display.DisplayObject;

import flash.events.TimerEvent;

import flash.geom.Point;

import flash.geom.Rectangle;
import flash.utils.Timer;

import hud.ChargeMeter;

import maps.ElementsCollection;
import maps.ItemsValidator;
import maps.LayoutElements;
import maps.LayoutPhysicsElement;

import maps.MapsManager;

import nape.callbacks.CbEvent;

import nape.callbacks.CbType;

import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

import obstacles.House;

import obstacles.Wall;

import org.osflash.signals.Signal;

import starling.display.Quad;

import starling.events.Event;

public class PhysicsState extends StarlingState{

    private var _chargeMeter:ChargeMeter;
    private var _chargeVO:ChargeVO;

    private var _mobileHero:MobileHero;
    private var _cleaner:NapePhysicsObject;

    private var _maps:MapsManager;

    private var _timerCollectible:Timer;
    private var _chargeTimer:Timer;
    private var _lifeTimer:Timer;

    private var _interactionListener:InteractionListener;
    private var _obstacleInteractionListener:InteractionListener;
    private var _cleanerInteractionListener:InteractionListener;

//    private var _wallCollisionType:CbType=new CbType();
//    private var _ballCollisionType:CbType=new CbType();
//    private var _obstacleCollistionType:CbType = new CbType();
//    private var _cleanerCollisionType:CbType = new CbType();

    public function PhysicsState() {
        super();
    }

    override public function initialize():void
    {
        super.initialize();

        EngineSingleton.citrusCore = _ce;
        EngineSingleton.instance.signalsManager.addSignal(GameSignals.CHARGING, new Signal(), new Vector.<Function>());
        EngineSingleton.instance.signalsManager.addListenerToSignal(GameSignals.CHARGING, _toggleCharging);

        _maps = new MapsManager();

        _lifeTimer = new Timer(1000);
        _lifeTimer.addEventListener(TimerEvent.TIMER, _drainLife);
        _lifeTimer.start();

        _timerCollectible = new Timer(250);
//        _timerCollectible.addEventListener(TimerEvent.TIMER, _collectibleCreation);
        _timerCollectible.start();

        _chargeMeter = new ChargeMeter();
        _chargeTimer = new Timer(50);
        _chargeTimer.addEventListener(TimerEvent.TIMER, _decreaseCharge);
        _chargeVO = new ChargeVO();

        var physics:Nape = new Nape("myNape");
        _interactionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,Collisions.WALL_COLLISION_TYPE,Collisions.BALL_COLLISION_TYPE,_handleContact);
        _obstacleInteractionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,Collisions.OBSTACLE_COLLISION_TYPE,Collisions.BALL_COLLISION_TYPE,_handleObstacleContact);
        _cleanerInteractionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,Collisions.OBSTACLE_COLLISION_TYPE,Collisions.CLEANER_COLLISION_TYPE,_handleCleanerContact);

        this.add(physics);
        physics.visible = true;
        physics.gravity = new Vec2(0,350);
        physics.space.listeners.add(_interactionListener);
        physics.space.listeners.add(_obstacleInteractionListener);
        physics.space.listeners.add(_cleanerInteractionListener);

        _mobileHero = new MobileHero("hero", {x:40, y:150, width:80, height:75, jumpHeight:175, jumpAcceleration:5, view:new Quad(80,75,0xFF0000)});
        _mobileHero.chargeVO = _chargeVO;
        add(_mobileHero);
        _mobileHero.body.cbTypes.add(Collisions.BALL_COLLISION_TYPE);

        _cleaner = new NapePhysicsObject("cleaner", {x:20, y:150, width:100, height: 200});
        add(_cleaner);
        _cleaner.body.cbTypes.add(Collisions.CLEANER_COLLISION_TYPE);
        _cleaner.body.mass = 100;

        view.camera.setUp(_mobileHero, new Rectangle(0, 0, _maps.currentMap.length, _maps.currentMap.height),null , new Point(.25, .05));

        addChild(_chargeMeter);

        addEventListener(Event.ENTER_FRAME, advance);
    }

    private function advance():void
    {
        var pos:int = view.camera.camPos.x;

        var elements:ElementsCollection = _maps.currentMap.getElement(pos)

        for( var i:uint = 0; i<elements.elements.length; i++)
        {
            var element:LayoutPhysicsElement = elements.elements[i];
            ItemsValidator.validateItem(element);
//            var objToAdd:NapePhysicsObject = ItemsValidator.validateItem(element)
//            add(objToAdd);
        };

        _cleaner.body.position.x = _mobileHero.body.position.x - 500;
    }

    private function _decreaseCharge(tEvt:TimerEvent):void {
        _chargeVO.consumeCharge(2);
        _chargeMeter.updateFill(_chargeVO.chargeCurrentValue);
    }

    private function _drainLife(tEvt:TimerEvent):void
    {
        _chargeVO.consumeCharge(1);
        _chargeMeter.updateFill(_chargeVO.chargeCurrentValue);

        if(_chargeVO.chargeCurrentValue <=0){
            EngineSingleton.instance.signalsManager.dispatchSignal(GameSignals.GAME_OVER, GameSignals.GAME_OVER, {});
        }
    }

    private function _handleContact(collision:InteractionCallback):void
        {
            var collectible:NapePhysicsObject = NapeUtils.CollisionGetOther(_mobileHero, collision);
            _chargeVO.fillCharge(collectible.width / 10);
            _chargeMeter.updateFill(_chargeVO.chargeCurrentValue);
            collectible.kill = true;
        }

    private function _handleObstacleContact(collision:InteractionCallback):void
    {
        if(_mobileHero.charging) {
           NapeUtils.CollisionGetOther(_mobileHero, collision).kill = true;
        } else{
            _mobileHero.bounceBack();
        }
    }

    private function _handleCleanerContact(collision:InteractionCallback):void
    {
        NapeUtils.CollisionGetOther(_mobileHero, collision).kill = true;
    }

    private function _toggleCharging(type:String, obj:Object):void
    {
        if(obj["isCharging"] == true)
        {
            _chargeTimer.start();
        }
        else
        {
            _chargeTimer.stop();
        }
    }

    private function getCollectibleSize():int
    {
        return int(10+Math.random()*50)
    }

    override public function destroy():void {
        _timerCollectible.stop();
        _chargeTimer.stop();
        _lifeTimer.stop();

        _lifeTimer.removeEventListener(TimerEvent.TIMER, _drainLife);
//        _timerCollectible.removeEventListener(TimerEvent.TIMER, _collectibleCreation);
        _chargeTimer.removeEventListener(TimerEvent.TIMER, _decreaseCharge);

        super.destroy();
    }
}
}

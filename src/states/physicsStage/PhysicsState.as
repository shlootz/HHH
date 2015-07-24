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

    private var _maps:MapsManager;

    private var _timerCollectible:Timer;
    private var _chargeTimer:Timer;
    private var _lifeTimer:Timer;

    private var _interactionListener:InteractionListener;
    private var _obstacleInteractionListener:InteractionListener;
    private var _wallCollisionType:CbType=new CbType();
    private var _ballCollisionType:CbType=new CbType();
    private var _obstacleCollistionType:CbType = new CbType();

    public function PhysicsState() {
        super();
    }

    override public function initialize():void
    {
        super.initialize();

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
        _interactionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_wallCollisionType,_ballCollisionType,_handleContact);
        _obstacleInteractionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_obstacleCollistionType,_ballCollisionType,_handleObstacleContact);

        this.add(physics);
        physics.visible = true;
        physics.gravity = new Vec2(0,350);
        physics.space.listeners.add(_interactionListener);
        physics.space.listeners.add(_obstacleInteractionListener);

        //var platform:Platform = new Platform("p1", {x:5000, y:300, width:10000, height:60});
        //this.add(platform);

        _mobileHero = new MobileHero("hero", {x:40, y:150, width:80, height:75, jumpHeight:175, jumpAcceleration:5, view:new Quad(80,75,0xFF0000)});
        _mobileHero.chargeVO = _chargeVO;
        add(_mobileHero);
        _mobileHero.body.cbTypes.add(_ballCollisionType);

        view.camera.setUp(_mobileHero, new Rectangle(0, 0, _maps.currentMap.length, _maps.currentMap.height),null , new Point(.25, .05));

        addChild(_chargeMeter);

        addEventListener(Event.ENTER_FRAME, advance);
    }

    private function advance():void
    {
        var pos:int = Math.floor(view.camera.camPos.x)
        var elements:ElementsCollection = _maps.currentMap.getElement(pos)
        for( var i:uint = 0; i<elements.elements.length; i++)
        {
            var element:LayoutPhysicsElement = elements.elements[i];
            var objToAdd:NapePhysicsObject = ItemsValidator.validateItem(element)
            add(objToAdd);

            if(element.type == LayoutElements.COLLECTIBLE)
            {
                objToAdd.body.cbTypes.add(_wallCollisionType);
            }

            if(element.type == LayoutElements.COLLECTIBLE_TYPE_1)
            {
                objToAdd.body.cbTypes.add(_wallCollisionType);
            }
        };
    }


    private function _collectibleCreation(tEvt:TimerEvent):void {

        var random:uint = Math.random() * 5;

        if (random > 1) {

            var objSize:int = getCollectibleSize();
            var obj:NapePhysicsObject = new NapePhysicsObject("o1", {x:_mobileHero.x + 500, y:0, width:objSize, height:objSize, view:new Quad(objSize,objSize,0xFF0000)});
            add(obj);
            obj.body.cbTypes.add(_wallCollisionType);
        }

        if ( random > 2) {
            var wall:Wall = new Wall(_mobileHero.x + 300, 200, 2, 3, 30, 30, 10);
            for(var i:uint = 0; i<wall.objects.length; i++)
            {
                add(wall.objects[i]);
                wall.objects[i].body.cbTypes.add(_obstacleCollistionType);
//                wall.objects[i].body.mass = 100;
            }
        }

        if (random > 3) {
            var house:House = new House(_mobileHero.x + 300, 200);
            for(var j:uint = 0; j<house.objects.length; j++)
            {
//                add(house.objects[j]);
            }
        }
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

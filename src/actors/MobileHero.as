package actors {

import VO.ChargeVO;

import citrus.objects.platformer.nape.Hero;

import input.MobileInput;

import nape.geom.Vec2;

/**
 * @author Aymeric
 */
public class MobileHero extends Hero {

    public var jumpDecceleration:Number = 7;
    public var charging:Boolean = false;
    public var chargeVO:ChargeVO;

    private var _prevState:Boolean = false;
    private var _bouncing:Boolean = false;

    private var _mobileInput:MobileInput;

    public function MobileHero(name:String, params:Object = null) {

        super(name, params);

        _mobileInput = new MobileInput();
        _mobileInput.initialize();
    }

    override public function destroy():void {

        _mobileInput.destroy();

        super.destroy();
    }

    override public function update(timeDelta:Number):void {

        if(_body.velocity.x <= 0 && _body.velocity.x > -1.8)
        {
            _bouncing = false;
            _body.velocity.x = 100;
        }
        if(!_bouncing) {
            var velocity:Vec2 = _body.velocity;

            velocity.x = 100;

            if (!_mobileInput.screenTouched) {

                velocity.x = 100;
                charging = false;

                this.body.mass = .5;

                if (_onGround) {

                    velocity.y = -jumpHeight;
                    _onGround = false;

                } else if (velocity.y < 0)
                    velocity.y -= jumpAcceleration;
                else
                    velocity.y -= jumpDecceleration;
            }
            else {
                if (chargeVO.chargeCurrentValue > 0) {
                    this.body.mass = 50;
                    velocity.x = 200;
                    charging = true;
                }
            }

            _body.velocity = velocity;

            notifyChargeToggle();
            _updateAnimation();
        }
    }

    public function bounceBack():void
    {
          _bouncing = true;
//        var dx:Number = _body.position.x - 100;
//        var dy:Number = _body.position.y - 100;
//
//        var impulse:Vec2 = Vec2.weak(dx, dy);
//        impulse.length = 50;
//        _body.applyImpulse(impulse);
    }

    private function _updateAnimation():void {

        if (_mobileInput.screenTouched) {

            _animation = _body.velocity.y < 0 ? "jump" :  "ascent";

        } else if (_onGround)
            _animation = "fly";
        else
            _animation = "descent";
    }

    private function notifyChargeToggle():void
    {
        if(_prevState != charging)
        {
            _prevState = charging;
            EngineSingleton.instance.signalsManager.dispatchSignal(GameSignals.CHARGING, GameSignals.CHARGING, {isCharging:charging});
        }
    }
}
}
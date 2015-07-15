/**
 * Created by adm on 14.07.15.
 */
package VO {
public class ChargeVO {

    public var chargeMAX:uint = 200;
    public var chargeMIN:uint = 0;
    public var chargeCurrentValue:uint = 200;

    public function ChargeVO() {
    }

    public function consumeCharge(val:uint):void
    {
        if(chargeCurrentValue - val >=  chargeMIN)
        {
            chargeCurrentValue = chargeCurrentValue - val;
        }
    }

    public function fillCharge(val:uint):void
    {
        if(chargeCurrentValue + val <= chargeMAX)
        {
            chargeCurrentValue = chargeCurrentValue + val;
        }
        else
        {
            chargeCurrentValue = chargeMAX;
        }
    }
}
}

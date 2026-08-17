/**
 * Created by 22BoX on 2/10/14.
 */
package buildingTools {

import flash.geom.Point;
import gui.Constant;

public class Camera {

    private const _pos:Point = new Point(0, 0);
    private var _stopCamera:Boolean;
    private var _veloc:Number;

    public function Camera() {

    }

    public function update(p:Point, veloc:Number):void {

        _pos.setTo(p.x, p.y);

        _veloc = veloc * .01;

        if(InGameVars.GAME_CONT.y > InGameVars.GAME_CONT.height) {

            InGameVars.GAME_CONT.y = InGameVars.GAME_CONT.height;

            _stopCamera = true;
        }

        if(_pos.y < Constant.STAGE_HEIGHT * .2 && !_stopCamera) {

            InGameVars.GAME_BACKGROUND.y += 3 + Math.abs(_veloc);
            InGameVars.GAME_CONT.y += 4 + Math.abs(_veloc);
        }

        if(_pos.y > Constant.STAGE_HEIGHT * .6) {

            if(InGameVars.GAME_BACKGROUND.y > InGameVars.GAME_CONT.y && !_stopCamera) {

                InGameVars.GAME_BACKGROUND.y = InGameVars.GAME_CONT.y;

            }
            else InGameVars.GAME_BACKGROUND.y -= 3 + _veloc;

            InGameVars.GAME_CONT.y -= 4 + _veloc;

            _stopCamera = false;

        }

    }


}
}

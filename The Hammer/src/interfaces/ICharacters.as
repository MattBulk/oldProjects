/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/17/14
 * Time: 11:12 AM
 * To change this template use File | Settings | File Templates.
 */
package interfaces {
import nape.phys.Body;
import starling.display.Sprite;

public interface ICharacters {

    function textures():void;
    function createPhysicBody():Body;
    function jump():String;
    function jumpMovie():void;
    function move():void;
    function idle():void;
    function die():void;
    function landing():void;
    function falling():void;
    function attack():void;
    function get movie():Sprite;


    }
}

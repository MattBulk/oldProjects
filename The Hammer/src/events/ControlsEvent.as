/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 1/17/14
 * Time: 5:42 PM
 * To change this template use File | Settings | File Templates.
 */
package events {
import starling.events.Event;

public class ControlsEvent extends Event {

    public static const SET_CONTROL:String = "setControl";

    public var params:Object;

    public function ControlsEvent(type:String, _params:Object = null, bubbles:Boolean=false)
    {
        super(type, bubbles);
        this.params = _params;
    }
}
}

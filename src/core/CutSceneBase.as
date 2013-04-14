/**
 * Created with IntelliJ IDEA.
 * User: La
 * Date: 10.04.13
 * Time: 11:21
 * To change this template use File | Settings | File Templates.
 */
package core {
import flash.events.EventDispatcher;

public class CutSceneBase extends EventDispatcher{
    public static const IDLE_STATE:String = "idleState";
    public static const PLAY_STATE:String = "playState";
    public static const COMPLETE_STATE:String = "completeState";

    protected var _id:int;
    protected var _name:String;

    protected var _onCompleteCb:Function;

    protected var _state:String = IDLE_STATE;

    public function CutSceneBase() {
        init();
    }

    protected function init():void {
    }

    public function start():void{
        if(!isCompleted)
            beginAction();
    }

    public function stop():void{
        _state = IDLE_STATE;
    }

    public function forceComplete():void{
        onComplete(this);
    }

    protected function beginAction():void {
        _state = PLAY_STATE;
    }

    protected function onComplete(scene:CutSceneBase):void{
         if(!isCompleted)
            endAction(scene);
    }

    protected function endAction(scene:CutSceneBase):void {
        _state = COMPLETE_STATE;

        if(_onCompleteCb)
            _onCompleteCb(scene);
    }


    public function get isPlaying():Boolean {
        return _state == PLAY_STATE;
    }

    public function get isCompleted():Boolean {
        return _state == COMPLETE_STATE;
    }

    public function get isIdle():Boolean{
        return _state == IDLE_STATE;
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function get id():int {
        return _id;
    }

    public function set id(value:int):void {
        _id = value;
    }

//    override public function toString():String{
//        return "{ class: " + (this as Object).constructor + ", id: " + _id + ", name: " + _name + ", state: " + _state + " }";
//    }

    override public function toString():String{
        return "{ " + _name + ", " +_state + " }";
    }

    public function get onCompleteCb():Function {
        return _onCompleteCb;
    }

    public function set onCompleteCb(value:Function):void {
        _onCompleteCb = value;
    }
}
}

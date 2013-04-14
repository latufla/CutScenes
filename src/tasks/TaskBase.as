/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.04.13
 * Time: 15:02
 * To change this template use File | Settings | File Templates.
 */
package tasks {
public class TaskBase {

    public static const PLAY_STATE:String = "playState";
    public static const STOP_STATE:String = "stopState";
    public static const SKIP_STATE:String = "skipState";
    public static const COMPLETE_STATE:String = "completeState";

    protected var _id:int;
    protected var _name:String;
    protected var _state:String = STOP_STATE;

    protected var _onProgressCb:Function;
    protected var _onCompleteCb:Function;

    public function TaskBase() {
        init();
    }

    protected function init():void {
    }

    public function start():void{
        _state = PLAY_STATE;
    }

    public function stop():void{
        _state = STOP_STATE;
    }

    public function skip():void{
        _state = SKIP_STATE;
    }

    public function complete():void{
        _state = COMPLETE_STATE;

        if(_onCompleteCb)
            _onCompleteCb(this);
    }

    protected function onProgress(t:TaskBase):void{
        if(_onProgressCb)
            _onProgressCb(t);
    }

    public function get onProgressCb():Function {
        return _onProgressCb;
    }

    public function set onProgressCb(value:Function):void {
        _onProgressCb = value;
    }

    public function get onCompleteCb():Function {
        return _onCompleteCb;
    }

    public function set onCompleteCb(value:Function):void {
        _onCompleteCb = value;
    }

    public function get id():int {
        return _id;
    }

    public function set id(value:int):void {
        _id = value;
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function get isStarted():Boolean {
        return _state == PLAY_STATE;
    }

    public function get isCompleted():Boolean {
        return _state == COMPLETE_STATE;
    }

    public function get isStopped():Boolean{
        return _state == STOP_STATE;
    }

    public function get isSkipped():Boolean{
        return _state == SKIP_STATE;
    }

    public function get skippedOrCompleted():Boolean{
        return isSkipped || isCompleted;
    }

    public function toString():String{
        return "{ " + _name + ", " +_state + " }";
    }
}
}

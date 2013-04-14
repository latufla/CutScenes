/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.04.13
 * Time: 15:32
 * To change this template use File | Settings | File Templates.
 */
package tasks {
import core.CutSceneBase;

import flash.display.MovieClip;

import flash.events.Event;

import utils.VectorHelper;

public class MultipartTask extends TaskBase{

    protected var _tasks:Vector.<TaskBase>;
    private var _prevCompletedTasks:Vector.<TaskBase> = new Vector.<TaskBase>();

    private var _efBroadcaster:MovieClip;

    public function MultipartTask(efBroadcaster:MovieClip) {
        super();
        _efBroadcaster = efBroadcaster;
    }

    override protected function init():void {
        super.init();

        _tasks = new Vector.<TaskBase>();
    }

    override public function start():void{
        if(_tasks.length != 0){
            startSimulation();
            super.start();
        }
    }

    override public function stop():void{
        stopSimulation();

        _tasks.forEach(function(item:TaskBase, index:int, vector:Vector.<TaskBase>):void {
            item.stop();
        });

        super.stop();
    }

    override public function skip():void{
        stopSimulation();

        _tasks.forEach(function(item:TaskBase, index:int, vector:Vector.<TaskBase>):void {
            if(!item.skippedOrCompleted)
                item.skip();
        });

        super.skip();
    }

    override public function complete():void{
        stopSimulation();

        _tasks.forEach(function(item:TaskBase, index:int, vector:Vector.<TaskBase>):void {
            if(!item.skippedOrCompleted)
                item.complete();
        });

        super.complete();
    }


    public function doStep(e:Event = null):void{
        onProgress(this);
    }

    override protected function onProgress(t:TaskBase):void{
        var cTasks:Vector.<TaskBase> = skippedOrCompletedTasks;

        _prevCompletedTasks.forEach(function(item:TaskBase, index:int, vector:Vector.<TaskBase>):void {
            VectorHelper.removeElement(cTasks, item);
        });

        if(cTasks.length > 0){
            _prevCompletedTasks = cTasks.concat();
            cTasks.forEach(applyOnProgress);
        }
    }


    public function add(s:TaskBase):void{
        if(!shouldAdd(s))
            return;

        _tasks.push(s);
        s.onProgressCb = _onProgressCb;
    }

    public function removeScene(s:TaskBase):void{
        if(!shouldAdd(s))
            return;

        VectorHelper.removeElement(_tasks, s);
        s.onProgressCb = null;
    }


    public function get skippedOrCompletedTasks():Vector.<TaskBase>{
        return _tasks.filter(function(item:TaskBase, index:int, vector:Vector.<TaskBase>):Boolean {
            return item.skippedOrCompleted;
        });
    }

    override public function toString():String{
        return "{" + super.toString() + "\n tasks: " + _tasks + "}";
    }

    private function shouldAdd(s:TaskBase):Boolean{
        return s && s.isStopped;
    }

    private function applyOnProgress(item:TaskBase, index:int, vector:Vector.<TaskBase>):void{
        super.onProgress(item);
    }

    private function startSimulation():void{
        if(_efBroadcaster);
            _efBroadcaster.addEventListener(Event.ENTER_FRAME, doStep);
    }

    private function stopSimulation():void{
        if(_efBroadcaster);
            _efBroadcaster.removeEventListener(Event.ENTER_FRAME, doStep);
    }
}
}

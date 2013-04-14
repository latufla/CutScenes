/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.04.13
 * Time: 17:11
 * To change this template use File | Settings | File Templates.
 */
package tasks {
import flash.display.MovieClip;
import flash.events.Event;

public class ParallelMultipartTask extends MultipartTask{

    private var _firstCompleted:Boolean;

    public function ParallelMultipartTask(efBroacaster:MovieClip, firstCompleted:Boolean = false) {
        super(efBroacaster);
        _firstCompleted = firstCompleted;
    }

    override public function start():void{
        _tasks.forEach(function(item:TaskBase, index:int, vector:Vector.<TaskBase>):void {
            item.start();
        });

        super.start();
    }

    override public function doStep(e:Event = null):void{
        super.doStep(e);

        var cTasks:Vector.<TaskBase> = skippedOrCompletedTasks;

        if(cTasks.length == 0)
            return;

        if(_firstCompleted){
            applyFirstCompleted();
        } else if(cTasks.length == _tasks.length){
            complete();
        }
    }

    private function applyFirstCompleted():void {
        _tasks.forEach(function(item:TaskBase, index:int, vector:Vector.<TaskBase>):void {
            if(!item.skippedOrCompleted)
                item.skip();
        });

        complete();
    }

}
}

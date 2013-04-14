/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.04.13
 * Time: 15:48
 * To change this template use File | Settings | File Templates.
 */
package tasks {
import flash.display.MovieClip;
import flash.events.Event;

public class QueueMultipartTask extends MultipartTask{

    private var _curTaskId:int = -2;

    public function QueueMultipartTask(efBroadcaster:MovieClip) {
        super(efBroadcaster);
    }

    override public function doStep(e:Event = null):void{
        super.doStep(e);

        var id:int = nextTaskId;
        if(id == -1){
            complete();
            return;
        }

        if(id != _curTaskId){
            _tasks[id].start();
            _curTaskId = id;
        }
    }

    private function get nextTaskId():int{
        var n:uint = _tasks.length;
        for (var i:uint = 0; i < n; i++) {
            if(!_tasks[i].skippedOrCompleted)
                return i;
        }
        return -1;
    }
}
}

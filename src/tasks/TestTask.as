/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.04.13
 * Time: 16:37
 * To change this template use File | Settings | File Templates.
 */
package tasks {
import flash.display.MovieClip;

// emulate ur task here
public class TestTask extends TaskBase{

    private static var _dispatcher:MovieClip = new MovieClip();
    public function TestTask() {
        super();
    }

    override public function start():void{
        complete();
    }


    public static function run():void{
//        traceSimpleOps(simpleQueue);
//        traceSimpleOps(queueWithQueues);
//        traceSimpleOps(simpleParallel);
//        traceSimpleOps(parallelWithParallels);
        traceSimpleOps(unlockClusterSceneGap);
    }


    private static function testOnProgress(t:TaskBase):void{
        trace("progress: ", t);
    }

    private static function testOnComplete(t:TaskBase):void{
        trace("complete: ", t);
    }

    private static function traceSimpleOps(task:MultipartTask):void {
        trace("//-----------------------------------------------------");
        trace("task : ", task);
        task.start();
        trace("//-----------------------------------------------------");
    }

    private static function get simpleQueue():QueueMultipartTask{
        var task1:TestTask = new TestTask();
        task1.name = "task 1";

        var task2:TestTask = new TestTask();
        task2.name = "task 2";

        var mTask:QueueMultipartTask = new QueueMultipartTask(_dispatcher);
        mTask.name = "mTask";
        mTask.onProgressCb = testOnProgress;
        mTask.onCompleteCb = testOnComplete;

        mTask.add(task1);
        mTask.add(task2);


        return mTask;
    }

    private static function get queueWithQueues():QueueMultipartTask{
        var st1:TestTask = new TestTask();
        st1.name = "st1";

        var st2:TestTask = new TestTask();
        st2.name = "st2";

        var qt1:QueueMultipartTask = new QueueMultipartTask(_dispatcher);
        qt1.name = "qt1";
        qt1.add(st1);
        qt1.add(st2);


        var st3:TestTask = new TestTask();
        st3.name = "st3";

        var st4:TestTask = new TestTask();
        st4.name = "st4";

        var qt2:QueueMultipartTask = new QueueMultipartTask(_dispatcher);
        qt2.name = "qt2";
        qt2.add(st3);
        qt2.add(st4);


        var qt3:QueueMultipartTask = new QueueMultipartTask(_dispatcher);
        qt3.name = "qt3";
        qt3.onProgressCb = testOnProgress;
        qt3.onCompleteCb = testOnComplete;

        qt3.add(qt1);
        qt3.add(qt2);

        return qt3;
    }

    private static function get simpleParallel():ParallelMultipartTask{
        var st1:TaskBase = new TaskBase();
        st1.name = "st1";

        var st2:TestTask = new TestTask();
        st2.name = "st2";

        var pt1:ParallelMultipartTask = new ParallelMultipartTask(_dispatcher, true);
        pt1.name = "pt1";
        pt1.onProgressCb = testOnProgress;
        pt1.onCompleteCb = testOnComplete;

        pt1.add(st1);
        pt1.add(st2);

        return pt1;
    }

    private static function get parallelWithParallels():ParallelMultipartTask{
        var st1:TaskBase = new TaskBase();
        st1.name = "st1";

        var st2:TaskBase = new TaskBase();
        st2.name = "st2";

        var qt1:ParallelMultipartTask = new ParallelMultipartTask(_dispatcher, false);
        qt1.name = "qt1";
        qt1.add(st1);
        qt1.add(st2);


        var st3:TaskBase = new TaskBase();
        st3.name = "st3";

        var st4:TestTask = new TestTask();
        st4.name = "st4";

        var qt2:ParallelMultipartTask = new ParallelMultipartTask(_dispatcher, true);
        qt2.name = "qt2";
        qt2.add(st3);
        qt2.add(st4);


        var qt3:ParallelMultipartTask = new ParallelMultipartTask(_dispatcher,true);
        qt3.name = "qt3";
        qt3.onProgressCb = testOnProgress;
        qt3.onCompleteCb = testOnComplete;

        qt3.add(qt1);
        qt3.add(qt2);

        return qt3;
    }


    //  || - parallel, -> - next
    // (s1 || s2 -> s3 || s4) || s5
    private static function get unlockClusterSceneGap():ParallelMultipartTask{
        var s1:TestTask = new TestTask();
        s1.name = "s1";
        var s2:TaskBase = new TaskBase();
        s2.name = "s2";
        var ps1:ParallelMultipartTask =  new ParallelMultipartTask(_dispatcher, true);
        ps1.name  ="ps1";
        ps1.add(s1);
        ps1.add(s2);

        var s3:TestTask = new TestTask();
        s3.name = "s3";
        var s4:TestTask = new TestTask();
        s4.name = "s4";
        var ps2:ParallelMultipartTask =  new ParallelMultipartTask(_dispatcher, false);
        ps2.name  ="ps2"
        ps2.add(s3);
        ps2.add(s4);

        var qs1:QueueMultipartTask = new QueueMultipartTask(_dispatcher);
        qs1.name = "qs1";
        qs1.add(ps1);
        qs1.add(ps2);

        var s5:TaskBase = new TaskBase();
        s5.name = "s5";

        var ps3:ParallelMultipartTask = new ParallelMultipartTask(_dispatcher, true);
        ps3.name = "ps3";
        ps3.onCompleteCb = testOnComplete;
        ps3.onProgressCb = testOnProgress;
        ps3.add(qs1);
        ps3.add(s5);
        return ps3;
    }

}
}

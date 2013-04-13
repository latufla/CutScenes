/**
 * Created with IntelliJ IDEA.
 * User: La
 * Date: 10.04.13
 * Time: 15:14
 * To change this template use File | Settings | File Templates.
 */
package core {
import flash.utils.getTimer;
import flash.utils.setTimeout;

// test tool

public class TestCutScene extends CutSceneBase{
    public function TestCutScene() {
        super();
    }

    override public function start():void{
        onComplete(this);
    }

    public static function runSimpleNonAssertTests():void{
        traceSimpleOps(queued);
        traceSimpleOps(parallel);
        traceSimpleOps(queuedWithParallels);
        traceSimpleOps(parallelWithQueueds);
        traceSimpleOps(unlockClusterSceneGap);
//        traceExecutionTime(unlockClusterSceneGap, 100);
    }

    private static function traceSimpleOps(scene:CutSceneBase):void {
        trace("//-----------------------------------------------------");
        trace("mQCScene", scene);
        scene.start();
        trace("mQCScene start", scene);
        scene.stop();
        trace("mQCScene stop", scene);
        trace("//-----------------------------------------------------");
    }

    private static function traceExecutionTime(scene:CutSceneBase, times:uint = 100, delay:Number = 7000):void{
        setTimeout(function(){
            for (var i:uint = 0; i < times; i++){
                var t:Number = getTimer();
                scene.start();
                trace(getTimer() - t);
                scene.stop();
            }
        }, delay);
    }

    private static function get queued():QueuedCutScene{
        var s1:TestCutScene = new TestCutScene();
        s1.name = "s1";
        var s2:TestCutScene = new TestCutScene();
        s2.name = "s2";

        var qs1:QueuedCutScene = QueuedCutScene.create(new <CutSceneBase>[s1, s2]);
        qs1.name = "qs1";
        qs1.onCompleteCb = onCompleteTest;
        qs1.onProgressCb = onProgressTest;
        return qs1;
    }

    private static function get parallel():ParallelCutScene{
        var s1:TestCutScene = new TestCutScene();
        s1.name = "s1";
        var s2:TestCutScene = new TestCutScene();
        s2.name = "s2";

        var ps1:ParallelCutScene = ParallelCutScene.create(new <CutSceneBase>[s1, s2], true);
        ps1.name = "ps1";
        ps1.onCompleteCb = onCompleteTest;
        ps1.onProgressCb = onProgressTest;
        return ps1;
    }

    private static function get queuedWithParallels():QueuedCutScene{
        var s1:TestCutScene = new TestCutScene();
        s1.name = "s1";
        var s2:CutSceneBase = new CutSceneBase();
        s2.name = "s2";
        var ps1:ParallelCutScene = ParallelCutScene.create(new <CutSceneBase>[s1,  s2], true);
        ps1.name = "ps1";

        var s3:TestCutScene = new TestCutScene();
        s3.name = "s3";
        var s4:CutSceneBase = new CutSceneBase();
        s4.name = "s4";
        var ps2:ParallelCutScene = ParallelCutScene.create(new <CutSceneBase>[s3,  s4], true);
        ps2.name = "ps2";

        var qs1:QueuedCutScene = QueuedCutScene.create(new <CutSceneBase>[ps1, ps2]);
        qs1.name = "qs1";
        qs1.onCompleteCb = onCompleteTest;
        qs1.onProgressCb = onProgressTest;
        return qs1;
    }

    private static function get parallelWithQueueds():ParallelCutScene{
        var s1:TestCutScene = new TestCutScene();
        s1.name = "s1";
        var s2:CutSceneBase = new CutSceneBase();
        s2.name = "s2";
        var qs1:QueuedCutScene = QueuedCutScene.create(new <CutSceneBase>[s1,  s2]);
        qs1.name  ="qs1";

        var s3:TestCutScene = new TestCutScene();
        s3.name = "s3";
        var s4:TestCutScene = new TestCutScene();
        s4.name = "s4";
        var qs2:QueuedCutScene = QueuedCutScene.create(new <CutSceneBase>[s3,  s4]);
        qs2.name = "qs2";

        var ps1:ParallelCutScene = ParallelCutScene.create(new <CutSceneBase>[qs1,  qs2], true);
        ps1.name = "ps1";
        ps1.onCompleteCb = onCompleteTest;
        ps1.onProgressCb = onProgressTest;
        return ps1;
    }

    //  || - parallel, -> - next
    // (s1 || s2 -> s3 || s4) || s5
    private static function get unlockClusterSceneGap():ParallelCutScene{
        var s1:TestCutScene= new TestCutScene();
        s1.name = "s1";
        var s2:CutSceneBase = new CutSceneBase();
        s2.name = "s2";
        var ps1:ParallelCutScene = ParallelCutScene.create(new <CutSceneBase>[s1,  s2], true);
        ps1.name  ="ps1";

        var s3:TestCutScene = new TestCutScene();
        s3.name = "s3";
        var s4:TestCutScene = new TestCutScene();
        s4.name = "s4";
        var ps2:ParallelCutScene = ParallelCutScene.create(new <CutSceneBase>[s3,  s4]);
        ps2.name  ="ps2"

        var qs1:QueuedCutScene = QueuedCutScene.create(new <CutSceneBase>[ps1, ps2]);
        qs1.name = "qs1";

        var s5:CutSceneBase = new CutSceneBase();
        s5.name = "s5";

        var ps3:ParallelCutScene = ParallelCutScene.create(new <CutSceneBase>[qs1,  s5], true);
        ps3.name = "ps3";
        ps3.onCompleteCb = onCompleteTest;
        ps3.onProgressCb = onProgressTest;
        return ps3;
    }


    private static function onCompleteTest(scene:CutSceneBase):void {
        trace("complete: " +  scene.name);
    }

    private static function onProgressTest(scene:CutSceneBase):void {
        trace("progress: " +  scene.name);
    }
}
}

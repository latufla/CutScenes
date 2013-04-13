/**
 * Created with IntelliJ IDEA.
 * User: La
 * Date: 10.04.13
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package core {
import utils.VectorHelper;

//TODO: seems a lot like nq.utils.task.TaskQueue
public class QueuedCutScene extends CutSceneBase{

    // TODO: add onProgressCb
    private var _scenes:Vector.<CutSceneBase>;

    public function QueuedCutScene() {
        super();
    }

    public static function create(scenes:Vector.<CutSceneBase>):QueuedCutScene{
        var mCS:QueuedCutScene = new QueuedCutScene();
        if(scenes){
            scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
                mCS.addScene(item);
            });
        }
        return mCS;
    }

    override protected function init():void{
        _scenes = new Vector.<CutSceneBase>();
    }


    override protected function beginAction():void {
        if(_scenes.length == 0){
            onComplete(this);
            return;
        }

        resume();
    }

    override protected function endAction(scene:CutSceneBase):void {
        if(!resume())
            super.endAction(this);
    }

    // to first
    override public function stop():void{
        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.stop();
        });

        super.stop();
    }

    override public function skip():void{
        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.skip();
        });

        super.skip();
    }

    // TODO: think about throw errors
    public function addScene(s:CutSceneBase):void{
        if(!shouldAddScene(s))
            return;

        _scenes.push(s);
        s.onCompleteCb = onComplete;
    }

    public function removeScene(s:CutSceneBase):void{
        if(!shouldAddScene(s))
            return;

        s.stop();
        VectorHelper.removeElement(_scenes, s);
        s.onCompleteCb = null;
    }

    // uncomment and test if need
    // on current
//    public function pause():void{
//        var id:int = curPlayingSceneId;
//        if(id == -1)
//            return;
//
//        super.stop();
//        _scenes[id].stop();
//    }

    // from current
    protected function resume():Boolean{
        var id:int = nextSceneToPlayId;
        if(id == -1)
            return false;

        super.beginAction();
        _scenes[id].start();
        return true;
    }

    // if there is some incomplete scene
    protected function get nextSceneToPlayId():int{
        for (var i:uint = 0; i < _scenes.length; i++) {
            if(!_scenes[i].isCompleted)
                return i;
        }

        return -1;
    }

    // if there is some playing scene
    protected function get curPlayingSceneId():int{
        for (var i:uint = 0; i < _scenes.length; i++) {
            if(_scenes[i].isPlaying)
                return i;
        }

        return -1;
    }

    private function shouldAddScene(s:CutSceneBase):Boolean{
        return isIdle && s && s.isIdle;
    }

    override public function toString():String{
        return "{" + super.toString() + "\n scenes: " + _scenes + "}";
    }
}
}





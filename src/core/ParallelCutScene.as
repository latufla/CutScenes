/**
 * Created with IntelliJ IDEA.
 * User: La
 * Date: 10.04.13
 * Time: 13:57
 * To change this template use File | Settings | File Templates.
 */
package core {
import utils.VectorHelper;

public class ParallelCutScene extends CutSceneBase{

    private var _firstCompleted:Boolean; // completes when first parallel completed
    private var _scenes:Vector.<CutSceneBase>;

    public function ParallelCutScene(firstCompleted:Boolean = false) {
        super();
        _firstCompleted = firstCompleted;
    }

    public static function create(scenes:Vector.<CutSceneBase>, firstCompleted:Boolean = false):ParallelCutScene{
        var mCS:ParallelCutScene = new ParallelCutScene(firstCompleted);
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

    public function addScene(s:CutSceneBase):void{
        if(!shouldAddScene(s))
            return;

        _scenes.push(s as CutSceneBase);
        s.onCompleteCb = onComplete;
    }

    public function removeScene(s:CutSceneBase):void{
        if(!shouldAddScene(s))
            return;

        s.stop();
        VectorHelper.removeElement(_scenes, s);
        s.onCompleteCb = null;
    }

    override protected function beginAction():void {
        if(_scenes.length == 0){
            onComplete(this);
            return;
        }

        super.beginAction();

        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.start();
        });
    }

   override protected function endAction(scene:CutSceneBase):void {
        if(_firstCompleted)
            applyFirstCompleted();
        else
            applyAllCompleted();
   }

    override public function stop():void{
        super.stop();

        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.stop();
        });
    }

    override public function skip():void{
        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.skip();
        });

        super.skip();
    }

    private function applyFirstCompleted():void {
        super.endAction(this);

        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.skip();
        });
    }

    private function applyAllCompleted():void {
        var incompletedScenes:Vector.<CutSceneBase> = _scenes.filter(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):Boolean {
            return !item.isCompleted;
        });

        if(incompletedScenes.length == 0)
            super.endAction(this);
    }


    private function shouldAddScene(s:CutSceneBase):Boolean{
        return isIdle && s && s.isIdle;
    }


    override public function toString():String{
        return "{" + super.toString() + "\n scenes: " + _scenes + "}";
    }
}
}

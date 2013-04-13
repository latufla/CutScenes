/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 13.04.13
 * Time: 15:33
 * To change this template use File | Settings | File Templates.
 */
package core {
import utils.VectorHelper;

public class MultipartCutScene extends CutSceneBase{

    protected var _scenes:Vector.<CutSceneBase>;

    public function MultipartCutScene() {
        super();
    }

    override protected function init():void{
        _scenes = new Vector.<CutSceneBase>();
    }

    override public function start():void{
        if(_scenes.length == 0)
            onComplete(this);
        else
            super.start();
    }

    override public function stop():void{
        super.stop();

        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.stop();
        });
    }

    override public function skip():void{
        super.skip();

        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.skip();
        });
    }

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

    private function shouldAddScene(s:CutSceneBase):Boolean{
        return isIdle && s && s.isIdle;
    }

    override public function toString():String{
        return "{" + super.toString() + "\n scenes: " + _scenes + "}";
    }
}
}

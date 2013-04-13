/**
 * Created with IntelliJ IDEA.
 * User: La
 * Date: 10.04.13
 * Time: 13:57
 * To change this template use File | Settings | File Templates.
 */
package core {

public class ParallelCutScene extends MultipartCutScene{

    private var _firstCompleted:Boolean; // completes when first parallel completed

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

    override protected function beginAction():void {
        super.beginAction();

        _scenes.forEach(function(item:CutSceneBase, index:int, vector:Vector.<CutSceneBase>):void {
            item.start();
        });
    }

   override protected function endAction(scene:CutSceneBase):void {
       if(_onProgressCb)
           _onProgressCb(scene);

        if(_firstCompleted)
            applyFirstCompleted();
        else
            applyAllCompleted();
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
}
}

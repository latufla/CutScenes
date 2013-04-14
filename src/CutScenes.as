/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 13.04.13
 * Time: 11:57
 * To change this template use File | Settings | File Templates.
 */
package {
import core.TestCutScene;

import flash.display.MovieClip;

import flash.display.Sprite;

import tasks.TaskBase;
import tasks.TestTask;

public class CutScenes extends Sprite {


    public static const EF_BROADCASTER:MovieClip = new MovieClip()
    private var _task:TaskBase;
    public function CutScenes() {
//        TestCutScene.runSimpleNonAssertTests();

        TestTask.run();
    }

}
}

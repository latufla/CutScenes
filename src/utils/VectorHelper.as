/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 19:10
 * To change this template use File | Settings | File Templates.
 */
package utils {
public class VectorHelper {

    public static function removeElement(v:*, e:*):void{
        if(!v)
            return;

        var idx:int = v.indexOf(e);
        if(idx != -1)
            v.splice(idx, 1);
    }

}
}

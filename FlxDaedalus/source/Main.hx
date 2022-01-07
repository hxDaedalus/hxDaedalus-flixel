package;
import flixel.FlxGame;
import openfl.display.Sprite;
enum DaedalusDemos {
    BASIC;
    FINDING;
    MAZE;
}
class Main extends Sprite {
    var currentDemo = MAZE;
    public function new(){
        super();
        switch( currentDemo ){
            case BASIC:
                addChild( new FlxGame( 0, 0, Basic ) );
            case FINDING:
                addChild( new FlxGame( 0, 0, Pathfinding ) );
            case MAZE:
                addChild( new FlxGame( 0, 0, PathfindingMaze ) );
        }
    }
}

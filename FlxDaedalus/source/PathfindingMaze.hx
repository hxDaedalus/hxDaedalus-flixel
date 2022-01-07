package;

import flixel.FlxState;
import flixel.FlxG;
import hxDaedalus.GridMaze;

import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.math.RandGenerator;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.flx.View;

class PathfindingMaze extends FlxState {
    var _mesh: Mesh;
    var _view: View;
    var _viewEntity: View;
    var _entity: View;
    var _entityAI : EntityAI;
    var _pathfinder : PathFinder;
    var _path : Array<Float>;
    var _pathSampler : LinearPathSampler;
    var _newPath:Bool = false;
    var x: Float = 0;
    var y: Float = 0;
    var rows: Int = 15;
    var cols: Int = 15;
    
    override public function create(){
        super.create();
        _view = new View( 0, 0 );
        _viewEntity = new View( 0, 0 );
        add( _view );
        add( _viewEntity );
        // build a rectangular 2 polygons mesh of 600x600
        _mesh = RectMesh.buildRectangle(600, 600);
        GridMaze.generate(600, 600, cols, rows);
        _mesh.insertObject(GridMaze.object);
        _view.constraintsWidth = 4;
        // we need an entity
        _entityAI = new EntityAI();
        // set radius as size for your entity
        _entityAI.radius = GridMaze.tileWidth * .3;
        // set a position
        _entityAI.x = GridMaze.tileWidth / 2;
        _entityAI.y = GridMaze.tileHeight / 2;
        // now configure the pathfinder
        _pathfinder = new PathFinder();
        _pathfinder.entity = _entityAI;  // set the entity
        _pathfinder.mesh = _mesh;  // set the mesh
        // we need a vector to store the path
        _path = new Array<Float>();
        // then configure the path sampler
        _pathSampler = new LinearPathSampler();
        _pathSampler.entity = _entityAI;
        _pathSampler.samplingDistance = GridMaze.tileWidth * .7;
        _pathSampler.path = _path;
    }
    function reset(newMaze:Bool = false):Void {
        var seed = Std.int(Math.random() * 10000 + 1000);
        if( newMaze ) {
            _mesh = RectMesh.buildRectangle(600, 600);
            GridMaze.generate(600, 600, 30, 30, seed);
            GridMaze.object.scaleX = .92;
            GridMaze.object.scaleY = .92;
            GridMaze.object.x = 23;
            GridMaze.object.y = 23;
            _mesh.insertObject(GridMaze.object);
        }
        _entityAI.radius = GridMaze.tileWidth * .27;
        _pathSampler.samplingDistance = GridMaze.tileWidth * .7;
        _pathfinder.mesh = _mesh;
        _entityAI.x = GridMaze.tileWidth / 2;
        _entityAI.y = GridMaze.tileHeight / 2;
        _path = [];
        _pathSampler.path = _path;
    }
    var meshOnce: Bool = false;
    inline function renderDaedalus(){
        // show result mesh on screen
        // only draw first time
        if( !meshOnce ){
            _view.whiteBackground();
            _view.drawMesh( _mesh );
            meshOnce = true;
        }
        if( _newPath ){
            // find path !
            _pathfinder.findPath( x, y, _path );
            // show path on screen
            _viewEntity.drawPath( _path );
             // show entity position on screen
            _viewEntity.drawEntity( _entityAI ); 
            // reset the path sampler to manage new generated path
            _pathSampler.reset();
        }
        // animate !
        if ( _pathSampler.hasNext ) {
            // move entity
            _pathSampler.next();
        }
        // show entity position on screen
        _viewEntity.drawEntity( _entityAI );
    }
    override public function update( elapsed: Float ){
        super.update(elapsed);
        if( FlxG.mouse.pressed ){
            // The left mouse button is currently pressed
            x = FlxG.mouse.x;
            y = FlxG.mouse.y;
        }
        if( FlxG.mouse.justPressed ){
            // The left mouse button has just been pressed
            x = FlxG.mouse.x;
            y = FlxG.mouse.y;
            _newPath = true;
        }

        if( FlxG.mouse.justReleased ){
            // The left mouse button has just been released
            x = FlxG.mouse.x;
            y = FlxG.mouse.y;
            _newPath = false;
        }
        _viewEntity.clear();
        renderDaedalus();
    }
}
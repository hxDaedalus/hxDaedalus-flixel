package;

import flixel.FlxState;
import flixel.FlxG;

import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.math.RandGenerator;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.factories.RectMesh;

import hxDaedalus.flx.View;

class Pathfinding extends FlxState {
    var _mesh : Mesh;
    var _view : View;
    var _viewEntity: View;
    var _entityAI : EntityAI;
    var _pathfinder : PathFinder;
    var _path : Array<Float>;
    var _pathSampler : LinearPathSampler;
    var _newPath:Bool = false;
    var x: Float = 0;
    var y: Float = 0;

    override public function create(){
        super.create();
        // create viewports
        _view = new View( 0, 0 );
        add( _view );
        _viewEntity = new View( 0, 0 );
        add( _viewEntity );
        // build a rectangular 2 polygons mesh of 600x600
        _mesh = RectMesh.buildRectangle(600, 600);
        // pseudo random generator
        var randGen : RandGenerator;
        randGen = new RandGenerator();
        randGen.seed = 7259;  // put a 4 digits number here
        // populate mesh with many square objects
        var object : Object;
        var shapeCoords : Array<Float>;
        for (i in 0...50){
            object = new Object();
            shapeCoords = new Array<Float>();
            shapeCoords = [ -1, -1, 1, -1,
                             1, -1, 1, 1,
                            1, 1, -1, 1,
                            -1, 1, -1, -1];
            object.coordinates = shapeCoords;
            randGen.rangeMin = 10;
            randGen.rangeMax = 40;
            object.scaleX = randGen.next();
            object.scaleY = randGen.next();
            randGen.rangeMin = 0;
            randGen.rangeMax = 1000;
            object.rotation = (randGen.next() / 1000) * Math.PI / 2;
            randGen.rangeMin = 50;
            randGen.rangeMax = 600;
            object.x = randGen.next();
            object.y = randGen.next();
            _mesh.insertObject(object);
        }
        // we need an entity
        _entityAI = new EntityAI();
        // set radius as size for your entity
        _entityAI.radius = 4;
        // set a position
        _entityAI.x = 20;
        _entityAI.y = 20;
        // now configure the pathfinder
        _pathfinder = new PathFinder();
        _pathfinder.entity = _entityAI;  // set the entity
        _pathfinder.mesh = _mesh;  // set the mesh
        // we need a vector to store the path
        _path = new Array<Float>();
        // then configure the path sampler
        _pathSampler = new LinearPathSampler();
        _pathSampler.entity = _entityAI;
        _pathSampler.samplingDistance = 10;
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
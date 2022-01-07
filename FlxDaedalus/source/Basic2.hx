package;

import flixel.FlxState;

import cornerContour.io.Array2DTriangles;
import hxDaedalus.data.ConstraintSegment;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.data.Vertex;
import hxDaedalus.factories.RectMesh;
//import hxDaedalus.flx.View;
import cornerContour.flx.FlxView;
import cornerContour.ai.ContourDaedalus;
import cornerContour.StyleSketch;
import cornerContour.StyleEndLine;

class Basic2 extends FlxState {
    
    var _mesh:      Mesh;
    var _view:      ContourDaedalus;
    var _flxView:   FlxView;
    var _object:    Object;
    
    override public function create(){
        super.create();
        _flxView = new FlxView( 0, 0, StyleSketch.Crude, StyleEndLine.no );
        add( _flxView );
        _view = new ContourDaedalus();
        // build a rectangular 2 polygons mesh of 600x400
         _mesh = RectMesh.buildRectangle(600, 400);
         // SINGLE VERTEX INSERTION / DELETION
         // insert a vertex in mesh at coordinates (550, 50)
         var vertex : Vertex = _mesh.insertVertex(550, 50);
        
         // SINGLE CONSTRAINT SEGMENT INSERTION / DELETION
         // insert a segment in mesh with end points (70, 300) and (530, 320)
         var segment : ConstraintSegment = _mesh.insertConstraintSegment(70, 300, 530, 320);
        
         // CONSTRAINT SHAPE INSERTION / DELETION
         // insert a shape in mesh (a crossed square)
         var shape = _mesh.insertConstraintShape( [
                          50.,  50., 100.,  50.,      /* 1st segment with end points (50, 50) and (100, 50)       */
                         100.,  50., 100., 100.,      /* 2nd segment with end points (100, 50) and (100, 100)     */
                         100., 100.,  50., 100.,      /* 3rd segment with end points (100, 100) and (50, 100)     */
                          50., 100.,  50.,  50.,      /* 4rd segment with end points (50, 100) and (50, 50)       */
                          20.,  50., 130., 100.       /* 5rd segment with end points (20, 50) and (130, 100)      */
                                                 ] );
                                                
         // OBJECT INSERTION / TRANSFORMATION / DELETION
         // insert an object in mesh (a cross)
         var objectCoords : Array<Float> = new Array<Float>();

         _object = new Object();
         _object.coordinates = [ -50.,   0.,  50.,  0.,
                                   0., -50.,   0., 50.,
                                 -30., -30.,  30., 30.,
                                  30., -30., -30., 30.
                                 ];
         _mesh.insertObject( _object );  // insert after coordinates are setted

         // you can transform objects with x, y, rotation, scaleX, scaleY, pivotX, pivotY
         _object.x = 400;
         _object.y = 200;
         _object.scaleX = 2;
         _object.scaleY = 2;
    }   
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
        //_flxView.background( 0xFFFFFFFF );
        _object.rotation += 0.05;
        _mesh.updateObjects();  // don't forget to update
        _flxView.pen2D.pos = 0;
        _flxView.pen2D.arr = new Array2DTriangles();
        _view.drawMesh( _flxView.sketcher, _mesh );
        _flxView.clear();
        _flxView.rearrageDrawData();
    }
}

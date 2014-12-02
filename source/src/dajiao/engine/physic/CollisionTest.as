package dajiao.engine.physic
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.*
	import flash.display.BlendMode;
	
	public class CollisionTest
	{
//		public static function hitTest( target1:DisplayObject, target2:DisplayObject,  accurracy:Number = GameManager.COLLISTION_BITMAP_DEFAULT_ACCURRACY):Boolean
//        {
//        		return complexHitTest( target1, target2, accurracy);
//        }
//        
//        public static function hitTestReturnRec( target1:DisplayObject, target2:DisplayObject,  accurracy:Number = GameManager.COLLISTION_BITMAP_DEFAULT_ACCURRACY):Boolean
//        {
//        	return complexIntersectionRectangle( target1, target2, accurracy );
//        }
        
        public static function hitTest( target1:DisplayObject, target2:DisplayObject, accurracy:Number = GameManager.COLLISTION_BITMAP_DEFAULT_ACCURRACY ):Boolean
        {           
        		var rslt:Boolean = false;       
                var hitRectangle:Rectangle = preTest(target1 , target2 , accurracy) ;
                if( hitRectangle == null ){
                	return false;
                }
//                trace("width:"+hitRectangle.width)
//                trace("width*accurracy:"+hitRectangle.width*accurracy)
//                trace("height:"+hitRectangle.height)
//                trace("height*accurracy:"+hitRectangle.height*accurracy)
                var bitmapData1:BitmapData = new BitmapData( hitRectangle.width * accurracy, hitRectangle.height * accurracy, true, 0 ); 
 				var bitmapData2:BitmapData = bitmapData1.clone();
                // Draw the first target.
                bitmapData1.draw( target1, getDrawMatrix( target1, hitRectangle, accurracy ));
                // Overlay the second target.
                bitmapData2.draw( target2, getDrawMatrix( target2, hitRectangle, accurracy ));
                
                rslt =  bitmapData1.hitTest(new Point(), 255, bitmapData2, new Point(), 255);
                
                /* this.graphics.clear();
                this.graphics.lineStyle(1);
                this.graphics.drawRect(hitRectangle.x-300,hitRectangle.y-300,hitRectangle.width,hitRectangle.height);
                
                this.removeChild(bitmap1)
                this.removeChild(bitmap2)
                bitmap1 = new Bitmap(bitmapData1);
                bitmap2 = new Bitmap(bitmapData2);
                bitmap1.x = 100
                bitmap1.y = 100
                this.addChild(bitmap1);
				this.addChild(bitmap2); */
                
                bitmapData1.dispose();
                bitmapData2.dispose();
                //trace("rslt:"+rslt)
                return rslt;
                
        }
 
        public static function hitTestReturnRec( target1:DisplayObject, target2:DisplayObject, accurracy:Number = GameManager.COLLISTION_BITMAP_DEFAULT_ACCURRACY ):Rectangle
        {           
        	    var hitRectangle:Rectangle = preTest(target1 , target2 , accurracy) ;
                if( hitRectangle == null ){
                	return null;
                }
                
                var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accurracy, hitRectangle.height * accurracy, false, 0x000000 ); 
 
                // Draw the first target.
                bitmapData.draw( target1, getDrawMatrix( target1, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
                // Overlay the second target.
                bitmapData.draw( target2, getDrawMatrix( target2, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );
                
                // Find the intersection.
                var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );
                
                bitmapData.dispose();
                
                if(intersection.width*accurracy < 1){
                	//trace("b")
                	return null;
                }
                
                // Alter width and positions to compensate for accurracy
                if( accurracy != 1 )
                {
                    intersection.x /= accurracy;
                    intersection.y /= accurracy;
                    intersection.width /= accurracy;
                    intersection.height /= accurracy;
                }
                
                intersection.x += hitRectangle.x;
                intersection.y += hitRectangle.y;
                
                return intersection;
        }
        
        private static function preTest(target1:DisplayObject, target2:DisplayObject,accurracy:Number):Rectangle{
        	 if( accurracy <= 0 ) throw new Error( "ArgumentError: Error #5001: Invalid value for accurracy", 5001 );
                
                // If a simple hitTestObject is false, they cannot be intersecting.
                if( !target1.hitTestObject( target2 ) ) return null;
                
                var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
                // If their boundaries are no interesecting, they cannot be intersecting.
                if(hitRectangle == null || hitRectangle.width * accurracy <1 || hitRectangle.height * accurracy <1 ){
                	 return null;
                }	
                
                return  hitRectangle;
        }
        
         private static function intersectionRectangle( target1:DisplayObject, target2:DisplayObject ):Rectangle
        {
            // If either of the items don't have a reference to stage, then they are not in a display list
            // or if a simple hitTestObject is false, they cannot be intersecting.
            if( !target1.root || !target2.root ) return null;
            
            // Get the bounds of each DisplayObject.
            var bounds1:Rectangle = target1.getBounds( target1.root );
            var bounds2:Rectangle = target2.getBounds( target2.root );
            
            // Determine test area boundaries.
            var intersection:Rectangle = new Rectangle();
            intersection.x   = Math.max( bounds1.x, bounds2.x );
            intersection.y    = Math.max( bounds1.y, bounds2.y );
            intersection.width = Math.min( ( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
            intersection.height = Math.min( ( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );
    
            return intersection;
        }
        
        
        private static function getDrawMatrix( target:DisplayObject, hitRectangle:Rectangle, accurracy:Number ):Matrix
        {
                var localToGlobal:Point;;
                var matrix:Matrix;
                
                var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;
                
                localToGlobal = target.localToGlobal( new Point( ) );
                matrix = target.transform.concatenatedMatrix;
                matrix.tx = localToGlobal.x - hitRectangle.x;
                matrix.ty = localToGlobal.y - hitRectangle.y;
                
                matrix.a = matrix.a / rootConcatenatedMatrix.a;
                matrix.d = matrix.d / rootConcatenatedMatrix.d;
                if( accurracy != 1 ) matrix.scale( accurracy, accurracy );
 
                return matrix;
        }
 
       
	}
}
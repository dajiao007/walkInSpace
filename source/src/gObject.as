package
{
	import dajiao.engine.physic.CollisionTest;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class gObject extends MovieClip
	{
		public function gObject()
		{
			var long:Number = width >= height ? width : height;
			_radius = long /2;
		}
		
		public  var oldX:Number;
		public  var oldY:Number;
		protected var _radius:Number;
		protected var _points:Array;
		protected var _baseRadius:Boolean = false;
		public var doTrace:Boolean = true;
		public var thrust : Number=0;
		protected var _vx : Number=0;
		protected var _vy : Number=0;
		public static const mass:uint = 1;
		public var isAutoDrive : Boolean = false;
		public var allowAutoDrive : Boolean = false;
		public var breaking:Boolean = false;
		public var cashedWithSkyObject:Boolean = false;
		public var isMyShip:Boolean = false;
		
		public function get vx():Number{
			return _vx;
		}
		
		public function set vx(vx:Number):void{
			_vx = vx;
		}
		
		public function get vy():Number{
			return _vy;
		}
		
		public function set vy(vy:Number):void{
			_vy = vy;
		}
		
		public function get radius():Number{
			return _radius;
		}
		public function get points():Array{
			return _points;
		}
		public function get baseRadius():Boolean{
			return _baseRadius;
		}
		
//		public function set radius(radius:int):void{
//			 _radius = radius;
//		}
//		public function set points(points:Array):void{
//			 _points = points;
//		}
//		public function set baseRadius(baseRadius:Boolean):void{
//			 _baseRadius = baseRadius;
//		}
		
//		public static function collisionTest(cta1:DisplayObject):int{
//			var rslt:int = 0;
//			if(cta1.baseRadius){
//				rslt = collisionTestBaseRadius(cta1 , cta2 , center);
//			}else if(cta2.baseRadius){
//				rslt = collisionTestBaseRadius(cta2 , cta1 , center);
//			}else{
//			
//			}
//			
//			return rslt;
//		}
		
		public  function collisionTest(dsplObj:DisplayObject,accurracy:Number = GameManager.COLLISTION_BITMAP_DEFAULT_ACCURRACY):int{
			var rslt:int = 0;
			var collision:Boolean = false;
			var smooth:Boolean = true;
			
			collision = CollisionTest.hitTest(this, dsplObj,accurracy);
			if(collision &&  dsplObj is gObject){
				var speedDis:Number = Point.distance(new Point(this.vx,this.vy),new Point(gObject(dsplObj).vx,gObject(dsplObj).vy));
				if(speedDis > AbsShip.MAX_LINE_SPEED * GameManager.COLLISION_SPEED_FACTOR){
					smooth = false;
				}
			}
			
			if(collision){
				rslt = 1;
			}
			if(!smooth){
				rslt = 2;
			}
			//test
//			if(dsplObj is SpaceStation){
//				trace("rslt:"+rslt)
//			}
			
			return rslt;
		}
		
		public function afterCashWithSkyObject():void{
			cashedWithSkyObject = true;
		}
		
	}
}
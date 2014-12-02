package dajiao.engine.geom
{
	import flash.geom.Point;
	
	public class Grahic2D
	{
		public function Grahic2D()
		{
		}
		
		public static function angleOfPoints(p1:Point , p2:Point):Number{
			return pi2angle(Math.atan2(p1.y - p2.y ,p1.x - p2.x));
		}
		
		public static function angleOfPointsXY(p1x:Number ,p1y:Number ,p2x:Number ,p2y:Number ):Number{
			return pi2angle(Math.atan2(p1y - p2y ,p1x - p2x));
		}
		
		public static function pi2angle(pi:Number):Number{
			return pi/Math.PI * 180;
		}

	}
}
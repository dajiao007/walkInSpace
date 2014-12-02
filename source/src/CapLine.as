package
{
	import dajiao.engine.geom.Grahic2D;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class CapLine  extends MovieClip
	{
		public function CapLine(ship:Ship)
		{	
			this.ship = ship;
		}
		
		public static const MAX_LENGTH:int = 35;//15
		
		public static const STATUS_HIDDEN = 0;
		public static const STATUS_FIND = 1;
		public static const STATUS_CONN = 2;
		public var status:int = STATUS_HIDDEN;
		
		
		public var lineReachMaxLength:Boolean = false;
		public var canFetch:Boolean = false;
		public var fetched:Boolean = false;
		public var capture:Capture = null;
		private var ship:Ship = null;
		
		public function get length():Number{
			return this.scaleX ;
		}
		
		public function set length(length:Number):void{
			if(length <= MAX_LENGTH){
				this.scaleX = length;
				lineReachMaxLength = false;
			}else{
				lineReachMaxLength = true;
				this.scaleX = MAX_LENGTH;
			}
		}
		
		public function reDraw():void{
			if(capture == null || status <= STATUS_HIDDEN){
				return ;
			}

			var captureInSpace:Point = capture.getPosInSpace();
			var linePortInSpace:Point = ship.getCaplinePortInSpace(ship.curPortIndex);
			this.x = linePortInSpace.x;
			this.y = linePortInSpace.y;
			var angle:Number = Grahic2D.angleOfPointsXY(captureInSpace.x,captureInSpace.y,linePortInSpace.x,linePortInSpace.y);
			var length:Number = Point.distance(linePortInSpace,new Point(captureInSpace.x,captureInSpace.y));
			if(length > SkyObject.MOON_RADIUS * 2){
				canFetch = true;
			}
			this.rotation = angle ;
			this.length = length;
		}
	}
	
}
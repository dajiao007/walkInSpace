package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class SkyObject extends Sprite
	{
		public var skyObjectName:String = "";
		public var radius:Number ;
		public var mass:uint;
		public var innerCir:Number;
		public var outerCir:Number;

		public static const EARTH_RADIUS:uint = 90;    //25
		public static const EARTH_LOWEST_CIRCLE:uint = 250;
		public static const EARTH_1_CIRCLE:uint = 250;
		public static const EARTH_2_CIRCLE:uint = 300;
		public static const MOON_RADIUS:uint = 50;     //13
		public static const MOON_LOWEST_CIRCLE:uint = 65;
		public static const MOON_1_CIRCLE:uint = 60;
		public static const MOON_2_CIRCLE:uint = 90;
		public static const Earth_SURFACE_A:Number = 0.5;
		
		public static const MAX_DIS:Number = 1300;
		public static const MIN_DIS:Number = SkyObject.MOON_RADIUS + GameManager.SHIP_HALF_HEIGHT;
		
		//public static const G:Number = Earth_SURFACE_A * MIN_DIS * MIN_DIS /(Ship.MAX_LINE_SPEED*Ship.MAX_LINE_SPEED*EARTH_LOWEST_CIRCLE);
		public static const G:Number = 1;
		
		public static const MOON_MASS:uint = Math.pow(AbsShip.MAX_LINE_SPEED,2) * MOON_LOWEST_CIRCLE / G;; //34000000
		public static const EARTH_MASS:Number = Math.pow(AbsShip.MAX_LINE_SPEED,2) * EARTH_LOWEST_CIRCLE / G;//90000000 
		
		
		private var bitMap:Class;
		
		
		public function SkyObject(skyObjectName:String , bitMapClass:Class , radius:Number  , mass:uint  , 
					bitmap:BitmapData , innerCir:Number = 100 , outerCir:Number = 130 )
		{
			this.radius = radius;
			this.mass = mass;
			this.innerCir = innerCir;
			this.outerCir = outerCir;
			this.bitMap = bitMapClass;
			this.skyObjectName = skyObjectName;
//			trace("---20-->Ship.MAX_V_XY_PERSEC:"+Ship.MAX_V_XY_PERSEC);
//			trace("---1-->Ship.MAX_V_XY:"+Ship.MAX_V_XY);
//			trace("----->MAX_V_XY * Math.sqrt(2):"+Ship.MAX_V_XY * Math.sqrt(2));
//			trace("----->Ship.MAX_LINE_SPEED:"+Ship.MAX_LINE_SPEED);
//			trace("----->Math.pow(Ship.MAX_LINE_SPEED,2):"+Math.pow(Ship.MAX_LINE_SPEED,2));
//			trace("----->EARTH_LOWEST_CIRCLE:"+EARTH_LOWEST_CIRCLE);
//			trace("----->G:"+G);
//			trace("----->EARTH_MASS:"+EARTH_MASS);
//			trace("----->EARTH_MASS:"+EARTH_MASS);
			int(bitmap);
		}
		
		
		
		private function int(bitmap:BitmapData):void{
			//var bitmap:Bitmap = new bitMap();
			//bitmap.x = -radius;
			//bitmap.y = -radius;
			this.graphics.lineStyle(1); 
			var mx:Matrix = new Matrix();
			mx.translate(-radius,-radius);
			if(null != bitmap){
				graphics.beginBitmapFill(bitmap,mx,false,true);
			}			
			//this.addChild(bitmap);
			this.graphics.drawCircle(0 , 0 , radius-1);
			if(null != bitmap){
				graphics.endFill();
			}
			this.graphics.lineStyle(1,0x999999,0.6);
			this.graphics.drawCircle(0 , 0 , innerCir);
			this.graphics.drawCircle(0 , 0 , outerCir);
			//this.graphics.drawCircle(0 , 0 , MAX_DIS);
			this.graphics.lineStyle(1,0x990000,0.6);
			this.graphics.drawCircle(0 , 0 , MOON_RADIUS);
			 
		}
	}
}
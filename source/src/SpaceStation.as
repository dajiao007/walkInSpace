package
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class SpaceStation extends AbsShip
	{
		public function SpaceStation(parent:DisplayObjectContainer)
		{
			//draw(1);
			init(parent);
		}
		public var circle:SpaceStationCircle = null
		public var controlShips:Array = new Array();
		public var ports:Array = null;
		public const controlRadius : int = 45;
		public static const SPACESTATION_PORT_ANGLE:Number = -Math.atan(2);
		//private static const LAND_POINTS:Array =[new Point(35,10) , new Point(-35,10)];
		private var landPoints:Array = null;
		
		public  function draw(frame:int):void
		{
			this.gotoAndStop(frame);
		}
		
		private function init(parent:DisplayObjectContainer):void{
			circle = new SpaceStationCircle(this);
			parent.addChild(circle);
			this._points = [new Point(0,-45),new Point(-40,0),new Point(-30,20),new Point(-10,10),new Point(10,10),new Point(30,20),new Point(40,0)];
			this.landPoints = [Point.interpolate(this.points[1],this.points[2],3/5),Point.interpolate(this.points[6],this.points[5],3/5)]
			this._baseRadius = true;
			this._radius = controlRadius;
			
			this.ports = [new Port(this , Point(landPoints[0])) , new Port(this , Point(landPoints[1]))];
		}
		
		public override function  set x(value:Number):void {
			super.x = value
			this.circle.x = value;
		}
		public override function set y(value:Number):void {
			super.y = value
			this.circle.y = value;
		}
		
		public function selectPort(gObj:gObject){
			var port:Port = null;
			var notUsedPorts:Array= new Array();
			for each(var p:Port in ports){
				if(! p.used){
					notUsedPorts.push(p);
				}
			}
			
			var notUsedPortNum:int = notUsedPorts.length;
			if(notUsedPortNum == 1){
				port = notUsedPorts[0];
			}else if(notUsedPortNum > 1){
				var gObjCenter:Point = this.globalToLocal(gObj.localToGlobal(new Point(0,0)));
				if(gObjCenter.x < 0){
					port = ports[0]
				}else{
					port = ports[1]
				}
			}
			
			return port;
		}
		
		
	}
}
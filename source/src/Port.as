package
{
	import flash.geom.Point;
	public class Port
	{
		public function Port(spaceStation:SpaceStation ,landPoint:Point)
		{
			this.owner = spaceStation;
			this.landPoint = landPoint;
			this.pos = getPosByLandPoint();
		}
		
		private var owner:SpaceStation = null;
		public var landPoint:Point = null;
		public var used:Boolean = false; 
		private var pos:Point = null;
		
		private function getPosByLandPoint():Point{
			var angle:Number = 0;
			if(landPoint.x > 0){
				angle =  Math.PI/2 + SpaceStation.SPACESTATION_PORT_ANGLE
			}else if (landPoint.x < 0){
				angle =  Math.PI/2 - SpaceStation.SPACESTATION_PORT_ANGLE
			}
//			trace("landPoint.x"+landPoint.x);
//			trace("landPoint.y"+landPoint.y);
//			trace("pos.x"+landPoint.add(Point.polar(GameManager.SHIP_PORT_DISTANCE , angle)).x);
//			trace("pos.y"+landPoint.add(Point.polar(GameManager.SHIP_PORT_DISTANCE , angle)).y);
			
//			trace("landPoint.x:"+landPoint.x)
//			trace("landPoint.y:"+landPoint.y)
			return landPoint.add(Point.polar(GameManager.SHIP_PORT_DISTANCE , angle));
		}
		
		public function get globePos():Point{
//			trace("pos.x:"+pos.x)
//			trace("pos.y:"+pos.y)
			return owner.localToGlobal(pos);
		}

	}
}
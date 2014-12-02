package
{
	import flash.display.MovieClip;
	
	public class SpaceStationCircle extends gObject
	{
		private var spaceStatoin:SpaceStation = null;
		public function SpaceStationCircle(spaceStatoin:SpaceStation)
		{
			this.spaceStatoin = spaceStatoin;
		}
		
		public override function get vx():Number{
			return spaceStatoin.vx;
		}
		
		public override function get vy():Number{
			return spaceStatoin.vy;
		}

	}
}
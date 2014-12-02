package
{
	import flash.display.MovieClip;
	
	public class EnergyMonitor extends MovieClip
	{
		//public var ep1 : EnegyPanel;
		//public var ep2 : EnegyPanel;
		public function EnergyMonitor(){
			
		}
		
		public function showEnegy(enegy:int){
			var ep2Value :int = Math.floor(enegy / 10);
		    var ep1Value :int = enegy % 10;
		    
			this.ep1.setEnegy(Math.floor(ep1Value / 2));
			this.ep2.setEnegy(ep2Value);
			
			//trace("ep1Value"+ep1Value);
			//trace("ep2Value"+ep2Value);
		}
		
		public function alertNoEnergy():void{
			this.scaleX = 1.1;
			this.scaleY = 1.1;
			this.scaleX = 1;
			this.scaleY = 1;
		}
	}
}
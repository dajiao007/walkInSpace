package
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Capture extends gObject
	{
		public function Capture()
		{
			this.gotoAndStop(1);
			destroyTimer = new Timer(5*1000,1);
			destroyTimer2 = new Timer(1*1000,1);
			destroyTimer.addEventListener(TimerEvent.TIMER,destroy);
			destroyTimer2.addEventListener(TimerEvent.TIMER,destroy);
		}
		
		private static const AIR_DRAG_FACTOR:Number = 0.98;
		
		public var capLine:CapLine = null;
		public var released:Boolean = false;
		public var captured:Boolean = false;
		public var fetched:Boolean = false;
		public var destroyTimer:Timer = null;
		public var destroyTimer2:Timer = null;
		public var girl:Girl = null;

		public function airDrag():void{
			vx*= AIR_DRAG_FACTOR
			vy*= AIR_DRAG_FACTOR
		}
		
		public override function get radius():Number{
			return 1;
		}
		
		public function destroy(event:TimerEvent):void{
			if(captured){
				return
			}
			
			destroyTimer.removeEventListener(TimerEvent.TIMER,destroy);
			destroyTimer2.removeEventListener(TimerEvent.TIMER,destroy);
			var myShip:Ship = God7(root).space.myShip;
			if(myShip != null && myShip.capture == this){
				myShip.capture = null;
			}	
			parent.removeChild(this);
		}
		
		public function drop():void{
			released = true;
			destroyTimer.start();
			this.play();
		}
		
		public function doCapture(girl:Girl):void{
			this.captured = true;
			girl.captured();
			this.girl = girl;
			this.addChild(girl);
			girl.x = 0;
			girl.y = 0;
		}
		
		public override function afterCashWithSkyObject():void{
			super.afterCashWithSkyObject();
			destroyTimer2.start();
		}
		
		public function getPosInSpace():Point{
			var pInSpace:Point = null;
			if(released){
				if(!fetched){
					pInSpace = new Point(x,y);
				}else{
					pInSpace = God7(root).space.ship2Space(this)
				}
			}
			
			return pInSpace;
		}
	
	}
}
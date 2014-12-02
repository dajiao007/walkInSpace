package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Girl extends MovieClip
	{
		public function Girl()
		{	
			this.addEventListener(Event.ENTER_FRAME,goRound);
			this.rotation = 180
		}
		public var fetched:Boolean = false;
		
		private function goRound(event:Event):void{
			this.rotation += .5;
			var angle:Number = Math.PI/180*rotation;
			this.x = SkyObject.MOON_RADIUS*Math.sin(angle);
			this.y = -SkyObject.MOON_RADIUS*Math.cos(angle);
		}
		
		public function captured():void{
			this.removeEventListener(Event.ENTER_FRAME,goRound);
		}
		public function reset():void{
			this.addEventListener(Event.ENTER_FRAME,goRound);
			this.rotation = 180
		}

	}
}
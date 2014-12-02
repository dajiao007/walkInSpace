package
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.Timer;

	
	public class Ship2 extends Sprite
	{
		public function Ship2()
		{
			timer.addEventListener(TimerEvent.TIMER,sayExist,false,0,true);
			timer.start();
		}
		
		var i:int=0;
		private function sayExist(event:TimerEvent):void{
			i++
			trace("ship exists:"+i);
		}
		private var timer:Timer = new Timer(1000);	
	}
}
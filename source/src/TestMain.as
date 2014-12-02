package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestMain extends Sprite
	{
		public function TestMain(){
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			qq = new QQ();
			qq.x = 100;
			qq.y = 100;
			this.addChild(qq);
		}
		
		private var qq:QQ ;
		private var i:int;
		
		private function onEnterFrame(event:Event):void{
			try{
				qq.scaleX = (i++%2==0)?1:2;
			}catch(error:Error){
				trace(error.toString())
			}
		}
	}
}
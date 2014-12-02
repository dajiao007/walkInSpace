package
{
	import flash.events.Event;

	public class NetHelperDataEvent extends Event
	{
		public static const ONTIME:String  = "onTime";
		public static const ONDATA:String  = "onData";
		
		private var  _timerName:String;
		
		private var _to:Object;
		public function NetHelperDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event{
			var clone:NetHelperDataEvent = new NetHelperDataEvent(this.type);
			clone.timerName = this.timerName;
			clone.transObj = this.transObj;
			
			return clone;
		}
		
		public override function toString():String {
			return this.toString();
		}
		
		
		public function get timerName():String{
			return _timerName;
		}
		
		public function set timerName(timerName:String):void{
				 _timerName = timerName;
		}
		
		public function get transObj():Object{
			return _to;
		}
		
		public function set transObj(transObj:Object):void{
				 _to = transObj;
		}
		
	}
}
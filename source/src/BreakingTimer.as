package
{
	import flash.utils.Timer;
	
	//not used!!!!
	public class BreakingTimer extends Timer
	{
		public function BreakingTimer(gObj:gObject,delay:Number, repeatCount:int = 1)
		{
			super(delay , repeatCount);
			this.owner = gObj;
		}
		
		public var owner:gObject = null;

	}
}
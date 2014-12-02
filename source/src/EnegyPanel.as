package
{
	import flash.display.MovieClip;

	public class EnegyPanel extends MovieClip
	{
		private var enegy:int;
		
		public function EnegyPanel()
		{
			setEnegy(0);
		}
		
		public function setEnegy(enegy : int):void
		{
			this.enegy = enegy;
			this.gotoAndStop(enegy+1);
		}
		
	}
}
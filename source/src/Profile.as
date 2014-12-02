package
{
	import flash.display.Sprite;
	
	public class Profile extends Sprite
	{
		private static var i:int = 1;
		
		public function Profile(){
			try{
				trace("instance "+i++)
			}catch(error:Error){
				trace(error.toString())
			}
		}
	}
}
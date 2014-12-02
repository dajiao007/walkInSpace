package
{
	import flash.net.LocalConnection;

	public class Util
	{
		public function Util()
		{
		}
		
		//not credible
		public static function GC():void{
			var l1= new LocalConnection();
			var l2= new LocalConnection();
			try{
        		l1.connect("MoonSpirit");
        		l2.connect("MoonSpirit");
			}catch(error : Error){
				trace("error to gc")
			}finally{
				l1.close();
				l1 = null;
				//l2.close();
				l2 = null;
			}
		}
	}
}
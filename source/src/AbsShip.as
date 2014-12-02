package
{
	
	public class AbsShip extends gObject
	{
		public function AbsShip()
		{
			enegy = INIT_ENETY;
		}
		
		
		public static const INIT_ENETY:int = 50;
		protected var enegy:Number ;

		public static const MAX_SUN_ENETY:int = 25;
		public static const DELTA_SUN_ENETY:int = 2;
		
		public static const MAX_V_XY_PERSEC:Number = 20* Math.sqrt(10);
		public static const MAX_V_XY:Number = MAX_V_XY_PERSEC / GameManager.FPS;
		public static const MAX_LINE_SPEED:Number = MAX_V_XY * Math.sqrt(2);
		
		public static const TIME_TO_TOP_THRUST:int = 4;//SECOND
		public static const MAX_THRUST:Number = 0.6 * mass;
		public static const THRUST:Number = 0.2 * mass;
		public static const DELTA_THRUST:Number = (MAX_THRUST-THRUST) / (TIME_TO_TOP_THRUST * GameManager.FPS) ;
		//public  const THRUST:Number = (MAX_V_XY /(TIME_TO_TOP_SPEED * God7.FPS))*mass  ;//10
		public static const POWER_BRAKE:Number = -0.4 * mass;
		public static const BRAKE:Number = -THRUST;
		
		public static const RATE_OF_ENERGY_THRUST:Number = 1;
		
		public function reset():void{
			vx = 0;
			vy = 0;
			thrust = 0;
			this.rotation = 0;
			this.enegy = INIT_ENETY;
		}
		
		public override function set vx(vx:Number):void{
			if(Math.abs(testVx(vx)) <= MAX_LINE_SPEED){
				 _vx = vx;
			}
		}		

		public override function set vy(vy:Number):void{
			if(Math.abs(testVy(vy)) <= MAX_LINE_SPEED){
				 _vy = vy;
			}
			//trace("vy:"+vy)
		}
		
		public function get v():Number{
			return Math.sqrt(vx*vx + vy*vy);
		}
		
		private function testVx(testVx:Number):Number{
			return Math.sqrt(testVx*testVx + vy*vy);
		}
		
		private function testVy(testVy:Number):Number{
			return Math.sqrt(vx*vx + testVy*testVy);
		}
		
		public function setEnegy(enegy:Number):void{
			if(enegy <= INIT_ENETY && enegy >= 0){
				this.enegy = enegy;
			}
		}
		
		public function getEnegy():Number{
			return this.enegy;
		}
		
		public function addEnegy(add : Number):void{
			//trace("add enegy b4:"+ enegy);
			//trace(lose);
			if(enegy < INIT_ENETY){
				enegy += add;
			}
			//trace("add enegy af:"+ enegy);
		}
		
		public function loseEnegy(lose : Number):void{
			//trace("enegy b4:"+ enegy);
			//trace(lose);
			if(enegy > 0){
				enegy -= lose;
			}
			//trace("enegy af:"+ enegy);
		}
	}
}
package
{
	public class GameManager{
		public static var baseHeight:Number = 0;
		public static const FPS:int  = 20;
		public static const initCameraBaseHeight:int  = -20;
		public static var isNetworkGame:Boolean  = false;
		public static var doTraceOfMyShip:Boolean  = true;	
		public static var doTraceOfEnemyShip:Boolean  = false;	
		public static var doTraceOfFriendShip:Boolean  = false;	
		public static var doTraceOfSpaceStation:Boolean  = false;
		public static const MAX_SHIP_LIVES:int = 5;
		public static const SHIP_HALF_HEIGHT:int = 10;
		public static var  LEFT_SHIP_LIVES:int = MAX_SHIP_LIVES - 1;	
		public static var testCollisionWithFriend :Boolean  = false;
		public static var testCollisionWithEnemy :Boolean  = true;
		public static var testCollisionWithSpaceStation :Boolean  = true;	
		public static const COLLISION_SPEED_FACTOR:Number = 0.5;
		public static const GAP_OF_SHIP_PORT_DISTANCE:int = 3;
		public static const SHIP_PORT_DISTANCE:Number = 1/Math.sqrt(5)* SHIP_HALF_HEIGHT + GAP_OF_SHIP_PORT_DISTANCE;
		public static const COLLISTION_BITMAP_TRANSPARENT :Boolean = true;
		public static const COLLISTION_BITMAP_DEFAULT_ACCURRACY :int = 1;
		public static const COLLISTION_BITMAP_ACCURRACY :int = 1;
//		public static const SHIP_PORT_DISTANCE:Number = 10;
		
	}
	
}
	
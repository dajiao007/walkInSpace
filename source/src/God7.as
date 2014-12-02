package
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	//[SWF(backgroundColor = "0xffffff",frameRate = "20" )]
	public class God7 extends Sprite
	{
		public var space:Space;
		private var energyMonitor:EnergyMonitor ;
		public static  var stageWidth  = 800;
		public static  var	stageHeight = 600;
		public static var halfStageWidth  = stageWidth / 2;
		public static var halfStageHeight = stageHeight / 2;
		private var camera : Camera ;
		
		public static var userInfo:UserInfo = new UserInfo();
		
		
		
		public function God7()
		{trace("God7")
			//important and can not be changed.
			this.x = 0;
			this.y = 0;
//			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init();
		}
		
		private function init():void{
			//test
			trace("God7 init")
			
			var date:Date = new  Date()
			var tid :String = date.toString();
			userInfo.id = tid;
			userInfo.password= tid;
			
			Sprite3D.vpX = halfStageWidth;
			Sprite3D.vpY = halfStageHeight;
			camera = new Camera(null,this);
			GameManager.baseHeight = GameManager.initCameraBaseHeight;
			
			energyMonitor  = new EnergyMonitor();
			energyMonitor.x = halfStageWidth;
			energyMonitor.y = 0;
			this.addChild(energyMonitor);
			
			space = new Space(energyMonitor,this.stage,camera);
			
			this.addChild(space);
			
			camera.distance = 0;
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheel);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDown);
		}
		
		private function onMouseDown(event : MouseEvent):void{
//			stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp);
//			space.startDrag();
		}
		private function onMouseUp(event : MouseEvent):void{
//			stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
//			
//			space.stopDrag();
//			space.synXY();
		}
		
		private function onMouseWheel(mouseEvent:MouseEvent):void{
			if(camera.distance - mouseEvent.delta + Camera.f1 > 0 ){
//				trace("camera.distance:"+camera.distance);
//				trace("mouseEvent.delta:"+mouseEvent.delta);
//				trace("camera.distance - mouseEvent.delta + Camera.f1:"+(camera.distance - mouseEvent.delta + Camera.f1));
//				trace("--------------------");
				GameManager.baseHeight -= mouseEvent.delta;
				camera.distance -= mouseEvent.delta;
				//trace("camera.distance:"+camera.distance);
			}
			//camera.backDelta(-mouseEvent.delta);
//			trace("space.moon.x:"+space.moon.x);
//			trace("space.height:"+space.height);
		}
		
		private function onKeyDown(event:KeyboardEvent):void{
			var x:Number = 0;
			var y:Number = 0;
			if(event.keyCode == Keyboard.NUMPAD_4){
				camera.moveCamera(-1,Number.POSITIVE_INFINITY,Number.POSITIVE_INFINITY);
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}else if(event.keyCode == Keyboard.NUMPAD_6){
				camera.moveCamera(1,Number.POSITIVE_INFINITY,Number.POSITIVE_INFINITY);
			}else if(event.keyCode == Keyboard.NUMPAD_2){
				camera.moveCamera(Number.POSITIVE_INFINITY,1,Number.POSITIVE_INFINITY);
			}else if(event.keyCode == Keyboard.NUMPAD_8){
				camera.moveCamera(Number.POSITIVE_INFINITY,-1,Number.POSITIVE_INFINITY);
			}
		}
		
		

	}
}
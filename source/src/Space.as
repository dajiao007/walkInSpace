package {
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.display.DisplayObject;


	//[SWF(backgroundColor = "0xffffff",frameRate = "20")]
	public class Space extends Sprite3D
	{
		//temp pulbic 
		public var earth:SkyObject ;
		public var moon:SkyObject ;
		private var girl:Girl;
		public var myShip:Ship = null;
		private var enemyShips:Object = new Array();
		private var friendShips:Object = new Array();
		private var spaceStation:SpaceStation = null;
		
		private var netHelper:NetHelper = null;
		
		private var enegyTimer:Timer = new Timer(4000);
		
		private var leftPressing:Boolean = false;
		private var rightPressing:Boolean = false;
		private var upPressing:Boolean = false;
		private var downPressing:Boolean = false;
		private var shiftPressing:Boolean = false;
		private var mouseDowning:Boolean = false;
		
		private var isReturn:Boolean = false;
		
//		private var stageWidth  = God7.stageWidth;
//		private var	stageHeight = God7.stageHeight;
		private var halfStageWidth  = God7.halfStageWidth;
		private var	halfStageHeight = God7.halfStageHeight;
		
		private var energyMonitor:EnergyMonitor;
		private var exStage:Stage;
		
		//test
		public static var g_Earth:Array;
		public static var g_Moon:Array;
//		private var goAway:Sprite3D = new Sprite3D();
	
		
		
		

		public function Space(energyMonitor:EnergyMonitor,stage:Stage , camera : Camera)
		{
			trace("new space")
			super(camera);
			this.energyMonitor = energyMonitor;
			this.exStage = stage;
			//try{
				init();
//			}catch(error:Error){
//				trace("in space init():");
//				trace(error);
//				
//			}
		}
		
		private function init():void{
			trace("init")
			enegyTimer.addEventListener(TimerEvent.TIMER , addShipsEnegyBySun);
		    enegyTimer.start();
//			[Embed(source = "../pic/earth.jpg")]
			var Earth_pic:BitmapData = new EarthPic(SkyObject.EARTH_RADIUS,SkyObject.EARTH_RADIUS);
//			
//			[Embed(source = "../pic/moon.jpg")]
 			var Moon_pic:BitmapData = new MoonPic(SkyObject.MOON_RADIUS,SkyObject.MOON_RADIUS);
			
			earth = new SkyObject("earth",null , SkyObject.EARTH_RADIUS , SkyObject.EARTH_MASS ,Earth_pic,
								SkyObject.EARTH_1_CIRCLE , SkyObject.EARTH_2_CIRCLE);
		    moon = new SkyObject("moon" , null , SkyObject.MOON_RADIUS , SkyObject.MOON_MASS,Moon_pic,
		    					SkyObject.MOON_1_CIRCLE , SkyObject.MOON_2_CIRCLE);
//			earth = new SkyObject("earth",null , SkyObject.EARTH_RADIUS , SkyObject.EARTH_MASS ,null,
//								SkyObject.EARTH_1_CIRCLE , SkyObject.EARTH_2_CIRCLE);
//		    moon = new SkyObject("moon" , null , SkyObject.MOON_RADIUS , SkyObject.MOON_MASS,null,
//		    					SkyObject.MOON_1_CIRCLE , SkyObject.MOON_2_CIRCLE);
			this.addChild(earth);
			this.addChild(moon);
			this.girl = new Girl();
			moon.addChild(girl);
			
			earth.x = 2000;
			earth.y = 1000;
			moon.x = 400;
			moon.y = 400;
			
			spaceStation = new SpaceStation(this);
			spaceStation.x = earth.x;
			spaceStation.y = earth.y + 310.44;
			spaceStation.vx = 4;
			spaceStation.vy = 0;
			if(! GameManager.doTraceOfSpaceStation){
				spaceStation.doTrace = false;
			}
			this.addChild(spaceStation);
			
			//*enemyShips[0] = new Ship();
			//myShip = enemyShips[0];
			//this.addChild(myShip);
			bornMyShip();
			//myShip.rotation = -90;
			
			this.addEventListener(Event.ENTER_FRAME , onEnterFrame);
			exStage.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDown);
			exStage.addEventListener(KeyboardEvent.KEY_UP , onKeyUp);
			
			this.graphics.lineStyle(1,0xffffff);
			this.graphics.moveTo(myShip.x , myShip.y);
			
			if(GameManager.isNetworkGame){
				configNetHelper();
			    netHelper.connect();
			} 
			//test
//		this.graphics.lineStyle(1,0xffffff,0.6);
//		this.graphics.drawCircle(404.05,349.25,1);
//		this.graphics.drawCircle(400,400,50);
		}
		
		private function onEnterFrame(event:Event):void{
			//test
//			if(this.myShip.capture.released){
//				trace("capture.x:"+myShip.capture.x);
//				trace("capture.y:"+myShip.capture.y);
//			
//			}
			//try{
				moveShips();

				moveCapline();
		
				showSatus();
				//trace("stage.scaleMode"+stage.scaleMode);root
				if(myShip != null){
					moveCamera();
				}
//			}catch(error:Error){
//				trace("in space onEnterFrame:");
//				trace(error);
//				throw error;
//			}
		}
		
		private function moveShips():void{
				
			if(! GameManager.isNetworkGame){
				for each(var ship:Ship in enemyShips){
					moveShip(ship);
				}
					
				moveShip(spaceStation);
			}
			
			
			if(myShip != null && ! myShip.breaking){
				if( myShip.isAutoDrive){
					myShip.autoDrive();
				}else{
					//set angle and force
					driveShip(myShip);
					moveShip(myShip);
					if(myShip.capture != null && myShip.capture.released){
						moveShip(myShip.capture)
						//trace("dd")
						myShip.capture.airDrag();
					}
				}
			}
			
			
		}
		
		private function moveCapline():void{
			if(myShip != null && myShip.capture != null){
				myShip.capLine.reDraw();
			}
		}
		
		private function  moveCamera():void{
			    //var app:God7 = God7(this.camera.app);
				//trace("root:"+(root is God7));
				var cameraDistance:Number = GameManager.baseHeight + getCameraHeight();
				if(!isReturn && cameraDistance < -0.9*Camera.f1){
					//GameManager.baseHeight += 10
					isReturn = true;
				}
				if(isReturn){
					GameManager.baseHeight ++ ;
					cameraDistance ++;
					if(GameManager.baseHeight >= 0){
						isReturn = false;
					}
				}
				camera.moveTo(myShip.x,myShip.y,cameraDistance);
				//debug
//				if(this.camera.distance < -Camera.f1){
//					trace(this.camera.distance);
//				}
			
		}
		
		private function getCameraHeight():Number{
			var dx_e:Number = myShip.x - earth.x;
			var dy_e:Number = myShip.y - earth.y ;
			var dis2_e = dx_e*dx_e + dy_e*dy_e;
			var dx_m:Number = myShip.x - moon.x;
			var dy_m:Number = myShip.y - moon.y ;	
			var dis2_m = dx_m*dx_m + dy_m*dy_m;
			var dx_s:Number = myShip.x - spaceStation.x;
			var dy_s:Number = myShip.y - spaceStation.y ;	
			var dis2_s = dx_s*dx_s + dy_s*dy_s;
			
			var dis2:Array = [dis2_e,dis2_m,dis2_s];
			dis2.sort(Array.NUMERIC);
			
			var minDis2 = dis2[0];
					
			return Math.sqrt(minDis2) * 0.1;
		}
		
		private function addShipsEnegyBySun(event:TimerEvent):void{
			//enemy
			if(! GameManager.isNetworkGame){
				for each(var ship:Ship in enemyShips){
					addShipEnegyBySun(ship);
				}
			}

			if(myShip != null){
				addShipEnegyBySun(myShip);
			}
		}
		
		private function addShipEnegyBySun(ship:Ship):void{
			if(ship.getEnegy() + AbsShip.DELTA_SUN_ENETY <= AbsShip.MAX_SUN_ENETY){
				ship.addEnegy(AbsShip.DELTA_SUN_ENETY);
			}else if(ship.getEnegy() < AbsShip.MAX_SUN_ENETY){
				ship.setEnegy(AbsShip.MAX_SUN_ENETY);
			}
		}
		
		private function showSatus():void{
			//showEnegy
			if(myShip != null){
				this.energyMonitor.showEnegy(Math.round(this.myShip.getEnegy()));
			}	
		}
		
		private function moveShip(_gObject:gObject):void{
			//var reflected:Boolean = false;
			//trace("a")
			if(! _gObject.isMyShip && _gObject.cashedWithSkyObject){
				return;
			}
			//trace("b")
			_gObject.oldX = _gObject.x;
			_gObject.oldY = _gObject.y;
			this.graphics.moveTo(_gObject.oldX , _gObject.oldY);
			
			var ax:Number = 0;
			var ay:Number = 0;
			var angle:Number = 0;
			if(_gObject.thrust != 0){
				 angle = _gObject.rotation*Math.PI/180;
				
	//			trace("ship.thrust:"+ship.thrust);
	//			trace("angle:"+angle);			
				
				 ax = Math.sin(angle)*_gObject.thrust / gObject.mass;
				 ay = -Math.cos(angle)*_gObject.thrust / gObject.mass;
			}

			var gEarth:Array = doGravity(_gObject , earth);
			var gMoon:Array = doGravity(_gObject , moon);
			
			//test
			/*if(ship == myShip){
				trace("ay"+ay)
				trace("gy"+gEarth[1] + gMoon[1])
				if(Math.abs(ay) > (gEarth[1] + gMoon[1])){
					trace("------------------------")
				}
			}*/
			
			//test
			//gMoon = [0,0];
			
			//test
			//Space.g_Earth = gEarth;
			//Space.g_Moon = gMoon;
			//drawG();
//			if(_gObject.isMyShip&&(ay + gEarth[1] + gMoon[1])<0){
//			}
			doAcce(_gObject,ax + gEarth[0] + gMoon[0] , ay + gEarth[1] + gMoon[1]);
//			if(_gObject.isMyShip&&(ay + gEarth[1] + gMoon[1])<0){
//			
//			}

			if(! doCollision(_gObject)){
				doTrace(_gObject);
			}
		}
		
		public function doCollision(_gObject:gObject):Boolean{
			if(myShip == null){
				false; 
			}
			var collision:Boolean = false;
			if(isCrash(_gObject,earth)||isCrash(_gObject,moon)){
//				_gObject.x =oldx;
//				_gObject.y =oldy;
				
				
				_gObject.vx = 0;
				_gObject.vy = 0;
				collision = true;
			}
			
			if((! (_gObject is SpaceStation)) && _gObject.collisionTest(spaceStation)>0){
				//trace("a")
				if(_gObject is Ship){
					//trace("b")
					breakShip(Ship(_gObject));
					collision = true;
				}
				trace("collisionTest 2");
			}else if( ! _gObject.isAutoDrive && ! _gObject.breaking && !(_gObject is SpaceStation) && _gObject.collisionTest(spaceStation.circle) == 1){
				if(_gObject.allowAutoDrive ){
					if( _gObject is Ship){
						Ship(_gObject).inAutoDrive(spaceStation);
						collision = true;
					}
				}else{
					//_gObject
				}
				
				trace("collisionTest 1");
			}
			if(myShip == null||myShip.breaking){
				return false; 
			}
			
			 if((_gObject is Capture || _gObject.isMyShip) && !girl.fetched && myShip.capLine.status == CapLine.STATUS_HIDDEN && _gObject.collisionTest(girl)){
				if(_gObject is Capture){
					Capture(_gObject).doCapture(girl);
					myShip.prepareLine(Capture(_gObject));
				}else{
					//breakShip(Ship(_gObject));
				}
				
				collision = true;
			 }
			 
			 if(myShip == null){
				false; 
			}
			
			 if(myShip.capLine.capture != null && !myShip.capLine.fetched && myShip.capLine.canFetch && myShip.capLine.length < CapLine.MAX_LENGTH  ){

				myShip.capLine.fetched = true;
				myShip.capture.fetched = true;
				girl.fetched = true;
			 	var pInShip:Point = space2Ship(myShip.capture);
			 	myShip.addChild(myShip.capture);
			 	myShip.capture.x = pInShip.x;
			 	myShip.capture.y = pInShip.y;
			 	myShip.doFetch(myShip.capture);
				
			 }
		
			return collision;
		}
		
		
		
		/*private function drawG(ship:Ship):void{
			//trace('dd');
			var factor:Number = 0.01;
			
			this.graphics.clear();
			this.graphics.lineStyle(1,0x00ff00);
			this.graphics.moveTo(ship.x,ship.y);
			this.graphics.lineTo(ship.x + Space.g_Earth[0]*factor ,ship.y + Space.g_Earth[1]*factor);
		
//			this.graphics.lineStyle(1,0x0000ff);
//			this.graphics.moveTo(shipCenter.x,shipCenter.y);
//			this.graphics.lineTo(shipCenter.x + Space.g_Moon[0]*factor ,shipCenter.y + Space.g_Moon[1]*factor);
			
		
		}*/
		
/*		private function reflect(sprite : Sprite):Boolean{
			var reflected:Boolean = false;
			if(Math.abs(sprite.x - halfStageWidth) > halfStageWidth){
//				if(sprite.x > halfStageWidth){
//					sprite.x -= stageWidth;
//				}else{
//					sprite.x += stageWidth;
//				}
				resetShip();
				reflected = true;
			}
			
			if(Math.abs(sprite.y - halfStageHeight) > halfStageHeight){
//				if(sprite.y > halfStageHeight){
//					sprite.y -= stageHeight;
//				}else{
//					sprite.y += stageHeight;
//				}
				resetShip();
				reflected = true;
			}
			
			return reflected ;
		}*/
		
		private function doGravity(_gObject:gObject , object:SkyObject):Array{
			
			var dx:Number = object.x - _gObject.x;
			var dy:Number = object.y - _gObject.y;
			var disSQ:Number = dx*dx + dy*dy;
			var dis:Number = Math.sqrt(disSQ);
			
			if(dis > SkyObject.MAX_DIS){
				//trace("SkyObject.MAX_DIS"+SkyObject.MAX_DIS)
				return [0,0];
			}else if(dis < SkyObject.MIN_DIS){
				dis = SkyObject.MIN_DIS;
				disSQ = dis * dis;
			}
			
			//test
			//if(Math.abs(ship.vy) <= 0.002 && object.skyObjectName == "earth"){
//				trace("ship.vx:"+ship.vx);
//				trace("ship.vy:"+ship.vy);
//				trace("ship.height:"+Math.sqrt(disSQ));
//			}
			
//			if(object.skyObjectName == "earth"){
//				trace('SkyObject.G'+SkyObject.G);
//				trace('ship.mass'+ship.mass);
//				trace('object.mass'+object.mass);
//				trace('disSQ'+disSQ);
//				
//			}
			var gravity:Number = SkyObject.G*gObject.mass*object.mass/disSQ;
//			if(object.skyObjectName == "earth"){
//				trace('gravity'+gravity);
//				trace('gravity[]:'+[gravity * dx / dis , gravity * dy / dis]);
//			}
			return [gravity * dx / dis , gravity * dy / dis]
		}
		
		private function doTrace(_gObject:gObject):void{
			if(! _gObject.doTrace){
				return ;
			}
			this.graphics.lineStyle(1 , 0xaaaaaa);
			if(Math.random() > 0.7){
				this.graphics.lineTo(_gObject.x , _gObject.y);	
			}else{
				this.graphics.moveTo(_gObject.x , _gObject.y);
			}
		}
		
		private function doAcce(_gObject:gObject , ax:Number , ay:Number):void{
//			trace("in doAcce ax:"+ax);
// 			trace("in doAcce ay:"+ay);
//			if(Math.abs(ax) > 123){
//				trace("---------------");
//				trace("ship.vx :"+ship.vx);
//				trace("in doAcce ax:"+ax);
//				trace("Math.ceil(ship.vx):"+Math.ceil(ship.vx));
//			}

			_gObject.vx += ax;
			_gObject.vy += ay;
			
//			if(Math.abs(ax) > 123){
//				trace("ship.vx :"+ship.vx);
//				trace("in doAcce ax:"+ax);
//				trace(">>>>>>>>>>>>>>>>");
//			}
			
//			trace("vx:"+ship.vx);
// 			trace("vy:"+ship.vy);			
			
			_gObject.x += _gObject.vx;
			_gObject.y += _gObject.vy;
		}
		
		private function isCrash(_gObject:gObject , object:SkyObject):Boolean{
			var rslt:Boolean=false;
			var dx:Number = object.x - _gObject.x;
			var dy:Number = object.y - _gObject.y;
			var disSQ:Number = dx*dx + dy*dy;
			var dis:Number = Math.sqrt(disSQ);
			//test
//			if(_gObject.radius < 10&& object.radius==50){
//			trace("----------------------")
//				trace("_gObject.x:"+_gObject.x)
//				trace("_gObject.y:"+_gObject.y)
//				trace("object.x:"+object.x)
//				trace("object.y:"+object.y)
//				trace("dx:"+dx)
//				trace("dy:"+dy)
//				trace("disSQ:"+disSQ)
//				trace("_gObject.radius:"+_gObject.radius)
//				trace("object.radius:"+object.radius)
//				trace("Math.pow((object.radius+_gObject.radius),2):"+Math.pow((object.radius+_gObject.radius),2))
//				trace("cha:"+(disSQ-Math.pow((object.radius+_gObject.radius),2)))
//			trace("=============================")	
//			}
			
			
			if(dis < (object.radius+_gObject.radius)){
				rslt = true;
				if(object.radius+_gObject.radius - dis < .5){
					_gObject.x = _gObject.oldX;
					_gObject.y = _gObject.oldY;
				}else{
					var pCrash:Point = Point.interpolate(new Point(_gObject.x,_gObject.y),new Point(object.x,object.y),(object.radius+_gObject.radius)/dis);
					_gObject.x = pCrash.x;
					_gObject.y = pCrash.y;
				}
				
				_gObject.afterCashWithSkyObject();
			}
			return rslt;
		}
		
		private function onKeyDown(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.LEFT:
					leftPressing = true;
					break;
				case Keyboard.RIGHT:
					rightPressing = true;
					break;
				case Keyboard.UP:
					upPressing = true;
					break;
				case Keyboard.DOWN:
					downPressing = true;
					break;
				case Keyboard.SHIFT:
					shiftPressing = true;
					break;
				default:
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void{
			if(myShip == null && event.keyCode != 82){
				return ;
			}
			//trace(event.keyCode)
			switch(event.keyCode){
				case Keyboard.LEFT:
					leftPressing = false;
					break;
				case Keyboard.RIGHT:
					rightPressing = false;
					break;
				case Keyboard.UP:
					upPressing = false;
					break;
				case Keyboard.DOWN:
					downPressing = false;
					break;
				case Keyboard.SHIFT:
					shiftPressing = false;
					break;
				case Keyboard.SPACE:
					cleanTrace();
					//this.graphics.moveTo(ship.x , ship.y);
					break;
				case 65://a 
					myShip.allowAutoDrive = true;
					break;	
				
				case 66://b 
					myShip.addEnegy(AbsShip.INIT_ENETY);
					break;	
				case 67:// c
					myShip.prepareCapture();
					break;						
				case 68://shift+d 
					myShip.dropCapture();
					//todo:2 times only
					if(shiftPressing){
						myShip.setEnegy(AbsShip.INIT_ENETY);
					}
					break;	
				case 69://e
					if(myShip.isAutoDrive){
						myShip.offAutoDrive();	
					}
					trace("E,myShip.isAutoDrive:"+myShip.isAutoDrive)
					break;
				case 82://r 
					this.resetShip(myShip);
					break;	
				//case 78://n 
					//myShip = addShip();
					//break;		
				default:
					break;
			}
		}
		//private function addShip():Ship{
			//var newShip:Ship = enemyShips[enemyShips.length] = new Ship();
			//resetShip(newShip , false);
			//this.addChild(newShip);
			//return newShip;
		//}
		
		
		
		
		private function resetShip(ship:Ship , cleanTrace:Boolean = true):void{
//			if(GameManager.LEFT_SHIP_LIVES <= 0){
//			    return;
//			}
			
			bornMyShip();
			this.cleanTrace();
			girl.reset();
			//var app:God7 = God7(this.camera.app);
				//trace("root:"+(root is God7));
//		    GameManager.baseHeight = GameManager.initCameraBaseHeight;
//			this.graphics.moveTo(ship.x , ship.y);
			//GameManager.LEFT_SHIP_LIVES--;
		}
		
		private function cleanTrace():void{
			this.graphics.clear();
			this.graphics.lineStyle(1);
		}
		
		private function driveShip(ship:Ship):void{
			if(ship.getEnegy() <= 0){
				this.energyMonitor.alertNoEnergy();
				ship.thrust = 0;
				ship.draw(false);
				return;
			}
			
			if(leftPressing){
				ship.rotation += -5;
				ship.loseEnegy(0.05);
			}
			if(rightPressing){
				ship.rotation += 5;
				ship.loseEnegy(0.05);
			}
			if(upPressing){
				if(shiftPressing && ship.thrust >= AbsShip.THRUST){
					if(ship.thrust + AbsShip.DELTA_THRUST < AbsShip.MAX_THRUST){
						ship.thrust += AbsShip.DELTA_THRUST ;
					}
				}else{
					ship.thrust = AbsShip.THRUST ;
				}
				ship.draw(true);
				ship.loseEnegy(ship.thrust*AbsShip.RATE_OF_ENERGY_THRUST);
			}else{
				ship.thrust = 0;
				ship.draw(false);
			}
			if(downPressing){
				if(shiftPressing){
					ship.thrust = AbsShip.POWER_BRAKE ;
				}else{
					ship.thrust = AbsShip.BRAKE ;
				}
				ship.loseEnegy(ship.thrust*AbsShip.RATE_OF_ENERGY_THRUST);
			}
			
		}
		
		private function breakShip(ship:Ship){
			ship.broken();
		}
		
		private function bornMyShip():void{
			if(myShip != null){
				this.removeChild(myShip);
				myShip = null;
			}
			myShip = new Ship();
			myShip.isMyShip = true;
			this.addChild(myShip);
			if(! GameManager.doTraceOfMyShip){
				myShip.doTrace = false;
			}
			myShip.x = earth.x;
			myShip.y = earth.y - earth.radius - GameManager.SHIP_HALF_HEIGHT;
//			myShip.x = moon.x;
//			myShip.y = moon.y - moon.radius - GameManager.SHIP_HALF_HEIGHT;
			this.cleanTrace();
		    GameManager.baseHeight = GameManager.initCameraBaseHeight;
		}
	
		private function friendShipPos(event:NetHelperDataEvent):void{
			var transObj = event.transObj;
			
			var friendId:String = transObj.id;
			var friendShip:Ship = getFriendShip(friendId);
			if(friendShip == null){
				friendShip = new Ship();
				this.addChild(friendShip);
				this.friendShips[friendId] = friendShip;
			}
		
			friendShip.x = transObj.x;
			friendShip.y = transObj.y;		
		}
		
		private function configNetHelper():void{
			netHelper = new NetHelper("192.168.1.21",28);
			netHelper.validatePassport = false;
			netHelper.id = God7.userInfo.id;
			//trace("configNetHelper the id:"+netHelper.id);
			netHelper.password = God7.userInfo.password;
			netHelper.addEventListener(NetHelperDataEvent.ONDATA,netHelperOnData);
			netHelper.addEventListener(NetHelperDataEvent.ONTIME,netHelperOnTime);
		}
		
		private function netHelperOnData(event:NetHelperDataEvent):void{
			//var transObj:Object = event.transObj;
			var action:String = event.transObj.action;
			if(action != null){
				if(action =="friendShipPos"){
					friendShipPos(event);
				}
			}
		}
		
		private function netHelperOnTime(event:NetHelperDataEvent):void{
			var sentObj:Object = event.transObj;
			sentObj.id = God7.userInfo.id;
			
			if(event.timerName == "synTimer"){
				sentObj.action = "myShipPos";
				sentObj.x = myShip.x;
				sentObj.y = myShip.y;
			}
		}
		
		private function getFriendShip(friendId:String):Ship{
			return this.friendShips[friendId];
		}
		
		public function deFunctionOfNetOutput():void{
			if(netHelper != null){
				netHelper.removeEventListener(NetHelperDataEvent.ONTIME,netHelperOnTime);
			}
		}
		
		public function space2Ship(dpo:DisplayObject):Point{
			var globle:Point = localToGlobal(new Point(dpo.x,dpo.y));
			return myShip.globalToLocal(globle);
		}
		
		public function ship2Space(dpo:DisplayObject):Point{
			var globle:Point = myShip.localToGlobal(new Point(dpo.x,dpo.y));
			return globalToLocal(globle);
		}
	
	}
}

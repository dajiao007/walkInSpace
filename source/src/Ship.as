package
{
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
		
		
	public class Ship extends AbsShip
	{
		public function Ship()
		{
			this._points = [new Point(0,-HALF_HEIGHT),new Point(-HALF_HEIGHT,HALF_HEIGHT),new Point(0,HALF_HEIGHT/2),new Point(HALF_HEIGHT,HALF_HEIGHT)];
			graphics.lineStyle(1,0xffffff)
			capLine = new CapLine(this);
			caplinePorts = [new Point(-5,0),new Point(5,0)];
			girlPorts = [new Point(-2*HALF_HEIGHT,0),new Point(2*HALF_HEIGHT,0)];
			//radius = GameManager.SHIP_HALF_HEIGHT;
		}
		
		
		public static const HALF_HEIGHT:int = 10;
		public var caplinePorts:Array = null;
		public var girlPorts:Array = null;
		public var curPortIndex:int = 0;
		private var _curLinePortIndex:int = 0;
		
		public var port :Port = null;
		public var controlLineLength :Number = 0;
		public var controlSin:Number = 0;
		public var controlCos:Number = 0;
		private var spaceStation:SpaceStation = null;
		private static const BREAKING_FRAME_NUM:int = 60;
		private var glowFilter:Array = [new GlowFilter()];
		
		public var capLine:CapLine = null;
		public var capture:Capture = null
		private var fetchPoint:Point = null;
		private const DRIVE_FRAME_CNT:int = GameManager.FPS * 3;
		private var   driveFrame:int = 0;
	

		
		public function draw(showFlame:Boolean):void
		{
			if(showFlame){
				this.gotoAndStop(int(200*this.thrust) - 38);
			}else{
				this.gotoAndStop(1);
			}
			
			
			
			
			if(this.allowAutoDrive){
				//trace("a")
				
				this.filters = glowFilter;
			}else{
				this.filters = null;
			}
//			if(this.isAutoDrive){
//				//trace("b")
//				this.graphics.drawCircle(0,0,5);
//			}
			
//			graphics.clear();
//			graphics.lineStyle(1,0xffffff);
//			graphics.moveTo(points[0].x, points[0].y);
//			graphics.lineTo(points[1].x, points[1].y);
//			graphics.lineTo(points[2].x, points[2].y);
//			graphics.lineTo(points[3].x, points[3].y);
//			graphics.lineTo(points[0].x, points[0].y);
//			
//			if(showFlame)
//			{
//				graphics.moveTo(-3, 3)
//				graphics.lineTo(0,((thrust*5-0.08)*8.1 + 2.5));
//				graphics.lineTo(3, 3);
//			}
			//var rec:Rectangle = this.getBounds(this);
			//graphics.drawRect(rec.x , rec.y , rec.width , 2*HALF_HEIGHT);
		}
		
		public function inAutoDrive(spaceStation:SpaceStation):void{
			this.rotation = 0;
			this.isAutoDrive = true;
			this.spaceStation = spaceStation;
			this.port = spaceStation.selectPort(this);
			var globeCenter:Point = this.localToGlobal(new Point(0,0));
			this.controlLineLength = Point.distance(globeCenter,port.globePos);
			handleControlAngle(globeCenter , port.globePos);
		}
		
		private function handleControlAngle(p1:Point,p2:Point):void{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var disSQ:Number = dx*dx + dy*dy;
			var dis:Number = Math.sqrt(disSQ);
			this.controlSin = dx / dis;
			this.controlCos = dy / dis;
		}
		
		public function autoDrive():void{
			if(controlLineLength > 1){
				controlLineLength -= 1;
			}else{
				controlLineLength = 0;
//				trace("controlLineLength:"+controlLineLength);
//				trace("controlLineLength*controlSin:"+controlLineLength*controlSin);
//				trace("controlLineLength*controlCos:"+controlLineLength*controlCos);
			}
			
			
			
			
			var globlePos:Point = new Point(controlLineLength*controlSin , controlLineLength*controlCos ).add(port.globePos)
			var parentPos:Point = this.parent.globalToLocal(globlePos);
			
//			//test
//			var space:Space = Space(this.parent);
//			this.graphics.clear();
//			//space.graphics.lineStyle(1,0xffffff);
//			//this.parent.graphics.moveTo(points[0].x, points[0].y);
//			space.graphics.lineTo(space.globalToLocal(port.globePos).x, space.globalToLocal(port.globePos).y);
			
			this.vx = spaceStation.vx;
			this.vy = spaceStation.vy;
			this.x = parentPos.x;
			this.y = parentPos.y;
			
		}
		
		public function broken():void{
			if(! breaking){
				breaking = true;
				this.gotoAndPlay(83);
			}
		}
		
		private function afterBroken():void{
			var space:Space = Space(parent);
			
			space.deFunctionOfNetOutput();
			if(capture != null && capture.destroyTimer2 != null){
				capture.destroyTimer2.start();
			}
			space.myShip = null;
			space.removeChild(this);
		}
		
		public function offAutoDrive():void{
			allowAutoDrive = false;
			isAutoDrive = false; 
			vy += 0.25;
			vx += port.landPoint.x > 0 ? 0.25: - 0.25;	
		}
		
		
		public function prepareCapture():void{
			 if(capture == null){
				this.capture = new Capture();
			 	setCapturePos();
			 	this.addChild(capture);
			 }
		}
		
		private function setCapturePos():void{
			curPortIndex = getNearCapLinePortIndex()
			capture.x = caplinePorts[curPortIndex].x
			capture.y = caplinePorts[curPortIndex].y
		}
		
		private function setCapLinePos():void{
			curLinePortIndex = getNearCapLinePortIndex()
			capLine.x = caplinePorts[curLinePortIndex].x
			capLine.y = caplinePorts[curLinePortIndex].y
		}
		
		private function getNearCapLinePortIndex():int{
			var moon:SkyObject = Space(this.parent).moon;
			if(((y - moon.y) * vx) < 0){
				return 1;
			}else{
				return 0;
			}
		}
		
		public function getCaplinePortInSpace(index:int):Point{
			var g_port:Point = this.localToGlobal(caplinePorts[index]);
			return Space(this.parent).globalToLocal(g_port);
		}
		
		public function dropCapture():void{
			if(capture == null || capture.released){
				return;
			}
			
			//capLine.status = CapLine.STATUS_DOWN
			capture.drop();
			this.removeChild(capture);
			this.parent.addChild(capture);
			
			var dropPos:Point = getCaplinePortInSpace(curPortIndex);
			capture.x = dropPos.x
			capture.y = dropPos.y
			capture.vx = this.vx ;
			capture.vy = this.vy ;
		}
		
		public override function get radius():Number{
			return GameManager.SHIP_HALF_HEIGHT;
		}
		
//		public function destroyCapture(captureDestroying:Capture):void{
//			if(capture == captureDestroying){
//				capture = null;
//			}
//		}

		public function prepareLine(capture:Capture):void{
			setCapLinePos();
			parent.addChild(capLine);
			capLine.capture = capture;
			capLine.status = CapLine.STATUS_FIND;
		}
		
		public function doFetch(capture:Capture):void{
			capture.rotation = 0;
			capture.girl.rotation = 0;
			this.fetchPoint = new Point(capture.x , capture.y);
			this.addEventListener(Event.ENTER_FRAME,driveGirlToPort);
		}
		
		private function driveGirlToPort(event:Event):void{
			if(driveFrame > DRIVE_FRAME_CNT){
				this.removeEventListener(Event.ENTER_FRAME,driveGirlToPort);
				return ;
			}
			//var pDrive:Point = Point.interpolate(girlPorts[curLinePortIndex],fetchPoint,driveFrame++ / DRIVE_FRAME_CNT);		 
//			this.capture.x = pDrive.x;
//			this.capture.y = pDrive.y;
		
		}
		
		private function get curLinePortIndex():int{
			return _curLinePortIndex;
		}
		
		private function set curLinePortIndex(value:int):void{
			_curLinePortIndex = value;
			trace("curLinePortIndex is set to be : "+_curLinePortIndex)
		}
		
		
	}
}
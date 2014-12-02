package
{
	import flash.display.Sprite;
	
	public class Sprite3D extends Sprite
	{
		public function Sprite3D(camera:Camera = null)
		{
			if(camera != null){
				this.camera = camera;
				camera.content = this;
			}
		}
		
		//center point in parent coordinate,while x&y is leftTop
		private var _xpos:Number = 0;
		private var _ypos:Number = 0;
		private var _zpos:Number = 0;
		public var camera:Camera;
		
		public static var vpX:Number = 0;
		public static var vpY:Number = 0;
		public var f1:Number = Camera.f1;
		public var scale:Number = f1 / (f1 + _zpos);
		
		//left
		public  function get screenX():Number{
			return perspectiveX(xpos);
		}
		
		//top
		public  function get screenY():Number{
			return perspectiveY(ypos);;
		}
		
		public function get xpos():Number{
			return _xpos ;
		}
		
		public function set xpos(value:Number):void{
			_xpos = value;
			x = this.screenX ;
		}
		public function get ypos():Number{
			return _ypos ;
		}
		
		public function set ypos(value:Number):void{
			_ypos = value;
			y = this.screenY;
		}
		
		public function get zpos():Number{
			return _zpos ;
		}
		
		public function set zpos(value:Number):void{
			_zpos = value;
			scale = f1 / (f1 + _zpos);
			this.scaleX = this.scaleY = scale;
			x = this.screenX;
			y = this.screenY;
		}
		//left
		public function synX(x:Number):void{
			this.xpos = unPerspectiveX(x);
		}
		
		//top
		public function synY(y:Number):void{
			this._ypos = unPerspectiveY(y);
		}
		
		public function synXY():void{
			synX(this.x);
			synY(this.y);
		}
		
		public function perspectiveX(xpos:Number):Number{
			return vpX + (xpos - vpX) * scale - this.width/2;
		}
		
		public function perspectiveY(ypos:Number):Number{
			return vpY + (ypos - vpY) * scale - this.height/2;
		}
		
		public function unPerspectiveX(x:Number):Number{
			return (x + this.width/2 - vpX)/scale + vpX;
		}
		
		public function unPerspectiveY(y:Number):Number{
			return (y + this.height/2 - vpY)/scale + vpY;
		}
	}
}
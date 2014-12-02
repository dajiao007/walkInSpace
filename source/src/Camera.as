package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Camera
	{
		private var _content:Sprite3D;
		private var _app:Sprite;
		
		public var focusX:Number = 0;
		public var focusY:Number = 0;
		
		public static var f1:Number=25;	
		
		public function Camera(content:Sprite3D,app:Sprite)
		{
			if(content != null){
				this.content = content;
				content.camera = this;
			}
			
			this.app = app;
		}
		
		public function get content():Sprite3D{
			return this._content;
		}
		
		public function set content(content:Sprite3D):void{
			this._content = content;
		}
		
		public function get app():Sprite{
			return this._app;
		}
		
		public function set app(app:Sprite):void{
			this._app = app;
		}
		
		//fx,fy:focus point of content(leftTop)
		public function moveTo(fx:Number , fy:Number, fz:Number):void{
			var l_focus:Point = new Point(fx,fy);
//			var g_center:Point = app.localToGlobal(new Point(_content.xpos,_content.ypos));
			var l_center_unScaled:Point = new Point(_content.width/2/_content.scale,_content.height/2/_content.scale);
//			trace("g_focus.x - g_center.x : "+(l_focus.x - l_center.x));
//			trace("g_focus.y - g_center.y : "+(l_focus.y - l_center.y));
			if(fz != Number.POSITIVE_INFINITY){
				this._content.zpos = fz ;
				
			}
			if(fx != Number.POSITIVE_INFINITY){
				_content.x= _content.stage.stageWidth/2 - ((l_focus.x - l_center_unScaled.x)*_content.scale + _content.width/2);
				_content.synX(_content.x);
				focusX = fx;
				//this._content.xpos = _content.stage.stageWidth/2 - (l_focus.x - l_center.x)*_content.scale ;
			}
			if(fy != Number.POSITIVE_INFINITY){
				_content.y = _content.stage.stageHeight/2 - ((l_focus.y - l_center_unScaled.y)*_content.scale + _content.height/2);
				_content.synY(_content.y);
				//this._content.ypos = _content.stage.stageHeight/2 - (l_focus.y - l_center.y)*_content.scale ;
				focusY = fy;
			}
		}
		
		//deltax ,deltay ,deltaz is of app coordinate
		public function moveCamera(deltax:Number , deltay:Number, deltaz:Number):void{
			if(deltaz != Number.POSITIVE_INFINITY){
				this._content.zpos += deltaz ;
			}
			if(deltax != Number.POSITIVE_INFINITY){
				this._content.xpos -= deltax ;
				focusX -= deltax;
			}
			if(deltay != Number.POSITIVE_INFINITY){
				this._content.ypos -= deltay ;
				focusY -= deltay;
			}

		}
		
		//deltax ,deltay ,deltaz is of _content coordinate
		public function moveFocus(deltax:Number , deltay:Number, deltaz:Number):void{
			
			
			
		}
		
		
		public function backDelta(fzd:Number):void{
			this._content.zpos += fzd ;
		}
		
		public function get distance():Number{
			return this._content.zpos;
		}
		
		public function set distance(distance:Number):void{
			this._content.zpos = distance ;
		}
		

	}
}
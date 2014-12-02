package {
import flash.events.*;
import flash.net.Socket;
import flash.utils.Timer;

public class NetHelper  extends EventDispatcher{
	
    private var  socket:Socket;
	
	private var  hostUrl:String;
	private var  port:int ;
	private var  tick:int ;
	private const  defalut_tick:int = 50;
	
	public var  id:String ;
	public var  password:String;
	private var  obj:Object;
	private var  synTimer:Timer;
	//private var  rec:Boolean;
//	private var  sent:Boolean;	
	private var i:int = 0;
	
	private var  login:Boolean = false;
	private var  logining:Boolean = false;
	private const passportMaxNum:int = 20;
	private const  FILL_PASSPORT_FACTOR:Number = 0.5;
	private var  passport:Array = new Array(); 
	public  var  validatePassport:Boolean = true;
	
    public function NetHelper(hostUrl:String,port:int,tick:int = defalut_tick ) {
	   //ship0 = new Ship();		
	   //ship1 = new Ship();		
	  this.hostUrl = hostUrl;
	  this.port = port;
	  this.tick = tick;
	   
      socket = new Socket( );
	  //stage.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDown);
	  //this.addEventListener(Event.ENTER_FRAME , onEnterFrame);
      
      // Add an event listener to be notified when the connection is made
      socket.addEventListener( Event.CONNECT, onConnect );
	  socket.addEventListener( Event.CLOSE, onClose );
      socket.addEventListener( ProgressEvent.SOCKET_DATA, socketDataHandler);
	  synTimer = new Timer(tick );
	  synTimer.addEventListener(TimerEvent.TIMER,onTimer);
	    
      // Connect to the server
	  //Security.loadPolicyFile("xmlsocket://192.168.1.25:1234");
	  
    }
	/*private function onEnterFrame(event:Event):void{
		if(rec&&ship0!=null){
			ship0.scaleX = 2;
			rec = false;
		}else{
			ship0.scaleX = 1;
		}
		if(sent&&ship0!=null){
			ship0.scaleY = 2;
			sent = false;
		}else{
			ship0.scaleY = 1;
		}
	}
	
	/*private function onKeyDown(event:KeyboardEvent):void{
		ship0.x =ship0.x +3;
	
	}*/
	
	private function onTimer(event:TimerEvent):void{
		//trace("onTimer:");
		//sent = true;
		var sentObj:Object = new Object();
		
		if(! login){
			if(! logining){
				
			    sentObj.action = "login";
				sentObj.id = id;
				//trace("onTimer the id:"+id);
				sentObj.password = password;
				trace("loginObj:"+sentObj)
				socket.writeObject(sentObj);
				socket.flush();
				logining = true;
			}
			trace("logining.....")
		}else{
			if(validatePassport){
				if(this.passport[0] == undefined){
					//trace("no passport!!  "+i++);
					if(!unlockPassport()){
						throw new Error("no passport!!  ");
					}
					
					return ;
				}
				//trace("passport length:"+this.passport.length);
				sentObj.passport = this.passport[0];				
			}
			
			var netHelperDataEvent:NetHelperDataEvent = new NetHelperDataEvent(NetHelperDataEvent.ONTIME);
			netHelperDataEvent.timerName = "synTimer";
			netHelperDataEvent.transObj = sentObj;
			this.dispatchEvent(netHelperDataEvent);
			//trace("netLoginObj:"+netHelperDataEvent.transObj+"passport is :"+netHelperDataEvent.transObj.passport)
			//trace("before send")
			writeObject(netHelperDataEvent.transObj);
			socket.flush();
			//trace("after send")
			if(validatePassport){
				this.passport.shift();
			}
			
		}
	}
	
	private function unlockPassport():Boolean{
		var unlock:Boolean = false;
		while(this.passport[0] == undefined){
			if(! tryReadSocket()){
				break;
			}
		}
		if(this.passport[0] != undefined){
			unlock = true;
		}
		trace("unlock")
		return unlock
	}
	
	private function tryReadSocket():Boolean{
		var hasBytesAvailable:Boolean = false;
		trace("bytesAvailable"+socket.bytesAvailable);
		if(socket.bytesAvailable > 0){
			hasBytesAvailable = true;
			socket.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA))
		}
		trace("tryReadSocket")
		return hasBytesAvailable
	}
    
    private function onConnect( event:Event ):void {
		
		//ship0.x = 10;
		//ship0.y = 10;
		
		
		//ship1.x = 20;
		//ship1.y = 20;
      //this.addChild(ship0);
	  synTimer.start();
	  //this.addChild(ship1);
	  //socket.writeObject(ship0);
	  
    }
	
	private function onClose( event:Event ):void {
		trace("===================server socket closed!!")
	}
	
	function socketDataHandler(event:ProgressEvent):void {
		while(socket.bytesAvailable > 0){
			handleOneObject();
		}
	}
	
	function handleOneObject():void {
		//trace("接收数据:"+event.bytesLoaded);
		
		obj=socket.readObject();
		var action:String = obj.action;
		//trace("action:"+action)
		
		if(action != null){
			if(action==("passport") && validatePassport){
				handlePassport(obj);
			}else if(action==("loginOk")){
				loginOk(obj);
			}else {
				//test
				//if(! isNaN(Number(action))){
//					trace("接收数据:"+event.bytesLoaded);
//					trace("action:"+action)
//					return ;
//				}
				
				//test end
				var netHelperDataEvent:NetHelperDataEvent = new NetHelperDataEvent(NetHelperDataEvent.ONDATA);
				
				netHelperDataEvent.transObj = obj;
				
				this.dispatchEvent(netHelperDataEvent);
			}
		}
	}

	function loginOk(obj:Object):void{
		trace("loginOk")
		this.login = true;
		this.logining = false;
	}
	
	function handlePassport(obj:Object):void{
		var v_passport:Array = obj.passport;
		//trace("get passport:"+v_passport)
		if(v_passport != null){
			for(var i:int = 0 ; i < v_passport.length ; i++){
				this.passport.push(v_passport[i]);
			}
		}
		
		//trace("handlePassport finished:this.passport is :"+this.passport)
	}
	
	public function writeObject(obj:Object):void{
		socket.writeObject(obj);
	}
	
	public function connect():void{
		socket.connect(hostUrl, port ); 
	}
  
}
}

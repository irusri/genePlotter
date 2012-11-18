package events{
	
	import flash.events.Event;
	
	public class SendToListTextEvent  extends Event{
		
		public static const sendtoMainTextInput:String = "SENDSTRING";
		
		public var sendString:String;
		// Properties
		public var arg:*;
		// Constructor
		public function SendToListTextEvent (type:String, bubbles:Boolean=false, cancelable:Boolean=false,sendString:String="")
		{
			super(type, bubbles, cancelable);
			this.sendString = sendString;
			
		}
		override public function clone():Event{
			return new SendToListTextEvent (this.type,this.bubbles,this.cancelable,this.sendString);
		}
	}
}
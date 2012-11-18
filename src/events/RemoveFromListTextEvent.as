package events{
	
	import flash.events.Event;
	
	public class RemoveFromListTextEvent  extends Event{
		
		public static const removeTextInput:String = "REMOVESTRING";
		
		public var removeString:String;
		// Properties
		public var arg:*;
		// Constructor
		public function RemoveFromListTextEvent (type:String, bubbles:Boolean=false, cancelable:Boolean=false,removeString:String="")
		{
			super(type, bubbles, cancelable);
			this.removeString = removeString;
			
		}
		override public function clone():Event{
			return new RemoveFromListTextEvent (this.type,this.bubbles,this.cancelable,this.removeString);
		}
	}
}
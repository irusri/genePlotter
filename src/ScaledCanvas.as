package
{
	import flashx.textLayout.container.ScrollPolicy;
	
	import mx.containers.Canvas;

public class ScaledCanvas extends Canvas
{
	public function ScaledCanvas()
	{
		super();
		horizontalScrollPolicy = ScrollPolicy.OFF;
		verticalScrollPolicy = ScrollPolicy.OFF;
	}
	
	private var _minScale:Number = 0.5;
	
	[Inspectable]
	public function get minScale():Number {
		return _minScale;
	}
	
	public function set minScale(scale:Number):void {
		_minScale = scale;
		invalidateDisplayList();
	}
	
	private var _minFactor:Number = 0.1;
	
	[Inspectable]
	public function get minFactor():Number {
		return _minFactor;
	}
	
	public function set minFactor(factor:Number):void {
		_minFactor = factor;
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth,unscaledHeight);
		var mx:Number = measuredWidth / scaleX;
		var my:Number = measuredHeight / scaleY;
		if(width < mx || height < my) {
			var sx:Number = Math.max(minScale, width / mx);
			var sy:Number = Math.max(minScale, height / my);
			if(Math.max(Math.abs(sy - scaleY),Math.abs(sx - scaleX))>minFactor) {
				var s:Number = Math.min( sx, sy );
				this.scaleX = s;
				this.scaleY = s;
			}
		} else if ( width > mx && height > my && ( scaleX != 1 || scaleY != 1 ) ) {
			scaleX = 1;
			scaleY = 1;
		}
	}
}
}

/**
 * 
 * Grupow Wedge
 * Copyright (c) 2010 ruranga@grupow.com
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/

package com.grupow.drawing  {
	
	import flash.display.MovieClip;

	/**
	* @usage 
	*
	* 	import com.grupow.drawing.Wedge;
	* 
	*	function enterframe_handler (e:Event) {
	*		
	*		this.holder.graphics.clear();
	*		this.holder.graphics.beginFill(0xffffff, 1);
	*		Wedge.draw(this.holder, 12.5, 12.5, 0, (1 - value) * 360, 12.5);
	*		this.holder.graphics.endFill();
	*		value+=0.01
	*			
	*	}

	*	var holder:MovieClip = new MovieClip();
	*	addChild(holder);
	*
	*	var value:Number = 0;
	*
	*	this.addEventListener(Event.ENTER_FRAME,enterframe_handler)
	*/
	
	public class Wedge
	{
		public static function draw(target:MovieClip, x:Number, y:Number, startAngle:Number, arc:Number, radius:Number):void
		{
		
			var segAngle:Number;
			var theta:Number;
			var angle:Number;
			var angleMid:Number;
			var segs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			
			target.graphics.moveTo(x, y);
			
			if (Math.abs(arc)>360) {
				arc = 360;
			}
			
			segs = Math.ceil(Math.abs(arc)/45);
			segAngle = arc/segs;
			theta = -(segAngle/180)*Math.PI;
			angle = -(startAngle/180)*Math.PI;
			
			if (segs>0) {
				ax = x+Math.cos(startAngle/180*Math.PI)*radius;
				ay = y+Math.sin(-startAngle/180*Math.PI)*radius;
				target.graphics.lineTo(ax, ay);
				for (var i = 0; i<segs; i++) {
					angle += theta;
					angleMid = angle-(theta/2);
					bx = x+Math.cos(angle)*radius;
					by = y+Math.sin(angle)*radius;
					cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
					cy = y+Math.sin(angleMid)*(radius/Math.cos(theta/2));
					target.graphics.curveTo(cx, cy, bx, by);
				}
				target.graphics.lineTo(x, y);
			}
		};

	}
	
}
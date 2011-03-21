package com.grupow.controls.data 
{

	/**
	 * @author Raul Uranga
	 */
	public class LineStyleVars 
	{
		public var thickness:Number;
		public var color:uint;
		public var alpha:Number;
		public var pixelHinting:Boolean;
		public var scaleMode:String;
		public var caps:String;
		public var joints:String;
		public var miterLimit:Number;

		public function LineStyleVars(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3) 
		{
			this.miterLimit = miterLimit;
			this.joints = joints;
			this.caps = caps;
			this.scaleMode = scaleMode;
			this.pixelHinting = pixelHinting;
			this.alpha = alpha;
			this.color = color;
			this.thickness = thickness;
		}
	}
}

package com.greensock.plugins {
	import flash.display.*;
	import flash.geom.*;
	
	import com.greensock.*;
	
	public class TransformAroundCenterPlugin extends TransformAroundPointPlugin {
		public static const VERSION:Number = 1.02;
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		public function TransformAroundCenterPlugin() {
			super();
			this.propName = "transformAroundCenter";
		}
		
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			var remove:Boolean = false;
			if ($target.parent == null) {
				remove = true;
				var s:Sprite = new Sprite();
				s.addChild($target as DisplayObject);
			}
			var b:Rectangle = $target.getBounds($target.parent);
			$value.point = new Point(b.x + (b.width / 2), b.y + (b.height / 2));
			if (remove) {
				$target.parent.removeChild($target);
			}
			return super.onInitTween($target, $value, $tween);
		}
		
	}
}
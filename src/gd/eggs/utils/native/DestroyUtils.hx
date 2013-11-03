package gd.eggs.utils.native;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.Shape;
import gd.eggs.display.DisplayObject;
import gd.eggs.utils.Validate;

/**
 * @author SlavaRa
 */
@:noCompletion class DestroyUtils {
	
	#if (cpp || neko)
	public static function destroyDO(d:DisplayObject, safe:Bool = true):Dynamic {
		if(Validate.isNull(d)) {
			return null;
		}
		
		if(Validate.isNotNull(d.stage)) {
			return null;//TODO: throw error
		}
		
		if(Validate.isNotNull(Reflect.getProperty(d, "__graphicsCache"))) {
			cast(Reflect.getProperty(d, "__graphicsCache"), Graphics).clear();
			Reflect.setProperty(d, "__graphicsCache", null);
		}
		
		if(Validate.isNotNull(Reflect.getProperty(d, "__filters"))) {
			Reflect.setProperty(d, "__filters", null);
		}
		
		if(Std.is(d, DisplayObjectContainer)) {
			if(Std.is(d, Loader)) {
				var l:Loader = cast(d, Loader);
				if(Validate.isNotNull(l.content)) {
					destroyDO(l.content, safe);
				}
				l.unload();
			} else {
				if(Std.is(d, MovieClip)) {
					cast(d, MovieClip).stop();
				}
				
				var container:DisplayObjectContainer = cast(d, DisplayObjectContainer);
				while(container.numChildren != 0) {
					destroyDO(container.removeChildAt(0), safe);
				}
			}
		} else if(Std.is(d, Bitmap)) {
			var bitmap:Bitmap = cast(d, Bitmap);
			if(!safe && Validate.isNotNull(bitmap.bitmapData)) {
				bitmap.bitmapData.dispose();
			}
			bitmap.bitmapData = null;
		} else if(Std.is(d, TextField)) {
			cast(d, TextField).text = "";
		}
		
		d.mask = null;
		
		return null;
	}
	#end
}
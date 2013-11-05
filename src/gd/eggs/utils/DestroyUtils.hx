package gd.eggs.utils;
import gd.eggs.display.DisplayObject;

#if msignal
import msignal.Signal;
#end

/**
 * @author SlavaRa
 */
class DestroyUtils{

	/**
	 * @param d => IInitialize, msignal.Signal, Итерируемая коллекция, ByteArray, BitmapData, DisplayObject.
	 * @param safe => при false вызывает dispose для flash.display.BitmapData
	 * @return null
	 */
	public static function destroy(d:Dynamic, safe:Bool = true):Dynamic {
		if(Validate.isNull(d)) {
			return null;
		}
		
		if(Std.is(d, IInitialize)) {
			cast(d, IInitialize).destroy();
		}
		
		#if msignal
		if(Std.is(d, Signal)) {
			cast(d, Signal<Dynamic, Dynamic>).removeAll();
		} else 
		#end
		if(Reflect.hasField(d, "iterator")) {
			var itr:Iterator<Dynamic> = Reflect.callMethod(d, Reflect.field(d, "iterator"), []);
			while (itr.hasNext()) {
				destroy(itr.next());
			}
		} else if(Std.is(d, flash.utils.ByteArray)) {
			cast(d, flash.utils.ByteArray).clear();
		} else if(!safe && Std.is(d, flash.display.BitmapData)) {
			cast(d, flash.display.BitmapData).dispose();
		} else if(Std.is(d, DisplayObject)) {
			#if (flash && !starling)
			gd.eggs.utils.flash.DestroyUtils.destroyDO(cast(d, DisplayObject), safe);
			#elseif (cpp || neko)
			gd.eggs.utils.native.DestroyUtils.destroyDO(cast(d, DisplayObject), safe);
			//#elseif js
			#end
		}
		
		return null;
	}
	
}
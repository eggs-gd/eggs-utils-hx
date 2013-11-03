package gd.eggs.utils;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.utils.ByteArray;
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
		if(Std.is(d, IInitialize)) {
			cast(d, IInitialize).destroy();
		}
		
		#if msignal
		if(Std.is(d, Signal)) {
			cast(d, Signal<Dynamic, Dynamic>).removeAll();
		}
		#end
		
		if(Reflect.hasField(d, "iterator")) {
			var itr = Reflect.callMethod(d, Reflect.field(d, "iterator"), []);
			if(Reflect.hasField(itr, "hasNext")) {
				while (Reflect.callMethod(itr, Reflect.field(itr, "hasNext"), [])) {
					destroy(Reflect.callMethod(itr, Reflect.field(itr, "next"), []));
				}
			}
		}
		
		if(Std.is(d, ByteArray)) {
			cast(d, ByteArray).clear();
		}
		
		if(!safe && Std.is(d, BitmapData)) {
			cast(d, BitmapData).dispose();
		}
		
		#if (flash && !starling)
		if(Std.is(d, DisplayObject)) {
			gd.eggs.utils.flash.DestroyUtils.destroyDO(cast(d, DisplayObject), safe);
		}
		//#elseif (cpp && neko)
		//#elseif js
		#end
		
		return null;
	}
	
}
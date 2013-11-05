package gd.eggs.utils;

/**
 * @author SlavaRa
 */
class Validate {
	public static inline function isNull(d:Null<Dynamic>):Bool {
		return d == null;
	}
	
	public static inline function isNotNull(d:Null<Dynamic>):Bool {
		return d != null;
	}
}
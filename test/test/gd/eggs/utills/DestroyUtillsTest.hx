package test.gd.eggs.utills;
import flash.display.BitmapData;
import flash.display.Loader;
import gd.eggs.display.DisplayObject.Bitmap;
import gd.eggs.display.DisplayObject.MovieClip;
import gd.eggs.display.DisplayObject.Sprite;
import gd.eggs.display.DisplayObject.TextField;
import gd.eggs.utils.DestroyUtils;
import massive.munit.Assert;


/**
 * @author Dukobpa3
 */
class DestroyUtillsTest {
	
	public function new() {
	}
	
	#if (flash && !starling)
	@Test
	public function destroyFlashDO() {
		var container = new Sprite();
		var movieClip = new MovieClip();
		var textField = new TextField();
		var sprite = new Sprite();
		var shape = new Sprite();
		var bitmap = new Bitmap(new BitmapData(100, 100));
		var loader = new Loader();
		
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0, 0, 100, 100);
		sprite.graphics.endFill();
		
		shape.graphics.beginFill(0x00ff00);
		shape.graphics.drawRect(0, 0, 50, 50);
		shape.graphics.endFill();
		
		sprite.hitArea = shape;
		textField.text = "hello test";
		
		container.addChild(movieClip);
		container.addChild(textField);
		container.addChild(sprite);
		container.addChild(shape);
		container.addChild(bitmap);
		container.addChild(loader);
		
		DestroyUtils.destroy(container);
		
		Assert.areEqual(container.numChildren, 0);
		Assert.isFalse(movieClip.isPlaying);
		Assert.isNull(sprite.hitArea);
		Assert.isNull(textField.styleSheet);
		Assert.isNull(bitmap.bitmapData);
	}
	#end
	
	#if (cpp || neko)
	@Test
	public function destroySysDO() {
		var container = new Sprite();
		var movieClip = new MovieClip();
		var textField = new TextField();
		var sprite = new Sprite();
		var shape = new Sprite();
		var bitmap = new Bitmap(new BitmapData(100, 100));
		var loader = new Loader();
		
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0, 0, 100, 100);
		sprite.graphics.endFill();
		
		shape.graphics.beginFill(0x00ff00);
		shape.graphics.drawRect(0, 0, 50, 50);
		shape.graphics.endFill();
		
		textField.text = "hello test";
		
		container.addChild(movieClip);
		container.addChild(textField);
		container.addChild(sprite);
		container.addChild(shape);
		container.addChild(bitmap);
		container.addChild(loader);
		
		container.filters = [new flash.filters.GlowFilter()];
		
		DestroyUtils.destroy(container);
		
		Assert.areEqual(container.numChildren, 0);
		Assert.isNull(Reflect.getProperty(container, "__filters"));
		Assert.isNull(Reflect.getProperty(sprite, "__graphicsCache"));
		Assert.isNull(Reflect.getProperty(shape, "__graphicsCache"));
		Assert.isNull(bitmap.bitmapData);
	}
	#end
	
	@Test
	public function destroyCollection() {
		//TODO: implement me
	}
}
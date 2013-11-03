package gd.eggs.display;
#if (flash11 && starling)
typedef MovieClip = starling.display.MovieClip;
typedef Sprite = starling.display.Sprite;
typedef DisplayObjectContainer = starling.display.DisplayObjectContainer;
typedef DisplayObject = starling.display.DisplayObject;
#else
typedef MovieClip = flash.display.MovieClip;
typedef Sprite = flash.display.Sprite;
typedef Bitmap = flash.display.Bitmap;
typedef DisplayObjectContainer = flash.display.DisplayObjectContainer;
typedef DisplayObject = flash.display.DisplayObject;
typedef TextField = flash.text.TextField;
#end
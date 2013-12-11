package gd.eggs.utils;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;


/**
 * ...
 * @author Dukobpa3
 */
class GlobalTimer
{
	//=====================================================================
	//      CONSTANTS
	//=====================================================================

	//=====================================================================
	//      PARAMETERS
	//=====================================================================
	static var _instance(default, null):GlobalTimer;

	//-----------------------------
	//      Enterfrtame
	//-----------------------------
	var _visualBus(default, null):Sprite;

	//-----------------------------
	//      Timer
	//-----------------------------
	public var currentDate(default, null):Date;
	
	var _timer(default, null):Timer;
	var _synced(default, null):Bool;

	//-----------------------------
	//      Callbacks
	//-----------------------------
	var _timerCallBacks(default, null):Array<Date -> Void>;
	var _frameCallBacks(default, null):Array<Int -> Void>;
	//=====================================================================
	//      CONSTRUCTOR, INIT
	//=====================================================================
	public function new()
	{
		if (Validate.isNotNull(_instance)) throw "singleton";

		_timer = new Timer(1000);
		_timerCallBacks = [];

		_visualBus = new Sprite();
		_frameCallBacks = [];
	}

	public static function getInstance():GlobalTimer
	{
		if (Validate.isNull(_instance)) _instance = new GlobalTimer();
		return _instance;
	}

	//=====================================================================
	//      PUBLIC
	//=====================================================================
	public static function updateDate(date:Date):void
	{
		if (!_instance._timer.hasEventListener(TimerEvent.TIMER))
		{
			_instance._timer.addEventListener(TimerEvent.TIMER, _instance.onTimer);
		}

		_instance._currentDate = date;
		_instance._timer.reset();
		_instance._timer.start();

		_instance._synced = true;
	}

	/**
	 * Добавить коллбек ентерфрейма
	 * @param       func function onTimer(date:Date):void {} // коллбек принимает текущую дату getTimer().
	 */
	public function addFrameCallback(func:Int -> Void):void
	{
		if (_frameCallBacks.indexOf(func) == -1)
		{
			_frameCallBacks.push(func);
		}

		if (!_visualBus.hasEventListener(Event.ENTER_FRAME))
		{
			// если не подписаны - подписаться на ентерфейм
			_visualBus.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}

	/**
	 * Убрать коллбек энтерфрейма
	 * @param       func
	 */
	public function removeFrameCallback(func:Int -> Void):void
	{
		if (_frameCallBacks.indexOf(func) != -1)
		{
			_frameCallBacks.splice(_frameCallBacks.indexOf(func), 1);
		}
		
		if (_frameCallBacks.length != 0 && _visualBus.hasEventListener(Event.ENTER_FRAME))
		{
			_visualBus.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}

	/**
	 * Добавить коллбек таймера
	 * @param       func function onTimer(unixtime:int):void {} // коллбек принимает текущую дату сервера.
	 *              // текущую, которая установлена в таймере, а не в системеДля синхронизации с сервером.
	 */
	public function addTimerCallback(func:Date -> Void):void
	{
		if (_timerCallBacks.indexOf(func) == -1)
		{
			_timerCallBacks.push(func);
		}

		if (_synced && !_timer.hasEventListener(TimerEvent.TIMER))
		{
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
	}

	/**
	 * Убрать коллбек таймера
	 * @param       func
	 */
	public function removeTimerCallback(func:Date -> Void):void
	{
		if (_timerCallBacks.indexOf(func) != -1)
		{
			_timerCallBacks.splice(_timerCallBacks.indexOf(func), 1);
		}
		
		if (_timerCallBacks.length != 0 && _timer.hasEventListener(TimerEvent.TIMER))
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
		}
	}

	//=====================================================================
	//      PRIVATE
	//=====================================================================

	//=====================================================================
	//      HANDLERS
	//=====================================================================
	private function onTimer(event:TimerEvent):void
	{
		if (Validate.isNull(_currentDate)) return;
		_currentDate.seconds++;

		for (i in 0..._timerCallBacks.length)
		{
			_timerCallBacks[i](_currentDate);
		}
	}

	private function onEnterFrame(event:Event):void
	{
		for (i in 0..._frameCallBacks.length)
		{
			_frameCallBacks[i](getTimer());
		}
	}

	//=====================================================================
	//      ACCESSORS
	//=====================================================================
}
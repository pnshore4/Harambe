package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_73_73_DialogSystem extends SceneScript
{
	public var _TempDialogBoxWidth:Float;
	public var _TempDialogBoxHeight:Float;
	public var _DialogBoxOpen:Bool;
	public var _TextToShow:Array<Dynamic>;
	public var _ShowText:Bool;
	public var _ShowBox:Bool;
	public var _Counter:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_OpenDialogBox():Void
	{
		_TempDialogBoxHeight += ((getScreenWidth() - (5 * 2)) / 60);
		propertyChanged("_TempDialogBoxHeight", _TempDialogBoxHeight);
		_TempDialogBoxHeight += (120 / 60);
		propertyChanged("_TempDialogBoxHeight", _TempDialogBoxHeight);
		if((_TempDialogBoxHeight >= 120))
		{
			_TempDialogBoxWidth = asNumber((getScreenWidth() - (5 * 2)));
			propertyChanged("_TempDialogBoxWidth", _TempDialogBoxWidth);
			_TempDialogBoxHeight = asNumber(120);
			propertyChanged("_TempDialogBoxHeight", _TempDialogBoxHeight);
			_DialogBoxOpen = true;
			propertyChanged("_DialogBoxOpen", _DialogBoxOpen);
			_ShowText = true;
			propertyChanged("_ShowText", _ShowText);
		}
		else
		{
			runLater(1000 * 0.015, function(timeTask:TimedTask):Void
			{
				_customEvent_OpenDialogBox();
			}, null);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_CloseDialogBox():Void
	{
		if(_ShowText)
		{
			_ShowText = false;
			propertyChanged("_ShowText", _ShowText);
		}
		_TempDialogBoxHeight -= ((getScreenWidth() - (5 * 2)) / 60);
		propertyChanged("_TempDialogBoxHeight", _TempDialogBoxHeight);
		_TempDialogBoxHeight -= (120 / 60);
		propertyChanged("_TempDialogBoxHeight", _TempDialogBoxHeight);
		if((_TempDialogBoxHeight <= 0))
		{
			_TempDialogBoxWidth = asNumber(0);
			propertyChanged("_TempDialogBoxWidth", _TempDialogBoxWidth);
			_TempDialogBoxHeight = asNumber(0);
			propertyChanged("_TempDialogBoxHeight", _TempDialogBoxHeight);
			_DialogBoxOpen = false;
			propertyChanged("_DialogBoxOpen", _DialogBoxOpen);
			_ShowBox = false;
			propertyChanged("_ShowBox", _ShowBox);
		}
		else
		{
			runLater(1000 * 0.015, function(timeTask:TimedTask):Void
			{
				_customEvent_CloseDialogBox();
			}, null);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ToggleDialogBox():Void
	{
		if(_DialogBoxOpen)
		{
			_customEvent_CloseDialogBox();
		}
		else
		{
			_customEvent_OpenDialogBox();
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("TempDialogBoxWidth", "_TempDialogBoxWidth");
		_TempDialogBoxWidth = 0.0;
		nameMap.set("TempDialogBoxHeight", "_TempDialogBoxHeight");
		_TempDialogBoxHeight = 0.0;
		nameMap.set("DialogBoxOpen", "_DialogBoxOpen");
		_DialogBoxOpen = false;
		nameMap.set("TextToShow", "_TextToShow");
		nameMap.set("ShowText", "_ShowText");
		_ShowText = false;
		nameMap.set("ShowBox", "_ShowBox");
		_ShowBox = false;
		nameMap.set("Counter", "_Counter");
		_Counter = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.translateToScreen();
				g.fillColor = Utils.getColorRGB(153,153,153);
				g.fillRoundRect(5, 5, _TempDialogBoxWidth, _TempDialogBoxHeight, 10);
				g.strokeColor = Utils.getColorRGB(51,51,51);
				g.strokeSize = Std.int(5);
				g.drawRoundRect(5, 5, _TempDialogBoxWidth, _TempDialogBoxHeight, 10);
				if(_DialogBoxOpen)
				{
					_Counter = asNumber(0);
					propertyChanged("_Counter", _Counter);
					for(item in cast(_TextToShow, Array<Dynamic>))
					{
						g.drawString("" + item, 15, (9 + (20 * _Counter)));
						_Counter += 1;
						propertyChanged("_Counter", _Counter);
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}
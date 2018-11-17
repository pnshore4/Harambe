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



class Design_8_8_LifePointManager extends SceneScript
{
	public var _LifePoints:Float;
	public var _HeartActor:ActorType;
	public var _ListofHearts:Array<Dynamic>;
	public var _DamageDelay:Bool;
	public var _MaxLifepoints:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_IncreaseLifepoints():Void
	{
		if((_LifePoints < _MaxLifepoints))
		{
			_LifePoints += 1;
			propertyChanged("_LifePoints", _LifePoints);
			createRecycledActor(_HeartActor, (_ListofHearts.length * 32), 0, Script.FRONT);
			getLastCreatedActor().anchorToScreen();
			getLastCreatedActor().disableBehavior("LifePickupItem");
			_ListofHearts.push(getLastCreatedActor());
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("LifePoints", "_LifePoints");
		_LifePoints = 0.0;
		nameMap.set("Heart Actor", "_HeartActor");
		nameMap.set("List of Hearts", "_ListofHearts");
		nameMap.set("Damage Delay", "_DamageDelay");
		_DamageDelay = false;
		nameMap.set("Max Lifepoints", "_MaxLifepoints");
		_MaxLifepoints = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_MaxLifepoints = asNumber(_LifePoints);
		propertyChanged("_MaxLifepoints", _MaxLifepoints);
		_ListofHearts = new Array<Dynamic>();
		propertyChanged("_ListofHearts", _ListofHearts);
		for(index0 in 0...Std.int(_LifePoints))
		{
			createRecycledActor(_HeartActor, (index0 * 32), 0, Script.FRONT);
			getLastCreatedActor().anchorToScreen();
			getLastCreatedActor().disableBehavior("LifePickupItem");
			_ListofHearts.push(getLastCreatedActor());
		}
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(3).ID, getActorType(11).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(_DamageDelay))
				{
					_DamageDelay = true;
					propertyChanged("_DamageDelay", _DamageDelay);
					runLater(1000 * 2, function(timeTask:TimedTask):Void
					{
						_DamageDelay = false;
						propertyChanged("_DamageDelay", _DamageDelay);
					}, null);
					_LifePoints = asNumber((_LifePoints - 1));
					propertyChanged("_LifePoints", _LifePoints);
					recycleActor(_ListofHearts[Std.int((_ListofHearts.length - 1))]);
					_ListofHearts.splice(Std.int((_ListofHearts.length - 1)), 1);
					if((_LifePoints == 0))
					{
						reloadCurrentScene(createFadeOut(2, Utils.getColorRGB(0,0,0)), createFadeIn(2, Utils.getColorRGB(0,0,0)));
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}
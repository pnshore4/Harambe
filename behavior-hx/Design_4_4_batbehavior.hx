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



class Design_4_4_batbehavior extends ActorScript
{
	public var _position:Actor;
	public var _attackdelay:Bool;
	public var _AttackAnimation:String;
	public var _IdleAnimation:String;
	public var _OriginXPosition:Float;
	public var _SpitActor:ActorType;
	public var _SpitYOffset:Float;
	public var _XDirection:Float;
	public var _spit:Actor;
	public var _SpitActorType:ActorType;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("position", "_position");
		nameMap.set("attack delay", "_attackdelay");
		_attackdelay = false;
		nameMap.set("Attack Animation", "_AttackAnimation");
		nameMap.set("Idle Animation", "_IdleAnimation");
		nameMap.set("Origin X Position", "_OriginXPosition");
		_OriginXPosition = 0.0;
		nameMap.set("Spit Actor", "_SpitActor");
		nameMap.set("Spit Y Offset", "_SpitYOffset");
		_SpitYOffset = 0.0;
		nameMap.set("X Direction", "_XDirection");
		_XDirection = 0.0;
		nameMap.set("spit", "_spit");
		nameMap.set("Spit Actor Type", "_SpitActorType");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_OriginXPosition = asNumber(actor.getX());
		propertyChanged("_OriginXPosition", _OriginXPosition);
		_position = getValueForScene("SceneManager", "_PlayerActor");
		propertyChanged("_position", _position);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_SpitYOffset = asNumber(20);
				propertyChanged("_SpitYOffset", _SpitYOffset);
				_XDirection = asNumber(100);
				propertyChanged("_XDirection", _XDirection);
				_SpitActor = getActorType(11);
				propertyChanged("_SpitActor", _SpitActor);
				if((_position.getXCenter() < actor.getXCenter()))
				{
					actor.growTo(-100/100, 100/100, 0, Linear.easeNone);
					_XDirection = asNumber(-100);
					propertyChanged("_XDirection", _XDirection);
				}
				else
				{
					actor.growTo(100/100, 100/100, 0, Linear.easeNone);
					_XDirection = asNumber(100);
					propertyChanged("_XDirection", _XDirection);
				}
				if(!(_attackdelay))
				{
					if(((Math.abs((_position.getXCenter() - actor.getXCenter())) <= 300) && (Math.abs(((actor.getYCenter() + (actor.getHeight())) - (_position.getYCenter() + (_position.getHeight())))) <= 30)))
					{
						trace("" + ("" + "\"before creating actor\""));
						createRecycledActor(_SpitActor, actor.getXCenter(), actor.getYCenter(), Script.BACK);
						trace("" + getLastCreatedActor().getType());
						getLastCreatedActor().setX((actor.getXCenter() - (getLastCreatedActor().getWidth()/2)));
						trace("" + ("" + "After First use of LAST CREATED ACTOR"));
						getLastCreatedActor().setY((actor.getYCenter() - ((getLastCreatedActor().getHeight()/2) + _SpitYOffset)));
						getLastCreatedActor().growTo(_XDirection/100, 100/100, 0, Linear.easeNone);
						trace("" + ("" + "\"after growing actor, before push\""));
						if((_XDirection == 100))
						{
							getLastCreatedActor().applyImpulse(1, 0, 10);
						}
						else
						{
							getLastCreatedActor().applyImpulse(-1, 0, 10);
						}
						trace("" + ("" + "\"after creating actor\""));
						_attackdelay = true;
						propertyChanged("_attackdelay", _attackdelay);
						runLater(1000 * 3, function(timeTask:TimedTask):Void
						{
							_attackdelay = false;
							propertyChanged("_attackdelay", _attackdelay);
						}, actor);
						actor.setAnimation("" + _AttackAnimation);
						runLater(1000 * (actor.getNumFrames() * 0.1), function(timeTask:TimedTask):Void
						{
							actor.setAnimation("" + _IdleAnimation);
						}, actor);
					}
					actor.setX(_OriginXPosition);
				}
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(5).ID, getActorType(3).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(event.thisFromTop)
				{
					actor.setAnimation("" + _AttackAnimation);
					recycleActor(actor);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}
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



class Design_58_58_MovementandAttack extends ActorScript
{
	public var _OnGround:Bool;
	public var _WalkLeftAnimation:String;
	public var _LeftKeyControl:String;
	public var _WalkRightAnimation:String;
	public var _RightKeyCOntrol:String;
	public var _IdleRightAnimation:String;
	public var _IdleLeftAnimation:String;
	public var _JumpKeyControl:String;
	public var _Jump:String;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("OnGround?", "_OnGround");
		_OnGround = false;
		nameMap.set("Walk Left Animation", "_WalkLeftAnimation");
		nameMap.set("Left Key Control", "_LeftKeyControl");
		nameMap.set("Walk Right Animation", "_WalkRightAnimation");
		nameMap.set("Right Key Control", "_RightKeyCOntrol");
		nameMap.set("Idle Right Animation", "_IdleRightAnimation");
		nameMap.set("Idle Left Animation", "_IdleLeftAnimation");
		nameMap.set("Jump Key Control", "_JumpKeyControl");
		nameMap.set("Jump Animation", "_Jump");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_OnGround = false;
		propertyChanged("_OnGround", _OnGround);
		actor.makeAlwaysSimulate();
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(isKeyDown(_LeftKeyControl))
				{
					actor.setXVelocity(-20);
					actor.setActorValue("Facing Right?", false);
					actor.setAnimation("" + _WalkLeftAnimation);
				}
				else if(isKeyDown(_RightKeyCOntrol))
				{
					actor.setXVelocity(20);
					actor.setActorValue("Facing Right?", true);
					actor.setAnimation("" + _WalkRightAnimation);
				}
				else
				{
					actor.setXVelocity(0);
					if((actor.getActorValue("Facing Right?") == true))
					{
						actor.setAnimation("" + _IdleRightAnimation);
						/* Otherwise, if neither direction is held down, then the */
					}
					else
					{
						actor.setAnimation("" + _IdleLeftAnimation);
					}
				}
				if(isKeyPressed(_JumpKeyControl))
				{
					if(_OnGround)
					{
						actor.setYVelocity(-30);
						/* Up is the jump key, so if it was pressed, then see if */
						/* the player is on the ground. If so, then make the */
						/* player fly upwards (which is a negative y-speed). The */
						/* 85-down gravity in the scene's physics will bring the */
						/* player back down naturally. */
					}
					_OnGround = false;
					propertyChanged("_OnGround", _OnGround);
					/* Since the scene (the entire map) is larger than the */
					/* screen (the visible part), keep moving the camera */
					/* to where the player is. */
				}
				engine.cameraFollow(actor);
				/* If the player has left the screen (such as falling down */
				/* between the platforms), then reload the scene to give */
				/* the user another chance at the level. */
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(26), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(event.thisFromBottom)
				{
					actor.setYVelocity(-30);
					recycleActor(event.otherActor);
					Engine.engine.setGameAttribute("Enter Cave", (Engine.engine.getGameAttribute("Enter Cave") + 1));
				}
				else
				{
					reloadCurrentScene(null, createCrossfadeTransition(0.2));
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}
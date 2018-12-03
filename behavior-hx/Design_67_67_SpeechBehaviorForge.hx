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



class Design_67_67_SpeechBehaviorForge extends ActorScript
{
	public var _DisplayDialog:Bool;
	public var _progressiveCount:Float;
	public var _copyMessage:Array<Dynamic>;
	public var _dialog01:Array<Dynamic>;
	public var _dialog02:Array<Dynamic>;
	public var _dialog03:Array<Dynamic>;
	public var _messageLength:Float;
	public var _ofLines:Float;
	public var _dialogBox:ActorType;
	public var _dialogBoxActor:Actor;
	public var _ofDialogues:Float;
	public var _rizandomNumber:Float;
	public var _camReturn:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_opendialog():Void
	{
		_DisplayDialog = true;
		propertyChanged("_DisplayDialog", _DisplayDialog);
		/* Create a copy of the dialog */
		_rizandomNumber = asNumber(_progressiveCount);
		propertyChanged("_rizandomNumber", _rizandomNumber);
		if((_rizandomNumber == 1))
		{
			_copyMessage = _dialog01.copy();
			propertyChanged("_copyMessage", _copyMessage);
		}
		else if((_rizandomNumber == 2))
		{
			_copyMessage = _dialog02.copy();
			propertyChanged("_copyMessage", _copyMessage);
		}
		else
		{
			_copyMessage = _dialog03.copy();
			propertyChanged("_copyMessage", _copyMessage);
		}
		_messageLength = asNumber(Math.ceil((asNumber(_copyMessage.length) / _ofLines)));
		propertyChanged("_messageLength", _messageLength);
		/* dialog box position set in the dialog box behavior */
		createRecycledActor(getActorType(672), 0, 0, Script.FRONT);
		_dialogBoxActor = getLastCreatedActor();
		propertyChanged("_dialogBoxActor", _dialogBoxActor);
		/* Used by dialog box to continue the conversation */
		_customEvent_progress();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_progress():Void
	{
		if((_messageLength > 0))
		{
			/* Subtract pages of dialog by 1 so there's not an infinite loop of non-ending dialog */
			_messageLength -= 1;
			propertyChanged("_messageLength", _messageLength);
			/* Set the dialog for the message box */
			for(index0 in 0...Std.int(_ofLines))
			{
				_copyMessage.splice(Std.int(0), 1);
			}
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("DisplayDialog?", "_DisplayDialog");
		_DisplayDialog = false;
		nameMap.set("progressiveCount", "_progressiveCount");
		_progressiveCount = 1.0;
		nameMap.set("copyMessage", "_copyMessage");
		nameMap.set("dialog01", "_dialog01");
		nameMap.set("dialog02", "_dialog02");
		nameMap.set("dialog03", "_dialog03");
		nameMap.set("messageLength", "_messageLength");
		_messageLength = 0.0;
		nameMap.set("# of Lines", "_ofLines");
		_ofLines = 4.0;
		nameMap.set("dialogBox", "_dialogBox");
		_dialogBox = getActorType(672);
		nameMap.set("dialogBoxActor", "_dialogBoxActor");
		nameMap.set("# of Dialogues", "_ofDialogues");
		_ofDialogues = 0.0;
		nameMap.set("rizandomNumber", "_rizandomNumber");
		_rizandomNumber = 0.0;
		nameMap.set("camReturn", "_camReturn");
		_camReturn = false;
		
	}
	
	override public function init()
	{
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}
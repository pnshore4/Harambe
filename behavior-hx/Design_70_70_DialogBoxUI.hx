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



class Design_70_70_DialogBoxUI extends ActorScript
{
	public var DialogBoxMode:Float;
	public var Width:Float;
	public var Height:Float;
	public var DialogHorizontalOffset:Float;
	public var DialogVerticalOffset:Float;
	public var Alignment:Float;
	public var xPos:Float;
	public var yPos:Float;
	public var TextLeftMargin:Float;
	public var TextRightMargin:Float;
	public var TextTopMargin:Float;
	public var TextBottomMargin:Float;
	public var DialogBoxActor:ActorType;
	public var FadeTime:Float;
	public var CoreBehavior:String;
	public var UseTypingEffect:Bool;
	public var TypingDelay:Float;
	public var TextOverflowIndicator:ActorType;
	public var OverflowHorizontalOffset:Float;
	public var OverflowVerticalOffset:Float;
	public var PortraitActorType:ActorType;
	public var PortraitHoriztonalOffset:Float;
	public var PortraitVerticalOffset:Float;
	public var TypingSound:Sound;
	public var _Font:Font;
	public var _DialogBoxColor:Int;
	public var _DialogBoxTransparency:Float;
	public var _OpenDialogSound:Sound;
	public var _NextPageDialogSound:Sound;
	public var _CloseDialogSound:Sound;
	public var _KeywordFont:Font;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_DialogBoxTyping():Bool
	{
		var __Self:Actor = actor;
		return asBoolean(actor.getValue(CoreBehavior, "isTyping"));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_HasOverflow():Bool
	{
		var __Self:Actor = actor;
		return asBoolean(actor.getValue(CoreBehavior, "hasOverflow"));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_changeDBColor(__NewColor:Int):Void
	{
		var __Self:Actor = actor;
		actor.setValue(CoreBehavior, "dialogBoxColor", __NewColor);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_changeFont(__newFont:Font):Void
	{
		var __Self:Actor = actor;
		actor.setValue(CoreBehavior, "currentFont", __newFont);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_IsDisplaying():Bool
	{
		var __Self:Actor = actor;
		return asBoolean(actor.getValue(CoreBehavior, "isDisplaying"));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_ChangeDialogImage(__DialogImage:ActorType):Void
	{
		var __Self:Actor = actor;
		actor.setValue(CoreBehavior, "bgActorType", __DialogImage);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_ChangePortrait(__Portrait:ActorType):Void
	{
		var __Self:Actor = actor;
		actor.setValue(CoreBehavior, "portraitActorType", __Portrait);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_DisplayDialog(__Text:String):Void
	{
		var __Self:Actor = actor;
		if(!(asBoolean(actor.getValue(CoreBehavior, "isDisplaying"))))
		{
			_customEvent_SetPosition();
		}
		actor.setValue(CoreBehavior, "currentText", __Text);
		actor.say(CoreBehavior, "_customEvent_" + "requestDialog");
	}
	public function _customEvent_SetProperties():Void
	{
		actor.setValue(CoreBehavior, "currentFont", _Font);
		actor.setValue(CoreBehavior, "keywordFont", _KeywordFont);
		actor.setValue(CoreBehavior, "fadeTime", FadeTime);
		actor.setValue(CoreBehavior, "useTypingEffect", UseTypingEffect);
		actor.setValue(CoreBehavior, "typeDelay", TypingDelay);
		actor.setValue(CoreBehavior, "dialogBoxColor", _DialogBoxColor);
		actor.setValue(CoreBehavior, "dialogBoxAlpha", (_DialogBoxTransparency / 100));
		if((hasValue(TypingSound)))
		{
			actor.setValue(CoreBehavior, "typingSound", TypingSound);
		}
		if((hasValue(_OpenDialogSound)))
		{
			actor.setValue(CoreBehavior, "openSound", _OpenDialogSound);
		}
		if((hasValue(_NextPageDialogSound)))
		{
			actor.setValue(CoreBehavior, "nextSound", _NextPageDialogSound);
		}
		if((hasValue(_CloseDialogSound)))
		{
			actor.setValue(CoreBehavior, "closeSound", _CloseDialogSound);
		}
		if((hasValue(TextOverflowIndicator)))
		{
			actor.setValue(CoreBehavior, "overflowActorType", TextOverflowIndicator);
			actor.setValue(CoreBehavior, "overflowXOffset", Math.round(OverflowHorizontalOffset));
			actor.setValue(CoreBehavior, "overflowYOffset", Math.round(OverflowVerticalOffset));
		}
		if((hasValue(PortraitActorType)))
		{
			actor.setValue(CoreBehavior, "portraitActorType", PortraitActorType);
			actor.setValue(CoreBehavior, "portraitXOffset", Math.round(PortraitHoriztonalOffset));
			actor.setValue(CoreBehavior, "portraitYOffset", Math.round(PortraitVerticalOffset));
		}
	}
	public function _customEvent_SetPosition():Void
	{
		actor.setValue(CoreBehavior, "alignment", Math.round(Alignment));
		actor.setValue(CoreBehavior, "currentXOffset", Math.round(DialogHorizontalOffset));
		actor.setValue(CoreBehavior, "currentYOffset", Math.round(DialogVerticalOffset));
		actor.setValue(CoreBehavior, "txtLeftMargin", Math.round(TextLeftMargin));
		actor.setValue(CoreBehavior, "txtRightMargin", Math.round(TextRightMargin));
		actor.setValue(CoreBehavior, "txtTopMargin", Math.round(TextTopMargin));
		actor.setValue(CoreBehavior, "txtBottomMargin", Math.round(TextBottomMargin));
		/* Align on Actor */
		if((Alignment == 1))
		{
			xPos = asNumber(actor.getScreenX());
			propertyChanged("xPos", xPos);
			yPos = asNumber(actor.getScreenY());
			propertyChanged("yPos", yPos);
		}
		/* Align Top Left */
		if((Alignment == 2))
		{
			xPos = asNumber(0);
			propertyChanged("xPos", xPos);
			yPos = asNumber(0);
			propertyChanged("yPos", yPos);
		}
		/* Align Top Right */
		if((Alignment == 3))
		{
			xPos = asNumber(getScreenWidth());
			propertyChanged("xPos", xPos);
			yPos = asNumber(0);
			propertyChanged("yPos", yPos);
		}
		/* Align Bottom Left */
		if((Alignment == 4))
		{
			xPos = asNumber(0);
			propertyChanged("xPos", xPos);
			yPos = asNumber(getScreenHeight());
			propertyChanged("yPos", yPos);
		}
		/* Align Bottom Right */
		if((Alignment == 5))
		{
			xPos = asNumber(getScreenWidth());
			propertyChanged("xPos", xPos);
			yPos = asNumber(getScreenHeight());
			propertyChanged("yPos", yPos);
		}
		/* Align Center */
		if((Alignment == 6))
		{
			xPos = asNumber((getScreenWidth() / 2));
			propertyChanged("xPos", xPos);
			yPos = asNumber((getScreenHeight() / 2));
			propertyChanged("yPos", yPos);
		}
		/* Align Top Center */
		if((Alignment == 7))
		{
			xPos = asNumber((getScreenWidth() / 2));
			propertyChanged("xPos", xPos);
			yPos = asNumber(0);
			propertyChanged("yPos", yPos);
		}
		/* Align Bottom Center */
		if((Alignment == 8))
		{
			xPos = asNumber((getScreenWidth() / 2));
			propertyChanged("xPos", xPos);
			yPos = asNumber(getScreenHeight());
			propertyChanged("yPos", yPos);
		}
		actor.setValue(CoreBehavior, "xPos", Math.round(xPos));
		actor.setValue(CoreBehavior, "yPos", Math.round(yPos));
	}
	public function _customEvent_SetMode():Void
	{
		if((DialogBoxMode == 1))
		{
			actor.setValue(CoreBehavior, "useBgImage", false);
			actor.setValue(CoreBehavior, "useFixedSize", true);
			actor.setValue(CoreBehavior, "currentWidth", Math.round(Width));
			actor.setValue(CoreBehavior, "currentHeight", Math.round(Height));
		}
		if((DialogBoxMode == 2))
		{
			actor.setValue(CoreBehavior, "useBgImage", false);
			actor.setValue(CoreBehavior, "useFixedSize", false);
			actor.setValue(CoreBehavior, "currentWidth", Math.round(Width));
		}
		if((DialogBoxMode == 3))
		{
			actor.setValue(CoreBehavior, "useBgImage", true);
			actor.setValue(CoreBehavior, "bgActorType", DialogBoxActor);
			actor.setValue(CoreBehavior, "useFixedSize", true);
		}
		if((DialogBoxMode == 4))
		{
			actor.setValue(CoreBehavior, "useBgImage", true);
			actor.setValue(CoreBehavior, "bgActorType", DialogBoxActor);
			actor.setValue(CoreBehavior, "useFixedSize", false);
			actor.setValue(CoreBehavior, "currentWidth", Math.round(Width));
			actor.setValue(CoreBehavior, "currentHeight", Math.round(Height));
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Dialog Box Mode", "DialogBoxMode");
		DialogBoxMode = 0.0;
		nameMap.set("Width", "Width");
		Width = 0.0;
		nameMap.set("Height", "Height");
		Height = 0.0;
		nameMap.set("Dialog Horizontal Offset", "DialogHorizontalOffset");
		DialogHorizontalOffset = 0.0;
		nameMap.set("Dialog Vertical Offset", "DialogVerticalOffset");
		DialogVerticalOffset = 0.0;
		nameMap.set("Alignment", "Alignment");
		Alignment = 0.0;
		nameMap.set("xPos", "xPos");
		xPos = 0.0;
		nameMap.set("yPos", "yPos");
		yPos = 0.0;
		nameMap.set("Text Left Margin", "TextLeftMargin");
		TextLeftMargin = 0.0;
		nameMap.set("Text Right Margin", "TextRightMargin");
		TextRightMargin = 0.0;
		nameMap.set("Text Top Margin", "TextTopMargin");
		TextTopMargin = 0.0;
		nameMap.set("Text Bottom Margin", "TextBottomMargin");
		TextBottomMargin = 0.0;
		nameMap.set("Dialog Box Actor", "DialogBoxActor");
		nameMap.set("Fade Time", "FadeTime");
		FadeTime = 0.0;
		nameMap.set("Core Behavior", "CoreBehavior");
		CoreBehavior = "Dialog Box Core";
		nameMap.set("Use Typing Effect?", "UseTypingEffect");
		UseTypingEffect = false;
		nameMap.set("Typing Delay", "TypingDelay");
		TypingDelay = 0.15;
		nameMap.set("Text Overflow Indicator", "TextOverflowIndicator");
		nameMap.set("Overflow Horizontal Offset", "OverflowHorizontalOffset");
		OverflowHorizontalOffset = 0.0;
		nameMap.set("Overflow Vertical Offset", "OverflowVerticalOffset");
		OverflowVerticalOffset = 0.0;
		nameMap.set("Portrait Actor Type", "PortraitActorType");
		nameMap.set("Portrait Horiztonal Offset", "PortraitHoriztonalOffset");
		PortraitHoriztonalOffset = 0.0;
		nameMap.set("Portrait Vertical Offset", "PortraitVerticalOffset");
		PortraitVerticalOffset = 0.0;
		nameMap.set("Typing Sound", "TypingSound");
		nameMap.set("Font", "_Font");
		nameMap.set("Dialog Box Color", "_DialogBoxColor");
		_DialogBoxColor = Utils.getColorRGB(0,0,0);
		nameMap.set("Dialog Box Transparency", "_DialogBoxTransparency");
		_DialogBoxTransparency = 100.0;
		nameMap.set("Open Dialog Sound", "_OpenDialogSound");
		nameMap.set("Next Page Dialog Sound", "_NextPageDialogSound");
		nameMap.set("Close Dialog Sound", "_CloseDialogSound");
		nameMap.set("Keyword Font", "_KeywordFont");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		runLater(1000 * 0.1, function(timeTask:TimedTask):Void
		{
			_customEvent_SetMode();
			_customEvent_SetPosition();
			_customEvent_SetProperties();
		}, actor);
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}
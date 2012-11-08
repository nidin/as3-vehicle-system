/**
 * Car Movement - Accelerate, Brake, Rotate & Reverse
 * ---------------------
 * VERSION: 2.0
 * DATE: 1/09/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package nid.test
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
 
	public class Car extends Sprite
	{
		//Settings
		private var speed:Number = 0;
		private var speedMax:Number = 8;
		private var speedMaxReverse:Number = -3;
		private var speedAcceleration:Number = .15;
		private var speedDeceleration:Number = .90;
		private var groundFriction:Number = .95;
 
		private var steering:Number = 0;
		private var steeringMax:Number = 2;
		private var steeringAcceleration:Number = .10;
		private var steeringFriction:Number = .98;
 
		private var velocityX:Number = 0;
		private var velocityY:Number = 0;
 
		private var up:Boolean = false;
		private var down:Boolean = false;
		private var left:Boolean = false;
		private var right:Boolean = false;
 
		public function Car()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
 
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
 
			init();
		}
 
		private function init():void
		{
			stage.addEventListener(Event.ENTER_FRAME, runGame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, myOnPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, myOnRelease);
		}
 
		private function runGame(event:Event):void
		{
			if (up)
			{
				//check if below speedMax
				if (speed < speedMax) 				{ 					//speed up 					speed += speedAcceleration; 					//check if above speedMax 					if (speed > speedMax)
					{
						//reset to speedMax
						speed = speedMax;
					}
				}
			}
 
			if (down)
			{
				//check if below speedMaxReverse
				if (speed > speedMaxReverse)
				{
					//speed up (in reverse)
					speed -= speedAcceleration;
					//check if above speedMaxReverse
					if (speed < speedMaxReverse) 					{ 						//reset to speedMaxReverse 						speed = speedMaxReverse; 					} 				} 			} 			 			if (left) 			{ 				//turn left 				steering -= steeringAcceleration; 				//check if above steeringMax 				if (steering > steeringMax)
				{
					//reset to steeringMax
					steering = steeringMax;
				}
			}
 
			if (right)
			{
				//turn right
				steering += steeringAcceleration;
				//check if above steeringMax
				if (steering < -steeringMax) 				{ 					//reset to steeringMax 					steering = -steeringMax; 				} 			} 			 			// friction	 			speed *= groundFriction; 			 			// prevent drift 			if(speed > 0 && speed < 0.05) 			{ 				speed = 0 			} 			 			// calculate velocity based on speed 			velocityX = Math.sin (this.rotation * Math.PI / 180) * speed; 			velocityY = Math.cos (this.rotation * Math.PI / 180) * -speed; 			 			// update position	 			this.x += velocityX; 			this.y += velocityY; 			 			// prevent steering drift (right) 			if(steering > 0)
			{
				// check if steering value is really low, set to 0
				if(steering < 0.05)
				{
					steering = 0;
				}
			}
			// prevent steering drift (left)
			else if(steering < 0) 			{ 				// check if steering value is really low, set to 0 				if(steering > -0.05)
				{
					steering = 0;
				}
			}
 
			// apply steering friction
			steering = steering * steeringFriction;
 
			// make car go straight after driver stops turning
			steering -= (steering * 0.1);
 
			// rotate
			this.rotation += steering * speed;
		}
 
		/**
		 * Keyboard Handlers
		 */
		private function myOnPress(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{
				case Keyboard.UP:
					up = true;
					break;
 
				case Keyboard.DOWN:
					down = true;
					break;
 
				case Keyboard.LEFT:
					left = true;
					break;
 
				case Keyboard.RIGHT:
					right = true;
					break;
			}
 
			event.updateAfterEvent();
		}
 
		private function myOnRelease(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{
				case Keyboard.UP:
					up = false;
					break;
 
				case Keyboard.DOWN:
					down = false;
					break;
 
				case Keyboard.LEFT:
					left = false;
					break;
 
				case Keyboard.RIGHT:
					right = false;
					break;
			}
 
		}
 
	}
 
}

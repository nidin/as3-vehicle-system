//import some important flash libraries.
import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.display.MovieClip;
 
//initializes variables.
var speed:Number = 0.08;
var xspeed:Number = 0;
var yspeed:Number = 0;
var friction:Number = 0.98;
var key_left:Boolean = false;
var key_right:Boolean = false;
var key_up:Boolean = false;
var key_down:Boolean = false;
 
//Checks if the player presses a key.
stage.addEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
stage.addEventListener(KeyboardEvent.KEY_UP,KeyUp);
 
//Lets the function main play every frame.
addEventListener(Event.ENTER_FRAME,Main);
 
//create the function main.
function Main(event:Event){
	CheckKeys();
	MoveHero();
}
 
//create the function KeyDown.
function KeyDown(event:KeyboardEvent){
	if(event.keyCode == 37){		//checks if left arrowkey is pressed.
		key_left = true;
	}
	if(event.keyCode == 39){		//checks if right arrowkey is pressed.
		key_right = true;
	}
	if(event.keyCode == 38){		//checks if up arrowkey is pressed.
		key_up = true;
	}
	if(event.keyCode == 40){		//checks if down arrowkey is pressed.
		key_down = true;
	}
}
 
function KeyUp(event:KeyboardEvent){
	if(event.keyCode == 37){		//checks if left arrowkey is released.
		key_left = false;
	}
	if(event.keyCode == 39){		//checks if right arrowkey is released.
		key_right = false;
	}
	if(event.keyCode == 38){		//checks if up arrowkey is released.
		key_up = false;
	}
	if(event.keyCode == 40){		//checks if down arrowkey is released.
		key_down = false;
	}
}
 
function CheckKeys(){
	if(key_left){
		xspeed -= speed;
	}
	if(key_right){
		xspeed += speed;
	}
	if(key_up){
		yspeed -= speed;
	}
	if(key_down){
		yspeed += speed;
	}
}
 
function MoveHero(){
	hero.x += xspeed;
	hero.y += yspeed;
	xspeed *= friction;
	yspeed *= friction;
}
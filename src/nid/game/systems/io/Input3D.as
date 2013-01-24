package nid.game.systems.io 
{
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class Input3D 
	{
		public static var UP:Boolean
		public static var DOWN:Boolean
		public static var LEFT:Boolean
		public static var RIGHT:Boolean
		public static var SPACE:Boolean
		public static var CTRL:Boolean
		public static var ALT:Boolean
		public static var BACKSPACE:Boolean
		public static var ESC:Boolean
		public static var ENTER:Boolean
		public static var B:Boolean
		public static var D:Boolean
		public static var R:Boolean
		public static var X:Boolean
		public static var Z:Boolean
		public static var SHIFT:Boolean;
		public static var N:Boolean;
		
		static public function mapUp(keyCode:uint):void 
		{
			switch(keyCode)
			{
				case Keyboard.UP:UP = false; break;
				case Keyboard.DOWN:DOWN = false; break;
				case Keyboard.LEFT:LEFT= false; break;
				case Keyboard.RIGHT:RIGHT= false; break;
				case Keyboard.SPACE:SPACE= false; break;
				case Keyboard.CONTROL:CTRL= false; break;
				case Keyboard.ALTERNATE:ALT= false; break;
				case Keyboard.SHIFT:SHIFT= false; break;
				case Keyboard.BACKSPACE:BACKSPACE= false; break;
				case Keyboard.ESCAPE:ESC= false; break;
				case Keyboard.ENTER:ENTER= false; break;
				case Keyboard.B:B = false; break;
				case Keyboard.D:D = false; break;
				case Keyboard.N:N = false; break;
				case Keyboard.R:R = false; break;
				case Keyboard.X:X = false; break;
				case Keyboard.Z:Z = false; break;
			}
		}
		static public function mapDown(keyCode:uint):void 
		{
			switch(keyCode)
			{
				case Keyboard.UP:UP = true; break;
				case Keyboard.DOWN:DOWN = true; break;
				case Keyboard.LEFT:LEFT= true; break;
				case Keyboard.RIGHT:RIGHT= true; break;
				case Keyboard.SPACE:SPACE= true; break;
				case Keyboard.CONTROL:CTRL= true; break;
				case Keyboard.ALTERNATE:ALT = true; break;
				case Keyboard.SHIFT:SHIFT= true; break;
				case Keyboard.BACKSPACE:BACKSPACE= true; break;
				case Keyboard.ESCAPE:ESC= true; break;
				case Keyboard.ENTER:ENTER = true; break;
				case Keyboard.B:B = true; break;
				case Keyboard.D:D = true; break;
				case Keyboard.N:N = true; break;
				case Keyboard.R:R = true; break;
				case Keyboard.X:X = true; break;
				case Keyboard.Z:Z = true; break;
			}
		}
	}

}
package nid.utils 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class Graph extends Sprite 
	{
		private var s:Shape;
		private var busy:Boolean;
		private var count:int=0;
		
		public function Graph() 
		{
			s = new Shape();
			addChild(s);
			s.graphics.lineStyle(1,0xff0000);
		}
		public function update(p1:Number, p2:Number,clear:Boolean=false):void
		{
			if (clear) 
			{
				s.graphics.clear();
				s.graphics.lineStyle(1, 0xff0000);
				s.graphics.lineTo(0, p2);
			}
			s.graphics.lineTo(p1, p2);
			
		}
		
		public function changeColor():void 
		{
			s.graphics.lineStyle(1, Math.random() * (0xffffff));
		}
	}

}
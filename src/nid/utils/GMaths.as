package nid.utils 
{
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class GMaths 
	{
		public static function easeIn(t:Number, b:Number, c:Number):Number { return c * pow3( t ) + b; }
		public static function easeOut(t:Number, b:Number, c:Number):Number { return c * ( pow3( t - 1 ) + 1) + b; }
		[inline]
		public static function pow3(x:Number):Number { return (x * x * x); }
		
		public static function SGN(value:Number):int
		{
			return value == 0?0:(value < 0 ? -1 : 1);
		}
	}

}
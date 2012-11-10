package nid.game.systems.vehicle 
{
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class CarType 
	{
		public var b:Number = 1.0;				// in m, distance from CG to front axle
		public var c:Number = 1.0;				// in m, idem to rear axle
		public var h:Number = 1.0;				// in m, height of CM from ground
		public var wheelbase:Number = b + c;		// wheelbase in m
		public var mass:Number = 2600;				// in kg
		public var inertia:Number = 2600;			// in kg.m
		public var width:Number = 1.5;
		public var length:Number = 3.0;
		public var wheellength:Number = 0.7;
		public var wheelwidth:Number = 0.3;
	}

}
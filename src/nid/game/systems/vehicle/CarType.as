package nid.game.systems.vehicle 
{
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class CarType 
	{
		public var wheelbase:Number = 2.625;		// wheelbase in m
		public var b:Number = wheelbase / 2;				// in m, distance from CG to front axle
		public var c:Number = wheelbase / 2;				// in m, idem to rear axle
		public var h:Number = 0.865;				// in m, height of CM from ground
		public var mass:Number = 800;				// in kg
		//public var mass:Number = 1410;				// in kg
		public var inertia:Number = 1410;			// in kg.m
		public var width:Number = 1.770;
		public var length:Number = 4.490;
		public var wheellength:Number = 0.7;
		public var wheelwidth:Number = 0.3;
		
		public var max_brake:Number = 1000;
		public var max_throttle:Number = 100;
		public var max_streeing_angle:Number= 45;
	}

}
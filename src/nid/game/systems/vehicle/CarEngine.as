package nid.game.systems.vehicle 
{
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class CarEngine 
	{
		public var rpm:Number = 1000;
		public var min_rpm:Number = 1000;
		public var max_rpm:Number = 3500;
		public var redline_rpm:Number = 6000;
		
		public var start_torque:Number = 150;
		public var end_torque:Number = 275;
		public var max_torque:Number = 392;
		
		public var toruqe:Number;
		
		public function CarEngine() 
		{
			
		}
		
	}

}
package nid.game.systems 
{
	import flare.core.Pivot3D;
	import nid.game.systems.vehicle.IVehicle;
	import nid.game.systems.vehicle.VehicleControl;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class VehicleSystem 
	{
		public var control:VehicleControl;
		public var vehicle:IVehicle;
		
		public function VehicleSystem() 
		{
			control = new VehicleControl();
		}
		public function init(_vehicle:IVehicle):void
		{
			vehicle = _vehicle;
		}
		
	}

}
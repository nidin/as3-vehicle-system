package nid.game.systems 
{
	import flare.core.Pivot3D;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import nid.game.systems.vehicle.Car;
	import nid.game.systems.vehicle.IVehicle;
	import nid.game.systems.vehicle.VehicleControl;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class VehicleSystem 
	{
		private var car:Car;
		public var control:VehicleControl;
		public var vehicle:IVehicle;
		
		internal const C_drag:Number = 0.4257;
		internal const C_rr:Number = 12.8;
		
		public var engineForce:Number = 17500;
		public var mass:Number = 1500;
		public var brake:Boolean;
		
		private var F_long:Number=0;
		private var F_traction:Number=0;
		private var F_drag:Number=0;
		private var F_rr:Number=0;
		private var F_braking:Number=3000;
		private var a:Number = 0;
		private var v:Number = 0;
		private var u:Number = 1;
		
		private var dt:Number=0;
		private var st:Number=0;
		private var dtID:uint;
		private var busy:Boolean;
		private var steering_power:Number=10;
		private var steering_rot:Number=0;
		private var acc_value:int;
		private var brake_value:int;
		private var velocity:Number;
		private var steering_value:int;
		
		public function VehicleSystem(car:Car) 
		{
			this.car = car;
			control = new VehicleControl();
		}
		
		public function init(_vehicle:IVehicle):void
		{
			vehicle = _vehicle;
		}
		
		public function accelerate(value:int):void 
		{
			if (value == 0)
			{
				if (dt > 0) dt -= 0.05;
			}
			else
			{
				if (dt < 1) dt += 0.05;
			}
			acc_value = value;
			F_traction = u * engineForce * value * dt;
			//dt = 1;
		}
		
		public function process():void 
		{
			if (brake && velocity < 0)
			{
				v = 0;
				return;
			}
			F_drag 	= -C_drag * v * v;
			F_rr 	= -C_rr * v;
			F_traction = brake?-F_braking:F_traction;
			F_long = F_traction + F_drag + F_rr;
			
			a = F_long / mass;
			v = v + a;
			velocity = v / 100
			
			car.translateZ(velocity);
			if (velocity != 0) car.rotateY(steering_rot);
			//trace('---------------------------');
			//trace('F_long:' + F_long);
			//trace('F_drag:' + F_drag);
			//trace('F_rr:' + F_rr);
			//trace('acceleration:' + a);
			//trace('velocity:' + v.toFixed(0));
			busy = true;
		}
		
		public function steering(value:int):void 
		{
			if (value == 0)
			{
				st = Number(st.toFixed(2));
				if (st > 0) st -= 0.05;
				else if (st < 0) st += 0.05;
			}
			else
			{
				if (steering_value != value)
				st = -st;
				if (st < 1) st += 0.05;
			}
			steering_value = value == 0?steering_value:value;
			steering_rot = steering_value * st * steering_power;
			
			car.wheel_FL.setRotation(0, 180 + (steering_value * 45 * st), 0);
			car.wheel_FR.setRotation(0, steering_value * 45 * st, 0);
		}
		private function resetInterval():void {
			dt = 0;
			v = 0;
			a = 0;
			busy = false;
		}
	}

}
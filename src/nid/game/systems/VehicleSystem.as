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
		internal var C_rr:Number = C_drag * 30;
		
		//Engine
		public var rpm:Number = 2500;
		public var hp:Number;
		public var torque:Number = 448;
		
		
		public var engineForce:Number = 17500;
		public var mass:Number = 1500;
		public var g:Number = 9.81;
		public var W:Number = mass * g;
		public var brake_value:Boolean;
		public var h:Number = 0.93;
		public var L:Number = 2.5;
		
		public var F_drive:Number=0;
		public var F_traction:Number=0;
		public var F_long:Number=0;
		public var F_drag:Number=0;
		public var F_rr:Number=0;
		public var F_braking:Number=0;
		public var brakingForce:Number=3000;
		public var a:Number = 0;
		public var v:Number = 0;
		public var u:Number = 1;
		
		private var dt:Number=0;
		private var st:Number=0;
		private var dtID:uint;
		private var busy:Boolean;
		private var steering_power:Number=8;
		private var steering_rot:Number=0;
		private var acc_value:int;
		private var brake_value_value:int;
		private var bt:Number=0;
		public var velocity:Number;
		public var steering_value:int;
		public var wheel_speed:Number=5;
		public var Wshift:Number;
		public var Wf:Number;
		public var Wr:Number;
		public var xg:Number = 2.66;
		public var xd:Number = 3.42;
		public var Rw:Number = 0.34;
		public var n:Number = 0.7;
		
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
				else dt = 0;
			}
			else
			{
				if (dt < 1) dt += 0.05;
			}
			acc_value = value == 0?acc_value:value;
			F_traction = u * engineForce * acc_value * dt;
			//dt = 1;
		}
		
		public function brake(value:Boolean):void 
		{
			if (!value)
			{
				if (bt > 0) bt -= 0.01;
				else bt = 0;
			}
			else
			{
				if (bt < 1) bt += 0.05;
			}
			brake_value = value;
			F_braking = brakingForce * bt;
			//dt = 1;
		}
		
		public function process():void 
		{
			if (brake_value && velocity < 0)
			{
				v = 0;
				return;
			}
			
			F_drive = u * torque * xg * xd * n / Rw;
			
			F_drag 	= -C_drag * v * v;
			F_rr 	= -C_rr * v;
			//F_traction = brake_value? -F_braking:F_traction;
			F_long = (brake_value? -F_braking:F_traction) + F_drag + F_rr;
			
			a = F_long / mass;
			v = v + a;
			velocity = v / 100
			wheel_speed = v;
			car.translateZ(velocity);
			car.wheel_FL.rotateX(-wheel_speed);
			car.wheel_FR.rotateX(wheel_speed);
			if (!brake_value)
			{
				car.wheel_BL.rotateX(-wheel_speed);
				car.wheel_BR.rotateX(wheel_speed);
			}
			
			if (velocity != 0) car.rotateY(steering_rot * velocity);
			
			//Wf = 0.5 * W - ((h / L) * mass * a);
			//Wr = 0.5 * W + ((h / L) * mass * a);
			
			//Wshift = Wf / Wr;
			//car.chassis.setRotation(3 * (Wshift-1),0, 0);
			//trace('------------');
			//trace('Wf:' + Wf);
			//trace('Wr:' + Wr);
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
			
			car.wheel_FL.setRotation(car.wheel_FL.getRotation().x, 180 + (steering_value * 45 * st), 0);
			car.wheel_FR.setRotation(car.wheel_FR.getRotation().x, steering_value * 45 * st, 0);
		}
		private function resetInterval():void {
			dt = 0;
			v = 0;
			a = 0;
			busy = false;
		}
	}

}
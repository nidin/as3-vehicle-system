package nid.game.systems 
{
	import flare.core.Pivot3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
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
		public var car:Car;
		public var control:VehicleControl;
		public var vehicle:IVehicle;
		
		internal const C_drag:Number = 0.4257;
		internal var C_rr:Number = C_drag * 30;
		
		//Engine
		public var rpm:Number = 2500;
		public var hp:Number;
		
		
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
		
		public var dt:Number=0;
		public var st:Number=0;
		public var dtID:uint;
		public var busy:Boolean;
		public var steering_power:Number=8;
		public var steering_rot:Number=0;
		public var acc_value:int;
		public var brake_value_value:int;
		public var bt:Number=0;
		public var steering_value:int;
		public var wheel_speed:Number=5;
		public var Wshift:Number;
		public var Wf:Number;
		public var Wr:Number;
		public var xg:Number = 2.66;
		public var xd:Number = 3.42;
		public var Rw:Number = 0.34;
		public var n:Number = 0.7;
		
		//Port values
		public var DRAG:Number 		=  5.0;
		public var RESISTANCE:Number 	=  30.0;
		public var CA_R:Number	 		= -5.20
		public var CA_F:Number 		= -5.0
		public var MAX_GRIP:Number 	=  16.0
		public var sn:Number;
		public var cs:Number;
		public var breakme:Number;
		public var velocity:Point = new Point();
		public var yawspeed:Number;
		public var rot_angle:Number;
		public var sideslip:Number = 0;
		public var slipanglefront:Number;
		public var slipanglerear:Number;
		public var weight:Number;
		public var flatf:Point = new Point();
		public var front_slip:Boolean = false;
		public var rear_slip:Boolean = false;
		public var ftraction:Point = new Point();
		public var resistance:Point = new Point();
		public var force:Point = new Point();
		public var torque:Number = 448;
		public var acceleration:Point = new Point();
		public var angular_acceleration:Number;
		public var acceleration_wc:Point = new Point();
		public var DELTA_T:Number = 0.01;
		public var delta_t:Number = DELTA_T;
		public var flatr:Point = new Point();
		
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
			//trace('accelerate:' + value);
			/*if (value == 0)
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
			car.throttle = 100 * dt;*/
			acc_value = value;
			if (value > 0 && car.throttle < 100) 
			{
				car.throttle += 10;
			}
			else if (value <= 0 &&  car.throttle >= 10)
			{
				car.throttle -= 10;
			}
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
			
			if (value) 
			{
				car.brake = 1000;
				car.throttle = 0;
			}
			else car.brake = 0;
			//dt = 1;
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
			//trace(car.wheel_FL.getRotation().x);
			if (steering_value != 0)
			{
				car.wheel_FL.setRotation(car.wheel_FL.getRotation().x, 180 + (steering_value * 45 * st), 0);
				car.wheel_FR.setRotation(car.wheel_FR.getRotation().x, steering_value * 45 * st, 0);
			}
			
			if (value < 0 && car.steerangle > - Math.PI / 4.0 )
			{
				car.steerangle -= Math.PI / 32.0;
			}
			else if (value > 0 && car.steerangle < Math.PI / 4.0 )
			{
				car.steerangle += Math.PI / 32.0;
			}
			else
			{
				car.steerangle = 0;
			}
		}
		
		public function do_physics():void 
		{
			sn = Math.sin(car.angle);
			cs = Math.cos(car.angle);
			
			if( car.steerangle != 0.0 )
			{
				breakme = 1;
			}

			// SAE convention: x is to the front of the car, y is to the right, z is down

			//	bangz: Velocity of Car. Vlat and Vlong
			// transform velocity in world reference frame to velocity in car reference frame
			velocity.x =  cs * car.velocity_wc.y + sn * car.velocity_wc.x;
			velocity.y = -sn * car.velocity_wc.y + cs * car.velocity_wc.x;

		// Lateral force on wheels
		//	
			// Resulting velocity of the wheels as result of the yaw rate of the car body
			// v = yawrate * r where r is distance of wheel to CG (approx. half wheel base)
			// yawrate (ang.velocity) must be in rad/s
			//
			yawspeed = car.cartype.wheelbase * 0.5 * car.angularvelocity;	

			//bangz: velocity.x = fVLong_, velocity.y = fVLat_
			if( velocity.x == 0 )		// TODO: fix singularity
				rot_angle = 0;
			else
				rot_angle = Math.atan2( yawspeed, velocity.x);

			// Calculate the side slip angle of the car (a.k.a. beta)
			if( velocity.x == 0 )		// TODO: fix singularity
				sideslip = 0;
			else
				sideslip = Math.atan2( velocity.y, velocity.x);		

			// Calculate slip angles for front and rear wheels (a.k.a. alpha)
			slipanglefront = sideslip + rot_angle - car.steerangle;
			slipanglerear  = sideslip - rot_angle;

			// weight per axle = half car mass times 1G (=9.8m/s^2) 
			weight = car.cartype.mass * 9.8 * 0.5;	
			
			// lateral force on front wheels = (Ca * slip angle) capped to friction circle * load
			flatf.x = 0;
			flatf.y = CA_F * slipanglefront;
			flatf.y = Math.min(MAX_GRIP, flatf.y);
			flatf.y = Math.max(-MAX_GRIP, flatf.y);
			flatf.y *= weight;
			if(front_slip)
				flatf.y *= 0.5;

			// lateral force on rear wheels
			flatr.x = 0;
			flatr.y = CA_R * slipanglerear;
			flatr.y = Math.min(MAX_GRIP, flatr.y);
			flatr.y = Math.max(-MAX_GRIP, flatr.y);
			flatr.y *= weight;
			if(rear_slip)
				flatr.y *= 0.5;

			// longtitudinal force on rear wheels - very simple traction model
			ftraction.x = 1000 * (car.throttle - car.brake * SGN(velocity.x));
			ftraction.y = 0;
			if(rear_slip)
				ftraction.x *= 0.5;

		// Forces and torque on body
			
			// drag and rolling resistance
			resistance.x = -( RESISTANCE * velocity.x + DRAG * velocity.x * Math.abs(velocity.x) );
			resistance.y = -( RESISTANCE * velocity.y + DRAG * velocity.y * Math.abs(velocity.y) );

			// sum forces
			force.x = ftraction.x + Math.sin(car.steerangle) * flatf.x + flatr.x + resistance.x;
			force.y = ftraction.y + Math.cos(car.steerangle) * flatf.y + flatr.y + resistance.y;	

			// torque on body from lateral forces
			torque = car.cartype.b * flatf.y - car.cartype.c * flatr.y;

		// Acceleration
			
			// Newton F = m.a, therefore a = F/m
			acceleration.x = force.x/car.cartype.mass;
			acceleration.y = force.y/car.cartype.mass;
			
			angular_acceleration = torque / car.cartype.inertia;

		// Velocity and position
			
			// transform acceleration from car reference frame to world reference frame
			acceleration_wc.x =  cs * acceleration.y + sn * acceleration.x;
			acceleration_wc.y = -sn * acceleration.y + cs * acceleration.x;

			// velocity is integrated acceleration
			//
			car.velocity_wc.x += delta_t * acceleration_wc.x;
			car.velocity_wc.y += delta_t * acceleration_wc.y;

			// position is integrated velocity
			//
			car.x = car.position_wc.x += delta_t * car.velocity_wc.x;
			car.z = car.position_wc.y += delta_t * car.velocity_wc.y;
			
			
		// Angular velocity and heading

			// integrate angular acceleration to get angular velocity
			//
			car.angularvelocity += delta_t * angular_acceleration;

			// integrate angular velocity to get angular orientation
			//
			car.angle += delta_t * car.angularvelocity ;
			//car.setRotation(car.angle, 0, 0);
			//car.rotateY(rot_angle);
			car.setRotation(0, car.angle * (180 / Math.PI), 0);
			//car.setOrientation(new Vector3D(0, car.angle * (Math.PI / 180), 0));
			
			car.wheel_FL.rotateX(-velocity.x);
			car.wheel_FR.rotateX(velocity.x);
			if (!brake_value)
			{
				car.wheel_BL.rotateX(-velocity.x);
				car.wheel_BR.rotateX(velocity.x);
			}
		}
		
		private function SGN(value:Number):int
		{
			return value == 0?0:(value < 0 ? -1 : 1);
		}
		
		
		public function resetInterval():void {
			dt = 0;
			v = 0;
			a = 0;
			busy = false;
		}
	}

}
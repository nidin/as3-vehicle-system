package nid.game.systems 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import nid.game.systems.vehicle.Car;
	import nid.game.systems.vehicle.IVehicle;
	import nid.game.systems.vehicle.VehicleControl;
	import nid.test.RootReference;
	import nid.utils.GMaths;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class VehicleSystem 
	{
		public var abs_velocity:Number=0;
		private var direction:int=0;
		static private const STEERING_STIFNESS:Number = 0.026;
		public var throttle_value:Number;
		public var enableLateralForces:Boolean = false;
		public var wheel_angularvelocity:Number;
		public var min_velocity:Number = 0.5;
		public var speed:Number;
		public var car:Car;
		public var control:VehicleControl;
		public var vehicle:IVehicle;
		
		//internal var C_drag:Number = 0.4257;
		internal var C_drag:Number = 0.01;
		internal var C_traction:Number = 100;
		internal var C_rr:Number = C_drag * 5;
		internal var C_braking:Number = 12000;
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
		
		public var T_drive:Number=0;
		public var F_drive:Number=0;
		public var F_traction:Point = new Point();
		public var F_long:Point = new Point();
		public var F_lateral:Point = new Point();
		public var F_drag:Point = new Point();
		public var F_rr:Point = new Point();
		public var F_back:Point = new Point();
		public var F_braking:Number=0;
		public var brakingForce:Number=3000;
		public var a:Number = 0;
		public var v:Number = 0;
		public var u:Number = 1;
		
		public var at:Number=0;
		public var st:Number=0;
		public var dtID:uint;
		public var busy:Boolean;
		public var steering_power:Number=8;
		public var steering_rot:Number=0;
		public var acc_value:int;
		public var brake_value_value:int;
		public var bt:Number=0;
		public var steering_value:int;
		public var Wshift:Number;
		public var Wf:Number;
		public var Wr:Number;
		public var Rw:Number = 0.34;
		
		//Port values
		public var cornering_stiffness_F:Number = -5.0
		public var cornering_stiffness_R:Number	= -5.20
		public var MAX_GRIP:Number 	=  16.0
		public var sn:Number;
		public var cs:Number;
		public var breakme:Number;
		public var velocity:Point = new Point();
		public var yawspeed:Number;
		public var rot_angle:Number;
		public var side_slip:Number = 0;
		public var slip_angle_F:Number=0.1;
		public var slip_angle_R:Number=0.1;
		public var weight:Number;
		public var F_lat_f:Point = new Point();
		public var front_slip:Boolean = false;
		public var rear_slip:Boolean = true;
		public var resistance:Point = new Point();
		public var force:Point = new Point();
		public var max_torque:Number;
		public var C_torque:Number;
		public var acceleration:Point = new Point();
		public var angular_acceleration:Number=0;
		public var acceleration_wc:Point = new Point();
		public var delta_t:Number = 0.1;
		public var F_lat_r:Point = new Point();
		public var drpf:Number;
		public var drps:Number;
		public var rpsWheel:Number;
		public var kmh:Number;
		public var rpmWheel:Number=0;
		public var slipratio:Number = 5;
		public var rear_wheel_rotation:Number;
		public var C_scale:Number = 1;
		public var C_torque_f:Number;
		public var C_torque_r:Number;
		public var NOS:Number=1;
		
		public function VehicleSystem(car:Car) 
		{
			delta_t = 1 / RootReference.stage.frameRate;
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
				if (at > 0) at -= 0.05;
				if (at <= 0) at = 0;
			}
			else
			{
				if (acc_value != value) at = 0;
				if (at < 1) at += 0.05;
			}
			acc_value = value == 0?acc_value:value;
			throttle_value = car.cartype.max_throttle * acc_value * at;
			car.reverse = throttle_value < 0;
			car.clutch = throttle_value == 0 || brake_value;
			car.throttle = Math.abs(throttle_value);
			throttle_value = brake_value?0:throttle_value;
			//car.phyVehicle.setAccelerate(throttle_value);
			//car.phyVehicle.setAccelerate(15);
		}
		
		public function brake(value:Boolean):void 
		{
			if (!value)
			{
				if (bt > 0) bt -= 0.05;
				else bt = 0;
			}
			else
			{
				if (bt < 1) bt += 0.05;
			}
			brake_value = value;
			car.brake = car.cartype.max_brake * bt;
			
			if (value && abs_velocity > min_velocity)
			{
				F_braking = car.brake;
			}
			else
			{
				F_braking = 0;
			}
		}
		
		public function steering(value:int):void 
		{
			if (value == 0)
			{
				st = Number(st.toFixed(2));
				if (st > 0) st -= STEERING_STIFNESS;
				else if (st < 0) st += STEERING_STIFNESS;
			}
			else
			{
				if (steering_value != value)
				st = 0;
				if (st < 1) st += STEERING_STIFNESS;
				else st = 1;
			}
			
			steering_value = value == 0?steering_value:value;
			
			if (steering_value != 0)
			{
				steering_rot = 180 + (steering_value * car.cartype.max_streeing_angle * st);
				//car.wheel_FL.setRotation(car.wheel_FL.getRotation(false).x, steering_rot , 0);
				//car.wheel_FR.setRotation(car.wheel_FR.getRotation().x, steering_value * car.cartype.max_streeing_angle * st, 0);
			}
			
			car.steerangle = (steering_value * car.cartype.max_streeing_angle * st) * Math.PI / 180;
			car.phyVehicle.setSteeringValue(car.steerangle, 0);
			car.phyVehicle.setSteeringValue(car.steerangle, 1);
		}
		
		public function process():void 
		{
			/*acceleration.x = F_long / mass;
			
			velocity.x = velocity.x + (delta_t * acceleration.x);
			car.z = car.z + (delta_t * velocity.x);*/
			
			
			sn = Math.sin(car.angle);
			cs = Math.cos(car.angle);
			
			//velocity.x =  cs * car.velocity_wc.y + sn * car.velocity_wc.x;
			//velocity.y = -sn * car.velocity_wc.y + cs * car.velocity_wc.x;
			
			velocity.setTo(car.phyVehicle.getRigidBody().linearVelocity.z, car.phyVehicle.getRigidBody().linearVelocity.x);
			
			abs_velocity = Math.abs(velocity.x);
			direction = GMaths.SGN(velocity.x);
			
			yawspeed = car.cartype.wheelbase * 2.25 * car.angularvelocity;
			
			if (abs_velocity < min_velocity)
			{
				//car.brake = 0;
				car.phyVehicle.getRigidBody().linearVelocity.setTo(0, 0, 0);
				velocity.setTo(0, 0);
				car.velocity_wc.setTo(0, 0);
				car.steerangle = 0;
				car.angularvelocity = 0;
				abs_velocity = 0;
				car.phyVehicle.getRigidBody().linearVelocity.setTo(0, 0, 0);
				car.phyVehicle.getRigidBody().clearForces();
			}
			
			weight = 1410 * 9.8 * 0.5;	
			
			/**
			 * Lateral Forces
			 */
			if (enableLateralForces) 
			{
				if ( abs_velocity < min_velocity + 1 ) rot_angle = 0;
				else rot_angle = Math.atan2(yawspeed, abs_velocity);
				
				if ( abs_velocity < min_velocity + 1) side_slip = 0;
				else side_slip = Math.atan2(velocity.y, abs_velocity);
				
				slip_angle_F = side_slip + rot_angle - car.steerangle;
				slip_angle_R  = side_slip - rot_angle;
				
				 /** front **/
				F_lat_f.x = 0;
				F_lat_f.y = cornering_stiffness_F * slip_angle_F;
				F_lat_f.y = Math.min(MAX_GRIP, F_lat_f.y);
				F_lat_f.y = Math.max(-MAX_GRIP, F_lat_f.y);
				F_lat_f.y *= weight;
				if (front_slip) F_lat_f.y *= 0.5;
				
				/** rear **/
				F_lat_r.x = 0;
				F_lat_r.y = cornering_stiffness_R * slip_angle_R;
				F_lat_r.y = Math.min(MAX_GRIP, F_lat_r.y);
				F_lat_r.y = Math.max(-MAX_GRIP, F_lat_r.y);
				F_lat_r.y *= weight;
				if (rear_slip) F_lat_r.y *= 0.5;
				
				F_lateral.x = Math.sin(car.steerangle) * F_lat_f.x + F_lat_r.x;
				F_lateral.y = Math.cos(car.steerangle) * F_lat_f.y + F_lat_r.y;
			}
			
			C_torque_f = (Math.cos(car.steerangle) * car.cartype.b * F_lat_f.y);
			C_torque_r = (car.cartype.c * F_lat_r.y);
			C_torque =  (C_torque_f - C_torque_r );
			
			angular_acceleration = C_torque / car.cartype.inertia;
			car.angularvelocity += delta_t * angular_acceleration;
			car.angle += delta_t * car.angularvelocity * direction;
			
			/**
			 * Engine Force
			 */
			
			max_torque = getTorqueCurve( getRpmEngine() );
			car.engine.toruqe =  max_torque * car.throttle / 100;
			T_drive =  car.engine.toruqe * car.CGR * car.xd * car.efficiency;
			F_drive = T_drive / car.wheel_radius;
			
			/*if (brake_value && abs_velocity > 0)
				F_traction.x = -car.brake;
			else if(!brake_value)
				F_traction.x = (throttle_value / 100 * F_drive);*/
			
			F_traction.x = (throttle_value / 100 * F_drive);
			F_traction.y = 0;
			
			if(rear_slip)
				F_traction.x *= 0.5;
			
			speed = Math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y));
			
			F_drag.x 	= -(C_drag * velocity.x * speed);
			F_drag.y 	= -(C_drag * velocity.y * speed);
			F_rr.x 		= -(C_rr * velocity.x);
			F_rr.y 		= -(C_rr * velocity.y);
			//if (car.engine.rpm < 1000)
			//F_back.x 	= -((100 - car.throttle) * (velocity.x * 2));
			F_back.y 	= 0;
			
			F_long.x = F_traction.x + F_rr.x + F_drag.x + F_back.x;
			F_long.y = F_traction.y + F_rr.y + F_drag.y + F_back.y;
			
			force.x = (F_long.x + F_lateral.x) * NOS;
			force.y = (F_long.y + F_lateral.y) * NOS;
			
			if(brake_value)
			{
				car.phyVehicle.getWheelInfo(0).frictionSlip = 2;
				car.phyVehicle.getWheelInfo(1).frictionSlip = 2;
				car.phyVehicle.getWheelInfo(2).frictionSlip = 1;
				car.phyVehicle.getWheelInfo(3).frictionSlip = 1;
				
				car.phyVehicle.applyEngineForce(0, 2);
				car.phyVehicle.setBrake(F_braking, 2);
				
				car.phyVehicle.applyEngineForce(0, 3);
				car.phyVehicle.setBrake(F_braking, 3);
				
				car.phyVehicle.applyEngineForce(0, 0);
				car.phyVehicle.setBrake(F_braking, 0);
				
				car.phyVehicle.applyEngineForce(0, 1);
				car.phyVehicle.setBrake(F_braking, 1);
				
			}
			else
			{
				car.phyVehicle.getWheelInfo(0).frictionSlip = 5 + (steering_value * 0.1);
				car.phyVehicle.getWheelInfo(1).frictionSlip = 5 + (steering_value * 0.1);
				car.phyVehicle.getWheelInfo(2).frictionSlip = 8;
				car.phyVehicle.getWheelInfo(3).frictionSlip = 8;
				
				car.phyVehicle.applyEngineForce(force.x * 1.5, 2);
				car.phyVehicle.setBrake(F_braking, 2);
				
				car.phyVehicle.applyEngineForce(force.x * 1.5, 3);
				car.phyVehicle.setBrake(F_braking, 3);
				
				car.phyVehicle.applyEngineForce(force.x * 1.5, 0);
				car.phyVehicle.setBrake(F_braking, 0);
				
				car.phyVehicle.applyEngineForce(force.x * 1.5, 1);
				car.phyVehicle.setBrake(F_braking, 1);
			}
			
			acceleration.x = force.x / car.cartype.mass;
			acceleration.y = force.y / car.cartype.mass;
			acceleration_wc.x =  cs * acceleration.y + sn * acceleration.x;
			acceleration_wc.y = -sn * acceleration.y + cs * acceleration.x;
			
			car.velocity_wc.x += delta_t * acceleration_wc.x;
			car.velocity_wc.y += delta_t * acceleration_wc.y;
			
			if (car.clutch && abs_velocity < min_velocity) car.velocity_wc.x = 0;
			if (car.clutch && abs_velocity < min_velocity) car.velocity_wc.y = 0;
			
		}
		public function getRpmWheel():Number 
		{
			//drpf = ((velocity.x * delta_t) / car.wheel_length) * 360;
			if (brake_value && car.phyVehicle.getRigidBody().linearVelocity.z < min_velocity)
			{
				rpmWheel = 0;
			}
			else{
				drpf = ((car.phyVehicle.getRigidBody().linearVelocity.z * delta_t) / car.wheel_length) * 360;
				drps = drpf * 60;
				rpsWheel = drps / 360;
				kmh = ((rpsWheel * car.wheel_length) * 3600) / 1000;
				rpmWheel = rpsWheel * 60;
			}
			return rpmWheel;
		}
		public function getRpmEngine():Number 
		{
			//car.engine.rpm = getRpmWheel() * car.CGR * car.xd;
			wheel_angularvelocity = abs_velocity / car.wheel_radius;
			
			if (!car.clutch)
			{
				if ((car.current_gear == 1 || car.current_gear == 0) && abs_velocity < 11) car.engine.rpm = 4000 * car.throttle / 100;
				else car.engine.rpm = wheel_angularvelocity * car.CGR * car.xd * 60 / (2 * Math.PI);
			}
			else if (car.engine.rpm > 1000)
			{
				car.engine.rpm -= 100;
			}
			else
			{
				car.engine.rpm = 1000;
			}
			
			if (velocity.x != 0) slipratio = (wheel_angularvelocity * car.wheel_radius - velocity.x) / abs_velocity;
			
			if (car.engine.rpm > 7250 && car.reverse)
			{
				car.engine.rpm = 3500;
			}
			else if (car.engine.rpm > 8000)
			{
				car.engine.rpm -= 500;
			}
			
			//if (abs_velocity > 0) 
			rear_wheel_rotation = direction * car.engine.rpm  * car.wheel_radius / (car.CGR * car.xd * 60 / (2 * Math.PI));
			//else rear_wheel_rotation = 0;
			
			kmh = abs_velocity * 3.6;
			
			auto_shift();
			
			return car.engine.rpm;
		}
		
		private function auto_shift():void 
		{
			if(car.engine.rpm > 7000)
			{
				car.gearUp();
			}
			else if(car.engine.rpm < 4000)
			{
				car.gearDown();
			}
		}
		public function getTorqueCurve(_rpm:Number):Number 
		{
			with (car.engine)
			{
				if (_rpm <= min_rpm) {
					_rpm = min_rpm;
				}
				if (_rpm <= max_rpm) {
					return Math.max(0, GMaths.easeOut((_rpm - min_rpm) * (1 / max_rpm), start_torque, (max_torque- start_torque)));
				}else {
					return Math.max(0, GMaths.easeIn((_rpm - max_rpm) * (1 / (redline_rpm - max_rpm)), max_torque, -(max_torque - end_torque)));
				}
			}
			return null;
		}
		public function resetInterval():void {
			at = 0;
			v = 0;
			a = 0;
			busy = false;
		}
	}

}
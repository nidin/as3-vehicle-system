package nid.game.systems.vehicle 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPCompoundShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import awayphysics.dynamics.vehicle.AWPRaycastVehicle;
	import awayphysics.dynamics.vehicle.AWPVehicleTuning;
	import awayphysics.dynamics.vehicle.AWPWheelInfo;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import nid.game.systems.vehicle.particles.CarParticles;
	import nid.game.systems.VehicleSystem;
	import nid.test.Away3dVehiclePhysicsTest;
	import nid.test.RootReference;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class Car implements IVehicle
	{
		public var system:VehicleSystem;
		
		public var parts:CarParts;
		public var gear_ratio:Vector.<Number>;
		
		//Port values
		public var cartype:CarType = new CarType;				// pointer to static car data
		
		public var position_wc:Point = new Point();		// position of car centre in world coordinates
		public var velocity_wc:Point = new Point();		// velocity vector of car in world coordinates
		
		public var angle:Number=0;			// angle of car body orientation (in rads)
		public var angularvelocity:Number=0;
		
		public var steerangle:Number=0;		// angle of steering (input)
		public var brake:Number=0;			// amount of braking (input)
		public var reverse:Boolean;			// amount of braking (input)
		public var engine:CarEngine;
		public var wheel_radius:Number = 0.34;
		public var wheel_length:Number = wheel_radius * 2 * Math.PI;
		public var current_gear:int;
		public var xd:Number = 4.583;
		public var efficiency:Number = 0.7;
		public var clutch:Boolean = true;
		public function get CGR():Number { return reverse?gear_ratio[0]:gear_ratio[current_gear] };
		
		private var _throttle:Number=0;			// amount of throttle (input)
		private var carSound:CarSound;
		private var turning:AWPVehicleTuning;
		private var particles:CarParticles;
		private var brake_light:PointLight;
		private var brake_lightPicker:StaticLightPicker;
		private var brake_light_mat:MaterialBase;
		private var fireContainer:ObjectContainer3D = new ObjectContainer3D();
		public var chassis:ObjectContainer3D;
		public var phyVehicle:AWPRaycastVehicle;
		public var physics:AWPDynamicsWorld;
		public function get throttle():Number { return _throttle; }
		public function set throttle(value:Number):void { 
			_throttle = value; 
		}
		
		public function getPart(partName:String):Part
		{
			return parts.getPart(partName);
		}
		
		public function Car(obj:ObjectContainer3D = null, physics:AWPDynamicsWorld=null)
		{
			this.physics = physics;
			gear_ratio = new Vector.<Number>();
			gear_ratio.push(2.707);
			gear_ratio.push(2.909);
			gear_ratio.push(1.944);
			gear_ratio.push(1.434);
			gear_ratio.push(1.100);
			gear_ratio.push(0.868);
			gear_ratio.push(0.693);
			current_gear = 1;
			
			engine = new CarEngine();
			system = new VehicleSystem(this);
			parts = new CarParts();
			carSound = new CarSound();
			particles = new CarParticles();
			if(obj!=null)
			setup(obj);
		}
		
		public function setup(chassis:ObjectContainer3D):void
		{
			this.chassis = chassis;
			var mesh:Mesh;
			
			RootReference.scene.addChild(chassis);
			trace(chassis.numChildren)
			var count:int = chassis.numChildren;
			
			brake_light = new PointLight();
			brake_light.color = 0xFF0000;	
			brake_light.specular = 1.5;
			brake_light.position = new Vector3D(0, 0, -600);
				
			brake_lightPicker = new StaticLightPicker([brake_light]);
			Away3dVehiclePhysicsTest.instance.envMapMethod.alpha = 0.25
			
			for (var i : int = 0; i < count; i++) 
			{
				var obj:ObjectContainer3D = chassis.getChildAt(i);
				obj.visible = false;
				//trace('[' + i + ']:' + obj.name);
				mesh = Mesh(obj);
				mesh.geometry.scale(100);
				//mesh.castsShadows = false;
				mesh.material.lightPicker =  RootReference.lightPicker;
				//mesh.material.lightPicker =  lightPicker;
				//if(mesh.material is TextureMaterial)
				
				if (obj.name.indexOf("bumper") != -1) {
					//TextureMaterial(mesh.material).addMethod(Away3dVehiclePhysicsTest.instance.envMapMethod);
				}
				switch(obj.name)
				{
					case "frame":
					case "interior":
						obj.visible = false;
					break;
					case "gun_holder":
						TextureMaterial(mesh.material).specular = 0;
					break;
					case "brake_light_R":
					case "brake_light_L":
						TextureMaterial(mesh.material).gloss = 500;
						TextureMaterial(mesh.material).specular = 1.0;
						mesh.addChild(brake_light); 
						brake_light_mat = mesh.material;
					break;
					case "glass_HL_R":
					case "glass_HL_L":
					case "glass_R1":
					case "glass_R2":
					case "glass_L1":
					case "glass_L2":
					case "glass_F":
					case "glass_B":
						ColorMaterial(mesh.material).ambientColor = 0xff0000;
						ColorMaterial(mesh.material).color = 0x1F2125;
						//ColorMaterial(mesh.material).alpha = 0.75;
						ColorMaterial(mesh.material).addMethod(Away3dVehiclePhysicsTest.instance.envMapMethod);
					break;
					
					case "body":
					{
						//mesh.castsShadows = true;
						//TextureMaterial(mesh.material).ambientColor = 0x000000;
						//TextureMaterial(mesh.material).colorTransform = new ColorTransform(0.07, 0.19, 0.44, 1);
						//TextureMaterial(mesh.material).shadowMethod = RootReference.shadowMethod;
						TextureMaterial(mesh.material).addMethod(Away3dVehiclePhysicsTest.instance.envMapMethod);
					}
					default:
						if (mesh.material is TextureMaterial) {
							//TextureMaterial(mesh.material).colorTransform = new ColorTransform(0.07, 0.19, 0.44, 1);
							//TextureMaterial(mesh.material).normalMap = new BitmapTexture(body_nrm_texture);
						}
						//mesh.geometry.scale(100);
						//mesh.material.lightPicker =  RootReference.lightPicker
					break;
				}
				obj.y += 95;
				obj.z += 22;
				parts.mapPart(obj);
			}
			parts.init(1);
			
			//w1.movePivot( 0, 0, 0);
			//chassis.position = new Vector3D(50, 10, 0);
			// create the chassis body
			var carShape : AWPCompoundShape = createCarShape();
			var carBody : AWPRigidBody = new AWPRigidBody(carShape, chassis, cartype.mass);
			carBody.activationState = AWPCollisionObject.DISABLE_DEACTIVATION;
			carBody.friction = 0.9;
			carBody.linearDamping = 0.1;
			carBody.angularDamping = 0.1;
			//carBody.position = new Vector3D(10000, 500, 0);
			carBody.position = new Vector3D(-10000, 500, 0);
			carBody.rotationY = 90;
			physics.addRigidBody(carBody);
			
			// create vehicle
			turning = new AWPVehicleTuning();
			turning.frictionSlip = 1;
			turning.suspensionStiffness = 100;
			turning.suspensionDamping = 5;
			turning.suspensionCompression = 0.85;
			turning.maxSuspensionTravelCm = 40;
			turning.maxSuspensionForce = 50000;
			phyVehicle = new AWPRaycastVehicle(turning, carBody);
			physics.addVehicle(phyVehicle);
			
		}
		private function createCarShape() : AWPCompoundShape {
			var boxShape1 : AWPBoxShape = new AWPBoxShape(200, 70, 450);
			var boxShape2 : AWPBoxShape = new AWPBoxShape(200, 70, 200);

			var carShape : AWPCompoundShape = new AWPCompoundShape();
			carShape.addChildShape(boxShape1, new Vector3D(0, 80, 25), new Vector3D());
			carShape.addChildShape(boxShape2, new Vector3D(0, 120, 0), new Vector3D());

			return carShape;
		}
		public function setWheel(obj:ObjectContainer3D):void 
		{
			trace('setWheel');
			var count:int = obj.numChildren;
			for (var i : int = 0; i < count; i++) 
			{
				var mesh:Mesh = obj.getChildAt(i) as Mesh;
				if (mesh.name == "alloy")
				{
					TextureMaterial(mesh.material).specular = 1;
				}
				else
				{
					TextureMaterial(mesh.material).specular = 0;
				}
				mesh.geometry.scale(100);
				
				mesh.material.lightPicker =  RootReference.lightPicker;
			}
			var w1:ObjectContainer3D = new ObjectContainer3D();
			var w2:ObjectContainer3D = new ObjectContainer3D();
			var w3:ObjectContainer3D = new ObjectContainer3D();
			var w4:ObjectContainer3D = new ObjectContainer3D();
			obj.scaleX = 1.1;
			obj.scaleY = 1.26;
			obj.scaleZ = 1.26;
			w1.addChild(obj);
			var tmp:Object3D = obj.clone();
			tmp.rotationY = 180;
			w2.addChild(ObjectContainer3D(tmp));
			tmp = obj.clone();
			w3.addChild(ObjectContainer3D(tmp));
			tmp = obj.clone();
			tmp.rotationY = 180;
			w4.addChild(ObjectContainer3D(tmp));
			
			w1.name = "wheel_FR";
			w2.name = "wheel_FL";
			w3.name = "wheel_RR";
			w4.name = "wheel_RL";
			
			RootReference.scene.addChild(w1);
			RootReference.scene.addChild(w2);
			RootReference.scene.addChild(w3);
			RootReference.scene.addChild(w4);
			
			var j_y:int = 70;
			var j_x:int = 85;
			var j_zF:int = 160;
			var j_zR:int = 110;
			
			var w1_joint:Vector3D = new Vector3D(-j_x, j_y,j_zF);
			var w2_joint:Vector3D = new Vector3D(j_x, j_y,j_zF);
			var w3_joint:Vector3D = new Vector3D(-j_x,j_y,-j_zR);
			var w4_joint:Vector3D = new Vector3D(j_x, j_y, -j_zR);
			
			var w_dir:Vector3D = new Vector3D(0, -1, 0);
			var w_axleCS:Vector3D = new Vector3D(-1, 0, 0);
			
			var radius:Number = 35;
			var susp:Number = 10;
			
			phyVehicle.addWheel(w1, w1_joint, w_dir, w_axleCS, susp, radius, turning, true);
			phyVehicle.addWheel(w2, w2_joint, w_dir, w_axleCS, susp, radius, turning, true);
			phyVehicle.addWheel(w3, w3_joint, w_dir, w_axleCS, susp, radius, turning, false);
			phyVehicle.addWheel(w4, w4_joint, w_dir, w_axleCS, susp, radius, turning, false);
			
			for (i = 0; i < phyVehicle.getNumWheels(); i++) {
				var wheel : AWPWheelInfo = phyVehicle.getWheelInfo(i);
				wheel.wheelsDampingRelaxation = 4.5;
				wheel.wheelsDampingCompression = 4.5;
				wheel.suspensionRestLength1 = 25;
				wheel.rollInfluence = 0.01;
				wheel.frictionSlip = -5;
			}
			
			
			particles.addWheelSmoke(parts.getPart('hood').activeObject, w3, w4);
		}
		
		public function reset():void 
		{
			phyVehicle.getRigidBody().linearVelocity = new Vector3D();
			phyVehicle.getRigidBody().angularVelocity = new Vector3D();
			phyVehicle.getRigidBody().rotation = new Vector3D(0, -90, 0);
			phyVehicle.getRigidBody().position = new Vector3D(10000, 500, 0);
		}
		
		public function step():void 
		{
			system.process();
			particles.update(phyVehicle.getRigidBody());
			carSound.engineLevel = (engine.rpm / 7250);
			//carSound.engineLevel = system.throttle_value;
		}
		
		public function setHBrake(value:Boolean):void 
		{
			system.brake(value);
			Mesh(parts.getPart('brake_light_R').activeObject).material.lightPicker = value?brake_lightPicker:RootReference.lightPicker;
			Mesh(parts.getPart('brake_light_L').activeObject).material.lightPicker = value?brake_lightPicker:RootReference.lightPicker;
			
			if(value && system.abs_velocity > system.min_velocity)
			{
				particles.showSmoke();
				carSound.brake = true;
				//trails.enable = true;
			}
			else
			{
				particles.hideSmoke();
				carSound.brake = false;
				//Mesh(parts.getPart('brake_light_R').activeObject).material.lightPicker = RootReference.lightPicker
				//Mesh(parts.getPart('brake_light_L').activeObject).material.lightPicker = RootReference.lightPicker
				//trails.enable = false;
			}
		}
		
		public function setSteer(value:Number):void 
		{
			system.steering(value);
		}
		
		public function setAccelerate(value:Number):void 
		{
			//this.translateZ(value);
			system.accelerate(value);
		}
		
		public function setWorld(obj:ObjectContainer3D):void 
		{
			//addChild(obj);
			//sp_collisions.addCollisionWith(obj);
			//ground = new PlaneCollisionPrimitive();
			//ground = new BoxCollisionPrimitive(new Vector3D(1, 1, 1))
			//ground.transform = obj.world;
		}
		
		public function gearUp():void 
		{
			if (current_gear < gear_ratio.length - 1)
			{
				current_gear++;
				//system.at = 0;
			}
		}
		
		public function gearDown():void 
		{
			if (current_gear > 1)
			{
				current_gear--;
				//system.at = 0;
			}
		}
		
		public function setBoost(value:Number):void 
		{
			system.NOS = value;
		}
		
		public function destroy():void 
		{
			phyVehicle.getRigidBody().clearForces();
			phyVehicle.getRigidBody().angularVelocity = new Vector3D(Math.random() * 25, Math.random() * 5, Math.random() * 5);
			phyVehicle.getRigidBody().linearVelocity = new Vector3D(Math.random() * 25, Math.random() * 30, Math.random() * 25);
		}
	}

}
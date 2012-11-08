package nid.game.systems.vehicle 
{
	import caurina.transitions.Tweener;
	import flare.basic.Scene3D;
	import flare.collisions.SphereCollision;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	import flare.physics.collision.BoxCollisionPrimitive;
	import flare.physics.collision.CollisionPrimitive;
	import flare.physics.collision.CollisionResultInfo;
	import flare.physics.collision.MeshCollisionPrimitive;
	import flare.physics.collision.PlaneCollisionPrimitive;
	import flare.physics.core.PhysicsBox;
	import flare.physics.core.PhysicsMesh;
	import flare.physics.core.PhysicsSystemManager;
	import flare.physics.core.RigidBody;
	import flare.physics.vehicles.PhysicsVehicle;
	import flare.primitives.Box;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import nid.game.systems.VehicleSystem;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class Car  extends Pivot3D implements IVehicle
	{
		private var system:VehicleSystem;
		private var material:Shader3D;
		public var body:Mesh3D
		public var hood:Mesh3D
		public var front_bumper:Mesh3D
		public var back_bumper:Mesh3D
		public var spoiler:Mesh3D
		public var break_light_L:Mesh3D
		public var break_light_R:Mesh3D
		public var mirror_L:Mesh3D
		public var mirror_R:Mesh3D
		public var tyre_front_L:Mesh3D
		public var tyre_front_R:Mesh3D
		public var tyre_back_L:Mesh3D
		public var tyre_back_R:Mesh3D
		
		public var parts:CarParts;
		public var holder:Pivot3D;
		
		[Embed(source = "../../../../../model/texture/decal1a.jpg")]
		private var bmp1:Class;
		private var carBody:PhysicsVehicle;
		//private var ground:PlaneCollisionPrimitive;
		private var ground:CollisionPrimitive;
		private var collision:CollisionPrimitive;
		private var sp_collisions:SphereCollision;
		private var wheel_FR:Pivot3D;
		private var wheel_BR:Pivot3D;
		private var wheel_FL:Pivot3D;
		private var wheel_BL:Pivot3D;
		public var collider:Mesh3D;
		public var chassis:Pivot3D;
		public var physics:PhysicsSystemManager;
		
		public function getPart(partName:String):Part
		{
			return parts.getPart(partName);
		}
		
		public function Car(obj:Pivot3D=null) 
		{
			system = new VehicleSystem(this);
			parts = new CarParts();
			
			if(obj!=null)
			setup(obj);
		}
		
		public function setup(chassis:Pivot3D):void
		{
			this.chassis = chassis;
			addChild(chassis);
			
			for (var i:int = 0; i < chassis.children.length; i++)
			{
				chassis.children[i].visible = false;
				parts.mapPart(chassis.children[i]);
				//trace(chassis.children[i].name)
			}
			parts.init();
		}
		
		override public function getChildByName(name:String, startIndex:int = 0, includeChildren:Boolean = true):flare.core.Pivot3D 
		{
			return holder.getChildByName(name, startIndex, includeChildren);
		}
		
		public function setWheel(obj:Pivot3D):void 
		{
			wheel_FR = obj.getChildByName('main');
			wheel_FR.resetTransforms();
			wheel_FR.setScale(1, 1.25, 1.25);
			wheel_BR = wheel_FR.clone();
			
			wheel_FL = wheel_FR.clone();
			wheel_FL.rotateY(180);
			wheel_BL = wheel_FR.clone();
			wheel_BL.rotateY(180);
			
			chassis.getChildByName('wheel_FR').addChild(wheel_FR);
			chassis.getChildByName('wheel_FL').addChild(wheel_FL);
			chassis.getChildByName('wheel_BR').addChild(wheel_BR);
			chassis.getChildByName('wheel_BL').addChild(wheel_BL);
		}
		
		public function reset():void 
		{
			chassis.setOrientation(new Vector3D());
		}
		
		public function step():void 
		{
			system.process();
		}
		
		public function setHBrake(value:Boolean):void 
		{
			
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
		
		public function setWorld(obj:Pivot3D):void 
		{
			//addChild(obj);
			//sp_collisions.addCollisionWith(obj);
			ground = new MeshCollisionPrimitive(obj as Mesh3D);
			//ground = new PlaneCollisionPrimitive();
			//ground = new BoxCollisionPrimitive(new Vector3D(1, 1, 1))
			//ground.transform = obj.world;
		}
	}

}
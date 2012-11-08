package nid.game.systems.vehicle 
{
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
		public var collider:Mesh3D;
		public var chassis:Pivot3D;
		public var physics:PhysicsSystemManager;
		
		public function getPart(partName:String):Part
		{
			return parts.getPart(partName);
		}
		
		public function Car(obj:Pivot3D=null) 
		{
			system = new VehicleSystem();
			parts = new CarParts();
			
			if(obj!=null)
			setup(obj);
		}
		
		public function setup(chassis:Pivot3D):void
		{
			this.chassis = chassis;
			//addChild(chassis);
			
			for (var i:int = 0; i < chassis.children.length; i++)
			{
				parts.mapPart(chassis.children[i]);
				//trace(chassis.children[i].name)
			}
			var mat:Shader3D = new Shader3D("", [new ColorFilter(0x00ff00, 0.25)]);
			collider = chassis.getChildByName("collision") as Mesh3D;
			addChild(collider);
			//collision = new BoxCollisionPrimitive(new Vector3D(1, 1, 1));
			collision = new MeshCollisionPrimitive(collider,500,500);
			var coll_box:Box = new Box("", 1, 1, 1);
			coll_box.setMaterial(mat);
			addChild(coll_box);
			//sp_collisions = new SphereCollision( this, 1 );
			collision.transform = collider.world;
		}
		
		override public function getChildByName(name:String, startIndex:int = 0, includeChildren:Boolean = true):flare.core.Pivot3D 
		{
			return holder.getChildByName(name, startIndex, includeChildren);
		}
		
		public function setWheel(obj:Pivot3D):void 
		{
			var wheel_FR:Pivot3D = obj.getChildByName('main');
			wheel_FR.resetTransforms();
			wheel_FR.setScale(1, 1.25, 1.25);
			var wheel_BR:Pivot3D = wheel_FR.clone();
			
			var wheel_FL:Pivot3D = wheel_FR.clone();
			wheel_FL.rotateY(180);
			var wheel_BL:Pivot3D = wheel_FR.clone();
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
			var collInfo : Vector.<CollisionResultInfo> = new Vector.<CollisionResultInfo>(1);
			if (collision.collisionDetectWith(ground, collInfo))
			{
				trace('collision true');
			}
			collision.transform = collider.world
			//if (sp_collisions.intersect())
			//{
				//trace('sp_collisions true');
			//}
		}
		
		public function setHBrake(value:Boolean):void 
		{
			
		}
		
		public function setSteer(value:Number):void 
		{
			collider.translateX(value);
		}
		
		public function setAccelerate(value:Number):void 
		{
			collider.translateY(value);
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
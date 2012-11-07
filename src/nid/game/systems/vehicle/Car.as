package nid.game.systems.vehicle 
{
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.physics.core.PhysicsBox;
	import flare.physics.core.PhysicsMesh;
	import flare.physics.core.PhysicsSystemManager;
	import flare.physics.core.RigidBody;
	import flare.physics.vehicles.PhysicsVehicle;
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
		public var chassis:Pivot3D;
		public var physics:PhysicsSystemManager;
		
		public function getPart(partName:String):Part
		{
			return parts.getPart(partName);
		}
		
		public function Car(obj:Pivot3D=null) 
		{
			material = new Shader3D("");
			material.filters.push(new ColorFilter(0x0FFFFF));
			//material.filters.push(new TextureFilter(new Texture3D(new bmp1().bitmapData)));
			//material.filters.push(new SpecularFilter());
			system = new VehicleSystem();
			parts = new CarParts();
			
			if(obj!=null)
			setup(obj);
		}
		
		public function setup(chassis:Pivot3D):void
		{
			this.chassis = chassis;
			addChild(chassis);
			//var chassisBox:PhysicsMesh = new PhysicsMesh();
			//chassis.addComponent(chassisBox);
			//chassisBox.mass = 3;
			//chassisBox.setActive(true);
			for (var i:int = 0; i < chassis.children.length; i++)
			{
				var phyMesh:PhysicsMesh = new PhysicsMesh();
				phyMesh.mass = 300;
				parts.mapPart(chassis.children[i]);
				chassis.children[i].addComponent(phyMesh);
				//trace('Material:' + obj.children[i].);
			}
			//chassis.setRotation(0, 0, 0);
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
		
		public function accelerate():void 
		{
			this.translateZ(0.21);
		}
		public function decelerate():void 
		{
			this.translateZ(-0.21);
		}
		
		public function turnLeft():void 
		{
			this.rotateY(6);
		}
		
		public function turnRight():void 
		{
			this.rotateY(-6);
		}
		
		public function reset():void 
		{
			//chassis.setPosition(0, 0, 0);
			chassis.setOrientation(new Vector3D());
		}
		
		public function step():void 
		{
			physics.step();
		}
		
		public function setHBrake(value:Boolean):void 
		{
			carBody.setHBrake(value);
		}
		
		public function setSteer(value:Number):void 
		{
			carBody.setSteer(value);
		}
		
		public function setAccelerate(value:Number):void 
		{
			carBody.setAccelerate(value);
		}
	}

}
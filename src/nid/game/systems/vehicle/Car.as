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
		private var physics:PhysicsSystemManager;
		private var carBody:PhysicsVehicle;
		public var chassis:Pivot3D;
		
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
			physics=PhysicsSystemManager.getInstance();
			if(obj!=null)
			setup(obj);
		}
		
		public function setup(chassis:Pivot3D):void
		{
			this.chassis = chassis;
			holder = new Pivot3D("holder");
			holder.addChild(chassis);
			addChild(holder);
			chassis.addComponent(new PhysicsBox());
			//obj.setMaterial(material);
			for (var i:int = 0; i < chassis.children.length; i++)
			{
				parts.mapPart(chassis.children[i]);
				//trace(chassis.children[i].name);
				//trace('Material:' + obj.children[i].);
			}
			
			carBody=new PhysicsVehicle(chassis.components[0] as RigidBody,40,2.5,12000);
			carBody.chassis.mass = 2;
			carBody.chassis.setPosition(chassis.x, chassis.y, chassis.z);
			var chassisPos:Vector3D = chassis.getPosition();
			physics.addVehicle(carBody);
		}
		
		//override
		override public function getChildByName(name:String, startIndex:int = 0, includeChildren:Boolean = true):flare.core.Pivot3D 
		{
			return holder.getChildByName(name, startIndex, includeChildren);
		}
		
		public function setWheel(obj:Pivot3D):void 
		{
			var wheel_FR:Pivot3D = obj.getChildByName('main');
			//wheel_FR.setScale(1, 1.25, 1.25);
			wheel_FR.x = 0;
			wheel_FR.y = 0;
			wheel_FR.z = 0;
			var wheel_BR:Pivot3D = wheel_FR.clone();
			
			var wheel_FL:Pivot3D = wheel_FR.clone();
			//wheel_FL.rotateY(180);
			var wheel_BL:Pivot3D = wheel_FR.clone();
			//wheel_BL.rotateY(180);
			
			holder.getChildByName('wheel_FR').addChild(wheel_FR);
			holder.getChildByName('wheel_FL').addChild(wheel_FL);
			holder.getChildByName('wheel_BR').addChild(wheel_BR);
			holder.getChildByName('wheel_BL').addChild(wheel_BL);
			
			holder.getChildByName('wheel_FR').y = -1
			holder.getChildByName('wheel_FL').y = -1
			holder.getChildByName('wheel_BR').y = -1
			holder.getChildByName('wheel_BL').y = -1
			
			var pos1:Vector3D = wheel_FL.getPosition();
			var pos2:Vector3D = wheel_FR.getPosition();
			var pos3:Vector3D = wheel_BL.getPosition();
			var pos4:Vector3D = wheel_BR.getPosition();
			//pos1.y = -1;
			//pos2.y = -1;
			//pos3.y = -1;
			//pos4.y = -1;
			
			carBody.addWheel("1", wheel_FL, true, true, pos1);
			carBody.addWheel("2", wheel_FR, true, true, pos2);
			carBody.addWheel("3", wheel_BL, false, true, pos3);
			carBody.addWheel("4", wheel_BR, false, true, pos4);
			
			trace(carBody.wheels[1]);
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
			carBody.chassis.setPosition(0, 2, 0);
			carBody.chassis.setOrientation(new Matrix3D());
			carBody.chassis.setActive(true);
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
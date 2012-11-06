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
		
		public function setup(obj:Pivot3D):void
		{
			holder = obj;
			addChild(holder);
			//obj.setMaterial(material);
			for (var i:int = 0; i < obj.children.length; i++)
			{
				parts.mapPart(obj.children[i]);
				//trace(obj.children[i].name);
				//trace('Material:' + obj.children[i].);
			}
		}
		
		//override
		override public function getChildByName(name:String, startIndex:int = 0, includeChildren:Boolean = true):flare.core.Pivot3D 
		{
			return holder.getChildByName(name, startIndex, includeChildren);
		}
		
		public function setWheel(obj:Pivot3D):void 
		{
			var wheel_FR:Pivot3D = obj.getChildByName('main');
			wheel_FR.setScale(1, 1.25, 1.25);
			wheel_FR.x = 0;
			wheel_FR.y = 0;
			wheel_FR.z = 0;
			var wheel_BR:Pivot3D = wheel_FR.clone();
			
			var wheel_FL:Pivot3D = wheel_FR.clone();
			wheel_FL.rotateY(180);
			var wheel_BL:Pivot3D = wheel_FR.clone();
			wheel_BL.rotateY(180);
			
			holder.getChildByName('wheel_FR').addChild(wheel_FR);
			holder.getChildByName('wheel_FL').addChild(wheel_FL);
			holder.getChildByName('wheel_BR').addChild(wheel_BR);
			holder.getChildByName('wheel_BL').addChild(wheel_BL);
			//holder.addChild(wheel_FR);
			//holder.addChild(wheel_BL);
			//holder.addChild(wheel_BR);
		}
	}

}
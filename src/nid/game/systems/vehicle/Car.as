package nid.game.systems.vehicle 
{
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import nid.game.systems.VehicleSystem;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class Car implements IVehicle
	{
		private var system:VehicleSystem;
		private var scene:Scene3D;
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
		
		public var parts:Vector.<Part>;
		
		public function getPart(partName:String):Part
		{
			for (var i:int = 0; i < parts.length; i++)
			{
				var part:Part = parts[i];
				if (part.name == partName)
				{
					return part;
				}
			}
			return null;
		}
		
		public function Car(obj:Pivot3D=null,scene:Scene3D=null) 
		{
			this.scene = scene;
			parts = new Vector.<Part>();
			system = new VehicleSystem();
			
			//changeable parts
			parts.push(new Part("hood"));
			parts.push(new Part("mirror_l"));
			parts.push(new Part("mirror_r"));
			parts.push(new Part("skirt_l"));
			parts.push(new Part("skirt_r"));
			parts.push(new Part("bumper_front"));
			parts.push(new Part("bumper_rear"));
			parts.push(new Part("spoiler"));
			
			//default parts
			parts.push(new Part("body"));
			parts.push(new Part("head_l_fr"));
			parts.push(new Part("head_l_fl"));
			parts.push(new Part("head_l_br"));
			parts.push(new Part("head_l_bl"));
			parts.push(new Part("glass_r1"));
			parts.push(new Part("glass_r2"));
			parts.push(new Part("glass_l1"));
			parts.push(new Part("glass_l2"));
			parts.push(new Part("glass_front"));
			parts.push(new Part("glass_rear"));
			parts.push(new Part("no_plat_front"));
			parts.push(new Part("no_plat_rear"));
			
			//universal parts
			parts.push(new Part("tyer_front_l"));
			parts.push(new Part("tyer_front_r"));
			parts.push(new Part("tyer_rear_l"));
			parts.push(new Part("tyer_rear_r"));
			
			
			if(obj!=null)
			setup(obj);
		}
		
		public function setup(obj:Pivot3D):void
		{
			for (var i:int = 0; i < obj.children.length; i++)
			{
				mapPart(obj.children[i]);
				var part:Pivot3D = obj.children[i];
				parts.push(new Part(part));
				
			}
		}
		
		private function mapPart(obj:Pivot3D):void 
		{
			
		}
	}

}
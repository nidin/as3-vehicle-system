package nid.game.systems.vehicle 
{
	import away3d.containers.ObjectContainer3D;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class CarParts 
	{
		public var parts:Vector.<Part>;
		
		public function CarParts() 
		{
			parts = new Vector.<Part>();
			
			//changeable parts
			parts.push(new Part("hood"));
			parts.push(new Part("mirror_L"));
			parts.push(new Part("mirror_R"));
			parts.push(new Part("skirt_L"));
			parts.push(new Part("skirt_R"));
			parts.push(new Part("bumper_F"));
			parts.push(new Part("bumper_B"));
			parts.push(new Part("spoiler"));
			
			//fixed parts
			parts.push(new Part("body"));
			parts.push(new Part("gun_holder"));
			
			parts.push(new Part("head_light_L"));
			parts.push(new Part("head_light_R"));
			parts.push(new Part("brake_light_L"));
			parts.push(new Part("brake_light_R"));
			parts.push(new Part("tail_light_L"));
			parts.push(new Part("tail_light_R"));
			
			parts.push(new Part("glass_R1"));
			parts.push(new Part("glass_R2"));
			parts.push(new Part("glass_L1"));
			parts.push(new Part("glass_L2"));
			parts.push(new Part("glass_F"));
			parts.push(new Part("glass_B"));
			parts.push(new Part("glass_HL_L"));
			parts.push(new Part("glass_HL_R"));
			
			parts.push(new Part("no_plate_F"));
			parts.push(new Part("no_plate_B"));
			
			//universal parts
			parts.push(new Part("wheel_FL"));
			parts.push(new Part("wheel_FR"));
			parts.push(new Part("wheel_RR"));
			parts.push(new Part("wheel_RL"));
		}
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
		
		public function mapPart(part:ObjectContainer3D):void 
		{
			for (var i:int = 0; i < parts.length; i++)
			{
				if (part.name.indexOf(parts[i].name) > -1)
				{
					parts[i].push(part);
				}
			}
		}
		
		public function init(style:int):void 
		{
			for (var i:int = 0; i < parts.length; i++)
			{
				parts[i].meshes.reverse();
				if (parts[i].meshes.length > 0) 
				{
					parts[i].activate(style);
				}
			}
		}
	}

}
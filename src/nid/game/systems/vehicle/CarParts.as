package nid.game.systems.vehicle 
{
	import flare.core.Pivot3D;
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
		
		public function mapPart(obj:Pivot3D):void 
		{
			var partName:String = getPartName(obj);
		}
		
		private function getPartName(part:Pivot3D):String 
		{
			var partName:String = "";
			
			if (part.name.indexOf("body") > -1)
			{
				
			}
			return partName;
		}
	}

}
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
	public class Car  extends Pivot3D implements IVehicle
	{
		private var system:VehicleSystem;
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
		
		public function setup(obj:Pivot3D):void
		{
			holder = obj;
			addChild(holder);
			
			for (var i:int = 0; i < obj.children.length; i++)
			{
				parts.mapPart(obj.children[i]);
				trace(obj.children[i].name);
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
			var wheel_BR:Pivot3D = wheel_FR.clone();
			
			var wheel_FL:Pivot3D = wheel_FR.clone();
			var wheel_BL:Pivot3D = wheel_FR.clone();
			
			holder.getChildByName('wheel_BR').addChild(wheel_FL);
			//holder.addChild(wheel_FR);
			//holder.addChild(wheel_BL);
			//holder.addChild(wheel_BR);
		}
	}

}
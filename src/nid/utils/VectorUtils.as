package nid.utils 
{
	import flare.core.Pivot3D;
	import nid.game.systems.vehicle.particles.SmokeEmiter;
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class VectorUtils 
	{
		
		public function VectorUtils() 
		{
			
		}
		
		static public function copyPosition(pivot1:Pivot3D, pivot2:Pivot3D):void 
		{
			pivot1.x = pivot2.x;
			pivot1.y = pivot2.y;
			pivot1.z = pivot2.z;
		}
		
	}

}
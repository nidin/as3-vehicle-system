package nid.game.systems.vehicle 
{
	import flare.core.Pivot3D;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class Part extends Pivot3D
	{
		public var meshes:Vector.<Pivot3D>;
		
		public function Part(name:String) 
		{
			this.name = name;
			meshes = new Vector.<Pivot3D>();
		}
		public function push(obj:Pivot3D):void
		{
			meshes.push(obj);
		}
	}

}
package nid.game.systems.vehicle 
{
	import away3d.containers.ObjectContainer3D;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class Part extends ObjectContainer3D
	{
		private var id:Number=0;
		public var meshes:Vector.<ObjectContainer3D>;
		
		public function Part(name:String) 
		{
			this.name = name;
			meshes = new Vector.<ObjectContainer3D>();
		}
		public function get activeObject():ObjectContainer3D
		{
			return meshes[id];
		}
		public function push(obj:ObjectContainer3D):void
		{
			meshes.push(obj);
		}
		
		public function deactivate(id:Number):void 
		{
			if (meshes.length >= id + 1) meshes[id].visible = false;
		}
		public function activate(id:Number):void 
		{
			if (meshes.length >= id+1)
			{
				this.id = id;
				meshes[id].visible = true;
			}
			else {
				this.id = 0;
				meshes[0].visible = true;
			}
		}
	}

}
package nid.game.systems.collision 
{
	import flare.physics.collision.CollisionResultInfo;
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class CollisionUtils 
	{
		
		public function CollisionUtils() 
		{
			
		}
		public static function info(collInfo:Vector.<CollisionResultInfo>):String
		{
			var out:String = '';
			for (var i:int = 0; i < collInfo.length; i++)
			{
				if(collInfo[i]!=null)
				{
					out += '--collision--\n';
					out += 'dirToBody:' + collInfo[i].dirToBody.toString() + '\n';
					out += 'friction:' + collInfo[i].friction.toString() + '\n';
					out += collInfo[i].obj0 + '\n';
					out += collInfo[i].obj1 + '\n';
					out += 'pointInfo:' + collInfo[i].pointInfo.toString() + '\n';
					out += 'restitution:' + collInfo[i].restitution.toString() + '\n';
					out += 'satisfied:' + collInfo[i].satisfied.toString() + '\n';
				}
			}
			return out;
		}
	}

}
package nid.game.systems.vehicle.trails 
{
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.core.Trails3D;
	import flash.geom.Vector3D;
	import nid.game.systems.vehicle.Car;
	import nid.test.VehiclePhysicsTest;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class TyreTrails 
	{
		[Embed(source="../../../../../../model/texture/tyre-trail-2.png")]
		private var TrailTexture:Class;
		private var mat:Texture3D;
		private var trail_L:Trails3D;
		private var trail_R:Trails3D;
		private var wheel_BR:Pivot3D;
		private var wheel_BL:Pivot3D;
		private var car:Car;
		
		public function TyreTrails() 
		{
			mat = new Texture3D( new TrailTexture )
			
		}
		public function set enable(value:Boolean):void {
			trail_L.enable = value;
			trail_R.enable = value;
			
			var y:Number = wheel_BL.y < wheel_BR.y?wheel_BL.y:wheel_BR.y;
			
			trail_L.setPosition( 0, y, 0);
			trail_R.setPosition( 0, y, 0);
		}
		public function addTrails(car:Car, wheel_BR:Pivot3D, wheel_BL:Pivot3D):void 
		{
			this.car = car;
			this.wheel_BL = wheel_BL;
			this.wheel_BR = wheel_BR;
			trail_L = new Trails3D( wheel_BL, 100, 0.25, mat, car.chassis);
			trail_R = new Trails3D( wheel_BR, 100, 0.25, mat, car.chassis);
			
			//trail_L.translateY(0.1);
			//trail_R.translateY(0.1);
			//trail_L.setPosition( -1, 0.2, 0);
			//trail_R.setPosition( 2.1, 0.2, 0);
			
			VehiclePhysicsTest.getScene().addChild(trail_L);
			VehiclePhysicsTest.getScene().addChild(trail_R);
		}
		
	}

}
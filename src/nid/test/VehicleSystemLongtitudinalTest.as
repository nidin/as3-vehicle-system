package nid.test 
{
	import com.bit101.components.PushButton;
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.core.Poly3D;
	import flare.loaders.Flare3DLoader;
	import flare.loaders.Flare3DLoader1;
	import flare.materials.filters.SpecularFilter;
	import flare.physics.core.PhysicsPlane;
	import flare.physics.core.RigidBody;
	import flare.system.Input3D;
	import flare.utils.Pivot3DUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nid.game.systems.vehicle.Car;
	import nid.game.systems.VehicleSystem;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class VehicleSystemLongtitudinalTest extends Sprite
	{
		private var scene:Scene3D;
		private var car_container:Pivot3D;
		private var wheel_container:Pivot3D;
		private var next:PushButton;
		private var prev:PushButton;
		private var vehicle:Car;
		private var camera:Camera3D;
		private var world_container:Pivot3D;
		
		public function VehicleSystemLongtitudinalTest() 
		{
			stage.align = "topLeft";
			stage.scaleMode = "noScale";
			
			scene = new Viewer3D( this );
			scene.registerClass(Flare3DLoader1);
			scene.registerClass(SpecularFilter);
			scene.autoResize = true;
			scene.antialias = 2;
			
			camera = new Camera3D('tail_camera');
			camera.x = 10
			camera.y = 10
			camera.z = 10
			scene.camera = camera;
			
			world_container = new Pivot3D("world");
			car_container = new Pivot3D("vehicle");
			wheel_container = new Pivot3D("wheel");
			
			scene.addChildFromFile( "world.f3d" , world_container);
			scene.addChildFromFile( "test-car-3.f3d" , car_container);
			scene.addChildFromFile( "wheel.f3d" , wheel_container);
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent )
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent )
			
			var button_holder:Sprite = new Sprite();
			next = new PushButton();
			prev = new PushButton();
			next.label = "Next";
			prev.label = "Previous";
			prev.x = next.width + 10;
			button_holder.addChild(next);
			button_holder.addChild(prev);
			addChild(button_holder);
			button_holder.y = stage.stageHeight - button_holder.height - 20;
			button_holder.x = (stage.stageWidth - button_holder.width) / 2;
			
			next.addEventListener(MouseEvent.CLICK, handleEvent);
		}
		
		private function handleEvent(e:MouseEvent):void 
		{
			if (e.currentTarget == next)
			{
				//vehicle.front_bumper
			}
			else
			{
				
			}
		}
		private function progressEvent(e:Event):void 
		{
			//trace( scene.loadProgress );
		}
		
		private function completeEvent(e:Event):void 
		{
			trace( "complete" );
			
			var floor:Pivot3D = world_container.getChildByName("floor");
			floor.resetTransforms();
			
			vehicle = new Car(car_container);
			vehicle.setWheel(wheel_container);
			vehicle.setWorld(floor);
			
			vehicle.y = 0.8;
			
			floor.setScale(100, 100, 100);
			//vehicle.setScale(10, 10, 10);
			
			scene.addChild(floor);
			scene.addChild(vehicle);
			
			camera.lookAt(vehicle.x, vehicle.y, vehicle.z);
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		private function updateEvent(e:Event = null):void {
			
			vehicle.setHBrake(false);
			//Accelerator
			if (Input3D.keyDown(Input3D.UP)) {
				vehicle.setAccelerate(1);
			}
			if (Input3D.keyDown(Input3D.DOWN)) {
				vehicle.setAccelerate(-1);
			}
			if (!Input3D.keyDown(Input3D.UP) && !Input3D.keyDown(Input3D.DOWN)) {
				vehicle.setAccelerate(0);
			}
			//Steering
			if (Input3D.keyDown(Input3D.LEFT)) {
				vehicle.setSteer(-1);
			}
			if (Input3D.keyDown(Input3D.RIGHT)) {
				vehicle.setSteer(1);
			}
			if (!Input3D.keyDown(Input3D.LEFT) && !Input3D.keyDown(Input3D.RIGHT)) {
				vehicle.setSteer(0);
			}
			
			if (Input3D.keyDown(Input3D.SPACE)) {
				vehicle.setHBrake(true);
			}

			if (Input3D.keyHit(Input3D.R)) {
				vehicle.reset();
			}
			vehicle.step();
			if (!Input3D.mouseDown)
			{
				Pivot3DUtils.setPositionWithReference( scene.camera, 0, 2, -5, vehicle.chassis, 0.4 );
				Pivot3DUtils.lookAtWithReference( scene.camera, 0, 0, 0, vehicle.chassis );
			}
		}
	}

}
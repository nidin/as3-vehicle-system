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
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.Shader3D;
	import flare.physics.collision.AABB;
	import flare.physics.core.PhysicsBox;
	import flare.physics.core.PhysicsMesh;
	import flare.physics.core.PhysicsPlane;
	import flare.physics.core.PhysicsSphere;
	import flare.physics.core.PhysicsSystemManager;
	import flare.physics.core.RigidBody;
	import flare.primitives.Plane;
	import flare.primitives.Sphere;
	import flare.system.Input3D;
	import flare.utils.Pivot3DUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import nid.game.systems.vehicle.Car;
	import nid.game.systems.VehicleSystem;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class VehicleSystemTest2 extends Sprite
	{
		private var scene:Scene3D;
		private var car_container:Pivot3D;
		private var wheel_container:Pivot3D;
		private var next:PushButton;
		private var prev:PushButton;
		private var vehicle:Car;
		private var camera:Camera3D;
		private var world_container:Pivot3D;
		private var physics:PhysicsSystemManager;
		private var sphere1:Sphere;
		private var plane3D:Plane;
		
		public function VehicleSystemTest2() 
		{
			stage.align = "topLeft";
			stage.scaleMode = "noScale";
			
			scene = new Viewer3D( this );
			scene.registerClass(Flare3DLoader1);
			scene.registerClass(SpecularFilter);
			scene.autoResize = true;
			scene.antialias = 2;
			scene.pause();
			
			//camera = new Camera3D('tail_camera');
			//camera.x = 10
			//camera.y = 10
			//camera.z = 10
			//scene.camera = camera;
			camera = scene.camera;
			
			
			physics = PhysicsSystemManager.getInstance();
			physics.gravity = new Vector3D(0, -981, 0);
			physics.accuracy = PhysicsSystemManager.HIGH_ACCURACY;
			
			
			//var worldLimit:AABB = new AABB();			
			//worldLimit.addPoint(new Vector3D( -1000, -200, -1000));
			//worldLimit.addPoint(new Vector3D( 1000, 100, 1000));
			//physics.worldLimit = worldLimit;
			
			world_container = new Pivot3D("world");
			car_container = new Pivot3D("vehicle");
			wheel_container = new Pivot3D("wheel");
			
			var floorMaterial:Shader3D = new Shader3D( "", [new ColorFilter( 0x8282c8 )] );
			plane3D = new Plane( "plane3D", 2000, 2000, 1, floorMaterial, "+xz" );
			scene.addChild( plane3D );
			
			var planePhys: RigidBody = new PhysicsPlane();
			plane3D.addComponent( planePhys );			
			plane3D.visible = true;
			
			scene.addChildFromFile( "world.f3d" , world_container);
			//scene.addChildFromFile( "car.f3d" , car_container);
			//scene.addChildFromFile( "wheel.f3d" , wheel_container);
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent )
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent )
			
			//var button_holder:Sprite = new Sprite();
			//next = new PushButton();
			//prev = new PushButton();
			//next.label = "Next";
			//prev.label = "Previous";
			//prev.x = next.width + 10;
			//button_holder.addChild(next);
			//button_holder.addChild(prev);
			//addChild(button_holder);
			//button_holder.y = stage.stageHeight - button_holder.height - 20;
			//button_holder.x = (stage.stageWidth - button_holder.width) / 2;
			
			//next.addEventListener(MouseEvent.CLICK, handleEvent);
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
			//vehicle = new Car(car_container);
			//vehicle.physics = physics;
			//vehicle.setWheel(wheel_container);
			//vehicle.y = 5;
			//var floor:Pivot3D = world_container.getChildByName("floor");
			//floor.addComponent(new PhysicsBox());
			//RigidBody(floor.components[0]).movable = false;
			//scene.addChild(floor);
			//scene.addChild(vehicle);
			
			//camera.lookAt(vehicle.x, vehicle.y, vehicle.z);
			camera.lookAt(0, 0, 0);
			
			var sphereMaterial:Shader3D = new Shader3D( "", [new ColorFilter( 0xc8c864 )] );
			
			sphere1 = new Sphere("sphere1", 1, 16, sphereMaterial);			
			sphere1.setPosition(0, 50, 0);
			scene.addChild( sphere1 );
			sphere1.addComponent( new PhysicsSphere() );
			//RigidBody(sphere1.components[0]).mass = 5;
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, update );
			scene.resume();
		}
		private function update(e:Event):void 
		{
			/*if (Input3D.keyDown(Input3D.RIGHT) || Input3D.keyDown(Input3D.D))
				vehicle.turnLeft();
			else if (Input3D.keyDown(Input3D.LEFT) || Input3D.keyDown(Input3D.A))
				vehicle.turnRight();
				
			if (Input3D.keyDown(Input3D.UP) || Input3D.keyDown(Input3D.W))
			{
				vehicle.accelerate();
			}
			else if (Input3D.keyDown(Input3D.DOWN) || Input3D.keyDown(Input3D.S))
			{
				vehicle.decelerate();
			}
			if (Input3D.keyDown(Input3D.R))
			{
				vehicle.reset();
			}*/
			if (Input3D.keyDown(Input3D.S))
			{
				sphere1.y = 50;
			}
			if(!Input3D.mouseDown && !Input3D.keyDown(Input3D.CONTROL))
			{
				//Pivot3DUtils.setPositionWithReference( scene.camera, 0, 2, -50,sphere1 , 0.25 );
				//Pivot3DUtils.lookAtWithReference( scene.camera, 0, 0, 0, sphere1);
			}
			physics.step();
		}
	}

}
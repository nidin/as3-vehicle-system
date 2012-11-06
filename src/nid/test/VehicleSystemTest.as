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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nid.game.systems.vehicle.Car;
	import nid.game.systems.VehicleSystem;
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public class VehicleSystemTest extends Sprite
	{
		private var scene:Viewer3D;
		private var car_container:Pivot3D;
		private var wheel_container:Pivot3D;
		private var next:PushButton;
		private var prev:PushButton;
		private var vehicle:Car;
		
		public function VehicleSystemTest() 
		{
			stage.align = "topLeft";
			stage.scaleMode = "noScale";
			
			scene = new Viewer3D( this );
			scene.registerClass(Flare3DLoader1);
			scene.registerClass(SpecularFilter);
			scene.autoResize = true;
			scene.antialias = 2;
			
			car_container = new Pivot3D("vehicle");
			wheel_container = new Pivot3D("wheel");
			
			scene.addChildFromFile( "car.f3d" , car_container);
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
			//scene.addChild(container);
			vehicle = new Car(car_container);
			//trace('Material:'+vehicle.getMaterialByName("Material #21"));
			vehicle.setWheel(wheel_container);
			//vehicle.z = 5;
			scene.addChild(vehicle)
			//addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			vehicle.rotateX(vehicle.getRotation().x + 1);
			vehicle.rotateY(vehicle.getRotation().y + 1);
			vehicle.rotateZ(vehicle.getRotation().z + 1);
		}
	}

}
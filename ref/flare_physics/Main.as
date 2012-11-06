package {
	import flare.basic.*;
	import flare.core.*;
	import flare.physics.core.PhysicsBox;
	import flare.physics.core.PhysicsPlane;
	import flare.physics.core.PhysicsSphere;
	import flare.physics.core.PhysicsSystemManager;
	import flare.physics.core.RigidBody;
	import flare.physics.vehicles.PhysicsVehicle;
	import flare.materials.Shader3D;
	import flare.materials.filters.ColorFilter;
	import flare.primitives.*;
	import flare.utils.*;
	import flare.system.*;
	import flare.loaders.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.*;
	public class Main extends Sprite {
		[Embed(source = "carscene.f3d", mimeType = "application/octet-stream")]
		private var embeddedScene:Class;
		private var scene:Scene3D;
		private var physics:PhysicsSystemManager;
		private var wheelFL:Pivot3D;
		private var wheelFR:Pivot3D;
		private var wheelRL:Pivot3D;
		private var wheelRR:Pivot3D;
		private var carBody:PhysicsVehicle;
		private var chassis:Pivot3D;
		public function Main():void {
			scene = new Viewer3D(this, "without_this_embed_wont_work.f3d");
			scene.registerClass(Flare3DLoader1);
			scene.addEventListener(Scene3D.COMPLETE_EVENT, completeEvent);
			physics=PhysicsSystemManager.getInstance();
			for (var i:int;i<20;i++){
				var boxMaterial:Shader3D=new Shader3D("",[new ColorFilter(0xc86464)]);
				var cube:Cube=new Cube("box",5,5,5,1,boxMaterial);
				cube.setPosition((Math.random()-0.5)*100,5,(Math.random()-0.5)*100);
				scene.addChild(cube);
				cube.addComponent(new PhysicsBox());
			}
			var controls:TextField=new TextField();
			controls.autoSize=TextFieldAutoSize.LEFT;
			controls.defaultTextFormat=new TextFormat("Arial",12,0xffffff);
			addChild(controls);
			controls.htmlText = "ARROWS KEY: control the car"+String.fromCharCode(13)+"SPACE: handbrake" + String.fromCharCode(13)+"F1: reset position";
			controls.y=stage.stageHeight-53;
			scene.pause();
		}
		private function processCar():void {
			chassis=scene.getChildByName("chassis");
			chassis.addComponent(new PhysicsBox());
			scene.getChildByName("Sphere01").addComponent(new PhysicsSphere());
			carBody=new PhysicsVehicle(chassis.components[0] as RigidBody,40,2.5,2000);
			carBody.chassis.mass=10;
			carBody.chassis.setPosition(chassis.x, chassis.y, chassis.z);
			var chassisPos:Vector3D=chassis.getPosition();
			wheelFL=scene.getChildByName("FL_tire");
			carBody.addWheel("1", wheelFL, true, true);
			wheelFR=scene.getChildByName("FR_tire");
			carBody.addWheel("2", wheelFR, true, true);
			wheelRL=scene.getChildByName("RL_tire");
			carBody.addWheel("3", wheelRL, false, true);
			wheelRR=scene.getChildByName("RR_tire");
			carBody.addWheel("4", wheelRR, false, true);
			physics.addVehicle(carBody);
		}
		private function completeEvent(e:Event):void {
			var planet:Flare3DLoader = new Flare3DLoader( embeddedScene );
			planet.parent = scene;
			planet.load();
			var floor:Pivot3D=scene.getChildByName("floor");
			var floorPhysics: RigidBody = new PhysicsPlane();
			floor.addComponent(floorPhysics);
			processCar();
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
			scene.resume();
		}
		private function updateEvent(e:Event = null):void {
			carBody.setAccelerate(0);
			carBody.setSteer(0);
			carBody.setHBrake(false);
			if (Input3D.keyDown(Input3D.UP)) {
				carBody.setAccelerate(1);
			}
			if (Input3D.keyDown(Input3D.DOWN)) {
				carBody.setAccelerate(-0.5);
			}
			if (Input3D.keyDown(Input3D.LEFT)) {
				carBody.setSteer(-1);
			}
			if (Input3D.keyDown(Input3D.RIGHT)) {
				carBody.setSteer(1);
			}
			if (Input3D.keyDown(Input3D.SPACE)) {
				carBody.setHBrake(true);
			}

			if (Input3D.keyHit(Input3D.F1)) {
				carBody.chassis.setPosition(0, 2, 0);
				carBody.chassis.setOrientation(new Matrix3D());
				carBody.chassis.setActive(true);
			}
			physics.step();
			Pivot3DUtils.setPositionWithReference(scene.camera,0,10,-20,chassis,0.1);
			Pivot3DUtils.lookAtWithReference(scene.camera,0,0,10,chassis);
		}
	}
}
package nid.test{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.FollowController;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.LoaderEvent;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.CascadeShadowMapper;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.lightpickers.*;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.CascadeShadowMapMethod;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.*;
	import away3d.textures.BitmapCubeTexture;
	import away3d.tools.utils.Bounds;
	import away3d.utils.Cast;
	import awayphysics.collision.shapes.*;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.*;
	import awayphysics.dynamics.vehicle.*;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import nid.game.systems.io.Input3D;
	import nid.game.systems.vehicle.Car;
	import nid.utils.Graph;


	[SWF(backgroundColor = "#000000", frameRate = "60", width = "1024", height = "768")]
	
	public class Away3dVehiclePhysicsTest extends Sprite 
	{
		// Environment map.
		[Embed(source = "../../../assets/skybox/sky_posX.jpg")] private var EnvPosX:Class;
		[Embed(source = "../../../assets/skybox/sky_posY.jpg")] private var EnvPosY:Class;
		[Embed(source = "../../../assets/skybox/sky_posZ.jpg")] private var EnvPosZ:Class;
		[Embed(source = "../../../assets/skybox/sky_negX.jpg")] private var EnvNegX:Class;
		[Embed(source = "../../../assets/skybox/sky_negY.jpg")] private var EnvNegY:Class;
		[Embed(source = "../../../assets/skybox/sky_negZ.jpg")] private var EnvNegZ:Class;
		
		public var view : View3D;
		private var physicsWorld : AWPDynamicsWorld;
		private var car : AWPRaycastVehicle;
		private var _engineForce : Number = 0;
		private var _breakingForce : Number = 0;
		private var _vehicleSteering : Number = 0;
		private var timeStep : Number = 1.0 / 60;
		private var keyRight : Boolean = false;
		private var keyLeft : Boolean = false;
		
		private var cameraController:HoverController;
        private var move:Boolean = false;
        private var lastPanAngle:Number;
        private var lastTiltAngle:Number;
        private var lastMouseX:Number;
        private var lastMouseY:Number;
		
		private var debugDraw:AWPDebugDraw;
		private var vehicle:Car;
		private var graph:Graph;
		private var info:TextField;
		private var followController:FollowController;
		private var sceneLoaded:Boolean;
		private var delta:Vector3D;
		private var angle:Number=0;
		private var prev_angle:Number=0;
		private var _x:Number=0;
		private var _y:Number=0;
		private var _z:Number=0;
		private var skyBox:SkyBox;
		public var cubeTexture:BitmapCubeTexture;
		private var light2:PointLight;
		private var wheel_obj:ObjectContainer3D;
		private var car_shadow:Mesh;
		public var envMapMethod:EnvMapMethod;
		
		//Lights and shadow
		private var sunlight:DirectionalLight;
		private var sunlight2:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		private var headLight:PointLight;
		private var _lights:Array;
		private var _cascadeShadowMapper:CascadeShadowMapper;
		private var _directionalLight:DirectionalLight;
		private var _lightDirection:Number = Math.PI/4;
		private var _lightElevation:Number = Math.PI/180;
		private var _baseShadowMethod:FilteredShadowMapMethod;
		private var _fogMethod:FogMethod;
		private var _cascadeMethod:CascadeShadowMapMethod;
		
		public static var instance:Away3dVehiclePhysicsTest;
		
		public function Away3dVehiclePhysicsTest() {
			addChild(new KeyConfig());
			instance = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			RootReference.stage = stage;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			view = new View3D();
			this.addChild(view);
			var stats:AwayStats = new AwayStats(view)
			this.addChild(stats);
			stats.x = stage.stageWidth - stats.width;
			RootReference.scene = view.scene;
			
			initLights();
			
			//view.camera.lens.far = 5000;
			view.camera.lens.far = 30000;
			view.camera.y = 2000;
			view.camera.z = -2000;
			view.camera.rotationX = 40;
			
			cameraController = new HoverController(view.camera, null, 150, 10, 500);
			//followController = new FollowController(view.camera, null, 10, 500);
			
			
			cubeTexture = new BitmapCubeTexture(Cast.bitmapData(EnvPosX), Cast.bitmapData(EnvNegX), Cast.bitmapData(EnvPosY), Cast.bitmapData(EnvNegY), Cast.bitmapData(EnvPosZ), Cast.bitmapData(EnvNegZ));
			skyBox = new SkyBox(cubeTexture);
			view.scene.addChild(skyBox);
			envMapMethod = new EnvMapMethod(cubeTexture, 0.25)
			
			// init the physics world
			physicsWorld = AWPDynamicsWorld.getInstance();
			physicsWorld.initWithDbvtBroadphase();
			physicsWorld.gravity = new Vector3D(0, -30, 0);
			
			debugDraw = new AWPDebugDraw(view, physicsWorld); 
			//debugDraw.debugMode = AWPDebugDraw.DBG_DrawCollisionShapes;
			
			
			Parsers.enableAllBundled();
			
			// load scene model
			var _loader : Loader3D = new Loader3D();
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onSceneResourceComplete);
			//_loader.load(new URLRequest('../assets/junkyard.obj'));
			//_loader.load(new URLRequest('../assets/junkyard_prefab/junkyard_prefab.awd'));
			_loader.load(new URLRequest('../assets/set.AWD'));
			
			 //load car model
			_loader = new Loader3D();
			//_loader.load(new URLRequest('../assets/car2.obj'));
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onCarResourceComplete);
			_loader.load(new URLRequest('../assets/car.AWD'));
			
			
			 //load car model
			_loader = new Loader3D();
			//_loader.load(new URLRequest('../assets/car2.obj'));
			_loader.load(new URLRequest('../assets/wheel.AWD'));
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onWheelResourceComplete);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			info = new TextField();
			info.multiline = true;
			info.wordWrap = true;
			info.selectable = false;
			info.mouseEnabled = false;
			//info.autoSize = TextFieldAutoSize.LEFT;
			info.width = 700;
			info.height = stage.stageHeight;
			info.defaultTextFormat = new TextFormat("Verdana", 10, 0xffffff);
			//addChild(info);
			
			graph = new Graph();
			//addChild(graph);
		}
		
		private function initLights():void
		{
			//create lights array
			_lights = new Array();
			
			
			sunlight = new DirectionalLight(10,-10,100);
			sunlight.color = 0xFDF9E8
			sunlight.position = new Vector3D(100, 500, 8000);
			view.scene.addChild(sunlight);
			
			sunlight2 = new DirectionalLight(1, 1, 1);
			sunlight2.color = 0xFDF9E8
			sunlight2.position = new Vector3D(0, 500, 0);
			view.scene.addChild(sunlight2);
			
			headLight = new PointLight();
			headLight.color = 0xffffff;
			headLight.position = new Vector3D(0, 10000, 5000);
			headLight.ambient = 0.45
			headLight.ambientColor = 0x0f0000;
			headLight.specular = 0.25
			view.scene.addChild(headLight);
			
			light2 = new PointLight();
			light2.color = 0xFDF9E8
			view.scene.addChild(light2);
			
			//_lights.push(sunlight);
			//_lights.push(sunlight2);
			_lights.push(headLight);
			//_lights.push(light2);
			
			//sunlight.shadowMapper = new DirectionalShadowMapper();
			//sunlight.shadowMapper.depthMapSize = 2048;
			//RootReference.shadowMethod = new HardShadowMapMethod(sunlight);
			//RootReference.shadowMethod = new SoftShadowMapMethod(sunlight);
			//RootReference.shadowMethod.alpha = 0.5;
			
			
			//create global directional light
			_cascadeShadowMapper = new CascadeShadowMapper(3);
			//_cascadeShadowMapper.lightOffset = 10000;
			_directionalLight = new DirectionalLight(1,1,1);
			_directionalLight.shadowMapper = _cascadeShadowMapper;
			_directionalLight.castsShadows = false;
			_directionalLight.color = 0xeedddd;
			_directionalLight.ambient = .35;
			_directionalLight.ambientColor = 0x808090;
			view.scene.addChild(_directionalLight);
			_lights.push(_directionalLight);
			
			updateDirection();
			
			//creat flame lights
			/*var flameVO:FlameVO;
			for each (flameVO in _flameData)
			{
				var light : PointLight = flameVO.light = new PointLight();
				light.radius = 200;
				light.fallOff = 600;
				light.color = flameVO.color;
				light.y = 10;
				_lights.push(light);
			}*/
			
			//create our global light picker
			lightPicker = new StaticLightPicker(_lights);
			RootReference.lightPicker = lightPicker;
			
			_baseShadowMethod = new FilteredShadowMapMethod(_directionalLight);
			
			//create our global fog method
			_fogMethod = new FogMethod(0, 10000, 0x95796F);
			_cascadeMethod = new CascadeShadowMapMethod(_baseShadowMethod);
			_cascadeMethod.alpha = 0.75
			//_cascadeMethod.baseMethod = new DitheredShadowMapMethod(_directionalLight);
			_cascadeMethod.baseMethod = new SoftShadowMapMethod(_directionalLight);
			RootReference.shadowMethod = _cascadeMethod;
		}
		
		private function updateDirection():void
		{
			_directionalLight.direction = new Vector3D(
				Math.sin(_lightElevation)*Math.cos(_lightDirection),
				-Math.cos(_lightElevation),
				Math.sin(_lightElevation)*Math.sin(_lightDirection)
			);
		}
		private function onSceneResourceComplete(event : LoaderEvent) : void {
			
			var container : ObjectContainer3D = ObjectContainer3D(event.target);
			view.scene.addChild(container);
			var body : AWPRigidBody;
			var mesh : Mesh;
			
			for (var i:int = 0; i < container.numChildren; i++)
			{
				mesh = container.getChildAt(i) as Mesh;
				if(mesh.material is TextureMaterial)TextureMaterial(mesh.material).bothSides = true;
				mesh.geometry.scale(100);
				
				if(mesh.material is TextureMaterial)TextureMaterial(mesh.material).specular = 0;
				
				if ( mesh.name.indexOf("sdw") != -1) {
					TextureMaterial(mesh.material).shadowMethod = _cascadeMethod;
				}
				if ( mesh.name == "road")
				{
					
					if (mesh.material is TextureMaterial)
					{
						TextureMaterial(mesh.material).repeat = true;
						TextureMaterial(mesh.material).bothSides = false;
						TextureMaterial(mesh.material).lightPicker = lightPicker;
						//mesh.castsShadows = true;
						TextureMaterial(mesh.material).shadowMethod = _cascadeMethod;
						TextureMaterial(mesh.material).addMethod(_fogMethod)
					}
					
					mesh.geometry.scaleUV(100, 100);
					
					
					//TextureMaterial(mesh.material).addMethod(new ProjectiveTextureMethod(car_shadow));
					
					var sceneShape : AWPBvhTriangleMeshShape = new AWPBvhTriangleMeshShape(mesh.geometry);
					body = new AWPRigidBody(sceneShape, mesh, 0);
					physicsWorld.addRigidBody(body);
				}
				
				else if (mesh != null &&  mesh.name == "box")
				{
					Bounds.getObjectContainerBounds(mesh)
					var boxShape:AWPBoxShape = new AWPBoxShape(Bounds.width, Bounds.height, Bounds.depth);
					body = new AWPRigidBody(boxShape, mesh, 1);
					body.friction = .9;
					physicsWorld.addRigidBody(body);
					var material:MaterialBase = mesh.material;
					TextureMaterial(mesh.material).addMethod(_fogMethod)
					var cube_mesh:Mesh = mesh;
				}
			}
			
			debugDraw.debugMode = AWPDebugDraw.DBG_NoDebug;
			sceneLoaded = true;
			
			boxShape = new AWPBoxShape(Bounds.width, Bounds.height, Bounds.depth);
			
			var numx : int = 10;
			var numy : int = 5;
			var numz : int = 1;
			
			for (i= 0; i < numx; i++ ) {
				for (var j : int = 0; j < numz; j++ ) {
					for (var k : int = 0; k < numy; k++ ) {
						mesh = cube_mesh.clone() as Mesh;
						mesh.material.lightPicker = lightPicker;
						TextureMaterial(mesh.material).ambient = 1;
						TextureMaterial(mesh.material).specular = 0
						view.scene.addChild(mesh);
						body = new AWPRigidBody(boxShape, mesh, 1);
						body.friction = .9;
						body.position = new Vector3D(-1500 + i * Bounds.width, Bounds.height + k * Bounds.height, 1000 + j * Bounds.depth);
						physicsWorld.addRigidBody(body);
					}
				}
			}
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}

		private function onWheelResourceComplete(event : LoaderEvent) : void {
			wheel_obj = ObjectContainer3D(event.target);
			if (vehicle != null) vehicle.setWheel(wheel_obj);
		}
		private function onCarResourceComplete(event : LoaderEvent) : void {
			var container : ObjectContainer3D = ObjectContainer3D(event.target);
			vehicle = new Car(container, physicsWorld);
			if (wheel_obj != null) vehicle.setWheel(wheel_obj);
		}
		private function keyDownHandler(event : KeyboardEvent) : void {
			Input3D.mapDown(event.keyCode);
		}
		private function keyUpHandler(event : KeyboardEvent) : void {
			Input3D.mapUp(event.keyCode);
		}
		private function mouseDownHandler(e:MouseEvent):void
        {
            lastPanAngle = cameraController.panAngle;
            lastTiltAngle = cameraController.tiltAngle;
            lastMouseX = stage.mouseX;
            lastMouseY = stage.mouseY;
            move = true;
            stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
        }
		private function mouseUpHandler(e:MouseEvent):void
        {
            move = false;
            stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
        }
		private function onStageMouseLeave(e:Event):void
        {
            move = false;
            stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
        }
		private function resizeHandler(e:Event=null):void
        {
            view.width = stage.stageWidth;
            view.height = stage.stageHeight;
			info.height = stage.stageHeight;
        }
		private function handleEnterFrame(e : Event) : void {
			
			if (vehicle) {
				
				//Accelerator
				
				vehicle.setBoost(Input3D.N?8:1);
				
				if (Input3D.D) {
					vehicle.destroy();
				}
				if (Input3D.UP) {
					vehicle.setAccelerate(1);
				}
				if (Input3D.DOWN) {
					vehicle.setAccelerate(-1);
				}
				if (!Input3D.UP && !Input3D.DOWN) {
					vehicle.setAccelerate(0);
				}
				//Steering
				if (Input3D.LEFT) {
					vehicle.setSteer(-1);
				}
				if (Input3D.RIGHT) {
					vehicle.setSteer(1);
				}
				if (!Input3D.LEFT && !Input3D.RIGHT) {
					vehicle.setSteer(0);
				}
				if (Input3D.Z) {
					vehicle.gearUp();
					graph.changeColor();
				}
				if (Input3D.X) {
					vehicle.gearDown();
					graph.changeColor();
				}
				
				if (Input3D.SPACE) {
					vehicle.setHBrake(true);
				}
				else vehicle.setHBrake(false);

				if (Input3D.R) {
					vehicle.reset();
				}
				
				vehicle.step();
				physicsWorld.step(timeStep);
				
				/*car.applyEngineForce(_engineForce, 0);
				car.setBrake(_breakingForce, 0);
				car.applyEngineForce(_engineForce, 1);
				car.setBrake(_breakingForce, 1);
				car.applyEngineForce(_engineForce, 2);
				car.setBrake(_breakingForce, 2);
				car.applyEngineForce(_engineForce, 3);
				car.setBrake(_breakingForce, 3);

				car.setSteeringValue(_vehicleSteering, 0);
				car.setSteeringValue(_vehicleSteering, 1);
				_vehicleSteering *= 0.9;*/
				
				//followController.update();
				
				var cam_distance:Number = 350;
				var _scale:Number 		= 3;
				var smooth:Number 		= 0.75;
				var dir:Vector3D 		= vehicle.phyVehicle.getRigidBody().front;
				var up:Vector3D 		= vehicle.phyVehicle.getRigidBody().up;
				var pos:Vector3D 		= vehicle.phyVehicle.getRigidBody().position;
				var angle:Number 		= Math.atan2( dir.z, dir.x);
				
				delta  = new Vector3D(Math.sin( -angle) * cam_distance / 2, 0, Math.cos( -angle) * cam_distance / 2);
				
				var pos2:Vector3D = pos.add(new Vector3D( -delta.z * _scale, 300, delta.x * _scale));
				
				if (smooth != 1)
				{
					pos2.x = pos2.x + (_x - pos2.x) * smooth;
					pos2.y = pos2.y + (_y - pos2.y) * smooth;
					pos2.z = pos2.z + (_z - pos2.z) * smooth;
				}
				
				_x = pos2.x;
				_y = pos2.y;
				_z = pos2.z;
				
				var s_rot:Number = (angle * 57.2957795);
				s_rot = s_rot < 0?360 + s_rot:s_rot;
				//car_shadow.x = pos.x
				//car_shadow.z = pos.z + 20;
				//car_shadow.rotationY = 90 - s_rot;
				
				//headLight.position = pos.add(new Vector3D(100 * dir.x, 0, 100 * dir.z));
				//headLight.position = pos.add(new Vector3D(0, 0, 250));
				
				//car_shadow.rotationZ = vehicle.phyVehicle.getRigidBody().rotationZ;
				
				view.camera.position = pos2;
				//view.camera.lookAt(vehicle.phyVehicle.getRigidBody().position, vehicle.phyVehicle.getRigidBody().up);
				view.camera.lookAt(vehicle.phyVehicle.getRigidBody().position.add(new Vector3D(0,100,0)));
				
				//view.camera.rotate(new Vector3D(view.camera.x - pos.x, view.camera.y - pos.y, 0, 0), vehicle.phyVehicle.getRigidBody().rotationY);
				//view.camera.rotationY = -angle / 0.0174532925;
				
				info.htmlText = '------------------------' +
							'<br> CAR PROPERTIES' +
							'<br>------------------------'+
							'<br>Mass:' + vehicle.cartype.mass +
							'<br>RotX:' + vehicle.phyVehicle.getRigidBody().rotationX +
							'<br>RotY:' + vehicle.phyVehicle.getRigidBody().rotationY +
							'<br>RotZ:' + vehicle.phyVehicle.getRigidBody().rotationZ +
							'<br>linearVelocityZ:' + vehicle.phyVehicle.getRigidBody().linearVelocity.z +
							'<br>------------------------' +
							'<br> ENGINE' +
							'<br>------------------------' +
							'<br>RPM:' + vehicle.engine.rpm +
							'<br>E_toruqe:' + vehicle.engine.toruqe +
							'<br>HP:' + vehicle.system.hp +
							'<br>gear:' + vehicle.system.car.current_gear +
							'<br>throttle_value:' + vehicle.system.throttle_value +
							'<br>throttle:' + vehicle.system.car.throttle +
							'<br>clutch:' + vehicle.clutch +
							'<br>------------------------' +
							'<br> RESISTANCE' +
							'<br>------------------------' +
							'<br>F_drag:' + vehicle.system.F_drag + 
							'<br>F_rr:' + vehicle.system.F_rr + 
							'<br>------------------------' +
							'<br> MOVEMENT' +
							'<br>------------------------'+
							'<br>acceleration:' + vehicle.system.acceleration +
							'<br>acceleration_wc:' + vehicle.system.acceleration_wc +
							'<br>velocity:' + vehicle.system.velocity + 
							'<br>velocity_wc:' + vehicle.velocity_wc + 
							'<br>speed:' + vehicle.system.speed + 
							'<br>kmh:' + vehicle.system.kmh + 
							'<br>------------------------' +
							'<br> WHEEL' +
							'<br>------------------------' +
							'<br>D_torque:' + vehicle.system.T_drive +
							'<br>slipratio:' + vehicle.system.slipratio +
							'<br>rpmWheel:' + vehicle.system.rpmWheel +
							'<br>------------------------' +
							'<br> STEERING' +
							'<br>------------------------' +
							'<br>steerangle:' + (vehicle.steerangle * 180 / Math.PI) + '-deg,' + vehicle.steerangle + '-rad'+
							'<br>angular_acceleration:' + vehicle.system.angular_acceleration +
							'<br>angularvelocity:' + vehicle.angularvelocity +
							'<br>yawspeed:' + vehicle.system.yawspeed+
							'<br>C_torque_f:' + vehicle.system.C_torque_f+
							'<br>C_torque_r:' + vehicle.system.C_torque_r+
							'<br>C_torque:' + vehicle.system.C_torque+
							'<br>angle:' + (vehicle.angle * (180/Math.PI)) +
							'<br>rot_angle:' + (vehicle.system.rot_angle * (180/Math.PI)) +
							'<br>side_slip:' + vehicle.system.side_slip +
							'<br>slip_angle_F:' + vehicle.system.slip_angle_F +
							'<br>slip_angle_R:' + vehicle.system.slip_angle_R +
							'<br>------------------------' +
							'<br> LATERAL FORCE' +
							'<br>------------------------' +
							'<br>F_lat_f:' + vehicle.system.F_lat_f +
							'<br>F_lat_r:' + vehicle.system.F_lat_r +
							'<br>F_lateral:' + vehicle.system.F_lateral +
							'<br>------------------------' +
							'<br> FORCE' +
							'<br>------------------------'+
							'<br>F_traction:' + vehicle.system.F_traction +
							'<br>F_long:' + vehicle.system.F_long +
							'<br>brake_value:' + vehicle.system.brake_value +
							'<br>F_braking:' + vehicle.brake +
							'<br>F_back:' + vehicle.system.F_back +
							'<br>F_drive:' + vehicle.system.F_drive +
							'<br>force:' + vehicle.system.force +
							'<br>brake:' + vehicle.brake +
							'<br>------------------------' +
							'<br> FPS' +
							'<br>------------------------'+
							'<br>delta_t:' + vehicle.system.delta_t;
			}
			debugDraw.debugDrawWorld();
			if (move) {
                cameraController.lookAtObject = vehicle.chassis;
                cameraController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
                cameraController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
            }
			else
			{
				cameraController.lookAtObject = null;
			}
			//var pos:Vector3D = vehicle.phyVehicle.getRigidBody().position;
			
			view.render();
			
			
		}
		
	}
}
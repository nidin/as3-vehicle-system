package nid.test
{
	import flare.basic.*;
	import flare.core.Pivot3D;
	import flare.materials.filters.ColorFilter;
	import flare.materials.Shader3D;
	import flare.physics.collision.*;
	import flare.physics.core.PhysicsBox;
	import flare.physics.core.PhysicsCapsule;
	import flare.physics.core.PhysicsPlane;
	import flare.physics.core.PhysicsSphere;
	import flare.physics.core.PhysicsSystemManager;
	import flare.physics.core.RigidBody;
	import flare.physics.tools.Math3D;
	import flare.primitives.*;
	import flare.system.Input3D;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
 
	public class Test02_Primitives extends Sprite 
	{
		private var scene: Scene3D;
		private var physics  : PhysicsSystemManager;
 
		public function Test02_Primitives() 
		{
			//Create the scene
			scene = new Viewer3D(this);
 
			//Set the expected frame rate
			scene.frameRate = 30;
 
			//Initialize the physics manager
			//By default physics engine use grid clasification(The performance is increased when exists lot of objects)
			physics = PhysicsSystemManager.getInstance();			
 
			//This demo works in centimeters and grams and seconds 
 
			//Set the gravity acceleration
			//By default, it is set to 9.81 mts. This demo use centimeters, so we set gravity to 981 cms.
			physics.gravity = new Vector3D(0, -981, 0);								
 
			//Create a visual representation (a Plane) for the floor 
			var floorMaterial:Shader3D = new Shader3D( "", [new ColorFilter( 0x8282c8 )] );
			var plane3D:Plane = new Plane( "plane3D", 2000, 2000, 1, floorMaterial, "+xz" );
			scene.addChild( plane3D );		
 
			//Create a physical representation for the floor
			//By default, the plane is +XZ			
 
			//Link the visual with the physical representation
			var planePhys: RigidBody = new PhysicsPlane();
			plane3D.addComponent( planePhys );			
			plane3D.visible = true;			
 
			//load 3D model for capsule 
			//scene.addChildFromFile("../resources/capsule.f3d");							
			//scene.getChildByName("capsule.f3d").visible = false;
 
			//Create a label to show instructions
			var controls: TextField = new TextField();			
			controls.autoSize = TextFieldAutoSize.LEFT;
			controls.defaultTextFormat = new TextFormat( "Helvetica" , 14, 0xffffff);
			addChild(controls);
			controls.htmlText =	"1: Add spheres" + String.fromCharCode(13) + 
								"2: Add capsules" + String.fromCharCode(13) + 
								"3: Add boxes";
			controls.x = 5;
			controls.y = 5;	
 
			//Set the camera position
			scene.camera.setPosition( 0, 1.4, 4.0 );
			scene.camera.lookAt( 0, 0, 0 );
 
			//Define an update event
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
 
		private function addBox(x:Number, y: Number, z:Number):void 
		{
			//CREATE A BOX			
			//Create the visual
			//the box dimensions are 10 x 10 x 10 cm.
			var boxMaterial:Shader3D = new Shader3D( "", [new ColorFilter( 0xc86464 )] );
			var cube:Cube = new Cube("box", 20, 20, 20, 1, boxMaterial);			
			cube.setPosition(x, y, z);
			scene.addChild( cube );
 
			//Create the physical representation for box and link to the visual			
			cube.addComponent( new PhysicsBox() );		
		}
 
		private function addSphere(x:Number, y: Number, z:Number):void 
		{
			//CREATE A SPHERE			
			//Create the visual
			//the sphere radius is 5 cm.
			var sphereMaterial:Shader3D = new Shader3D( "", [new ColorFilter( 0xc8c864 )] );
			var sphere:Sphere = new Sphere("sphere", 5, 12, sphereMaterial);			
			sphere.setPosition(x, y, z);
			scene.addChild( sphere );
 
			//Create physical representation for sphere and link to the visual			
			sphere.addComponent( new PhysicsSphere() );		
		}
 
		private function addCapsule(x:Number, y: Number, z:Number):void 
		{
			//CREATE A CAPSULE			
			//Create the visual			
			//the capsule radius is 1.5 cm and lenght is 10 cm.
			var capsuleMaterial:Shader3D = new Shader3D( "", [new ColorFilter( 0x6464c8 )] );
			var capsule: Pivot3D = scene.getChildByName("capsule.f3d").clone();			
			capsule.setScale(2, 2, 2);
			capsule.setMaterial(capsuleMaterial);			
			capsule.setOrientation(new Vector3D(Math.random() * 90, Math.random() * 90 , Math.random() * 90));
			capsule.setPosition(x, y, z);
			capsule.visible = true;
			scene.addChild(capsule);
 
			//Create physical representation for capsule and link to the visual
			capsule.addComponent(new PhysicsCapsule());							
		}	
 
		private function updateEvent(e:Event):void 
		{				
			if ( Input3D.keyHit( Input3D.NUMBER_1 ) ) 
				addSphere( (Math3D.random() - 0.5) * 100, 40 + Math3D.random() * 50, (Math3D.random() - 0.5) * 100);	
 
			if ( Input3D.keyHit( Input3D.NUMBER_2 ) ) 
				//addCapsule( (Math3D.random() - 0.5) * 100, 40 + Math3D.random() * 50, (Math3D.random() - 0.5) * 100);
 
			if ( Input3D.keyHit( Input3D.NUMBER_3 ) ) 
				//addBox( (Math3D.random() - 0.5) * 100, 40 + Math3D.random() * 50, (Math3D.random() - 0.5) * 100);			
				addBox( (Math3D.random() - 0.5) * 10, 40 + Math3D.random() * 50, (Math3D.random() - 0.5) * 10);			
 
			//update physics engine
			physics.step();
		}
	}
}
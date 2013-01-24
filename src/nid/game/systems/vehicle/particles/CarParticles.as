package nid.game.systems.vehicle.particles 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import awayphysics.dynamics.AWPRigidBody;
	import flash.display.Bitmap;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	import nid.utils.VectorUtils;
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class CarParticles 
	{
		[Embed(source = "smoke4.png")]
		private var smoke_img:Class;
		
		public var isVisible:Boolean;
		private var ready:Boolean;
		private var smoke_mat:TextureMaterial;
		private var smoke_particle_HOOD:FollowSmoke;
		private var smoke_particle_RL:FollowSmoke;
		private var smoke_particle_RR:FollowSmoke;
		
		private var smoke_target_HOOD:Object3D
		private var smoke_target_RL:Object3D
		private var smoke_target_RR:Object3D
		private var hood:ObjectContainer3D;
		private var wheel_RR:ObjectContainer3D;
		private var wheel_RL:ObjectContainer3D;
		private var hidden_position:Vector3D;
		private var offset_position:Vector3D;
		
		public function CarParticles() 
		{
			hidden_position = new Vector3D(0, -500, 0);
			offset_position = new Vector3D(0, -30, 0);
			smoke_mat = new TextureMaterial(new BitmapTexture(new smoke_img().bitmapData));
		}
		public function addWheelSmoke( hood:ObjectContainer3D, wheel_RR:ObjectContainer3D, wheel_RL:ObjectContainer3D):void 
		{
			this.wheel_RL = wheel_RL;
			this.wheel_RR = wheel_RR;
			this.hood = hood;
			
			var smoke_bmp:Bitmap = new smoke_img();
			//smoke_particle_HOOD = new FollowSmoke(smoke_bmp.bitmapData);
			smoke_particle_RL = new FollowSmoke(smoke_bmp.bitmapData, 10);
			smoke_particle_RR = new FollowSmoke(smoke_bmp.bitmapData, 10);
			
			//hood.scene.addChild(smoke_particle_HOOD);
			hood.scene.addChild(smoke_particle_RL);
			hood.scene.addChild(smoke_particle_RR);
			
			smoke_target_HOOD = new Object3D();
			smoke_target_RL = new Object3D();
			smoke_target_RR= new Object3D();
			
			//smoke_particle_HOOD.target = smoke_target_HOOD
			smoke_particle_RL.target = smoke_target_RL
			smoke_particle_RR.target = smoke_target_RR
			
			ready = true;
		}
		
		public function showSmoke():void 
		{
			if (!ready) return;
			isVisible = true;
		}
		
		public function hideSmoke():void 
		{
			if (!ready) return;
			isVisible = false;
		}
		
		public function update(rigidBody:AWPRigidBody):void 
		{
			var speed:Number = Math.abs((rigidBody.linearVelocity.z + 5)  / 4);
			smoke_target_HOOD.position = hood.scenePosition;
			
			if(isVisible)
			{
				smoke_target_RL.position = wheel_RL.scenePosition.add(offset_position);
				smoke_target_RR.position = wheel_RR.scenePosition.add(offset_position);
			}
			else
			{
				smoke_target_RL.position = hidden_position;
				smoke_target_RR.position = hidden_position;
			}
			
			//smoke_target_HOOD.position = 
			
			//smoke_particle_HOOD.update(speed);
			smoke_particle_RL.update(speed);
			smoke_particle_RR.update(speed);
		}
	}

}
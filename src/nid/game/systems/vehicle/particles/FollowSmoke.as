package nid.game.systems.vehicle.particles 
{
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.data.ParticlePropertiesMode;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.nodes.ParticleBillboardNode;
	import away3d.animators.nodes.ParticleColorNode;
	import away3d.animators.nodes.ParticleFollowNode;
	import away3d.animators.nodes.ParticlePositionNode;
	import away3d.animators.nodes.ParticleScaleNode;
	import away3d.animators.nodes.ParticleVelocityNode;
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.tools.helpers.ParticleGeometryHelper;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	import nid.test.Away3dVehiclePhysicsTest;
	import nid.test.RootReference;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class FollowSmoke extends ObjectContainer3D 
	{
		private var speed:Number;
		private var animationSet:ParticleAnimationSet;
		private var animator:ParticleAnimator;
		private var follow_node:ParticleFollowNode;
		
		public function FollowSmoke(bitmapData:BitmapData,speed:Number=10):void 
		{
			this.speed = speed;
			var plane:PlaneGeometry = new PlaneGeometry( 50, 50, 1, 1, false, false);
			var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
			for (var i:int = 0; i < 50; i++)
			{
				geometrySet.push(plane);
			}
			
			var particleGeometry:Geometry = ParticleGeometryHelper.generateGeometry(geometrySet);
			//create the particle animation set
			animationSet = new ParticleAnimationSet(true, true, true);
			
			animationSet.addAnimation(follow_node = new ParticleFollowNode(true, true));
			animationSet.addAnimation(new ParticleBillboardNode());
			animationSet.addAnimation(new ParticleScaleNode(ParticlePropertiesMode.GLOBAL, false, false, 1, 3));
			animationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.GLOBAL, new Vector3D(0, 20, 0)));
			animationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
			
			var color_node:AnimationNodeBase = new ParticleColorNode(ParticlePropertiesMode.GLOBAL, true, true, false, false,
			new ColorTransform(0.15, 0.15, 0.15, 0.5), 
			new ColorTransform(0.25, 0.25, 0.25, 0));
			
			animationSet.addAnimation(color_node);
			animationSet.initParticleFunc = initParticleParam;
			
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(bitmapData));
			//material.alpha = 0.75
			material.alphaBlending = true;
			material.blendMode = BlendMode.ADD;
			//material.lightPicker = RootReference.lightPicker;
			var particleMesh:Mesh = new Mesh(particleGeometry, material);
			particleMesh.bounds.fromSphere(new Vector3D(), 100000);
			particleMesh.castsShadows = false;
			animator = new ParticleAnimator(animationSet);
			particleMesh.animator = animator;
			addChild(particleMesh);
			animator.start();
			
		}
		public function set target(_target:Object3D):void {
			follow_node.getAnimationState(animator).followTarget = _target;
		}
		public function update(speed:Number):void 
		{
			animator.playbackSpeed = speed * 2;
		} 
		private function initParticleParam(prop:ParticleProperties):void
		{
			prop.startTime = Math.random()*4.1;
			prop.duration = 6
			
			//var degree1:Number = Math.random() * Math.PI * 2;
			//var degree2:Number = Math.random() * Math.PI * 2;
			//var r:Number = Math.random() * 100;
			//prop[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(r * Math.sin(degree1) * Math.cos(degree2), r * Math.cos(degree1) * Math.cos(degree2), r * Math.sin(degree2));
			//prop[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(Math.random() * 10, Math.random() * 20, Math.random() * 10);
			prop[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(Math.random() * 100 - 50, Math.random() * 10, Math.random() * 100 - 50);
		}
	}

}
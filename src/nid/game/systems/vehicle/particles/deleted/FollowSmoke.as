package nid.game.systems.vehicle.particles.deleted
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.primitives.PlaneGeometry;
	import awayphysics.dynamics.AWPRigidBody;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author liaocheng
	 */
	public class FollowSmoke extends ObjectContainer3D 
	{
		public var particle:paricle;
		private var _target:Object3D;
		private var scaleAction:ScaleByLifeGlobal;
		private var speed:Number;
		private var generater:SingleGenerater;
		
		public function FollowSmoke(bitmapData:BitmapData,speed:Number=10):void 
		{
			this.speed = speed;
			var material:ParticleBitmapMaterial = new ParticleBitmapMaterial(bitmapData);
			material.blendMode = BlendMode.ADD;
			material.requiresBlending = true;
			var plane:PlaneGeometry = new PlaneGeometry( 50, 50, 1, 1, false, false);
			var sample:ParticleSample = new ParticleSample(plane.subGeometries[0], material);
			generater = new SingleGenerater(sample, 250);
			
			particle = new TransformFollowContainer();
			particle.alwaysInFrustum = true;
			particle.loop = true;
			particle.playbackSpeed = speed;
			
			var action:VelocityLocal = new VelocityLocal();
			particle.addAction(action);
			
			var action2:ChangeColorByLifeGlobal = new ChangeColorByLifeGlobal(
				new ColorTransform(0.15, 0.15, 0.15, 0.5), 
				new ColorTransform(0.25, 0.25, 0.25, 0));
			
			particle.addAction(action2);
			
			var action3:BillboardGlobal = new BillboardGlobal();
			particle.addAction(action3);
			
			scaleAction = new ScaleByLifeGlobal(0.5,5);
			particle.addAction(scaleAction);
			
			var action5:DriftLocal = new DriftLocal();
			particle.addAction(action5);
			
			particle.initParticleFun = initParticleParam;
			particle.generate(generater);
			particle.start();
			particle.animator.autoUpdate = true;
			addChild(particle);
		}
		public function update(_speed:Number):void 
		{
			particle.playbackSpeed = _speed;
		}
		
		public function stop():void 
		{
			particle.stop();
		}
		public function resume():void 
		{
			particle.start();
		}
		
		public function set target(_target:Object3D): void
		{
			this._target = _target;
			TransformFollowContainer(particle).followTarget = _target;
		}
		
		private function initParticleParam(param:away3d.animators.data.ParticleProperties):void
		{
			param.startTime = Math.random() * 5;
			param.duringTime = Math.random() * 1 + 5;
			var degree:Number = Math.random() * Math.random() * Math.PI * 2;
			var cos:Number = Math.cos(degree);
			var sin:Number = Math.sin(degree);
			var r1:Number = Math.random() * 100;
			param["VelocityLocal"] = new Vector3D(r1 * cos, Math.random() * 20, r1 * sin);
			param["DriftLocal"] = new Vector3D(Math.random() * 10, 0, Math.random() * 10, Math.random() * 5 + 2);
		}
		
	}
	
}
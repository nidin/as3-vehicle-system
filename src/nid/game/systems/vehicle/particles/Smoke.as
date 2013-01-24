package nid.game.systems.vehicle.particles
{
	import a3dparticle.animators.actions.color.ChangeColorByLifeGlobal;
	import a3dparticle.animators.actions.drift.DriftLocal;
	import a3dparticle.animators.actions.rotation.AlwayFaceToCameraGlobal;
	import a3dparticle.animators.actions.scale.ScaleByLifeGlobal;
	import a3dparticle.animators.actions.velocity.VelocityLocal;
	import a3dparticle.generater.SingleGenerater;
	import a3dparticle.particle.ParticleBitmapMaterial;
	import a3dparticle.particle.ParticleParam;
	import a3dparticle.particle.ParticleSample;
	import a3dparticle.ParticlesContainer;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.primitives.PlaneGeometry;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author liaocheng
	 */
	public class Smoke extends ObjectContainer3D 
	{
		private var particle:ParticlesContainer;
		
		private var _target:Object3D;
		
		public function Smoke(bitmapData:BitmapData):void 
		{
			var material:ParticleBitmapMaterial = new ParticleBitmapMaterial(bitmapData);
			var plane:PlaneGeometry = new PlaneGeometry(20, 20, 1, 1, false);
			var sample:ParticleSample = new ParticleSample(plane.subGeometries[0], material);
			
			//step 2:we create a generater which will group the samples.
			var generater:SingleGenerater = new SingleGenerater(sample, 500);
			
			//step 3: we create a container and set some attributes.
			particle = new ParticlesContainer();
			particle.loop = true;
			particle.playbackSpeed = 5;
			
			//step 4:we add some actions to the container.
			var action:VelocityLocal = new VelocityLocal();
			particle.addAction(action);
			
			var action2:ChangeColorByLifeGlobal = new ChangeColorByLifeGlobal(new ColorTransform(0.5, 0.5, 0.5, 0.5), new ColorTransform(0.5, 0.5, 0.5, 0));
			particle.addAction(action2);
			
			var action3:AlwayFaceToCameraGlobal = new AlwayFaceToCameraGlobal();
			particle.addAction(action3);
			
			var action4:ScaleByLifeGlobal = new ScaleByLifeGlobal(0.5,2);
			particle.addAction(action4);
			
			var action5:DriftLocal = new DriftLocal();
			particle.addAction(action5);
			
			//step 5:we set the param function whose return value will be used for actions
			particle.initParticleFun = initParticleParam;
			
			//finally,we generate the particles,and start
			particle.generate(generater);
			particle.start();
			
			addChild(particle);
			
		}
		public function set target(_target:Object3D): void
		{
			this._target = _target;
		}
		private function initParticleParam(param:ParticleParam):void
		{
			param.startTime = Math.random() * 5;
			param.duringTime = Math.random() * 1 + 5;
			var degree:Number = Math.random() * Math.random() * Math.PI * 2;
			var cos:Number = Math.cos(degree);
			var sin:Number = Math.sin(degree);
			var r1:Number = Math.random() * 15;
			param["VelocityLocal"] = new Vector3D(r1*cos, Math.random() * 20+50, r1*sin);
			param["DriftLocal"] = new Vector3D(Math.random()*10, 0, Math.random()*10,Math.random()*5+2);
		}
		
	}
	
}
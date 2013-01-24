package nid.game.systems.vehicle.particles
{
	
	
	public class SmokeEmiter extends ParticleEmiter3D 
	{
		public function SmokeEmiter( texture:Texture3D ) 
		{
			var material:Shader3D = new ParticleMaterial3D();
			material.filters.push( new TextureFilter( texture ) );
			material.filters.push( new ColorParticleFilter( [ 0xffffff, 0xffffff, 0xffffff], [ 0, 0.2, 0 ] ) );
			material.build();
			
			super( "smoke", material, new SmokeParticle() );
			super.decrementPerFrame = -1;
			super.emitParticlesPerFrame = 2;
			super.particlesLife = 15;
		}
	}
}

import flare.core.*;

class SmokeParticle extends Particle3D
{
	private var speed:Number;
	private var spin:Number;
	
	override public function init( emiter:ParticleEmiter3D ):void 
	{
		speed = Math.random() * 2;
		spin = 0.1;
		
		this.x = Math.random() * 2;
		this.y = Math.random() * 20 - 10;
		this.z = Math.random() * 20 - 10;
		
		var scale:Number = emiter.scaleX;
		
		this.sizeX = scale * 2;
		this.sizeY = scale * 2;
	}
	
	override public function update(time:Number):void 
	{
		this.y += speed;
		this.z -= speed;
		this.rotation += spin;
		this.sizeX *= 1.2;
		this.sizeY *= 1.2;
	}
	
	override public function clone():Particle3D 
	{
		return new SmokeParticle();
	}	
}
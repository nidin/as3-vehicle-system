package nid.game.systems.vehicle.particles 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.ParticleGroupParser;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class Explosion extends ObjectContainer3D 
	{
		private var fire:ParticleGroup;
		private var glass:ParticleGroup;
		private var explosive:ParticleGroup;
		private var clearID:uint;
		private var isReady:Boolean;
		
		public function Explosion() 
		{
			var loader:AssetLoader = new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onFireReady);
			loader.load(new URLRequest('gfx/explosion-fire-4.4.grp'), null, null, new ParticleGroupParser());
			
			loader = new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onExplosiveReady);
			loader.load(new URLRequest('gfx/explosion-4.4.grp'), null, null, new ParticleGroupParser());
			
			loader = new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onGlassReady);
			loader.load(new URLRequest('gfx/shatters_1.0.grp'), null, null, new ParticleGroupParser());
		}
		
		private function onFireReady(e:AssetEvent):void 
		{
			if (e.asset.assetType == AssetType.CONTAINER && e.asset is ParticleGroup) {
				fire = e.asset as ParticleGroup;
				fire.particleMeshes.forEach(function(a:Mesh, i:int, ar:Vector.<Mesh>):void {
					Mesh(a).castsShadows = false;
				});
				addChild(fire);
				isReady = true;
			}
		}
		private function onExplosiveReady(e:AssetEvent):void 
		{
			if (e.asset.assetType == AssetType.CONTAINER && e.asset is ParticleGroup) {
				explosive = e.asset as ParticleGroup;
				explosive.particleMeshes.forEach(function(a:Mesh, i:int, ar:Vector.<Mesh>):void {
					Mesh(a).castsShadows = false;
				});
				addChild(explosive);
				explosive.visible = false;
				explosive.position = new Vector3D(0, 25, 100);
			}
		}
		private function onGlassReady(e:AssetEvent):void 
		{
			if (e.asset.assetType == AssetType.CONTAINER && e.asset is ParticleGroup) {
				glass = e.asset as ParticleGroup;
				glass.particleMeshes.forEach(function(a:Mesh, i:int, ar:Vector.<Mesh>):void {
					Mesh(a).castsShadows = false;
				});
				addChild(glass);
			}
		}
		public function play():void {
			if (!isReady) return;
			explosive.animator.resetTime();
			explosive.animator.start();
			explosive.visible = true;
			fire.animator.resetTime();
			fire.animator.start();
			glass.animator.resetTime();
			glass.animator.start();
			clearTimeout(clearID);
			clearID = setTimeout(stop, 10000);
		}
		
		public function stop():void 
		{
			explosive.animator.stop();
			fire.animator.stop();
			glass.animator.stop();
		}
		public function update(speed:Number):void 
		{
			if (isReady) {
				speed = speed < 3?3:speed;
				fire.animator.playbackSpeed = speed/2;
			}
		}
		
	}

}
package nid.game.systems.vehicle 
{
	import flash.events.SampleDataEvent;
	import flash.media.scanHardware;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import nid.game.systems.vehicle.sound.EngineSound;
	import nid.game.systems.vehicle.sound.Loop;
	import tonfall.core.blockSize;
	import tonfall.core.Driver;
	import tonfall.core.Engine;
	import tonfall.core.Memory;
	import tonfall.prefab.audio.ContinuousLoop;
	import tonfall.prefab.audio.ContinuousSyncedLoop;
	import tonfall.prefab.routing.MixingUnit;
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class CarSound 
	{
		private const TEMPO_MIN: Number = 10.0;
		private const TEMPO_MAX: Number = 900.0;
		
		private const loopPlayer: ContinuousLoop = new ContinuousLoop( Loop.ENGINE_IDLE, Loop.ENGINE_IDLE.numSamples, 1.0 );
		private const loopPlayer2: ContinuousLoop = new ContinuousLoop( Loop.BRAKE, Loop.BRAKE.numSamples, 1.0 );
		private const mixer: MixingUnit = new MixingUnit( 2 );
		
		private var driver: Driver = Driver.getInstance();
		private var engine: Engine = Engine.getInstance();
		
		public function CarSound() 
		{
			driver.engine = engine;
			engine.bpm = 300.0;
			Memory.length = blockSize << 3;
			
			mixer.connectAt( loopPlayer.signalOutput, 0 );
			mixer.connectAt( loopPlayer2.signalOutput, 1 );
			
			//mixer.setGainAt(0, 1);
			
			loopPlayer2.enabled = false;
			
			engine.processors.push( loopPlayer );
			engine.processors.push( loopPlayer2 );
			engine.processors.push( mixer );
			engine.input = mixer.signalOutput;
			
			//setTimeout( driver.init, 100 );
		}
		public function set engineLevel(value:Number):void { loopPlayer.bpm = value * TEMPO_MAX; }
		public function set brake(value:Boolean):void
		{
			mixer.setGainAt(value?0.35:0, 1);
		}
	}

}
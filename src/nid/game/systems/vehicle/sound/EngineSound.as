package nid.game.systems.vehicle.sound 
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class EngineSound 
	{
		private var output:Sound;
		public var delay:Number = 3741.0;
		public var bufferSize:int = 4096;
		public var samplesTotal:int = 0;
		public var samplesPosition:int = 0;
		public var src_sound:Sound;
		public var buffer:Number;
		public var duration:Number;
		private var BLOCK_SIZE: int = 3072;
		private var _target: ByteArray;
		private var _position: Number;
		private var _rate: Number;
		private var _skip_bytes_at_start:uint;
		private var _skip_bytes_at_end:uint;
		
		public var channel:SoundChannel;
		public var enabled:Boolean = false;
		
		public function EngineSound(src:Sound, buffer:Number)
		{
			_position = 0.0;
			_rate = 0.0;
			_target = new ByteArray();
			init(src);
		}
		public function init(src:Sound):void
		{
			src_sound = src;
			
			if (channel != null)
			{
				channel.stop();
			}
			output = null;
			
			if (src != null)
			{
				output = new Sound();
				output.addEventListener(SampleDataEvent.SAMPLE_DATA, process);
				channel = output.play();
				channel.soundTransform = new SoundTransform(0.5);
			}
		}
		public function set pitch(value:Number):void 
		{
			_rate = value;
		}
		private function process(e:SampleDataEvent):void
		{
			if (channel) delay = ((e.position / 44.1) - channel.position);
			
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = e.data;
			
			var scaledBlockSize: Number 	= BLOCK_SIZE * _rate;
			var positionInt: int 			= _position;
			var alpha: Number 				= _position - positionInt;
			var positionTargetNum: Number 	= alpha;
			var positionTargetInt: int 		= -1;

			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need: int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			var read: int = _mp3.extract( _target, need, positionInt );

			var n: int = read == need ? BLOCK_SIZE : read / _rate;

			var l0: Number;
			var r0: Number;
			var l1: Number;
			var r1: Number;

			for( var i: int = 0 ; i < n ; ++i )
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if( int( positionTargetNum ) != positionTargetInt )
				{
					positionTargetInt = positionTargetNum;
					
					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;
	
					//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
					l0 = _target.readFloat();
					r0 = _target.readFloat();

					l1 = _target.readFloat();
					r1 = _target.readFloat();
				}
				
				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
				data.writeFloat( l0 + alpha * ( l1 - l0 ) );
				data.writeFloat( r0 + alpha * ( r1 - r0 ) );
				
				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;
				
				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}
			
			//-- FILL REST OF STREAM WITH ZEROs
			if( i < BLOCK_SIZE )
			{
				while( i < BLOCK_SIZE )
				{
					data.writeFloat( 0.0 );
					data.writeFloat( 0.0 );
					
					++i;
				}
			}

			//-- INCREASE SOUND POSITION
			_position += scaledBlockSize;
		}
	}

}
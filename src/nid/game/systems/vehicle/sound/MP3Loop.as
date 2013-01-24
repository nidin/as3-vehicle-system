package nid.game.systems.vehicle.sound
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	/**
	 * Playback MP3-Loop (gapless)
	 *
	 * This source code enable sample exact looping of MP3.
	 * 
	 * http://blog.andre-michelle.com/2010/playback-mp3-loop-gapless/
	 *
	 * Tested with samplingrate 44.1 KHz
	 *
	 * <code>latency</code> does not change on different bitrates.
	 * Value was found by comparision of encoded and original audio file.
	 *
	 * @author andre.michelle@audiotool.com (04/2010)
	 */
	[SWF(width='512',height='16',frameRate='999',backgroundColor='0xDDDDDD')]
	public final class MP3Loop extends Sprite
	{
		private var latency:Number = 2257.0; // LAME 3.98.2 + flash.media.Sound Delay
		//private var latency:Number = 0; // LAME 3.98.2 + flash.media.Sound Delay

		private var bufferSize: int = 4096; // Stable playback
		
		private var samplesTotal: int = 0; // original amount of sample before encoding (change it to your loop)

		private const mp3: Sound = new Sound(); // Use for decoding
		private const out: Sound = new Sound(); // Use for output stream

		private const textField: TextField = new TextField();

		private var samplesPosition: int = 0;

		private var enabled: Boolean = false;
		private var channel:SoundChannel;
		private var startPos:Number;

		public function MP3Loop()
		{
			initUI();

			loadMp3();
		}

		private function initUI():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.defaultTextFormat = new TextFormat( 'Verdana', 10, 0xFFFFFF );
			textField.text = 'loading...';
			addChild( textField );
		}

		private function click( event:MouseEvent ):void
		{
			enabled = !enabled;

			updateText();
		}

		private function updateText(): void
		{
			textField.text = enabled ? 'click to pause...' : 'click to play...';
		}

		private function loadMp3(): void
		{
			mp3.addEventListener( Event.COMPLETE, mp3Complete );
			mp3.addEventListener( IOErrorEvent.IO_ERROR, mp3Error );
			mp3.load( new URLRequest( 'engine_highload.mp3' ) );
		}

		private function mp3Complete( event:Event ):void
		{
			var samples:ByteArray = new ByteArray();
			samplesTotal = mp3.length * 44.1;
			var slices:int = Math.round(samplesTotal / bufferSize);
			//bufferSize = samplesTotal / slices;
			trace('slices:' + slices, '\nbufferSize:' + bufferSize);
			trace('samplesTotal:' + samplesTotal);
			
			stage.addEventListener( MouseEvent.CLICK, click );
			
			updateText();
			startPlayback();
		}

		private function startPlayback():void
		{
			out.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
			channel = out.play();
		}

		private function sampleData( event:SampleDataEvent ):void
		{
			if (channel != null) latency = ((event.position / 44.1) - channel.position);
			if( enabled )
			{
				extract( event.data, bufferSize );
			}
			else
			{
				silent( event.data, bufferSize );
			}
		}

		/**
		 * This methods extracts audio data from the mp3 and wraps it automatically with respect to encoder delay
		 *
		 * @param target The ByteArray where to write the audio data
		 * @param length The amount of samples to be read
		 */
		private function extract( target: ByteArray, length:int ):void
		{
			//trace(samplesPosition + length, samplesTotal);
			var read:int;
			//startPos = samplesPosition + latency;
			startPos = samplesPosition + latency;
			
			/*trace('--------------------');
			trace('startPos:' + startPos);
			trace('samplesPosition:' + samplesPosition);
			trace('latency:' + latency);
			*/
			while( 0 < length )
			{
				if(samplesTotal - startPos < length)
				{
					trace(samplesTotal - startPos);
					read = length;
					length = 0;
					samplesPosition = 0;
					startPos = samplesTotal - read - latency;
					//startPos = latency;
					trace(read, startPos , latency);
				}
				else
				{
					read = length;
					length = 0;
				}
				
				mp3.extract( target, read, startPos );
				samplesPosition += read;
				
				//trace(read, startPos , latency);
			}
		}

		private function silent( target:ByteArray, length:int ):void
		{
			target.position = 0;

			while( length-- )
			{
				target.writeFloat( 0.0 );
				target.writeFloat( 0.0 );
			}
		}

		private function mp3Error( event:IOErrorEvent ):void
		{
			trace( event );
		}

		public override function toString():String
		{
			return '[SandboxMP3Cycle]';
		}
	}
}
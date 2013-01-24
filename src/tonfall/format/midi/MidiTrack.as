package tonfall.format.midi {
	import flash.utils.ByteArray;	final public class MidiTrack
	{
		public const channels: Vector.<Vector.<MidiChannelEvent>> = new Vector.<Vector.<MidiChannelEvent>>( 16, true );		
		private var _index: int;

		public function MidiTrack( index: int )
		{
			_index = index;
			init();
		}		public function decode( stream: ByteArray, timeDivision: Number ): void
		{			var absoluteTime: Number = 0.0;			
			var event: MidiEvent;
			
			var deltaTime: Number;
			
			var byte: int;
			var lastByte: int = 0;
			
			for(; ;)
			{
				deltaTime = readVarLen( stream );								absoluteTime += deltaTime;
				
				byte = stream.readUnsignedByte( );
				
				if( byte < 0xF0 ) // 0x00....0xEF
				{					if( byte < 0x80 ) // running mode, use the last type/channel!
					{
						--stream.position;
						event = new MidiChannelEvent( absoluteTime / timeDivision );
						MidiChannelEvent( event ).decode( stream, lastByte );
					}
					else
					{
						event = new MidiChannelEvent( absoluteTime / timeDivision );
						MidiChannelEvent( event ).decode( stream, byte );
						
						lastByte = byte;
					}										if( byte > 0 )					{
						channels[ MidiChannelEvent( event ).channelNum ].push( event );					}				}
				else if( byte < 0xF8 ) // 0xF0....0xF7
				{
					throw new Error( 'SysEx is not supported yet.' );
				}
				else // 0xF8....0xFF
				{
					event = new MidiMetaEvent( absoluteTime / timeDivision );
					MidiMetaEvent( event ).decode( stream );

					if( MidiMetaEvent( event ).type == MidiMetaEvent.END_OF_TRACK )
						break;
				}
			}		}				public function toString(): String		{			return '[MidiTrack index: ' + _index + ']';		}
		private function init(): void		{			for( var i: int = 0 ; i < 16 ; ++i )			{				channels[i] = new Vector.<MidiChannelEvent>();			}		}	}
}
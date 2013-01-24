package tonfall.format.midi {
	import flash.utils.ByteArray;	public class MidiMetaEvent extends MidiEvent
	{
		static public const END_OF_TRACK: int = 0x2f;		
		private var _type: int;

		public function MidiMetaEvent( pos: Number )
		{
			super( pos );
		}		public function get type(): int		{			return _type;		}

		internal function decode( stream: ByteArray ): void
		{
			_type = stream.readUnsignedByte( );

			var length: uint = readVarLen( stream );						var string: String;
			
			//trace( 'META HEX:' + type.toString( 16 ) );
			switch( _type )
			{
				//-- Sequence Number
				case 0x00:
				
//					trace( "Sequence Number" );
					stream.position += length;
					break;
				
				//-- Text Event
				case 0x01:
					string = stream.readUTFBytes( length );
//					trace( 'Text Event', string + '|' );
					break;
				
				//-- Copyri Notice
				case 0x02:
										string = stream.readUTFBytes( length );
//					trace( 'Copyri Notice', string );
					break;
				
				//-- Sequence/Track Name
				case 0x03:
					string = stream.readUTFBytes( length );
//					trace( 'Sequence/Track Name', string );
					break;
				
				//-- Instrument Name
				case 0x04:
				
					string = stream.readUTFBytes( length );
//					trace( 'Instrument Name', string );
					break;
				
				//-- Lyrics
				case 0x05:
				
					string = stream.readUTFBytes( length );
//					trace( 'Lyrics', string );
					break;
				
				//-- Marker
				case 0x06:
				
					string = stream.readUTFBytes( length );
//					trace( 'Marker', string );
					break;
				
				//-- Cue Point
				case 0x07:
				
					string = stream.readUTFBytes( length );
//					trace( 'Cue Point', string );
					break;
				
				//-- MIDI Channel Prefix
				case 0x20: 
				
					//trace( "MIDI Channel Prefix" );
					stream.position += length;
					break;
				
				//-- Set Tempo
				case 0x51:
				
					//trace( "Set Tempo" );
					stream.position += length;
					break;
				
				//-- SMPTE Offset
				case 0x54:
				
					//trace( "SMPTE Offset:" );
					stream.position += length;
					break;
				
				//-- Time Signature
				case 0x58:
				
					//trace( "Time Signature" );
					stream.position += length;
					break;
				
				//-- Key Signature
				case 0x59:
				
					//trace( "Key Signature" );
					stream.position += length;
					break;
				
				//-- Sequencer Specific
				case 0x7f:
				
					//trace( "Sequencer Specific" );
					stream.position += length;
					break;
				
				//-- prefixport
				case 0x21:
				
					stream.position += length;
					break;
				
				//-- End Of Track
				case 0x2f:
					break;
				
				default:
				
					//trace( "Unknown Meta Event", type, length );
					stream.position += length;
					break;
			}
		}
	}
}
package tonfall.format.pcm
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM32BitFloatStereo44Khz extends PCMStrategy
		implements IPCMIOStrategy
	{
		public function PCM32BitFloatStereo44Khz( compressionType: Object = null )
		{
			super( compressionType, 44100.0, 2, 32 );
		}
		
		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 3 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( data.readFloat() );
				target.writeFloat( data.readFloat() );
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				target.writeFloat( data.readFloat() );
				target.writeFloat( data.readFloat() );
			}
		}
	}
}

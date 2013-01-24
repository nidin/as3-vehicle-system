package nid.game.systems.vehicle.sound
{
	import tonfall.format.wav.WAVDecoder;
	/**
	 * @author Nidin P Vinayakan
	 */
	public final class Loop
	{
		[Embed(source = "incubator/apachee_stidle.wav", mimeType = "application/octet-stream")]
		private static const ENGINE_IDLE_CLASS: Class;
		
		[Embed(source = "incubator/brake1_fx.wav", mimeType = "application/octet-stream")]
		private static const BRAKE_CLASS: Class;
		
		public static const ENGINE_IDLE:WAVDecoder = new WAVDecoder( new ENGINE_IDLE_CLASS() );
		public static const BRAKE:WAVDecoder = new WAVDecoder( new BRAKE_CLASS() );
	}
}
package nid.game.systems.vehicle.particles 
{
    public class Particle3D extends Object
    {
        public var x:Number=0;
        public var y:Number=0;
        public var z:Number=0;
        public var sizeX:Number=1;
        public var sizeY:Number=1;
        public var rotation:Number = 0;
		
        var life:Number = 0;
		
        public function Particle3D()
        {
            super();
            return;
        }
        public function clone():Particle3D
        {
            return new Particle3D();
        }
        public function init(arg1:ParticleEmiter3D):void
        {
            this.x = Math.random() * 20 - 10;
            this.y = Math.random() * 20 - 10;
            this.z = Math.random() * 20 - 10;
            return;
        }
        public function update(arg1:Number):void
        {
            return;
        }
    }
}

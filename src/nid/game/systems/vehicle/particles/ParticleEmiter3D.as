package nid.game.systems.vehicle.particles
{
	import away3d.core.base.Object3D;
	import away3d.materials.MaterialBase;
    import flash.events.*;
    import flash.geom.*;

    public class ParticleEmiter3D extends Object3D
    {
        private var _emitParticlesPerFrame:Number = 0;
        private var _surface:Surface3D;
        private var _context:Scene3D;
        public var particlesLife:Number = 100;
        public var decrementPerFrame:Number = 0;
        private var _useGlobalSpace:Boolean = false;
        private var _emited:int = 0;
        private var _started:int = 0;
        private var _particles:Vector.<Particle3D>;
        private var _particle:Particle3D;
        private var _particlesFraction:Number = 0;
        private var _bounds:Boundings3D;
        private var _right:Vector3D;
        private var _up:Vector3D;
        private var _dir:Vector3D;
        private var _pos:Vector3D;
        private var _vertexLength:int;
        private static var _bScale:Vector3D = new Vector3D();
        private static var _bCenter:Vector3D = new Vector3D();

        public function ParticleEmiter3D(param1:String = "", mat:MaterialBase = null, particle:Particle3D = null)
        {
            this._particles = new Vector.<Particle3D>;
            this._right = new Vector3D();
            this._up = new Vector3D();
            this._dir = new Vector3D();
            this._pos = new Vector3D();
            
            if (particle)
            {
				this._particle = new Particle3D();
				this._surface = new Surface3D();
				this._surface.addVertexData(Surface3D.POSITION);
				this._surface.addVertexData(Surface3D.UV0);
				this._surface.addVertexData(Surface3D.PARTICLE);
				this._surface.addVertexData(Surface3D.NORMAL);
				this._surface.bounds = new Boundings3D();
			}
            if (mat)
            {
				his._surface.material = new Shader3D("", null, true, Shader3D.VERTEX_PARTICLE);
			}
            return;
        }

        override public function dispose() : void
        {
            this._surface.dispose();
            this._surface = null;
            this._particles = null;
            this._particle = null;
            this._context = null;
            this._bounds = null;
            super.dispose();
            return;
        }

        override public function clone() : Pivot3D
        {
            var _loc_2:* = null;
            var _loc_1:* = new ParticleEmiter3D(name, this._surface.material, this.particle);
            _loc_1.world.copyFrom(world);
            _loc_1.visible = visible;
            _loc_1.animationEnabled = animationEnabled;
            _loc_1.frameSpeed = frameSpeed;
            if (frames)
            {
                frames = frames.concat();
            }
            _loc_1.labels = labels;
            _loc_1.play();
            _loc_1.particlesLife = this.particlesLife;
            _loc_1.emitParticlesPerFrame = this.emitParticlesPerFrame;
            _loc_1.decrementPerFrame = this.decrementPerFrame;
            _loc_1.layer = layer;
            for each (_loc_2 in children)
            {
                
                _loc_1.addChild(_loc_2.clone());
            }
            return _loc_1;
        }

        private function emit(param1:int) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            global.copyColumnTo(0, this._right);
            global.copyColumnTo(1, this._up);
            global.copyColumnTo(2, this._dir);
            global.copyColumnTo(3, this._pos);
            if (param1 > this._started)
            {
                _loc_2 = 0;
                while (_loc_2 < param1)
                {
                    
                    _loc_4 = this._surface.vertexVector.length / this._surface.sizePerVertex;
                    _loc_3 = this._particle.clone();
                    this.init(_loc_3);
                    this._particles.push(_loc_3);
                    this._surface.vertexVector.push(0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1);
                    this._surface.indexVector.push(_loc_4, (_loc_4 + 1), _loc_4 + 2, _loc_4 + 3, _loc_4 + 2, (_loc_4 + 1));
                    _loc_2 = _loc_2 + 1;
                }
                this._emited = this._emited + param1;
                _uploaded = false;
            }
            else
            {
                this._started = this._started - param1;
                _loc_2 = 0;
                while (_loc_2 < param1)
                {
                    
                    _loc_3 = this._particles.shift();
                    this.init(_loc_3);
                    this._particles.push(_loc_3);
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }

        private function init(param1:Particle3D) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            param1.life = 0;
            param1.init(this);
            if (this.useGlobalSpace)
            {
                _loc_2 = param1.x * this._right.x + param1.y * this._up.x + param1.z * this._dir.x + this._pos.x;
                _loc_3 = param1.x * this._right.y + param1.y * this._up.y + param1.z * this._dir.y + this._pos.y;
                _loc_4 = param1.x * this._right.z + param1.y * this._up.z + param1.z * this._dir.z + this._pos.z;
                param1.x = _loc_2;
                param1.y = _loc_3;
                param1.z = _loc_4;
            }
            return;
        }

        override public function update() : void
        {
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            super.update();
            this._particlesFraction = this._particlesFraction + this._emitParticlesPerFrame;
            if (this._particlesFraction >= 1)
            {
                this.emit(this._particlesFraction);
                this._particlesFraction = this._particlesFraction - int(this._particlesFraction);
            }
            this._emitParticlesPerFrame = this._emitParticlesPerFrame - (this.decrementPerFrame == -1 ? (this._emitParticlesPerFrame) : (this.decrementPerFrame));
            if (this._emitParticlesPerFrame < 0)
            {
                this._emitParticlesPerFrame = 0;
            }
            var _loc_1:* = this._surface.vertexVector;
            var _loc_2:* = this._surface.sizePerVertex;
            var _loc_3:* = this._surface.sizePerVertex * 2;
            var _loc_4:* = this._surface.sizePerVertex * 3;
            var _loc_5:* = this._surface.sizePerVertex * 4;
            var _loc_6:* = this.particlesLife > 0 ? (1 / this.particlesLife) : (0);
            var _loc_7:* = this._started;
            while (_loc_7 < this._emited)
            {
                
                _loc_8 = this._particles[_loc_7];
                _loc_8.life = _loc_8.life + _loc_6;
                if (_loc_8.life < 1)
                {
                    _loc_8.update(_loc_8.life);
                    _loc_9 = _loc_7 * _loc_5;
                    _loc_10 = _loc_9;
                    _loc_11 = _loc_9 + _loc_2;
                    _loc_12 = _loc_9 + _loc_3;
                    _loc_13 = _loc_9 + _loc_4;
                    _loc_1[_loc_10] = _loc_8.x;
                    _loc_1[(_loc_10 + 1)] = _loc_8.y;
                    _loc_1[_loc_10 + 2] = _loc_8.z;
                    _loc_1[_loc_10 + 5] = _loc_8.sizeX;
                    _loc_1[_loc_10 + 6] = -_loc_8.sizeY;
                    _loc_1[_loc_10 + 7] = _loc_8.life;
                    _loc_1[_loc_10 + 8] = _loc_8.rotation;
                    _loc_1[_loc_11] = _loc_8.x;
                    _loc_1[(_loc_11 + 1)] = _loc_8.y;
                    _loc_1[_loc_11 + 2] = _loc_8.z;
                    _loc_1[_loc_11 + 5] = -_loc_8.sizeX;
                    _loc_1[_loc_11 + 6] = -_loc_8.sizeY;
                    _loc_1[_loc_11 + 7] = _loc_8.life;
                    _loc_1[_loc_11 + 8] = _loc_8.rotation;
                    _loc_1[_loc_12] = _loc_8.x;
                    _loc_1[(_loc_12 + 1)] = _loc_8.y;
                    _loc_1[_loc_12 + 2] = _loc_8.z;
                    _loc_1[_loc_12 + 5] = _loc_8.sizeX;
                    _loc_1[_loc_12 + 6] = _loc_8.sizeY;
                    _loc_1[_loc_12 + 7] = _loc_8.life;
                    _loc_1[_loc_12 + 8] = _loc_8.rotation;
                    _loc_1[_loc_13] = _loc_8.x;
                    _loc_1[(_loc_13 + 1)] = _loc_8.y;
                    _loc_1[_loc_13 + 2] = _loc_8.z;
                    _loc_1[_loc_13 + 5] = -_loc_8.sizeX;
                    _loc_1[_loc_13 + 6] = _loc_8.sizeY;
                    _loc_1[_loc_13 + 7] = _loc_8.life;
                    _loc_1[_loc_13 + 8] = _loc_8.rotation;
                }
                else
                {
                    var _loc_14:* = this;
                    var _loc_15:* = this._started + 1;
                    _loc_14._started = _loc_15;
                }
                _loc_7 = _loc_7 + 1;
            }
            return;
        }

        override public function download() : void
        {
            super.download();
            _uploaded = false;
            this._surface.download();
            return;
        }

        override public function upload(param1:Scene3D = null, param2:Boolean = false, param3:Boolean = true) : Boolean
        {
            if (param1)
            {
                this._context = param1;
                this._context.addEventListener(Event.CONTEXT3D_CREATE, this.contextEvent, false, 0, true);
            }
            if (super.upload(param1, param2, param3) == false)
            {
                return false;
            }
            if (this._surface.vertexVector.length == 0)
            {
                return false;
            }
            if (!this.material.scene)
            {
                this.material.upload(param1);
            }
            if (_uploaded == false)
            {
                if (this._surface.vertexVector.length == this._vertexLength)
                {
                }
                if (!this._surface.scene)
                {
                    if (this._surface.indexBuffer)
                    {
                        this._surface.indexBuffer.dispose();
                    }
                    if (this._surface.vertexBuffer)
                    {
                        this._surface.vertexBuffer.dispose();
                    }
                    this._surface.indexBuffer = param1.context.createIndexBuffer(this._surface.indexVector.length);
                    this._surface.vertexBuffer = param1.context.createVertexBuffer(this._surface.vertexVector.length / this._surface.sizePerVertex, this._surface.sizePerVertex);
                    this._vertexLength = this._surface.vertexVector.length;
                }
                this._surface.indexBuffer.uploadFromVector(this._surface.indexVector, 0, this._surface.indexVector.length);
                this._surface.vertexBuffer.uploadFromVector(this._surface.vertexVector, 0, this._surface.vertexVector.length / this._surface.sizePerVertex);
            }
            _uploaded = true;
            return true;
        }

        private function contextEvent(event:Event) : void
        {
            this._surface.material.download();
            this.download();
            this.upload(this._context, false, false);
            return;
        }

        public function get bounds() : Boundings3D
        {
            return this._bounds;
        }

        public function set bounds(param1:Boundings3D) : void
        {
            this._bounds = param1;
            return;
        }

        override public function get inView() : Boolean
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (!visible)
            {
                return false;
            }
            if (this.bounds)
            {
                Matrix3DUtils.getScale(global, _bScale);
                Matrix3DUtils.transformVector(global, this.bounds.center, _bCenter);
                Matrix3DUtils.transformVector(Device3D.view, _bCenter, _bCenter);
                _loc_1 = this.bounds.radius * Math.max(_bScale.x, _bScale.y, _bScale.z);
                if (_bCenter.length >= _loc_1)
                {
                    _loc_2 = 1 / Device3D.camera.zoom / _bCenter.z;
                    _loc_3 = Device3D.scene.viewPort.width / Device3D.scene.viewPort.height;
                    if ((_bCenter.x + _loc_1) * _loc_2 < -0.55)
                    {
                        return false;
                    }
                    if ((_bCenter.x - _loc_1) * _loc_2 > 0.55)
                    {
                        return false;
                    }
                    if ((_bCenter.y + _loc_1) * _loc_2 * _loc_3 < -0.55)
                    {
                        return false;
                    }
                    if ((_bCenter.y - _loc_1) * _loc_2 * _loc_3 > 0.55)
                    {
                        return false;
                    }
                    if (_bCenter.z - _loc_1 > Device3D.camera.far)
                    {
                        return false;
                    }
                    if (_bCenter.z + _loc_1 < Device3D.camera.near)
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        public function get particle() : Particle3D
        {
            return this._particle;
        }

        public function set particle(param1:Particle3D) : void
        {
            this._particle = param1;
            return;
        }

        public function get useGlobalSpace() : Boolean
        {
            return this._useGlobalSpace;
        }

        public function set useGlobalSpace(param1:Boolean) : void
        {
            this._useGlobalSpace = param1;
            return;
        }

        public function set emitParticlesPerFrame(param1:Number) : void
        {
            this._emitParticlesPerFrame = param1;
            return;
        }

        public function get emitParticlesPerFrame() : Number
        {
            return this._emitParticlesPerFrame;
        }

        public function set emitParticlesPerSecond(param1:Number) : void
        {
            this._emitParticlesPerFrame = param1 / Device3D.scene.frameRate;
            return;
        }

        public function get emitParticlesPerSecond() : Number
        {
            return this._emitParticlesPerFrame * Device3D.scene.frameRate;
        }

        public function get surface() : Surface3D
        {
            return this._surface;
        }

        public function set material(param1:Material3D) : void
        {
            this._surface.material = param1;
            return;
        }

        public function get material() : Material3D
        {
            return this._surface.material;
        }

        override public function draw(param1:Boolean = true) : void
        {
            var _loc_2:* = null;
            if (!scene)
            {
            }
            if (!this._context)
            {
                return;
            }
            if (!_uploaded)
            {
                if (!scene)
                {
                }
            }
            if (this.upload(this._context, false, false) == false)
            {
                return;
            }
            if (_eventFlags & ENTER_DRAW_FLAG)
            {
                dispatchEvent(_enterDrawEvent);
            }
            if (param1)
            {
                for each (_loc_2 in children)
                {
                    
                    _loc_2.draw(param1);
                }
            }
            if (this._started == this._emited)
            {
                return;
            }
            this._surface.vertexBuffer.uploadFromVector(this._surface.vertexVector, 0, this._surface.vertexVector.length / this._surface.sizePerVertex);
            if (this.useGlobalSpace)
            {
                Device3D.special0.copyFrom(Device3D.camera.view);
            }
            else
            {
                Device3D.global.copyFrom(global);
                Device3D.special0.copyFrom(Device3D.global);
                Device3D.special0.append(Device3D.camera.view);
            }
            this._surface.material.draw(this, this._surface, this._started * 6, this._emited * 2 - this._started * 2);
            if (_eventFlags & EXIT_DRAW_FLAG)
            {
                dispatchEvent(_exitDrawEvent);
            }
            return;
        }

    }
}

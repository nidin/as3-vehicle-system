package flare.primitives 
{
    import __AS3__.vec.*;
    import flare.basic.*;
    import flare.core.*;
    import flare.materials.*;
    import flare.system.*;
    import flare.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    
    public class ShadowPlane extends flare.core.Mesh3D
    {
        public function ShadowPlane(arg1:String, arg2:flare.basic.Scene3D, arg3:flare.core.Light3D, arg4:Number=10, arg5:Number=10, arg6:int=256, arg7:int=256, arg8:int=1)
        {
            this._8 = new flash.events.Event(RENDER_EVENT);
            this._11 = new flash.events.Event(POSTRENDER_EVENT);
            this._14 = new flash.geom.Matrix3D();
            this._17 = new flare.core.Texture3D();
            this._20 = new flare.materials.FlatColorMaterial("", 0);
            this._32 = new flash.filters.BlurFilter();
            this._35 = new flash.geom.ColorTransform();
            this._38 = new flash.geom.Point();
            this._41 = new flash.geom.Matrix3D();
            super(arg1);
            this.bitmapData = new flash.display.BitmapData(arg6, arg7, true, 0);
            this._23 = new flash.geom.Matrix(1, 0, 0, -1, 0, this.bitmapData.height);
            this._26 = new flare.core.Camera3D();
            this._17.bmp = this.bitmapData;
            var loc1:*;
            (loc1 = new flare.materials.TextureMaterial("shadowPlane", this._17)).repeat = false;
            materials.push(loc1);
            this._47(arg4, arg5, arg8, loc1);
            this.scene = arg2;
            this.light = arg3;
            this.autoUpdate = true;
            return;
        }

        internal function _44(arg1:flash.events.Event):void
        {
            var size:flash.geom.Vector3D;
            var depth:Number;
            var e:flash.events.Event;
            var textureRatio:Number;
            var zoom:Number;
            var v:__AS3__.vec.Vector.<Number>;
            var point:flash.geom.Vector3D;
            var prev:flare.materials.Material;
            var meshRatio:Number;

            var loc1:*;
            point = null;
            e = arg1;
            this._26.far = this.scene.camera.far;
            this._26.zoom = this.scene.camera.zoom;
            updateTransforms();
            this._26.updateTransforms();
            this.light.updateTransforms();
            size = bounds.length;
            meshRatio = size.x / size.z;
            textureRatio = this.bitmapData.width / this.bitmapData.height;
            depth = bounds.length.x;
            zoom = this._26.zoom;
            if (this.light) 
            {
                point = globalToLocal(this.light.global.position);
            }
            else 
            {
                point = new flash.geom.Vector3D(0, size.x, 0);
                point = global.deltaTransformVector(point);
            }
            flare.utils.Vector3DUtils.mirror(point, flare.utils.Matrix3DUtils.getUp(global), point);
            this._14.identity();
            v = this._14.rawData;
            v[8] = (-point.x) / depth * zoom;
            v[9] = point.z / depth * zoom;
            v[10] = point.y / depth * zoom;
            try 
            {
                this._14.rawData = v;
            }
            catch (e:Error)
            {
                return;
            }
            this._14.appendRotation(-90, flash.geom.Vector3D.X_AXIS);
            this._14.append(global);
            this._14.prependTranslation(0, 0, (-depth) / zoom);
            this._14.prependScale(1, 1 / meshRatio * textureRatio, 1);
            this._26.world.rawData = this._14.rawData;
            flare.materials.FlatColorMaterial(this._20).fillColor = this.shadowColor;
            prev = flare.system.Device3D.renderMaterial;
            flare.system.Device3D.renderMaterial = this._20;
            visible = false;
            dispatchEvent(this._8);
            if (this.backColor == 0) 
            {
                this.bitmapData.fillRect(this.bitmapData.rect, 0);
            }
            this.scene.renderToBitmapData(this._26, this.bitmapData, this.backColor, this._23);
            dispatchEvent(this._11);
            visible = true;
            if (this.blur > 0) 
            {
                this._32.blurY = loc2 = this.blur;
                this._32.blurX = loc2;
                this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, this._38, this._32);
            }
            if (this.alpha < 1) 
            {
                this._35.alphaMultiplier = this.alpha;
                this.bitmapData.colorTransform(this.bitmapData.rect, this._35);
            }
            flare.system.Device3D.renderMaterial = prev;
            return;
        }

        internal function _47(arg1:Number=10, arg2:Number=10, arg3:int=1, arg4:flare.materials.Material3D=null):void
        {
            var loc1:*=NaN;
            var loc2:*=NaN;
            var loc9:*=null;
            var loc10:*=null;
            var loc11:*=null;
            var loc12:*=null;
            var loc3:*=arg1 / 2;
            var loc4:*=arg2 / 2;
            var loc5:*=arg1 / arg3;
            var loc6:*=arg2 / arg3;
            var loc7:*=arg3 + 1;
            var loc8:*=1 / arg3;
            loc2 = 0;
            while (loc2 < loc7) 
            {
                loc1 = 0;
                while (loc1 < loc7) 
                {
                    addVertex(new flare.core.Vertex3D(loc1 * loc5 - loc3, 0, loc2 * (-loc6) + loc4));
                    ++loc1;
                }
                ++loc2;
            }
            loc2 = 0;
            while (loc2 < arg3) 
            {
                loc1 = 0;
                while (loc1 < arg3) 
                {
                    loc9 = vertex[loc2 * loc7 + loc1];
                    loc10 = vertex[loc2 * loc7 + (loc1 + 1)];
                    loc11 = vertex[(loc2 + 1) * loc7 + loc1];
                    (loc12 = new flare.core.Poly3D(loc9, loc10, loc11, arg4)).uvA0 = new flare.core.UV3D(loc1 * loc8, loc2 * loc8);
                    loc12.uvA1 = new flare.core.UV3D((loc1 + 1) * loc8, loc2 * loc8);
                    loc12.uvA2 = new flare.core.UV3D(loc1 * loc8, (loc2 + 1) * loc8);
                    addPoly(loc12);
                    loc9 = vertex[loc2 * loc7 + (loc1 + 1)];
                    loc10 = vertex[(loc2 + 1) * loc7 + (loc1 + 1)];
                    loc11 = vertex[(loc2 + 1) * loc7 + loc1];
                    (loc12 = new flare.core.Poly3D(loc9, loc10, loc11, arg4)).uvA0 = new flare.core.UV3D((loc1 + 1) * loc8, loc2 * loc8);
                    loc12.uvA1 = new flare.core.UV3D((loc1 + 1) * loc8, (loc2 + 1) * loc8);
                    loc12.uvA2 = new flare.core.UV3D(loc1 * loc8, (loc2 + 1) * loc8);
                    addPoly(loc12);
                    ++loc1;
                }
                ++loc2;
            }
            updateBoundings();
            return;
        }

        public function render():void
        {
            this._44(null);
            return;
        }

        public override function dispose():void
        {
            flare.system.Device3D.removeEventListener("render", this._44);
            super.dispose();
            return;
        }

        public function get autoUpdate():Boolean
        {
            return this._29;
        }

        public function set autoUpdate(arg1:Boolean):void
        {
            if (arg1) 
            {
                flare.system.Device3D.addEventListener("render", this._44);
            }
            else 
            {
                flare.system.Device3D.removeEventListener("render", this._44);
            }
            this._29 = arg1;
            return;
        }

        public static const POSTRENDER_EVENT:String="postRender";

        public static const RENDER_EVENT:String="render";

        internal var _14:flash.geom.Matrix3D;

        internal var _17:flare.core.Texture3D;

        internal var _8:flash.events.Event;

        internal var _35:flash.geom.ColorTransform;

        public var light:flare.core.Light3D;

        internal var _38:flash.geom.Point;

        internal var _20:flare.materials.Material;

        public var alpha:Number=1;

        internal var _23:flash.geom.Matrix;

        internal var _26:flare.core.Camera3D;

        internal var _29:Boolean=true;

        public var blur:Number=2;

        public var shadowColor:uint=0;

        internal var _32:flash.filters.BlurFilter;

        internal var _41:flash.geom.Matrix3D;

        public var bitmapData:flash.display.BitmapData;

        public var backColor:uint=4294967295;

        internal var _11:flash.events.Event;
    }
}



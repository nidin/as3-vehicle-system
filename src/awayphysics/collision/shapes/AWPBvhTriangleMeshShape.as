package awayphysics.collision.shapes {
	import AWPC_Run.*;
	
	import away3d.core.base.*;
	
	public class AWPBvhTriangleMeshShape extends AWPCollisionShape {
		private var indexDataPtr : uint;
		private var vertexDataPtr : uint;
		
		private var _geometry:Geometry;
		
		/**
		 *create a static triangle mesh shape with a 3D mesh object
		 */
		public function AWPBvhTriangleMeshShape(geometry : Geometry, useQuantizedAabbCompression : Boolean = true) {
			_geometry = geometry;
			var indexData : Vector.<uint> = geometry.subGeometries[0].indexData;
			var indexDataLen : int = indexData.length;
			indexDataPtr = createTriangleIndexDataBufferInC(indexDataLen);
			
			for (var i : int = 0; i < indexDataLen; i++ ) {
				CModule.write32(indexDataPtr+i*4,indexData[i]);
			}
			
			var vertexData : Vector.<Number> = geometry.subGeometries[0].vertexData;
			var vertexDataLen : int = vertexData.length/13;
			vertexDataPtr = createTriangleVertexDataBufferInC(vertexDataLen*3);
			
			for (i = 0; i < vertexDataLen; i++ ) {
				CModule.writeFloat(vertexDataPtr+i*12,vertexData[i*13] / _scaling);
				CModule.writeFloat(vertexDataPtr+i*12 + 4,vertexData[i*13+1] / _scaling);
				CModule.writeFloat(vertexDataPtr+i*12 + 8,vertexData[i*13+2] / _scaling);
			}
			
			var triangleIndexVertexArrayPtr : uint = createTriangleIndexVertexArrayInC(int(indexDataLen / 3), indexDataPtr, int(vertexDataLen), vertexDataPtr);
			
			pointer = createBvhTriangleMeshShapeInC(triangleIndexVertexArrayPtr, useQuantizedAabbCompression ? 1 : 0, 1);
			super(pointer, 9);
		}
		
		override public function dispose() : void {
			m_counter--;
			if (m_counter > 0) {
				return;
			}else {
				m_counter = 0;
			}
			if (!_cleanup) {
				_cleanup  = true;
				removeTriangleIndexDataBufferInC(indexDataPtr);
				removeTriangleVertexDataBufferInC(vertexDataPtr);
				disposeCollisionShapeInC(pointer);
			}
		}
		
		public function get geometry():Geometry {
			return _geometry;
		}
	}
}
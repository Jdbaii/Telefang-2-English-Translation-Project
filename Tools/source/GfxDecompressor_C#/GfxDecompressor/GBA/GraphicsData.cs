using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GfxDecompressor.GBA
{
    public class GraphicsData : IComparable<GraphicsData>
    {
        public int Offset
        {
            get;
            set;
        }
        public int PaletteOffset
        {
            get;
            set;
        }
        public bool Compressed
        {
            get;
            set;
        }
        public bool PaletteCompressed
        {
            get;
            set;
        }

        #region IComparable<GraphicsData> Members

        public int CompareTo(GraphicsData other)
        {
            return this.Offset - other.Offset;
        }

        #endregion
    }
}

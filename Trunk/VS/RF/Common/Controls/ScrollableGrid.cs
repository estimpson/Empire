using System;
using System.Reflection;
using System.Windows.Forms;

namespace Controls
{
    public class ScrollableGrid : DataGrid, IScrollableGrid
    {
        /// <summary>
        /// Scrolls datagrid to the row.
        /// </summary>
        /// <param name="rowNumber">The row num.</param>
        public void ScrollToRow(Int32 rowNumber)
        {
            FieldInfo fi = this.GetType().GetField("m_sbVert",
                                                   BindingFlags.NonPublic | BindingFlags.GetField |
                                                   BindingFlags.Instance);
            ((VScrollBar) fi.GetValue(this)).Value = rowNumber;
        }
    }
}

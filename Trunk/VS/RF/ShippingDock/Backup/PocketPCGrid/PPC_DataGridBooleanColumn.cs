using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Reflection;

namespace PocketPCGrid
{
    public delegate void CheckedEventHandler(object sender, DataGridEnableEventArgs e);

    public class PPC_DataGridBooleanColumn : DataGridTextBoxColumn
    {
        public event CheckedEventHandler IsChecked;
        private int _col;

        public PPC_DataGridBooleanColumn(int column)
        {
            _col = column;
        }

        protected override void Paint(Graphics g, Rectangle Bounds, CurrencyManager Source, int RowNum, Brush BackBrush, Brush ForeBrush, bool AlignToRight)
        {
            if (IsChecked != null)
            {
                //  White backround.
                g.FillRectangle(BackBrush, Bounds);

                //  Show check box if true.
                Boolean Enabled = true;
                DataGridEnableEventArgs e = new DataGridEnableEventArgs(RowNum, _col, Enabled);
                IsChecked(this, e);
                if (e.MeetsCriteria)
                {
                    try
                    {
                        Image imgCheckBox = new Bitmap(Assembly.GetExecutingAssembly().GetManifestResourceStream("PocketPCGrid.CheckBox.GIF"));
                        g.DrawImage(imgCheckBox, Bounds.X + (Bounds.Width - imgCheckBox.Width) / 2, Bounds.Y);
                    }
                    catch (Exception)
                    {}
                }
            }
        }
    }
}

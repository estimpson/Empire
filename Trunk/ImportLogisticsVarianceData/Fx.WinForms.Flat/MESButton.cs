#region Using

using System;
using System.Windows.Forms;

#endregion

namespace Fx.WinForms.Flat
{
    public partial class MESButton : Button
    {
        public MESButton()
        {
            InitializeComponent();

            EnabledChanged += OnEnabledChanged;
        }

        private void OnEnabledChanged(object sender, EventArgs eventArgs)
        {
            // Handle the changing of the background color.
            //ForeColor = Enabled
            //    ? Color.FromArgb(240, 240, 240)
            //    : Color.FromArgb(101, 101, 101);
            //BackColor = Enabled
            //    ? Color.FromArgb(37, 37, 38)
            //    : Color.FromArgb(19, 19, 19);
        }
    }
}
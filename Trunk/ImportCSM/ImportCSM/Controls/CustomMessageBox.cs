using System;
using System.Drawing;
using System.Windows.Forms;

namespace ImportCSM.Controls
{
    public partial class CustomMessageBox : Form
    {
        #region Properties

        private string _message;
        public string Message
        {
            get { return _message; }
            set{ _message = tbxMessage.Text = value; }
        }

        #endregion


        #region Constructor, Activated

        public CustomMessageBox()
        {
            InitializeComponent();
        }

        private void CustomMessageBox_Activated(object sender, EventArgs e)
        {
            btnOk.Focus();
        }

        #endregion


        #region Panel Events

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            int thickness = 1;
            int halfThickness = thickness / 2;
            using (var p = new Pen(Color.White, thickness))
            {
                e.Graphics.DrawRectangle(p, new Rectangle(halfThickness,
                                                          halfThickness,
                                                          panel1.ClientSize.Width - thickness,
                                                          panel1.ClientSize.Height - thickness));
            }
        }

        #endregion


        #region Button Events

        private void btnOk_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion


    }
}

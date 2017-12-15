using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace ImportLogisticsVarianceData.Controls
{
    public partial class CustomMessageBox : Form
    {
        #region Properties

        private string _message;
        public string Message
        {
            get { return _message; }
            set { _message = tbxMessage.Text = value; }
        }

        #endregion


        #region Constructor, Activated

        public CustomMessageBox()
        {
            InitializeComponent();
        }

        private void CustomMessageBox_Activated(object sender, EventArgs e)
        {
            mesBtnOk.Focus();
        }

        #endregion


        #region Button Events

        private void mesBtnOk_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion


    }
}

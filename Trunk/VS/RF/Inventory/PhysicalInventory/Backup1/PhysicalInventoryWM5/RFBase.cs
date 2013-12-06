using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using SymbolRFGun;

namespace ShippingDock
{
    public partial class formRFBase : Form
    {
        private SymbolRFGun.SymbolRFGun MyRFGun = null;

        public formRFBase()
        {
            InitializeComponent();
        }

        private void menuItemClose_Click(object sender, EventArgs e)
        {
            MyRFGun.Close();
            this.Close();
        }

        private void menuItemView_Click(object sender, EventArgs e)
        {

        }

        private void frmRFBase_Load(object sender, EventArgs e)
        {
            try
            {
                MyRFGun = new SymbolRFGun.SymbolRFGun();
                MyRFGun.RFScan += new RFScanEventHandler(MyRFGun_RFScan);
            }
            catch (SymbolRFGunException ex)
            {
                MessageBox.Show (ex.Message);
                this.Close();
            }
        }

        void MyRFGun_RFScan(object sender, RFScanEventArgs e)
        {
            MessageBox.Show(e.Text);
        }
    }
}
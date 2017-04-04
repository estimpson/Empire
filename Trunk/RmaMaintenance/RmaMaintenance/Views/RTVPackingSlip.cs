#region Using

using System;
using System.Linq;
using System.Windows.Forms;
using RmaMaintenance.Model;

#endregion

namespace RmaMaintenance.Views
{
    public partial class RTVPackingSlip : Form
    {
        public Int32 RTVShipperID { get; set; }

        public RTVPackingSlip()
        {
            InitializeComponent();
        }

        private void RTVPackingSlip_Load(object sender, EventArgs e)
        {
            using (var context = new MONITOREntities())
            {
                var PackingSlip = context.RTV_PackingSlip.Where(rtv => rtv.RTVShipperID == RTVShipperID).ToList();
                createRmaRTVPackingSlipBindingSource.DataSource = PackingSlip;
            }
            reportViewer1.RefreshReport();
        }
    }
}
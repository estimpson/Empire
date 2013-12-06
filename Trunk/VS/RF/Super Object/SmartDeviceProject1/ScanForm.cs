using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using SymbolRFGun;

namespace SmartDeviceProject1
{
    public partial class Form1 : Form
    {
            
#region Initialize
        private SymbolRFGun.SymbolRFGun MyRFGun = null;
        private int ScanCount = 0;

        #endregion

#region ScanForm
        private void ScanForm()
        {
            InitializeComponent();
        }

        private void ScanForm_Load(object sender, EventArgs e)
        {
            MyRFGun = new SymbolRFGun.SymbolRFGun();
            MyRFGun.RFScan += new RFScanEventHandler(MyRFGun_RFScan);
        }
#endregion

#region Scan Data
        void MyRFGun_RFScan(object sender, RFScanEventArgs e)
        {
            try
            {
                ScanData scanData = e.Text;
                switch (scanData.ScanDataType)
                {
                    case eScanDataType.Serial:
                        EnterSerial(scanData.DataValue);
                        break;

                    case eScanDataType.Undef:
                        Exception ex0 = new Exception("Unknown data identifier.");
                        throw ex0;

                    case eScanDataType.Shipper:
                        Exception ex1 = new Exception("Not a serial number");
                        throw ex1;

                    case eScanDataType.PO:
                        Exception ex2 = new Exception("Not a serial number");
                        throw ex2;

                    case eScanDataType.Part:
                        Exception ex3 = new Exception("Not a serial number");
                        throw ex3;
                        
                    case eScanDataType.Quantity:
                        Exception ex4 = new Exception("Not a serial number");
                        throw ex4;
                    
                    case eScanDataType.TwoDBarcode:
                        Exception ex5 = new Exception("Not a serial number");
                        throw ex5;
                }
            }
            catch (Exception ex)
            {
                uxMessage.Text = ex.Message;
                MyRFGun.BadReadNotification();
            }
        }
        #endregion

#region Serial
        private void EnterSerial(String sSer)
        {
            foreach (string item in uxListBox1.Items)
            {
                if (sSer == item)
                {
                    uxMessage.Text = "Serial # Already Scanned, Please Scan Another.";
                    MyRFGun.BadReadNotification();
                }
                else
                {
                    SerialEntered(sSer);
                    MyRFGun.GoodReadNotification();
                }
            }
        }

        private void SerialEntered(string sSer)
        {
          uxListBox1.Items.Add(sSer.TrimStart('0'));
          ScanCount += 1;
          uxCount.Text = ScanCount.ToString();
        }
        #endregion

        private void button2_Click_1(object sender, EventArgs e)
        {
            
        }

        private void button1_Click_1(object sender, EventArgs e)
        {

        }

        private void uxCount_ParentChanged(object sender, EventArgs e)
        {

        }

        private void label1_ParentChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void uxMessage_ParentChanged(object sender, EventArgs e)
        {

        }

      
        private void uxListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label2_ParentChanged(object sender, EventArgs e)
        {

        }

    }
}
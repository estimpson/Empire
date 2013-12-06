using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using SymbolRFGun;
using System.IO; //For Test file

namespace LabelVerify
{
    public partial class ScanForm : Form
    {
#region Initialize
        private SymbolRFGun.SymbolRFGun MyRFGun = null;
        // private String Operator = null;
        // private String SID = null;
        // private Int32? PO = null;
        private String wPart = null;
        private String yPart = null;
        private String wQty = null;
        private String yQty = null;
        private int ScanCount = 0;
        // private String Lot = null;
        // private String PrintServer = "LEAFS";
        #endregion

#region ScanForm
        public ScanForm()
        {
            InitializeComponent();
        }

        private void ScanForm_Load(object sender, EventArgs e)
        {
            MyRFGun = new SymbolRFGun.SymbolRFGun();
            MyRFGun.RFScan += new RFScanEventHandler(MyRFGun_RFScan);
            RefreshScreenState();
        }
#endregion

#region Scan Data
        void MyRFGun_RFScan(object sender, RFScanEventArgs e)
        {
            //exception =new exception
            try
            {
                ScanData scanData = e.Text;
                switch (scanData.ScanDataType)
                {
                    //case eScanDataType.Shipper:
                    //    Exception ex0 = new Exception("Not a part number or quantity");
                    //    throw ex0;
                    //    break;
                    //case eScanDataType.PO:
                    //    Exception ex1 = new Exception("Not a part number or quantity");
                    //    throw ex1;
                    //    break;
                    case eScanDataType.Part:
                        EnterPart(scanData.DataValue);
                        break;
                    case eScanDataType.Quantity:
                        EnterQty(scanData.DataValue);
                        break;
                    //case eScanDataType.Serial:
                    //    Exception ex2 = new Exception("Not a part number or quantity");
                    //    throw ex2;
                    //    break;
                   
                    
                    case eScanDataType.TwoDBarcode:
                        //EnterQty();
                        //ModScan = scanData.DataValue.Replace("\31" , "*");
                        MessageBox.Show("2d");
                        MyRFGun.GoodReadNotification();
                        string[] words = scanData.DataValue.Split((char)31);
                        foreach (string word in words)
                        {
                            //MessageBox.show(word);
                            MessageBox.Show(word);
                        }
                                
                        break;


                    case eScanDataType.Undef:
                        Exception ex3 = new Exception("Unknown data identifier.");
                        throw ex3;
                }
            }
 
            catch (Exception ex)
            {
                uxMessage.Text = ex.Message;
            }
        }
     #endregion

#region Part
        private void uxWhitePart_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxWhitePartEnter.Focus();
                e.Handled = false;
            }
        }

        private void uxYellowPart_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxYellowPartEnter.Focus();
                e.Handled = false;
            }
        }

        private void uxWhitePart_GotFocus(object sender, EventArgs e)
        {
            uxWhitePartEnter.Visible = (uxWhitePartEnter.Text == "Clear");
            uxWhiteQtyEnter.Visible = (uxWhiteQtyEnter.Text == "Clear");
            uxYellowPartEnter.Visible = (uxYellowPartEnter.Text == "Clear");
            uxYellowQtyEnter.Visible = (uxYellowQtyEnter.Text == "Clear");
            uxWhitePartEnter.Visible = true;
        }

        private void uxWhitePartEnter_Click(object sender, EventArgs e)
        {
            //MessageBox.Show(uxWhitePart.Text);

            switch (uxWhitePartEnter.Text)
            {
                case "Enter":
                    EnterPart(uxWhitePart.Text);
                    break;
                case "Clear":
                    ClearWhitePart();
                    break;
            }
        }

        private void EnterPart(String sPart)
        {
            //Need to see if white is scanned & determine what field to populate
            //Decimal? NextDueAmount = null;
            //DateTime? NextDueDate = null;
            //Int32? iResult = null;
            //PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            //taPODetails.ValidatePOPartQty(PO, sPart, Qty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);
            if (uxWhitePart.Text  == "")
                WhitePartEntered(sPart);
            else
                YellowPartEntered(sPart);
        }

        private void WhitePartEntered(String sPart)
        {
            wPart = sPart.Trim();
            uxWhitePartEnter.Text = "Clear";
            uxWhitePart.Text = wPart;
            uxWhitePart.Enabled = false;
            MyRFGun.GoodReadNotification();
            uxWhitePart.Refresh();
        }
        
        private void YellowPartEntered(String sPart)
        {
            if (uxWhiteQty.Text != "")
            {
                yPart = sPart.Trim();
                uxYellowPartEnter.Text = "Clear";
                uxYellowPart.Text = yPart;
                uxYellowPart.Enabled = false;
                MyRFGun.GoodReadNotification();
            }
            else
            {
                uxMessage.Text = "Please Scan White Qty First";
                MyRFGun.FailNotification();
            }

            //Need to compare the yellow and the White part #
        }

        private void ClearWhitePart()
        {
            wPart = "";
            uxWhitePartEnter.Text = "Enter";
            uxWhitePart.Text = wPart;
            uxWhitePart.Enabled = true;
        }

        private void ClearYellowPart()
        {
            yPart = "";
            uxYellowPartEnter.Text = "Enter";
            uxYellowPart.Text = yPart;
            uxYellowPart.Enabled = true;
        }

        private void uxYellowPartEnter_Click(object sender, EventArgs e)
        {
            switch (uxYellowPartEnter.Text)
            {
                case "Enter":
                    EnterPart(uxYellowPart.Text);
                    break;
                case "Clear":
                    ClearYellowPart();
                    break;
            }
        }

         #endregion

#region Qty
        private void EnterQty(String sQty)
        {
            //string sQty = Convert.ToDecimal(sQty);
            Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            //PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            //taPODetails.ValidatePOPartQty(PO, Part, decQty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);
            
            if (uxWhiteQty.Text == "")
                WhiteQtyEntered(sQty);
            else
                YellowQtyEntered(sQty);
            //QtyEnteredWhite(sQty);
        }

        private void WhiteQtyEntered(string sQty)
        {
            if(uxWhitePart.Text!="")
            {
            wQty = sQty.Trim();
            uxWhiteQtyEnter.Text = "Clear";
            //a=a.TrimStart('0')
            uxWhiteQty.Text = sQty.TrimStart('0');
            uxWhiteQty.Enabled = false;
            MyRFGun.GoodReadNotification();
            }
            else
            {
                uxMessage.Text = "Please Scan White Part # First";
                MyRFGun.FailNotification();
            }
        }

        private void YellowQtyEntered(string sQty)
        {
           if(uxYellowPart.Text!="")
            {
            yQty = sQty.Trim();
            uxYellowQtyEnter.Text = "Clear";
            uxYellowQty.Text = sQty.TrimStart('0');
            uxYellowQty.Enabled = false;
            //Check values to see if they are the same
            VerifyLabels();
            }
             else
            {
            uxMessage.Text = "Please Scan Yellow Part # First";
            MyRFGun.FailNotification();
            }
        }

        private void uxWhiteQtyEnter_Click(object sender, EventArgs e)
        {
            switch (uxWhiteQtyEnter.Text)
            {
                case "Enter":
                    WhiteQtyEntered(uxWhitePart.Text);
                    break;
                case "Clear":
                    ClearWhitePart();
                    break;
             }
        }

        private void uxYellowQtyEnter_Click(object sender, EventArgs e)
        {
            switch (uxYellowQtyEnter.Text)
            {
                case "Enter":
                    YellowQtyEntered(uxWhitePart.Text);
                    break;
                case "Clear":
                    ClearYellowPart();
                    break;
            }
        }

        #endregion

#region Refresh
        private void RefreshScreenState()
        {
            if (wPart == "")
            {
                uxMessage.Text = "Scan or enter White Label Part.";
                uxWhitePart.Focus();
                return;
            }
            if (wQty == "")
            {
                uxMessage.Text = "Scan or enter White Label Qty.";
                uxWhiteQty.Focus();
                return;
            }
            if (yPart == "")
            {
                uxMessage.Text = "Scan or enter Yellow Label Part.";
                uxYellowPart.Focus();
                return;
            }
            if (yQty == "")
            {
                uxMessage.Text = "Scan or enter Yellow Label Qty.";
                uxYellowQty.Focus();
                return;
            }

            uxMessage.Text = "Press button to verify labels.";
            uxReset.Text = "Verify Labels";


            uxMessage.Text = "Press button to receive box and print label.";
            //uxReceive.Text = "Receive Box";
        }
        #endregion

#region Reset
        private void uxReset_Click(object sender, EventArgs e)
        {
            switch (uxReset.Text)
            {
                case "Reset Counter":
                    ScanCount=0;
                    lblScanCount.Text = "Scan Count:0";
                    break;
                case "Verify Labels":
                    VerifyLabels();
                    break;
                default:
                    Exception ex = new Exception("Invalid button text for Button.");
                    throw ex;
            }
        }

        private void ResetForm()
        {
            uxWhitePart.Text = "";
            uxWhiteQty.Text = "";
            uxYellowPart.Text = "";
            uxYellowQty.Text = "";
        }

#endregion
        private void VerifyLabels()
        {
            if ((uxYellowPart.Text== uxWhitePart.Text) && uxWhiteQty.Text == uxYellowQty.Text)
            {
                ScanCount += 1;
                MyRFGun.ApproveNotification();
                lblScanCount.Text = "Scan Count: " + ScanCount;
                ResetForm();
            }
            else
            {
                MyRFGun.BadReadNotification();
                MessageBox.Show("Labels do not match \r\n White Part:" + uxWhitePart.Text + "\r\n Yellow Part:" + uxYellowPart.Text + "\r\n White Qty:" + uxWhiteQty.Text + "\r\n Yellow Qty:" + uxYellowQty.Text);
                StreamWriter sw = File.AppendText("\\Application Data\\LV.txt");
                sw.WriteLine("Labels do not match \r\n White Part:" + uxWhitePart.Text + "\r\n Yellow Part:" + uxYellowPart.Text + "\r\n White Qty:" + uxWhiteQty.Text + "\r\n Yellow Qty:" + uxYellowQty.Text + "\r\n");
                sw.WriteLine("=================== \r\n");
                ResetForm();
                sw.Close();
            }
        }

        private void uxYellowQty_TextChanged(object sender, EventArgs e)
        {

        }

        private void lblScanCount_ParentChanged(object sender, EventArgs e)
        {

        }
    }
}
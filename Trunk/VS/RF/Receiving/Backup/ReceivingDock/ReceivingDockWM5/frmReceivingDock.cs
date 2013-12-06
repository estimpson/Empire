using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using CommonData;
using CommonData.dsCommonTableAdapters;
using ReceivingDockData;
using ReceivingDockData.dsReceivingDockTableAdapters;
using System.Data.SqlClient;
using SymbolRFGun;
using System.IO;

namespace ReceivingDockWM5
{
    public partial class frmReceivingDock : Form
    {
        #region Class Initialization
        // 03-29-2010 1.01 Added ability to lock lot Number and changed error log to create CSV file
#if PocketPC
        private SymbolRFGun.SymbolRFGun MyRFGun = null;
#endif
        private String Operator = null;
        private String SID = null;
        private Int32? PO = null;
        private String Part = null;
        private Decimal? Qty = null;
        private String Lot = null;
        private String PrintServer = "LEAFS";


        public frmReceivingDock()
        {
            InitializeComponent();
        }

        private void frmReceivingDock_Load(object sender, EventArgs e)
        {
            RefreshScreenState();
        }
        #endregion

        #region Operator
        private void uxPWD_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxConfirmPWD.Focus();
                e.Handled = false;
            }
        }

        private void uxConfirmPWD_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxConfirmPWD.Text)
                {
                    case "Confirm":
                        Login(uxPWD.Text);
                        break;
                    case "Log Off":
                        LogOff();
                        break;
                    default:
                        throw new Exception("Invalid button text for login control.");
                }
            }
            catch (Exception ex)
            {
                uxMessage.Text = ex.Message;
            }
        }

        private void Login(string sPassword)
        {
            EEHEmployeeTableAdapter taEmployee = new EEHEmployeeTableAdapter();
            dsCommon.EEHEmployeeDataTable dtEmployees = taEmployee.GetOperatorCodeByPassword(sPassword);
            string sOperatorCode;
            switch (dtEmployees.Rows.Count)
            {
                case 1:
                    sOperatorCode = dtEmployees[0].OperatorCode;
                    OperatorConfirmed(sOperatorCode);
#if PocketPC
                    MyRFGun = new SymbolRFGun.SymbolRFGun();
                    MyRFGun.RFScan += new RFScanEventHandler(MyRFGun_RFScan);
#endif
                    break;
                case 0:
                    uxPWD.Text = "";
                    uxPWD.Focus();
                    throw new Exception("Invalid password.");
                default:
                    uxPWD.Focus();
                    throw new Exception("Unknown error validating password.");
            }
            RefreshScreenState();
        }

        private void OperatorConfirmed(string sOperator)
        {
            Operator = sOperator;
            uxConfirmPWD.Text = "Log Off";
            uxPWD.Visible = false;
            uxPWD.Text = "";
            uxPWD.Enabled = false;
            uxOperator.Text = sOperator;
            uxOperator.Visible = true;
            panelStdReceiving.Enabled = true;
        }

        private void LogOff()
        {
            Operator = null;
            uxConfirmPWD.Text = "Confirm";
            uxOperator.Visible = false;
            uxPWD.Visible = true;
            uxPWD.Enabled = true;
            uxPWD.Focus();
            uxOperator.Text = "";
            panelStdReceiving.Enabled = false;
            RefreshScreenState();

#if PocketPC
            if (MyRFGun != null) MyRFGun.Close();
#endif
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
                    case eScanDataType.Shipper:
                        EnterSID(scanData.DataValue);
                        break;
                    case eScanDataType.PO:
                        EnterPO(scanData.DataValue);
                        break;
                    case eScanDataType.Part:
                        EnterPart(scanData.DataValue);
                        break;
                    case eScanDataType.Quantity:
                        EnterQty(scanData.DataValue);
                        break;
                    case eScanDataType.Serial:
                        EnterLot(scanData.DataValue);
                        if (SID != null && PO != null && Part != null && Qty != null && Lot != null) ReceiveBox();
                        break;
                    case eScanDataType.Undef:
                        Exception ex = new Exception("Unknown data identifier.");
                        throw ex;
                }
            }
            catch (SqlException ex)
            {
                uxMessage.Text = ex.Message;
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                sw.Close();
                
            }
            catch (Exception ex)
            {
                uxMessage.Text = ex.Message;
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
               // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                sw.Close();
            }
        }
        #endregion

        #region SID
        private void uxSID_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxEnterSID.Focus();
                e.Handled = false;
            }
        }

        private void uxSID_GotFocus(object sender, EventArgs e)
        {
            uxEnterSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterPO.Visible = (uxEnterPO.Text == "Clear");
            uxEnterPart.Visible = (uxEnterPart.Text == "Clear");
            uxEnterQty.Visible = (uxEnterQty.Text == "Clear");
            uxEnterLot.Visible = (uxEnterLot.Text == "Clear");
            uxStoreSID.Visible = true;
            uxEnterSID.Visible = true;
        }

        private void uxEnterSID_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxEnterSID.Text)
                {
                    case "Enter":
                        if (uxStoreSID.Checked == false)
                        {
                            if (MessageBox.Show("Store shipper number?", "Receiving Dock", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) == DialogResult.Yes)
                            {
                                uxStoreSID.Checked = true;
                            }
                        }
                        EnterSID(uxSID.Text);
                        break;
                    case "Clear":
                        uxStoreSID.Checked = false;
                        ClearSID();
                        break;
                    default:
                        Exception ex = new Exception("Invalid button text for SID control.");
                        throw ex;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                sw.Close();
                ClearSID();
            }
            RefreshScreenState();
        }

        private void EnterSID(String sSID)
        {
            MyRFGun.GoodReadNotification();
            SIDEntered(sSID);
        }

        private void SIDEntered(String sSID)
        {
            SID = sSID;
            uxEnterSID.Text = "Clear";
            uxSID.Text = SID;
            uxSID.Enabled = false;
        }

        private void ClearSID()
        {
            SID = null;
            uxEnterSID.Text = "Enter";
            uxSID.Text = SID;
            uxSID.Enabled = true;
        }
        #endregion

        #region PO
        private void uxPO_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxEnterPO.Focus();
                e.Handled = false;
            }
        }

        private void uxPO_GotFocus(object sender, EventArgs e)
        {
            uxStoreSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterPO.Visible = (uxEnterPO.Text == "Clear");
            uxEnterPart.Visible = (uxEnterPart.Text == "Clear");
            uxEnterQty.Visible = (uxEnterQty.Text == "Clear");
            uxEnterLot.Visible = (uxEnterLot.Text == "Clear");
            uxEnterPO.Visible = true;
        }

        private void uxEnterPO_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxEnterPO.Text)
                {
                    case "Enter":
                        EnterPO(uxPO.Text);
                        break;
                    case "Clear":
                        ClearPO();
                        break;
                    default:
                        Exception ex = new Exception("Invalid button text for PO control.");
                        throw ex;
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                sw.Close();
                ClearPO();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                sw.Close();
                ClearPO();
            }
            RefreshScreenState();
        }

        private void EnterPO(string sPO)
        {
            Int32 iPO = Convert.ToInt32(sPO);
            Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ValidatePOPartQty(iPO, Part, Qty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);
            MyRFGun.GoodReadNotification();
            POEntered(iPO);
        }

        private void POEntered(Int32 iPO)
        {
            PO = iPO;
            uxEnterPO.Text = "Clear";
            uxPO.Text = PO.ToString();
            uxPO.Enabled = false;
        }

        private void ClearPO()
        {
            PO = null;
            uxEnterPO.Text = "Enter";
            uxPO.Text = PO.ToString();
            uxPO.Enabled = true;
        }
        #endregion

        #region Part
        private void uxPart_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxEnterPart.Focus();
                e.Handled = false;
            }
        }

        private void uxPart_GotFocus(object sender, EventArgs e)
        {
            uxStoreSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterPO.Visible = (uxEnterPO.Text == "Clear");
            uxEnterPart.Visible = (uxEnterPart.Text == "Clear");
            uxEnterQty.Visible = (uxEnterQty.Text == "Clear");
            uxEnterLot.Visible = (uxEnterLot.Text == "Clear");
            uxEnterPart.Visible = true;
        }

        private void uxEnterPart_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxEnterPart.Text)
                {
                    case "Enter":
                        EnterPart(uxPart.Text);
                        break;
                    case "Clear":
                        ClearPart();
                        break;
                    default:
                        Exception ex = new Exception("Invalid button text for part control.");
                        throw ex;
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                sw.Close();
                ClearPart();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                sw.Close();
                ClearPart();
            }
            RefreshScreenState();
        }

        private void EnterPart(String sPart)
        {
            Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ValidatePOPartQty(PO, sPart, Qty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);
            MyRFGun.GoodReadNotification();
            PartEntered(sPart);
        }

        private void PartEntered(String sPart)
        {
            Part = sPart;
            uxEnterPart.Text = "Clear";
            uxPart.Text = Part;
            uxPart.Enabled = false;
        }

        private void ClearPart()
        {
            Part = null;
            uxEnterPart.Text = "Enter";
            uxPart.Text = Part;
            uxPart.Enabled = true;
        }
        #endregion

        #region Qty
        private void uxQty_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxEnterQty.Focus();
                e.Handled = false;
            }
        }

        private void uxQty_GotFocus(object sender, EventArgs e)
        {
            uxStoreSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterPO.Visible = (uxEnterPO.Text == "Clear");
            uxEnterPart.Visible = (uxEnterPart.Text == "Clear");
            uxEnterQty.Visible = (uxEnterQty.Text == "Clear");
            uxEnterLot.Visible = (uxEnterLot.Text == "Clear");
            uxEnterQty.Visible = true;
        }

        private void uxEnterQty_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxEnterQty.Text)
                {
                    case "Enter":
                        EnterQty(uxQty.Text);
                        break;
                    case "Clear":
                        ClearQty();
                        break;
                    default:
                        Exception ex = new Exception("Invalid button text for qty control.");
                        throw ex;
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                sw.Close();
                ClearQty();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                sw.Close();
                ClearQty();
            }
            RefreshScreenState();
        }

        private void EnterQty(String sQty)
        {
            Decimal decQty = Convert.ToDecimal(sQty);
            Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ValidatePOPartQty(PO, Part, decQty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);
            MyRFGun.GoodReadNotification();
            QtyEntered(decQty);
        }

        private void QtyEntered(Decimal decQty)
        {
            Qty = decQty;
            uxEnterQty.Text = "Clear";
            uxQty.Text = Qty.ToString();
            uxQty.Enabled = false;
        }

        private void ClearQty()
        {
            Qty = null;
            uxEnterQty.Text = "Enter";
            uxQty.Text = Qty.ToString();
            uxQty.Enabled = true;
        }
        #endregion

        #region Lot
        private void uxLot_KeyDown(object sender, KeyEventArgs e)
        {
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxEnterLot.Focus();
                e.Handled = false;
            }
        }

        private void uxLot_GotFocus(object sender, EventArgs e)
        {
            uxStoreSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterSID.Visible = (uxEnterSID.Text == "Clear");
            uxEnterPO.Visible = (uxEnterPO.Text == "Clear");
            uxEnterPart.Visible = (uxEnterPart.Text == "Clear");
            uxEnterQty.Visible = (uxEnterQty.Text == "Clear");
            uxEnterLot.Visible = (uxEnterLot.Text == "Clear");
            uxStoreLOT.Visible = true;
            uxEnterLot.Visible = true;
        }

        private void uxEnterLot_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxEnterLot.Text)
                {
                    case "Enter":

                        if (uxStoreLOT.Checked == false)
                        {
                            if (MessageBox.Show("Store lot number?", "Receiving Dock", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) == DialogResult.Yes)
                            {
                                uxStoreLOT.Checked = true;
                            }
                        }
                        EnterLot(uxLot.Text);
                        break;
                    
                    case "Clear":
                        uxStoreLOT.Checked = false;
                        ClearLot();
                        break;
                    default:
                        Exception ex = new Exception("Invalid button text for lot control.");
                        throw ex;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                //sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                //sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                sw.Close();
                ClearLot();
            }
            RefreshScreenState();
        }

        private void EnterLot(string sLot)
        {
            MyRFGun.GoodReadNotification();
            LotEntered(sLot);
        }

        private void LotEntered(String sLot)
        {
            Lot = sLot;
            uxEnterLot.Text = "Clear";
            uxLot.Text = Lot;
            uxLot.Enabled = false;
        }

        private void ClearLot()
        {
            Lot = null;
            uxEnterLot.Text = "Enter";
            uxLot.Text = Lot;
            uxLot.Enabled = true;
        }
        #endregion

        #region Receive
        private void uxReceive_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxReceive.Text)
                {
                    case "Receive Box":
                        ReceiveBox();
                        break;
                    case "Clear Fields":
                        if (!uxStoreSID.Checked) ClearSID();
                        ClearPO();
                        ClearPart();
                        ClearQty();
                        // ClearLot();
                        if (!uxStoreLOT.Checked) ClearLot();
                        break;
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
               
                sw.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                sw.Close();
            }
            RefreshScreenState();
        }

        private void ReceiveBox()
        {
            Int32? iSerial = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ReceiveItem(PO, Part, Operator, Qty, 1, SID, Lot, PrintServer, ref iSerial, ref iResult);
            SerialReceived(iSerial);
        }

        private void SerialReceived(Int32? iSerial)
        {
            uxMessage.Text = "Serial " + iSerial.ToString() + " generated.  Scan or enter next label to continue.";
            if (!uxStoreSID.Checked) ClearSID();
            ClearPO();
            ClearPart();
            ClearQty();
            ClearLot();
            if (!uxStoreSID.Checked) uxSID.Focus(); else uxPO.Focus();
            uxReceive.Text = "Clear Fields";
        }
        #endregion

        #region Close
        private void menuItemClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void frmReceivingDock_Closing(object sender, CancelEventArgs e)
        {
#if PocketPC
            if (MyRFGun != null) MyRFGun.Close();
#endif
        }
        #endregion

        #region Refresh
        private void RefreshScreenState()
        {
            uxReceive.Text = "Clear Fields";
            if (Operator == null)
            {
                uxMessage.Text = "Login.";
                return;
            }
            if (SID == null)
            {
                uxMessage.Text = "Scan or enter shipper number.";
                uxSID.Focus();
                return;
            }
            if (PO == null)
            {
                uxMessage.Text = "Scan or enter PO.";
                uxPO.Focus();
                return;
            }
            if (Part == null)
            {
                uxMessage.Text = "Scan or enter Part.";
                uxPart.Focus();
                return;
            }
            if (Qty == null)
            {
                uxMessage.Text = "Scan or enter Qty.";
                uxQty.Focus();
                return;
            }
            if (Lot == null)
            {
                uxMessage.Text = "Scan or enter Lot.";
                uxLot.Focus();
                return;
            }
            uxMessage.Text = "Press button to receive box and print label.";
            uxReceive.Text = "Receive Box";
        }
        #endregion

        #region Printer Selection
        private void menuItemLeafsPrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = "LEAFS";
            menuItemPrintServer.Text = "Print (LEAFS)";
            menuItemLeafsPrintServer.Checked = true;
            menuItemHabsPrintServer.Checked = false;
        }

        private void menuItemHabsPrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = "HABS";
            menuItemPrintServer.Text = "Print (HABS)";
            menuItemHabsPrintServer.Checked = true;
            menuItemLeafsPrintServer.Checked = false;
        }
        #endregion

        private void panelStdReceiving_GotFocus(object sender, EventArgs e)
        {

        }

        private void uxOperator_ParentChanged(object sender, EventArgs e)
        {

        }

        private void uxMessage_ParentChanged(object sender, EventArgs e)
        {

        }


    }
}
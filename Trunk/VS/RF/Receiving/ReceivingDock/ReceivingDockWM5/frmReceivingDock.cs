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
using System.Xml;


namespace ReceivingDockWM5
{
    public partial class frmReceivingDock : Form
    {
#region Class Initialization
        // 03-29-2010 1.01 Added ability to lock lot Number and changed error log to create CSV file
        // 06-01-2011 Added ability to read from XML file and ability to get PO number from having just the part number
        // 03-27-2012 1.02 Added the checking of PCB Parts and Flag them to keep seperate - RED Screen - Diff Tone
#if PocketPC
        private SymbolRFGun.SymbolRFGun MyRFGun = null;
#endif
        private String Operator = null;
        private String SID = null;
        private Int32? PO = null;
        private String Part = null;
        private Decimal? Qty = null;
        private String Lot = null;
        private String PrintServer = "";
        string location = "";
        string dserver = "";
        string server1 = "";
        string server2 = "";
        string server3 = "";
        string server4 = "";
        string connectionString1 = "";


        public frmReceivingDock()
        {
            InitializeComponent();
            XmlTextReader reader = new XmlTextReader(@"\Application Data\Program.xml");
            while (reader.Read())
            {
                if (reader.Name == "ReceivingSQL")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        connectionString1 = reader.Value;
                    }
                }
                else if (reader.Name == "DPrintServer")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        dserver = reader.Value;
                        menuItem1PrintServer.Text = dserver;
                        menuItem1PrintServer.Checked = true;
                        PrintServer = dserver;
                        menuItemPrintServer.Text = "Print (" + dserver + ")";
                    }
                }
                else if (reader.Name == "PrintServer1")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        server1 = reader.Value;
                        menuItem2PrintServer.Text = server1;
                        menuItem2PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "PrintServer2")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        server2 = reader.Value;
                        menuItem3PrintServer.Text = server2;
                        menuItem3PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "PrintServer3")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        server3 = reader.Value;
                        menuItem4PrintServer.Text = server3;
                        menuItem4PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "PrintServer4")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        server4 = reader.Value;
                        menuItem5PrintServer.Text = server4;
                        menuItem5PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "ReceivingLocation")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        location = reader.Value;
                        menuItemLocation.Text = location;
                    }
                }
            }
            if (server1 == "")
            {
                menuItem2PrintServer.Enabled = false;
                menuItemPrintServer.Enabled = false;
            }
            if (server2 == "")
            {
                menuItem3PrintServer.Enabled = false;
            }
            if (server3 == "")
            {
                menuItem4PrintServer.Enabled = false;
            }
            if (server4 == "")
            {
                menuItem5PrintServer.Enabled = false;
            }
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
                    case eScanDataType.TwoDBarcode:
                        TwoDEntered(scanData.DataValue);
                        break;
                    case eScanDataType.Undef:
                        Exception ex = new Exception("Unknown data identifier.");
                        throw ex;
                }
            }
            catch (SqlException ex)
            {
                uxMessage.Text = ex.Message;
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                //sw.Close();
                
            }
            catch (Exception ex)
            {
                uxMessage.Text = ex.Message;
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
               // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                //sw.Close();
            }
        }
        #endregion

        private void TwoDEntered(String sPart)
        {
            string [] line = sPart.Split(']');
            line[0] = line[0].Replace("[","");
            line[1] = line[1].Replace("[", "");
            line[2] = line[2].Replace("[", "");
            line[3] = line[3].Replace("[", "");
            line[4] = line[4].Replace("[", "");
            for (int i = 0; i < 3; i++)
            { 
                try
                {
                    ScanData scanData = line[i];
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
                        case eScanDataType.TwoDBarcode:
                            TwoDEntered(scanData.DataValue);
                            break;
                        case eScanDataType.Undef:
                            Exception ex = new Exception("Unknown data identifier.");
                            throw ex;
                    }
                }
                catch (SqlException ex)
                {
                    uxMessage.Text = ex.Message;
                }
                catch (Exception ex)
                {
                    uxMessage.Text = ex.Message;
                }
            }
        }

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
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                //sw.Close();
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
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                //sw.Close();
                ClearPO();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                //sw.Close();
                ClearPO();
            }
            RefreshScreenState();
        }

        private void EnterPO(string sPO)
        {
            Int32 iPO = Convert.ToInt32(sPO);
            /*Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ValidatePOPartQty(iPO, Part, Qty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);*/
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
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                //sw.Close();
                ClearPart();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
                //sw.Close();
                ClearPart();
            }
            RefreshScreenState();
        }

        private void EnterPart(String sPart)
        {
            /*Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ValidatePOPartQty(PO, sPart, Qty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);*/
            MyRFGun.GoodReadNotification();
            PartEntered(sPart);
            if (uxPO.Enabled == true)
            {
                XmlTextReader reader = new XmlTextReader(@"\Application Data\POLookUp.xml");
                while (reader.Read())
                {
                    if (reader.Name == "PartNO")
                    {
                        reader.Read();
                        if (uxPart.Text == reader.Value)
                        {
                            SqlConnection connection1 = new SqlConnection(connectionString1);
                            connection1.Open();
                            SqlCommand command1 = new SqlCommand("Select default_po_number from part_online where part = '" + uxPart.Text + "'", connection1);
                            int PO1 = (int)command1.ExecuteScalar();
                            //PODetailsTableAdapter taPODetails1 = new PODetailsTableAdapter();
                            //taPODetails1.ValidatePOPartQty(PO1, Part, Qty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);
                            connection1.Close();
                            MyRFGun.GoodReadNotification();
                            PO = PO1;
                            uxEnterPO.Text = "Clear";
                            uxPO.Text = PO.ToString();
                            uxPO.Enabled = false;
                        }
                    }
                }
            }
        }

        private void PartEntered(String sPart)
        {
            Part = sPart;
            uxEnterPart.Text = "Clear";
            uxPart.Text = Part;
            uxPart.Enabled = false;
            //Check to see if part is a PCB Part
            SqlConnection connection1 = new SqlConnection(connectionString1);
            connection1.Open();
            //SqlCommand command1 = new SqlCommand("Select default_po_number from part_online where part = '" + uxPart.Text + "'", connection1);
            SqlCommand command1 = new SqlCommand("Select count(*) from part where product_line='pcb' and part = '" + uxPart.Text + "'", connection1);
            //select * from part where product_line='pcb'
            int PartCount = (int)command1.ExecuteScalar();
            connection1.Close();
            if (PartCount > 0) 
            {
                MyRFGun.PCBNotification(); //PCL 4-9-2012
            }
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
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                //sw.Close();
                ClearQty();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                //sw.Close();
                ClearQty();
            }
            RefreshScreenState();
        }

        private void EnterQty(String sQty)
        {
            Decimal decQty = Convert.ToDecimal(sQty);
            /*Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ValidatePOPartQty(PO, Part, decQty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);*/
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
            uxEnterLot.Visible = true;
        }

        private void uxEnterLot_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxEnterLot.Text)
                {
                    case "Enter":
                        EnterLot(uxLot.Text);
                        break;
                    
                    case "Clear":
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
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                //sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                //sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                //sw.Close();
                ClearLot();
            }
            RefreshScreenState();
        }

        private void EnterLot(string sLot)
        {
            LotEntered(sLot);
        }

        private void LotEntered(String sLot)
        {
            Lot = sLot;
            uxEnterLot.Text = "Clear";
            uxLot.Text = Lot;
            uxLot.Enabled = false;
            SqlConnection connection1 = new SqlConnection(connectionString1);
            string command1 = "SET ARITHABORT ON; select PackingSlip from edi.vw_ASN_DixieWire where SerialNo = '" + uxLot.Text + "'";
            string command2 = "SET ARITHABORT ON; select PONumber from edi.vw_ASN_DixieWire where SerialNo = '" + uxLot.Text + "'";
            string command3 = "SET ARITHABORT ON; select Part from edi.vw_ASN_DixieWire where SerialNo = '" + uxLot.Text + "'";
            string command4 = "SET ARITHABORT ON; select PartQty from edi.vw_ASN_DixieWire where SerialNo = '" + uxLot.Text + "'";
            SqlCommand command5 = new SqlCommand(command1, connection1);
            SqlCommand command6 = new SqlCommand(command2, connection1);
            SqlCommand command7 = new SqlCommand(command3, connection1);
            SqlCommand command8 = new SqlCommand(command4, connection1);
            MyRFGun.GoodReadNotification();
            if (uxSID.Enabled == true && uxPart.Enabled == true && uxPO.Enabled == true && uxQty.Enabled == true)
            {
                connection1.Open();
                string shipper1 = (string)command5.ExecuteScalar();
                if (shipper1 != null)
                {
                    EnterSID(shipper1);
                }
                string po1 = (string)command6.ExecuteScalar();
                if (po1 != null)
                {
                    EnterPO(po1);
                }
                string part1 = (string)command7.ExecuteScalar();
                if (part1 != null)
                {
                    EnterPart(part1);
                }
                string quanity1 = (string)command8.ExecuteScalar();
                if (quanity1 != null)
                {
                    EnterQty(quanity1);
                }
                connection1.Close();
            }
            Decimal? NextDueAmount = null;
            DateTime? NextDueDate = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ValidatePOPartQty(PO, Part, Qty, 1, ref NextDueAmount, ref NextDueDate, ref iResult);
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
                        ClearLot();
                        break;
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
               
                //sw.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                //StreamWriter sw = File.AppendText("\\Application Data\\Error-RD.txt");
                // sw.WriteLine(ex.Message + "\r\n SID:" + uxSID.Text + "\r\n PO:" + uxPO.Text + "\r\n Part:" + uxPart.Text + "\r\n Qty:" + uxQty.Text + "\r\n Lot:" + uxLot.Text );
                // sw.WriteLine(" \r\n=================== \r\n");
                //sw.WriteLine(ex.Message + ",SID:" + uxSID.Text + ",PO:" + uxPO.Text + ",Part:" + uxPart.Text + ",Qty:" + uxQty.Text + ",Lot:" + uxLot.Text + ",select part_number,vendor_code,MIN(date_due) as due, DATEDIFF(dd,GETDATE(),Min(date_due)) as doh from po_detail where po_number=" + uxPO.Text + " group by part_number,vendor_code union");
              
                //sw.Close();
            }
            RefreshScreenState();
        }

        private void ReceiveBox()
        {
            Int32? iSerial = null;
            Int32? iResult = null;
            PODetailsTableAdapter taPODetails = new PODetailsTableAdapter();
            taPODetails.ReceiveItem(PO, Part, Operator, Qty, 1, location, SID, Lot, PrintServer, ref iSerial, ref iResult);
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

        private void menuItem1PrintServer_Click(object sender, EventArgs e)
        {

            PrintServer = dserver;
            menuItemPrintServer.Text = "Print (" + dserver + ")";
            menuItem1PrintServer.Checked = true;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = false;
            menuItem5PrintServer.Checked = false;

        }

        private void menuItem2PrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = server1;
            menuItemPrintServer.Text = "Print (" + server1 + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = true;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = false;
            menuItem5PrintServer.Checked = false;
        }

        private void menuItem3PrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = server2;
            menuItemPrintServer.Text = "Print (" + server2 + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = true;
            menuItem4PrintServer.Checked = false;
            menuItem5PrintServer.Checked = false;
        }

        private void menuItem4PrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = server3;
            menuItemPrintServer.Text = "Print (" + server3 + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = true;
            menuItem5PrintServer.Checked = false;
        }

        private void menuItem5PrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = server4;
            menuItemPrintServer.Text = "Print (" + server4 + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = false;
            menuItem5PrintServer.Checked = true;
        }
        #endregion

#region Unused
        private void panelStdReceiving_GotFocus(object sender, EventArgs e)
        {

        }

        private void uxOperator_ParentChanged(object sender, EventArgs e)
        {

        }

        private void uxMessage_ParentChanged(object sender, EventArgs e)
        {

        }

        private void menuItemPrintServer_Click(object sender, EventArgs e)
        {

        }

        private void menuItem1_Click(object sender, EventArgs e)
        {

        }

        private void uxPO_TextChanged(object sender, EventArgs e)
        {

        }

        private void uxLot_TextChanged(object sender, EventArgs e)
        {

        }

        private void uxPWD_TextChanged(object sender, EventArgs e)
        {

        }

        private void uxPart_TextChanged(object sender, EventArgs e)
        {

        }

        #endregion

    }
}
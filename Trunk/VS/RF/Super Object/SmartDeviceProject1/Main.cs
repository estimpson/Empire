using System;
using System.Drawing;
using System.Windows.Forms;
using System.Globalization;
using System.Data.SqlClient;
using CommonData;
using CommonData.dsCommonTableAdapters;
using System.Xml;
using SymbolRFGun;

//08-18-2010 Ver 1.01
//  Added Version number
//08-27-2010 Ver 1.02 PCL
//  Added values to Location table: Group_No='Receiving' and Plant='EEH'
//02-01-2011 Ver 1.03 PCL
//  Added ability to choose weather it is on Container or CONT-TROY
//03-01-2011 Ver 1.04 PCL
//  Changed Listbox to show latest scan on top
//  Added Remove serial functionality
//  Added The ability to edit a Super Object
//  Added the ability to type in a serial
//06-28-2011 Ver 1.05 PCL
//  Added the ability to reprint a label
//  Added drop down box for all super object serials
//  Added PCB check

namespace SmartDeviceProject1
{
    public partial class Main : Form
    {

        #region Initialize
        private SymbolRFGun.SymbolRFGun MyRFGun = null;
        //Counter
        /*string connectionString1 = @"Initial Catalog=EEH;" +
        @"Data Source=192.168.2.3;" +
        @"User ID=sa;" +
        @"Password=";*/
        //string connectionString1 = @"Initial Catalog=testmonitor;" +
        //        @"Data Source=192.168.1.102;" +
        //        @"User ID=andre;" +
        //        @"Password=";
        private int ScanCount = 0;
        private String PrintServer = "";
        string location = "";
        string dserver = "";
        string server1 = "";
        string server2 = "";
        string server3 = "";
        string server4 = "";
        string connectionString1 = "";
        private int PCB = 0;

        

        #endregion

        #region CreateLocation
        //Gets the week number of the year that it is
        public static int GetWeekNumber(DateTime dtPassed)
        {
            CultureInfo ciCurr = CultureInfo.CurrentCulture;
            int weekNum = ciCurr.Calendar.GetWeekOfYear(dtPassed, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);
            return weekNum;
        }

        private void CreateLocation()
        {
            //This sql command just gets the current date
            try
            {
                SqlConnection connection1 = new SqlConnection(connectionString1);
                connection1.Open();
                SqlCommand insertCommand = new SqlCommand("select getdate()", connection1);
                DateTime date = (DateTime)insertCommand.ExecuteScalar();
                connection1.Close();
                //Gets the dya of the week
                string day = date.DayOfWeek.ToString();

                //Converts the week number from an int to a string
                int weekNum = GetWeekNumber(date);
                string week = weekNum.ToString();
                if (week.Length == 1) { week = "0" + week; } //Force Week to be 2 digits
                //Takes the information from above and changes it to the format used for the location
                if (day == "Sunday")
                {
                    day = "SU";
                }

                if (day == "Monday")
                {
                    day = "MO";
                }

                if (day == "Tuesday")
                {
                    day = "TU";
                }

                if (day == "Wednesday")
                {
                    day = "WE";
                }

                if (day == "Thursday")
                {
                    day = "TH";
                }

                if (day == "Friday")
                {
                    day = "FR";
                }

                if (day == "Saturday")
                {
                    day = "SA";
                }
                if (location == "CONT-TROY")
                {
                    uxContainer.Text = "TRAN1-" + week + day;
                    uxContTroy.Text = "CONT-TROY";
                }
                else if (location == "CONT-ELP")
                {
                    uxContainer.Text = "TR1-" + week + day + "EL";
                    uxContTroy.Text = "CONT-ELP";
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
        #endregion

        #region Operator
        private String Operator = null;
        //Not sure what this does, I just took it from the other code.
        private void uxPWD_KeyDown(object sender, KeyEventArgs e)
        {
            if ((Int32)e.KeyCode == 134)
            {
                uxConfirmPWD.Focus();
                e.Handled = false;
            }
        }

        private void uxConfirmPWD_Click_1(object sender, EventArgs e)
        {
            //Checks if the user is logging in or logging off
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
            //read in the XML file and applies the information given
            XmlTextReader reader = new XmlTextReader(@"\Application Data\Program.xml");
            while (reader.Read())
            {
                if (reader.Name == "TransferSQL")
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
                        menuItemDPrintServer.Text = dserver;
                        menuItemDPrintServer.Checked = true;
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
                        menuItem1PrintServer.Text = server1;
                        menuItem1PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "PrintServer2")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        server2 = reader.Value;
                        menuItem2PrintServer.Text = server2;
                        menuItem2PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "PrintServer3")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        server3 = reader.Value;
                        menuItem3PrintServer.Text = server3;
                        menuItem3PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "PrintServer4")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        server4 = reader.Value;
                        menuItem4PrintServer.Text = server4;
                        menuItem4PrintServer.Checked = false;
                    }
                }
                else if (reader.Name == "TransferLocation")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        location = reader.Value;
                    }
                }
            }
            if (server1 == "")
            {
                menuItem1PrintServer.Enabled = false;
                menuItemPrintServer.Enabled = false;
            }
            if (server2 == "")
            {
                menuItem2PrintServer.Enabled = false;
            }
            if (server3 == "")
            {
                menuItem3PrintServer.Enabled = false;
            }
            if (server4 == "")
            {
                menuItem4PrintServer.Enabled = false;
            }
            reader.Close();
            //Majority of this code I took from the receiving program. Just Checks if the password is correct.
            EEHEmployeeTableAdapter taEmployee = new EEHEmployeeTableAdapter();
            dsCommon.EEHEmployeeDataTable dtEmployees = taEmployee.GetDataBy(sPassword);
            string sOperatorCode;
            switch (dtEmployees.Rows.Count)
            {
                case 1:
                    sOperatorCode = dtEmployees[0].OperatorCode;
                    OperatorConfirmed(sOperatorCode);
                    break;
                case 0:
                    uxPWD.Text = "";
                    uxPWD.Focus();
                    throw new Exception("Invalid password.");
                default:
                    uxPWD.Focus();
                    throw new Exception("Unknown error validating password.");
            }

            //Default to Eduardo
            //sOperatorCode = "ECHAV";
            //OperatorConfirmed(sOperatorCode);

            //If password is correct it refreshes the screen and changes the button to Print.
            RefreshScreenState();
            uxbutton1.Text = "Print Label";

        }

        private void OperatorConfirmed(string sOperator)
        {
            //If user logs in successfully, the screen becomes enabled and the operator is assigned.
            Operator = sOperator;
            uxConfirmPWD.Text = "Log Off";
            uxPWD.Visible = false;
            uxPWD.Text = "";
            uxPWD.Enabled = false;
            uxOperator.Text = sOperator;
            uxOperator.Visible = true;
            panelStdReceiving.Enabled = true;
            uxListBox1.Focus();
            //Creates the location
            CreateLocation();
        }

        private void LogOff()
        {
            //When the user logs off, everything becomes disabled again
            Operator = null;
            uxConfirmPWD.Text = "Confirm";
            uxOperator.Visible = false;
            uxPWD.Visible = true;
            uxPWD.Enabled = true;
            uxPWD.Focus();
            uxOperator.Text = "";
            panelStdReceiving.Enabled = false;
            uxMessage.Text = "Log in.";

            //Gun turns off when the user logs off
#if PocketPC
            if (MyRFGun != null) MyRFGun.Close();
#endif
        }
        #endregion

        #region ScanForm
        //Put in every piece of code, does nothing specifically
        public Main()
        {
            InitializeComponent();
        }

        private void Main_Load(object sender, EventArgs e)
        {
            //When the screen loads, the page focuses on the textbox to type password
            uxPWD.Focus();
            //Center Panels
            uxPanel.Location = new Point(this.ClientSize.Width / 2 - uxPanel.Size.Width / 2,
    this.ClientSize.Height / 2 - uxPanel.Size.Height / 2);
            uxPanel.Anchor = AnchorStyles.None;
            //Center panelStdReceiving
            panelStdReceiving.Location = new Point(this.ClientSize.Width / 2 - panelStdReceiving.Size.Width / 2,
    this.ClientSize.Height / 2 - panelStdReceiving.Size.Height / 2);
            panelStdReceiving.Anchor = AnchorStyles.None;
            //Center uxPanelSo
            uxPanelSo.Location = new Point(this.ClientSize.Width / 2 - uxPanelSo.Size.Width / 2,
    this.ClientSize.Height / 2 - uxPanelSo.Size.Height / 2);
            uxPanelSo.Anchor = AnchorStyles.None;
        }
        #endregion

        #region ScanData
        void MyRFGun_RFScan(object sender, RFScanEventArgs e)
        {
            //This section of code I took, basically checks if it is a serial number then it approves it, if not it will fail
            try
            {
                ScanData scanData = e.Text;
                switch (scanData.ScanDataType)
                {
                    case eScanDataType.Serial:
                        EnterSerial(scanData.DataValue);
                        break;
                    default:
                        throw new Exception("Not a serial.");
                }
            }
            catch (Exception ex)
            {
                uxMessage.Text = ex.Message;
                MyRFGun.FailNotification();
            }
        }
        #endregion

        #region Serial
        private void EnterSerial(String sSer)
        {
            //Used to see if serial number is already been scanned
            int match = 0;
            //Loop through all the serial numbers that have already been scanned
            foreach (string item in uxListBox1.Items)
            {
                //If the serial number has already been scanned, user is notified
                if (sSer == item)
                {
                    uxMessage.Text = "Serial # Already Scanned, Please Scan Another.";
                    MyRFGun.BadReadNotification();
                    //Adds 1 if serial number has already been scanned
                    match += 1;
                }
            }
            //If serial number has not been scanned yet, then it is added to the list and the screen updates
            if (match != 1)
            {
                try
                {
                    //checks and make sure PCB parts are not mixed with other parts
                    string serial = sSer.TrimStart('0');

                    SqlConnection connection1 = new SqlConnection(connectionString1);
                    SqlCommand command1 = new SqlCommand("SELECT count(*) FROM object join part on object.part = part.part where object.serial = '" + serial + "' and part.product_line='pcb'", connection1);
                    connection1.Open();
                    int SerialCheck = (int)command1.ExecuteScalar();
                    connection1.Close();

                    //sets the PCB flag on first scan
                    if (ScanCount == 0)
                    {
                        PCB = SerialCheck;
                    }

                    //if the products match then enter the serial
                    if (PCB == SerialCheck)
                    {
                        SerialEntered(sSer);
                        uxCount.Refresh();
                        uxListBox1.Refresh();
                        uxMessage.Refresh();
                        MyRFGun.GoodReadNotification();
                    }
                    else
                    {
                        //gives a bad read notification if packages are mixed
                        MyRFGun.BadReadNotification();
                        DialogResult result1 = MessageBox.Show("WARNING: You are mixing PCB packages with other packages, are you sure you want to do this?", "Important Question", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2);
                        if (result1 == DialogResult.Yes)
                        {
                            SerialEntered(sSer);
                            uxCount.Refresh();
                            uxListBox1.Refresh();
                            uxMessage.Refresh();
                            MyRFGun.GoodReadNotification();
                        }
                    }
                }
                catch (SqlException ex)
                {
                    MessageBox.Show(ex.Message);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }

        private void SerialEntered(string sSer)
        {
            try
            {
                //strips the serial number, this step is needed
                string serial = sSer.TrimStart('0');
                //string result;
                //Runs the stored procedure

                SqlConnection connection1 = new SqlConnection(connectionString1);
                SqlCommand updateCom = new SqlCommand("execute HN.HCSP_Inv_Transfer_Core @operator='" + uxOperator.Text + "' ,@Serial=" + serial + ", @toserial=" + uxSODrop.Text, connection1);
                connection1.Open();
                updateCom.ExecuteNonQuery();
                connection1.Close();

                // updateCom.Parameters.Append updateCom.CreateParameter("RC", adInteger, adParamReturnValue);
                //  updateCom.Parameters.Add(new SqlParameter("@Result", SqlDbType.Int));
                //  updateCom.Parameters["@Result"].Direction = ParameterDirection.Output;
                //  int iresult = Convert.ToInt16(updateCom.Parameters["@Result"].Value) ;
                //  string strResult = Convert.ToString(iresult);
                //  System.Windows.Forms.MessageBox.Show(strResult);

                //If Serial was successfully inserted then:
                //Adds to the listbox
                uxListBox1.Items.Insert(0, serial);  //Used to be uxListBox1.Items.Add(serial); 
                //Adds to te counter
                ScanCount += 1;
                uxCount.Text = ScanCount.ToString();
                uxMessage.Text = "Successful Serial # Scan";
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        #endregion

        #region Refresh
        private void RefreshScreenState()
        {
            //Enables everything again
            uxOperator.Enabled = true;
            uxCount.Enabled = true;
            uxSODrop.Enabled = false;
            uxLocation.Enabled = true;
            uxMessage.Enabled = true;
            label1.Enabled = true;
            label2.Enabled = true;
            label3.Enabled = true;
            label4.Enabled = true;
            uxListBox1.Enabled = true;
            uxEdit.Enabled = true;
            button1.Enabled = true;
            button2.Enabled = true;

            //Resets the counter and clears the list of serial numbers
            uxCount.Text = "0";
            uxListBox1.Items.Clear();
            ScanCount = 0;

            uxPanel.Visible = true;

            //Commented below out 2-2-2011

            ////These commands are used to create the superobject serial
            //SqlConnection connection1 = new SqlConnection(connectionString1);
            //SqlCommand count = new SqlCommand("select next_serial from parameters", connection1);
            //connection1.Open();
            //int serial = (int)count.ExecuteScalar();
            ////Displays super object on screen
            //string serial1 = serial.ToString();
            //uxSO.Text = serial1;
            //SqlCommand insertCommand2 = new SqlCommand("execute hn.sp_CreateSuperObject @Operator='" + uxOperator.Text + "', @Pallets=1, @firstNewSerial = '',@Location='"+ uxLocation.Text + "'", connection1);
            //insertCommand2.ExecuteNonQuery();
            // connection1.Close();

            uxMessage.Text = "Waiting for scan...";

            //Turns on the gun
            MyRFGun = new SymbolRFGun.SymbolRFGun();
            MyRFGun.RFScan += new RFScanEventHandler(MyRFGun_RFScan);
        }
        #endregion

        #region PrintOptions

        //This string is used when writing to the database

        private void menuItem1PrintServer_Click(object sender, EventArgs e)
        {

            PrintServer = server1;
            menuItemPrintServer.Text = "Print (" + server1 + ")";
            menuItem1PrintServer.Checked = true;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = false;
            menuItemDPrintServer.Checked = false;

        }

        private void menuItem2PrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = server2;
            menuItemPrintServer.Text = "Print (" + server2 + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = true;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = false;
            menuItemDPrintServer.Checked = false;
        }

        private void menuItem3PrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = server3;
            menuItemPrintServer.Text = "Print (" + server3 + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = true;
            menuItem4PrintServer.Checked = false;
            menuItemDPrintServer.Checked = false;
        }

        private void menuItem4PrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = server4;
            menuItemPrintServer.Text = "Print (" + server4 + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = true;
            menuItemDPrintServer.Checked = false;
        }

        private void menuItemDPrintServer_Click(object sender, EventArgs e)
        {
            PrintServer = dserver;
            menuItemPrintServer.Text = "Print (" + dserver + ")";
            menuItem1PrintServer.Checked = false;
            menuItem2PrintServer.Checked = false;
            menuItem3PrintServer.Checked = false;
            menuItem4PrintServer.Checked = false;
            menuItemDPrintServer.Checked = true;
        }
        #endregion

        #region SuperObject/Print
        private void button1_Click_2(object sender, EventArgs e)
        {
            try
            {
                //Used if user wants to create a new super object
                if (uxbutton1.Text == "Create Super Object")
                {
                    RefreshScreenState();
                    //Create the SO
                    SqlConnection connection1 = new SqlConnection(connectionString1);
                    connection1.Open();
                    //Checks to see if current location is already in the database
                    SqlCommand insertCommand1 = new SqlCommand("select [CODE] from [location] where [name] = '" + uxLocation.Text + "'", connection1);
                    string location = (string)insertCommand1.ExecuteScalar();
                    //If the location is not the database then it is added
                    if (location == null)
                    {
                        SqlCommand insertCommand2 = new SqlCommand("Insert into location (code,[name],type,group_no,Plant) VALUES ('" + uxLocation.Text + "','" + uxLocation.Text + "', 'ST','Receiving','EEH')", connection1);
                        insertCommand2.ExecuteNonQuery();
                    }
                    //connection1.Close();

                    //SqlConnection connection1 = new SqlConnection(connectionString1);
                    SqlCommand count = new SqlCommand("select next_serial from parameters", connection1);
                    //connection1.Open();
                    int serial = (int)count.ExecuteScalar();
                    //Displays super object on screen
                    string serial1 = serial.ToString();
                    uxSODrop.Items.Add(serial1);
                    uxSODrop.Text = serial1;
                    SqlCommand insertCommand3 = new SqlCommand("execute hn.sp_CreateSuperObject @Operator='" + uxOperator.Text + "', @Pallets=1, @firstNewSerial = '',@Location='" + uxLocation.Text + "'", connection1);
                    insertCommand3.ExecuteNonQuery();
                    connection1.Close();
                    uxbutton1.Text = "Print Label";
                }

                //Used if user wants to print label
                else if (uxbutton1.Text == "Print Label")
                {
                    //Input box to enter weight
                    string input = Microsoft.VisualBasic.Interaction.InputBox("Enter Weight", "", "", 0, 0);
                    //If user doesn't enter anything then the input box pops up again
                    while (input == "")
                    {
                        input = Microsoft.VisualBasic.Interaction.InputBox("No weight was entered. Enter Weight", "", "", 0, 0);
                    }

                    //A bunch of SQL commands
                    SqlConnection connection1 = new SqlConnection(connectionString1);
                    connection1.Open();
                    SqlCommand selectCommand = new SqlCommand("select count(BoxCount) from SuperObject where Serial = '" + uxSODrop.Text + "'", connection1);
                    int check = (int)selectCommand.ExecuteScalar();
                    if (check == 0)
                    {
                        SqlCommand insertCommand = new SqlCommand("Insert into SuperObject (Serial,Weight,BoxCount) VALUES (" + uxSODrop.Text + "," + input + "," + ScanCount + ")", connection1);
                        insertCommand.ExecuteNonQuery();
                    }
                    else
                    {
                        SqlCommand updateCommand = new SqlCommand("update SuperObject set Weight = " + input + ", BoxCount = " + ScanCount + " where  serial = '" + uxSODrop.Text + "'", connection1);
                        updateCommand.ExecuteNonQuery();
                    }
                    SqlCommand insertCommand1 = new SqlCommand("Insert into printqueue (SerialNumber,PrintServer,LabelFormat) VALUES (" + uxSODrop.Text + ",'" + PrintServer + "','SUPER')", connection1);
                    insertCommand1.ExecuteNonQuery();
                    //Insert Second Label   
                    insertCommand1.ExecuteNonQuery();
                    // Contatiner or CONTROY
                    SqlCommand insertCommand2 = new SqlCommand("execute [HN].[HCSP_Inv_Transfer_Object] @operator='" + uxOperator.Text + "',@Serial=" + uxSODrop.Text + ",@ToLoc='" + uxLocation.Text + "'", connection1);
                    insertCommand2.ExecuteNonQuery();
                    connection1.Close();

                    //Disables everything until user hits create super object button and creates new super object
                    uxOperator.Enabled = false;
                    uxCount.Enabled = false;
                    uxSODrop.Enabled = true;
                    uxLocation.Enabled = false;
                    uxMessage.Enabled = false;
                    label1.Enabled = false;
                    label2.Enabled = false;
                    label3.Enabled = false;
                    label4.Enabled = false;
                    uxListBox1.Enabled = false;
                    uxEdit.Enabled = false;
                    button1.Enabled = false;
                    button2.Enabled = false;
                    uxbutton1.Text = "Create Super Object";
                    uxbutton1.Focus();
                    uxMessage.Text = "Create Super Object";

                    //Gun is turned off until user hits create super object button
                    if (MyRFGun != null) MyRFGun.Close();
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        #endregion

        #region AddContainer

        private void button1_Click_3(object sender, EventArgs e)
        {
            //REmove the addition of Containers temorarily
            if (uxContTroy.Text == "CONT-TROY")
            {
              string container = uxContainer.Text.Substring(4, 1);
              int containerNum = Convert.ToInt32(container);
              containerNum += 1;
              container = containerNum.ToString();
              uxContainer.Text = "TRAN" + containerNum + uxContainer.Text.Substring(5, 5);
            }
            else if (uxContTroy.Text == "CONT-ELP")
            {
              string container = uxContainer.Text.Substring(2, 1);
              int containerNum = Convert.ToInt32(container);
              containerNum += 1;
              container = containerNum.ToString();
              uxContainer.Text = "TR" + containerNum + uxContainer.Text.Substring(3, 7);
            }


            ////Runs the location sql command
            SqlConnection connection1 = new SqlConnection(connectionString1);
            connection1.Open();
            SqlCommand insertCommand1 = new SqlCommand("select [CODE] from [location] where [name] = '" + uxContainer.Text + "'", connection1);
            string location = (string)insertCommand1.ExecuteScalar();
            if (location == null)
            {
                SqlCommand insertCommand2 = new SqlCommand("Insert into location (code,[name],type,group_no,plant) VALUES ('" + uxContainer.Text + "','" + uxContainer.Text + "', 'ST','Receiving','EEH')", connection1);
                insertCommand2.ExecuteNonQuery();
            }
            connection1.Close();
        }
        #endregion

        #region SubtractDay
        private void button1_Click_4(object sender, EventArgs e)
        {

            ChangeDay("Minus");
            //Just update textbox - do not insert into DB

            //SqlConnection connection1 = new SqlConnection(connectionString1);
            //connection1.Open();
            ////Checks to see if current location is already in the database
            //SqlCommand insertCommand1 = new SqlCommand("select [CODE] from [location] where [name] = '" + uxLocation1.Text + "'", connection1);
            //string location = (string)insertCommand1.ExecuteScalar();
            ////If the location is not the database then it is added
            //if (location == null)
            //{
            //    SqlCommand insertCommand2 = new SqlCommand("Insert into location (code,[name],type,group_no,plant) VALUES ('" + uxLocation1.Text + "','" + uxLocation1.Text + "', 'ST','Receiving','EEH')", connection1);
            //    insertCommand2.ExecuteNonQuery();
            //}
            //connection1.Close();
        }
        #endregion

        #region ChangeDay
        private void ChangeDay(string AddOrMinus)
        {
            if (AddOrMinus == "Minus")
            {
                // Takes the current week in the location and makes it an int
                string week = "";
                string currentDay = "";
                if (location == "CONT-ELP")
                {
                    week = uxContainer.Text.Substring(4, 2);
                    currentDay = uxContainer.Text.Substring(6, 2); 
                }
                else if (location == "CONT-TROY")
                {
                    week = uxContainer.Text.Substring(6, 2);
                    currentDay = uxContainer.Text.Substring(8, 2); 
                }
                int weekNum = Convert.ToInt32(week);

                //Subtracts Day from current date

                string day = "";
                if (currentDay == "SU")
                {
                    day = "SA";
                    weekNum -= 1;
                }

                if (currentDay == "MO")
                {
                    day = "SU";
                }

                if (currentDay == "TU")
                {
                    day = "MO";
                }

                if (currentDay == "WE")
                {
                    day = "TU";
                }

                if (currentDay == "TH")
                {
                    day = "WE";
                }

                if (currentDay == "FR")
                {
                    day = "TH";
                }

                if (currentDay == "SA")
                {
                    day = "FR";
                }

                week = weekNum.ToString();
                if (week.Length == 1) { week = "0" + week; } //Force Week to be 2 digits
                if (location == "CONT-TROY")
                {
                    uxContainer.Text = "TRAN1-" + week + day;
                }
                if (location == "CONT-ELP")
                {
                    uxContainer.Text = "TR1-" + week + day + "EL";
                }

                uxContainer.Refresh();
            }
            else
            {
                string week = "";
                // Takes the current week in the location and makes it an int
                string currentDay = "";
                if (location == "CONT-ELP")
                {
                    week = uxContainer.Text.Substring(4, 2);
                    currentDay = uxContainer.Text.Substring(6, 2);
                }
                else if (location == "CONT-TROY")
                {
                    week = uxContainer.Text.Substring(6, 2);
                    currentDay = uxContainer.Text.Substring(8, 2);
                }
                int weekNum = Convert.ToInt32(week);
                string day = "";
                if (currentDay == "SU")
                {
                    day = "MO";
                }

                if (currentDay == "MO")
                {
                    day = "TU";
                }

                if (currentDay == "TU")
                {
                    day = "WE";
                }

                if (currentDay == "WE")
                {
                    day = "TH";
                }

                if (currentDay == "TH")
                {
                    day = "FR";
                }

                if (currentDay == "FR")
                {
                    day = "SA";
                }

                if (currentDay == "SA")
                {
                    day = "SU";
                    weekNum += 1;
                }

                week = weekNum.ToString();
                if (week.Length == 1) { week = "0" + week; } //Force Week to be 2 digits
                if (location == "CONT-TROY")
                {
                    uxContainer.Text = "TRAN1-" + week + day;
                }
                if (location == "CONT-ELP")
                {
                    uxContainer.Text = "TR1-" + week + day + "EL";
                }

                uxContainer.Refresh();
            }
        }
        #endregion

        #region AddDay
        private void button2_Click(object sender, EventArgs e)
        {
            ChangeDay("Add");

            //SqlConnection connection1 = new SqlConnection(connectionString1);
            //connection1.Open();
            ////Checks to see if current location is already in the database
            //SqlCommand insertCommand1 = new SqlCommand("select [CODE] from [location] where [name] = '" + uxLocation1.Text + "'", connection1);
            //string location = (string)insertCommand1.ExecuteScalar();
            ////If the location is not the database then it is added
            //if (location == null)
            //{
            //    SqlCommand insertCommand2 = new SqlCommand("Insert into location (code,[name],type,group_no,Plant) VALUES ('" + uxLocation1.Text + "','" + uxLocation1.Text + "', 'ST','Receiving','EEH')", connection1);
            //    insertCommand2.ExecuteNonQuery();
            //}
            //connection1.Close();
        }
        #endregion

        #region SelectLocation
        private void uxLocationBtn_Click(object sender, EventArgs e)
        {
            try
            {
                if (uxContTroy.Checked == false && uxContainer.Checked == false)
                {
                    MessageBox.Show("Choose a location!");
                    // break;
                }
                else
                {
                    if (uxContTroy.Checked == true)
                    { uxLocation.Text = uxContTroy.Text; } //CONT-TROY
                    else
                    {
                        //Get Container Name
                        uxLocation.Text = uxContainer.Text;
                    }
                    uxPanel.Visible = false;
                    panelStdReceiving.Visible = true;
                    //Create the SO
                    SqlConnection connection1 = new SqlConnection(connectionString1);
                    connection1.Open();
                    //Checks to see if current location is already in the database
                    SqlCommand insertCommand1 = new SqlCommand("select [CODE] from [location] where [name] = '" + uxLocation.Text + "'", connection1);
                    string location = (string)insertCommand1.ExecuteScalar();
                    //If the location is not the database then it is added
                    if (location == null)
                    {
                        SqlCommand insertCommand2 = new SqlCommand("Insert into location (code,[name],type,group_no,Plant) VALUES ('" + uxLocation.Text + "','" + uxLocation.Text + "', 'ST','Receiving','EEH')", connection1);
                        insertCommand2.ExecuteNonQuery();
                    }
                    //connection1.Close();

                    //SqlConnection connection1 = new SqlConnection(connectionString1);
                    SqlCommand count = new SqlCommand("select next_serial from parameters", connection1);
                    //connection1.Open();
                    int serial = (int)count.ExecuteScalar();
                    //Displays super object on screen
                    string serial1 = serial.ToString();
                    uxSODrop.Items.Add(serial1);
                    uxSODrop.Text = serial1;
                    SqlCommand insertCommand3 = new SqlCommand("execute hn.sp_CreateSuperObject @Operator='" + uxOperator.Text + "', @Pallets=1, @firstNewSerial = '',@Location='" + uxLocation.Text + "'", connection1);
                    insertCommand3.ExecuteNonQuery();
                    connection1.Close();
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        #endregion

        #region MenuItems
        private void menuItem2_Click_1(object sender, EventArgs e)
        {
            this.Close();
            if (MyRFGun != null) MyRFGun.Close();
        }

        private void menuItem4_Click(object sender, EventArgs e)
        {
            if (panelStdReceiving.Visible == false)
            {
                return;
            }
            panelStdReceiving.Visible = false;
            uxPanelSo.Visible = true;
            uxEnterSo.Text = "";
            uxEnterSo.Focus();
            uxlabelPanel.Text = "Enter or Scan Super Object";
        }

        private void menuItem3_Click(object sender, EventArgs e)
        {
            if (panelStdReceiving.Visible == false)
            {
                return;
            }
            panelStdReceiving.Visible = false;
            uxPanelSo.Visible = true;
            uxEnterSo.Focus();
            uxEnterSo.Text = "";
            uxlabelPanel.Text = "Enter Serial Number";
        }

        private void menuItem6_Click(object sender, EventArgs e)
        {
            if (panelStdReceiving.Visible == false)
            {
                return;
            }
            panelStdReceiving.Visible = false;
            uxPanelSo.Visible = true;
            uxEnterSo.Text = "";
            uxEnterSo.Focus();
            uxlabelPanel.Text = "Enter Super Object to Print";
        }

        private void menuItem5_Click(object sender, EventArgs e)
        {
            if (panelStdReceiving.Visible == false)
            {
                return;
            }

            if (uxListBox1.SelectedItem == null)
            {
                MessageBox.Show("Please select a serial number you would like to delete!");
                return;
            }
            panelStdReceiving.Visible = false;
            uxPanelSo.Visible = true;
            uxEnterSo.Text = uxEnterSo.Text = uxListBox1.SelectedItem.ToString();
            uxEnterSo.Focus();
            uxlabelPanel.Text = "Delete this serial?";
        }
        #endregion

        #region SOBox
        private void uxSoOK_Click(object sender, EventArgs e)
        {
            // MessageBox.Show("First Line - Befor SQL");
            try
            {
                int c = 0;

                switch (uxlabelPanel.Text)
                {
                    case "Delete this serial?":

                        //Prompt to delete
                        SqlConnection connection2 = new SqlConnection(connectionString1);
                        connection2.Open();

                        //Checks to see if current location is already in the database
                        // MessageBox.Show("execute [HN].[HCSP_Inv_Transfer_Object] @operator='" + uxOperator.Text + "',@Serial='" + uxEnterSo.Text + "',@ToLoc='EEI-STAGE'");

                        SqlCommand insertCommand = new SqlCommand("execute [HN].[HCSP_Inv_Transfer_Object] @operator='" + uxOperator.Text + "',@Serial='" + uxEnterSo.Text + "',@ToLoc='EEI-STAGE'", connection2);
                        insertCommand.ExecuteNonQuery();
                        connection2.Close();

                        uxListBox1.Items.Remove(uxListBox1.SelectedItem);
                        ScanCount -= 1;
                        uxCount.Text = ScanCount.ToString();
                        uxMessage.Text = "Serial Removed";
                        panelStdReceiving.Visible = true;
                        uxPanelSo.Visible = false;
                        break;
                    case ("Enter Super Object to Print"):
                        SqlConnection connection3 = new SqlConnection(connectionString1);
                        connection3.Open();
                        SqlCommand insertCommand3 = new SqlCommand("Insert into printqueue (SerialNumber,PrintServer,LabelFormat) VALUES (" + uxEnterSo.Text.ToString() + ",'" + PrintServer + "','SUPER')", connection3);
                        insertCommand3.ExecuteNonQuery();
                        insertCommand3.ExecuteNonQuery();
                        connection3.Close();
                        uxEnterSo.Text = "";
                        uxPanelSo.Visible = false;
                        panelStdReceiving.Visible = true;
                        break;
                    case ("Enter Serial Number"):

                        if (uxEnterSo.Text.Length < 2)
                        {
                            MessageBox.Show("Please enter a valid Serial Number");
                            return;
                        }
                        //Add Serial Number to Listbox
                        EnterSerial(uxEnterSo.Text);
                        uxEnterSo.Text = "";
                        uxPanelSo.Visible = false;
                        panelStdReceiving.Visible = true;
                        break;
                    case ("Enter or Scan Super Object"):

                        // Load Super object and allow Adding / Removing

                        if (uxEnterSo.Text.Length < 2)
                        {
                            MessageBox.Show("Please enter a valid Serial Number");
                            return;
                        }
                        SqlConnection connection1 = new SqlConnection(connectionString1);
                        connection1.Open();
                        SqlCommand insertCommand1 = new SqlCommand("select count(serial) from object where serial = '" + uxEnterSo.Text.ToString() + "' and part ='pallet'", connection1);
                        int serial = (int)insertCommand1.ExecuteScalar();
                        //If the location is not the database then it is added

                        if (serial == 0)
                        {
                            MessageBox.Show("Please enter a valid Super Object Number");
                            return;
                        }
                        else
                        {
                            //MessageBox.Show(serial.ToString());
                            uxSODrop.Items.Add(uxEnterSo.Text);
                            uxSODrop.Text = uxEnterSo.Text;
                        }

                        SqlCommand cmd = new SqlCommand("select serial from object where parent_serial = '" + uxEnterSo.Text.ToString() + "'", connection1);
                        SqlCommand location = new SqlCommand("select location from object where serial = '" + uxEnterSo.Text.ToString() + "'", connection1);
                        SqlDataReader reader1;
                        //connection1.Open();
                        string loc = (string)location.ExecuteScalar();
                        reader1 = cmd.ExecuteReader();
                        while (reader1.Read())
                        {
                            this.uxListBox1.Items.Add(reader1[0].ToString());
                            c += 1;
                        }
                        reader1.Close();
                        uxCount.Text = c.ToString();
                        uxLocation.Text = loc;
                        ScanCount = c;
                        connection1.Close();
                        uxPanelSo.Visible = false;
                        panelStdReceiving.Visible = true;
                        break;
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void uxSoCancel_Click(object sender, EventArgs e)
        {
            uxEnterSo.Text = "";
            uxPanelSo.Visible = false;
            panelStdReceiving.Visible = true;
        }
        #endregion

        #region CheckBox/Garbage
        private void checkBox1_CheckStateChanged(object sender, EventArgs e)
        {
            //if (checkBox1.Checked==true)
            //{
            //    //Change to Production Database
            //    uxListBox1.BackColor = Color.Red;
            //    connectionString1 = @"Initial Catalog=EEH;" +
            //    @"Data Source=192.168.2.3;" +
            //    @"User ID=sa;" +
            //    @"Password=";

            //}

            //else
            //{
            //    //Change to Test Database
            //    uxListBox1.BackColor = Color.White;
            //    connectionString1 = @"Initial Catalog=testmonitor;" +
            //    @"Data Source=192.168.1.102;" +
            //    @"User ID=andre;" +
            //    @"Password=";

            //}

        }
        
        //Just closes the program when the button is clicked, I put the excess stuff in here just to make the code cleanier it doesnt do anything else
        private void menuItemClose_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click_1(object sender, EventArgs e)
        {

        }

        private void uxCount_ParentChanged(object sender, EventArgs e)
        {

        }

        private void uxMessage_ParentChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click_1(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label1_ParentChanged(object sender, EventArgs e)
        {

        }

        private void uxCount_ParentChanged_1(object sender, EventArgs e)
        {

        }

        private void uxMessage_ParentChanged_1(object sender, EventArgs e)
        {

        }

        private void uxListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label2_ParentChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void label1_ParentChanged_1(object sender, EventArgs e)
        {

        }

        private void menuItemPrint1_Click(object sender, EventArgs e)
        {

        }

        private void uxPWD_TextChanged(object sender, EventArgs e)
        {

        }

        private void uxOperator_ParentChanged(object sender, EventArgs e)
        {

        }

        private void panelStdReceiving_GotFocus(object sender, EventArgs e)
        {

        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void uxPanel_GotFocus(object sender, EventArgs e)
        {

        }

        private void uxMessage_ParentChanged_2(object sender, EventArgs e)
        {

        }

        private void uxListBox1_SelectedIndexChanged_1(object sender, EventArgs e)
        {

        }

        private void uxCount_ParentChanged_2(object sender, EventArgs e)
        {

        }

        private void uxListBox1_SelectedValueChanged(object sender, EventArgs e)
        {

        }

        private void uxListBox1_KeyPress(object sender, KeyPressEventArgs e)
        {

        }

        private void uxPanelSo_GotFocus(object sender, EventArgs e)
        {

        }

        private void mnuEditSo_Click(object sender, EventArgs e)
        {

        }

        private void uxlabelPanel_ParentChanged(object sender, EventArgs e)
        {

        }

        #endregion

    }
}

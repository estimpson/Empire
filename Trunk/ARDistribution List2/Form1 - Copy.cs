using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.IO;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Net.Mail;
using System.Diagnostics;
using System.Threading;
using DataGridViewAutoFilter;

namespace Distribution_List
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            this.dataGridView1.KeyDown += new KeyEventHandler(dataGridView1_KeyDown);

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'mONITORDataSet.ee_accounts_receivable' table. You can move, or remove it, as needed.
            this.ee_accounts_receivableTableAdapter.Fill(this.mONITORDataSet.ee_accounts_receivable);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            List<string> autoFile = new List<string>();
            List<string> need2Send = new List<string>();
            List<string> need2SendnEmail = new List<string>();
            List<string> prepaid = new List<string>();
            string connectionString1 = "";
            //XmlTextReader reader = new XmlTextReader(@"C:\Users\apellerito\Documents\Program.xml");
            XmlTextReader reader = new XmlTextReader(@"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\ARDistributionList\Program.xml");
            while (reader.Read())
            {
                if (reader.Name == "AutoFile")
                {
                    reader.Read();
                    switch (reader.NodeType)
                    {
                        case XmlNodeType.Text:
                            autoFile.Add(reader.Value);
                            break;
                    }
                }
                else if (reader.Name == "NeedToSend")
                {
                    reader.Read();
                    switch (reader.NodeType)
                    {
                        case XmlNodeType.Text:
                            need2Send.Add(reader.Value);
                            break;
                    }
                }
                else if (reader.Name == "NeedToSendandEmail")
                {
                    reader.Read();
                    switch (reader.NodeType)
                    {
                        case XmlNodeType.Text:
                            need2SendnEmail.Add(reader.Value);
                            break;
                    }
                }
                else if (reader.Name == "Prepaid")
                {
                    reader.Read();
                    switch (reader.NodeType)
                    {
                        case XmlNodeType.Text:
                            prepaid.Add(reader.Value);
                            break;
                    }
                }
                else if (reader.Name == "connectionString")
                {
                    reader.Read();
                    switch (reader.NodeType)
                    {
                        case XmlNodeType.Text:
                            connectionString1 = reader.Value;
                            break;
                    }
                }
            }

            string[] filePaths = Directory.GetFiles(@"G:\Accounts Receivable\Invoices\Scans\READY TO SEND", "*.pdf");
            string file;
            string[] _values = null;
            string[] _values2 = null;
            string invoice;
            string companyName;
            string i;
            string aFiled = "";
            string need = "";
            string credits = "";
            string exceptions = "";
            string duplicates = "";
            string processed = "";
            string needsend = "";
            string freeSamples = "";
            int duplicateCount = 0;
            int fileCount = filePaths.Length;
            int exceptionCount = 0;
            int processedCount = 0;
            int needCount = 0;
            int creditCount = 0;
            int afCount = 0;
            int needsendCount = 0;
            int freeCount = 0;
            int totalFiles = filePaths.Length;
            while (fileCount != 0)
            {
                fileCount--;
                file = Path.GetFileName(filePaths[fileCount]);
                file = file.Replace("*", "");
                bool check = file.Contains(" ");
                bool check2 = file.Contains("_");
                if(check == true)
                {
                    _values = file.Split(' ');
                    if(_values.Length == 3)
                    {
                        _values2 = _values[2].Split('_');
                        companyName = _values[0];
                        i = _values[1];
                        if (_values2.Length == 1)
                        {
                            _values2 = _values[2].Split('.');
                            invoice = _values2[0];
                        }
                        else
                        {
                            invoice = _values2[0];
                        }
                        SqlConnection connection1 = new SqlConnection(connectionString1);
                        connection1.Open();
                        SqlCommand updateCommand = new SqlCommand("select distribution_list from ee_accounts_receivable where company_name= '" + _values[0] + "'", connection1);
                        string dList = (string)updateCommand.ExecuteScalar();
                        connection1.Close();
                        if (i == "I")
                        {
                            bool test = autoFile.Contains(companyName);
                            bool test2 = need2Send.Contains(companyName);
                            bool test3 = need2SendnEmail.Contains(companyName);
                            bool test4 = prepaid.Contains(companyName);
                            bool test5 = _values[2].Contains("S");
                            if (test)
                            {
                                file = companyName + " " + i + " " + invoice + ".pdf";
                                if (File.Exists(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                                {
                                    MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                    duplicateCount++;
                                    duplicates += file;
                                    duplicates += "\r\n";
                                }
                                else if(test5)
                                {
                                    File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                    freeCount++;
                                    freeSamples += file;
                                    freeSamples += "\r\n";
                                }
                                else
                                {
                                    File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                    afCount++;
                                    aFiled += file;
                                    aFiled += "\r\n";
                                }
                            }
                            else if (test2)
                            {
                                file = companyName + " " + i + " " + invoice + ".pdf";
                                if (File.Exists(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                                {
                                    MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                    duplicateCount++;
                                    duplicates += file;
                                    duplicates += "\r\n";
                                }
                                else if (test5)
                                {
                                    File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                    freeCount++;
                                    freeSamples += file;
                                    freeSamples += "\r\n";
                                }
                                else
                                {
                                    File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                    needCount++;
                                    need += file;
                                    need += "\r\n";
                                }
                            }
                            else if (test5)
                            {
                                file = companyName + " " + i + " " + invoice + ".pdf";
                                if (File.Exists(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                                {
                                    MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                    duplicateCount++;
                                    duplicates += file;
                                    duplicates += "\r\n";
                                }
                                else
                                {
                                    File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                    freeCount++;
                                    freeSamples += file;
                                    freeSamples += "\r\n";
                                }
                            }
                            else
                            {
                                file = companyName + " " + i + " " + invoice + ".pdf";
                                if (File.Exists(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                                {
                                    MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                    duplicateCount++;
                                    duplicates += file;
                                    duplicates += "\r\n";
                                }
                                else
                                {
                                    if (dList != null)
                                    {
                                        try
                                        {
                                            File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                            MailMessage mail = new MailMessage();
                                            mail.From = new MailAddress("rlee@empireelect.com");
                                            //mail.From = new MailAddress("apellerito@empireelect.com");
                                            mail.To.Add(dList);
                                            //mail.CC.Add("apellerito@empireelect.com,rlee@empireelect.com");
                                            mail.CC.Add("rlee@empireelect.com");
                                            Attachment data = new Attachment(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                            mail.Attachments.Add(data);
                                            mail.Subject = "Invoice " + companyName + " " + i + " " + invoice;
                                            mail.IsBodyHtml = false;
                                            if (test4)
                                            {
                                                mail.Body = "Invoice attached for your records. The following invoice was prepaid according to CIA terms:\r\n\r\n" + file +
                                                    "\r\n\r\nPlease address inquiries to:\r\n\r\nRusty Lee\r\nAccounts Receivable\r\nrlee@empireelect.com\r\n248-585-8130x286\r\n\r\nFax: 248-585-3686\r\n\r\nEmpire Electronics, Inc.\r\n214 East Maple Road\r\nTroy, MI 48098";
                                                    //"\r\n\r\nAndrea Pellerito\r\nAccounts Receivable\r\nEmpire Electronics, Inc.\r\nP 248-585-8130x271\r\nF 248-585-3686 (sub 271)";
                                            }
                                            else
                                            {
                                                mail.Body = "Please see attached for invoice:\r\n\r\n" + file +
                                                    "\r\n\r\nPlease address inquiries to:\r\n\r\nRusty Lee\r\nAccounts Receivable\r\nrlee@empireelect.com\r\n248-585-8130x286\r\n\r\nFax: 248-585-3686\r\n\r\nEmpire Electronics, Inc.\r\n214 East Maple Road\r\nTroy, MI 48098";
                                            }
                                            SmtpClient theClient = new SmtpClient("192.168.1.33");
                                            theClient.UseDefaultCredentials = false;
                                            System.Net.NetworkCredential theCredential = new System.Net.NetworkCredential("rlee", "Rika1111");
                                            theClient.Credentials = theCredential;
                                            theClient.Send(mail);
                                            if (test3)
                                            {
                                                needsendCount++;
                                                needsend += file;
                                                needsend += "\r\n";
                                            }
                                            else
                                            {
                                                processedCount++;
                                                processed += file;
                                                processed += "\r\n";
                                            }
                                        }
                                        catch (Exception _Exception)
                                        {
                                            MessageBox.Show(_Exception.ToString());
                                        }
                                    }
                                    else
                                    {
                                        if (File.Exists(@"G:\Accounts Receivable\Invoices\Exceptions\" + file))
                                        {
                                            MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                            duplicateCount++;
                                            duplicates += file;
                                            duplicates += "\r\n";
                                        }
                                        else
                                        {
                                            File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\Exceptions\" + file);
                                            exceptionCount++;
                                            exceptions += file;
                                            exceptions += "\r\n";
                                        }
                                    }
                                }
                            }
                        }
                        else if (i == "C")
                        {
                            bool test5 = _values[2].Contains("S");
                            if (companyName == "GMP")
                            {
                                file = companyName + " " + i + " " + invoice + ".pdf";
                                if (File.Exists(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                                {
                                    MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                    duplicateCount++;
                                    duplicates += file;
                                    duplicates += "\r\n";
                                }
                                else if (test5)
                                {
                                    file = companyName + " " + i + " " + invoice + ".pdf";
                                    if (File.Exists(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                                    {
                                        MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                        duplicateCount++;
                                        duplicates += file;
                                        duplicates += "\r\n";
                                    }
                                    else
                                    {
                                        File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                        freeCount++;
                                        freeSamples += file;
                                        freeSamples += "\r\n";
                                    }
                                }
                                else
                                {
                                    bool test3 = need2SendnEmail.Contains(companyName);
                                    bool test4 = prepaid.Contains(companyName);
                                    if (dList != null)
                                    {
                                        try
                                        {
                                            File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                            MailMessage mail = new MailMessage();
                                            mail.From = new MailAddress("rlee@empireelect.com");
                                            mail.To.Add(dList);
                                            //mail.CC.Add("apellerito@empireelect.com,rlee@empireelect.com");
                                            mail.CC.Add("rlee@empireelect.com");
                                            Attachment data = new Attachment(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                            mail.Attachments.Add(data);
                                            mail.Subject = "Invoice " + companyName + " " + i + " " + invoice;
                                            mail.IsBodyHtml = false;
                                            if (test4)
                                            {
                                                mail.Body = "Invoice attached for your records. The following invoice was prepaid according to CIA terms:\r\n\r\n" + file +
                                                    "\r\n\r\nPlease address inquiries to:\r\n\r\nRusty Lee\r\nAccounts Receivable\r\nrlee@empireelect.com\r\n248-585-8130x286\r\n\r\nFax: 248-585-3686\r\n\r\nEmpire Electronics, Inc.\r\n214 East Maple Road\r\nTroy, MI 48098";
                                            }
                                            else
                                            {
                                                mail.Body = "Please see attached for invoice:\r\n\r\n" + file +
                                                    "\r\n\r\nPlease address inquiries to:\r\n\r\nRusty Lee\r\nAccounts Receivable\r\nrlee@empireelect.com\r\n248-585-8130x286\r\n\r\nFax: 248-585-3686\r\n\r\nEmpire Electronics, Inc.\r\n214 East Maple Road\r\nTroy, MI 48098";
                                            }
                                            SmtpClient theClient = new SmtpClient("192.168.1.33");
                                            theClient.UseDefaultCredentials = false;
                                            //System.Net.NetworkCredential theCredential = new System.Net.NetworkCredential("apellerito", "Eggplant15");
                                            System.Net.NetworkCredential theCredential = new System.Net.NetworkCredential("rlee", "Rika1111");
                                            theClient.Credentials = theCredential;
                                            theClient.Send(mail);
                                            if (test3)
                                            {
                                                needsendCount++;
                                                needsend += file;
                                                needsend += "\r\n";
                                            }
                                            else
                                            {
                                                processedCount++;
                                                processed += file;
                                                processed += "\r\n";
                                            }
                                        }
                                        catch (Exception _Exception)
                                        {
                                            MessageBox.Show(_Exception.ToString());
                                        }
                                    }
                                    else
                                    {
                                        if (File.Exists(@"G:\Accounts Receivable\Invoices\Exceptions\" + file))
                                        {
                                            MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                            duplicateCount++;
                                            duplicates += file;
                                            duplicates += "\r\n";
                                        }
                                        else
                                        {
                                            File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\Exceptions\" + file);
                                            exceptionCount++;
                                            exceptions += file;
                                            exceptions += "\r\n";
                                        }
                                    }
                                }
                            }
                            else
                            {
                                file = companyName + " " + i + " " + invoice + ".pdf";
                                if (File.Exists(@"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                                {
                                    MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                    duplicateCount++;
                                    duplicates += file;
                                    duplicates += "\r\n";
                                }
                                else
                                {
                                    File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                                    creditCount++;
                                    credits += file;
                                    credits += "\r\n";
                                }
                            }
                        }
                        else
                        {
                            if (File.Exists(@"G:\Accounts Receivable\Invoices\Exceptions\" + file))
                            {
                                MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                                duplicateCount++;
                                duplicates += file;
                                duplicates += "\r\n";
                            }
                            else
                            {
                                File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\Exceptions\" + file);
                                exceptionCount++;
                                exceptions += file;
                                exceptions += "\r\n";
                            }
                        }
                    }
                    else
                    {
                        if (File.Exists(@"G:\Accounts Receivable\Invoices\Exceptions\" + file))
                        {
                            MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                            duplicateCount++;
                            duplicates += file;
                            duplicates += "\r\n";
                        }
                        else
                        {
                            File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\Exceptions\" + file);
                            exceptionCount++;
                            exceptions += file;
                            exceptions += "\r\n";
                        }
                    }
                }
                else
                {
                    if (File.Exists(@"G:\Accounts Receivable\Invoices\Exceptions\" + file))
                    {
                        MessageBox.Show("Invoice has already been filed. " + file + " will be left in the Scans folder");
                        duplicateCount++;
                        duplicates += file;
                        duplicates += "\r\n";
                    }
                    else
                    {
                        File.Move(filePaths[fileCount], @"G:\Accounts Receivable\Invoices\Exceptions\" + file);
                        exceptionCount++;
                        exceptions += file;
                        exceptions += "\r\n";
                    }
                }
            }
            try
            {
                MailMessage mail2 = new MailMessage();
                mail2.From = new MailAddress("empire@empireelect.com");
                //mail2.To.Add("apellerito@empireelect.com,rlee@empireelect.com");
                mail2.To.Add("rlee@empireelect.com");
                mail2.Subject = "Total Invoice Count";
                mail2.IsBodyHtml = false;
                mail2.Body = "Total number of invoices in Scans folder = " + totalFiles + ".\r\nTotal number of invoices moved to exception folder = " +
                    exceptionCount + ".\r\n" + exceptions + "\r\n\r\nInvoices that have been filed but still need to be sent out = " + needCount + ".\r\n" +
                    need + "\r\n\r\nInvoices that have been filed and emailed but still need to be sent out = " + needsendCount + ".\r\n" + needsend +
                    "\r\n\r\nDuplicates that have been left in the Scans folder = " + duplicateCount + ".\r\n" + duplicates +
                    "\r\n\r\nTotal number of invoices emailed and filed = " + processedCount + ".\r\n" + processed +
                    "\r\n\r\nInvoices that have been filed automatically = " + afCount + ".\r\n" + aFiled +
                    "\r\n\r\nCredit Memos that have been filed automatically = " + creditCount + ".\r\n" + credits +
                    "\r\n\r\nFree Samples that have been filed automatically = " + freeCount + ".\r\n" + freeSamples;
                SmtpClient theClient2 = new SmtpClient("192.168.1.33");
                theClient2.UseDefaultCredentials = false;
                System.Net.NetworkCredential theCredential2 = new System.Net.NetworkCredential("empire", "email.123");
                theClient2.Credentials = theCredential2;
                theClient2.Send(mail2);

                MessageBox.Show("All invoices have been processed.");
            }
            catch (Exception _Exception)
            {
                MessageBox.Show(_Exception.ToString());
            }

        }

        private void button2_Click(object sender, EventArgs e)
        {
            string connectionString1 = "";
            XmlTextReader reader = new XmlTextReader(@"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\ARDistributionList\Program.xml");
            while (reader.Read())
            {
                if (reader.Name == "connectionString")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        connectionString1 = reader.Value;
                    }
                }
            }
            if (textBox1.Text == "")
            {
                MessageBox.Show("You did not enter a company name. Please enter one now.");
            }
            else if (textBox2.Text == "")
            {
                MessageBox.Show("You did not enter a distribution list. Please enter one now.");
            }
            else
            {
                bool check = textBox2.Text.Contains(";");
                if (check == true)
                {
                    MessageBox.Show("The distribution list you have entered is invalid. Email addresses should be seperated by a comma not a semi-colon!");
                }
                else
                {
                    try
                    {
                        SqlConnection connection1 = new SqlConnection(connectionString1);
                        connection1.Open();
                        SqlCommand selectCommand = new SqlCommand("select distribution_list from ee_accounts_receivable where company_name= '" + textBox1.Text + "'", connection1);
                        string dList = (string)selectCommand.ExecuteScalar();
                        connection1.Close();
                        if (dList != null)
                        {
                            MessageBox.Show("The company name you entered already exists!");
                        }
                        else
                        {
                            string company = textBox1.Text;
                            string distributionList = textBox2.Text;
                            SqlConnection connection2 = new SqlConnection(connectionString1);
                            connection2.Open();
                            SqlCommand insertCommand = new SqlCommand("insert into ee_accounts_receivable (company_name, distribution_list) values ('" + company +
                                "','" + distributionList + "')", connection2);
                            insertCommand.ExecuteNonQuery();
                            connection2.Close();
                            MessageBox.Show("Distribution list was added successfully.");
                            textBox1.Text = "";
                            textBox2.Text = "";
                            this.ee_accounts_receivableTableAdapter.Fill(this.mONITORDataSet.ee_accounts_receivable);
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
        }

        private void dataGridView1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Alt && (e.KeyCode == Keys.Down || e.KeyCode == Keys.Up))
            {
                DataGridViewAutoFilterColumnHeaderCell filterCell =
                    this.dataGridView1.CurrentCell.OwningColumn.HeaderCell as
                    DataGridViewAutoFilterColumnHeaderCell;
                if (filterCell != null)
                {
                    filterCell.ShowDropDownList();
                    e.Handled = true;
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string connectionString1 = "";
            XmlTextReader reader = new XmlTextReader(@"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\ARDistributionList\Program.xml");
            while (reader.Read())
            {
                if (reader.Name == "connectionString")
                {
                    reader.Read();
                    if (reader.Value.Length > 2)
                    {
                        connectionString1 = reader.Value;
                    }
                }
            }
            if (button3.Text == "Look Up List")
            {
                SqlConnection connection1 = new SqlConnection(connectionString1);
                connection1.Open();
                SqlCommand selectCommand = new SqlCommand("select distribution_list from ee_accounts_receivable where company_name= '" + textBox3.Text + "'", connection1);
                string dList = (string)selectCommand.ExecuteScalar();
                connection1.Close();
                if (dList == null)
                {
                    MessageBox.Show("This company name does not exist in database. Please check your spelling and try again.");
                }
                else
                {
                    MessageBox.Show("Please edit the distribution list.");
                    textBox4.Visible = true;
                    textBox4.Enabled = true;
                    label4.Visible = true;
                    textBox4.Text = dList;
                    textBox3.Enabled = false;
                    button3.Text = "Update List";
                }
            }
            else if (button3.Text == "Update List")
            {
                bool check = textBox4.Text.Contains(";");
                if (check == true)
                {
                    MessageBox.Show("The distribution list you have entered is invalid. Email addresses should be seperated by a comma not a semi-colon!");
                }
                else
                {
                    try
                    {
                        SqlConnection connection1 = new SqlConnection(connectionString1);
                        connection1.Open();
                        SqlCommand updateCommand = new SqlCommand("update ee_accounts_receivable set distribution_list='" + textBox4.Text + "' where company_name ='" + textBox3.Text + "'", connection1);
                        updateCommand.ExecuteNonQuery();
                        connection1.Close();
                        MessageBox.Show("Distribution list has been updated successfully!");
                        button3.Text = "Look Up List";
                        textBox4.Visible = false;
                        textBox4.Enabled = false;
                        label4.Visible = false;
                        textBox4.Text = "";
                        textBox3.Text = "";
                        textBox3.Enabled = true;
                        this.ee_accounts_receivableTableAdapter.Fill(this.mONITORDataSet.ee_accounts_receivable);
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
            else
            {
                MessageBox.Show("Error has occurred, please restart the program.");
            }
        }

        private void btnMoveFromOk_Click(object sender, EventArgs e)
        {
            AutoFileFromOkToFile();
        }

        private void AutoFileFromOkToFile()
        {
            string[] filePaths = Directory.GetFiles(@"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\Invoices\Scans\OK TO FILE", "*.pdf");
            string file;
            string[] _values;
            string companyName;
            string i;
            int fileCount = filePaths.Length;

            while (fileCount != 0)
            {
                fileCount--;
                file = Path.GetFileName(filePaths[fileCount]);
                file = file.Replace("*", "");
                bool check = file.Contains(" ");

                if (check)
                {
                    _values = file.Split(' ');
                    companyName = _values[0];
                    i = _values[1];

                    if (i != "I" && i != "C")
                    {
                        MessageBox.Show(String.Format("Only invoices (I) or credit memos (C) are valid.  Also make sure only single spaces are used in this name:  {0}.  File will be left in the OK TO FILE folder.", file), "Alert");
                        return;
                    }

                    if (!Directory.Exists(@"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\Invoices\" + companyName))
                    {
                        MessageBox.Show(String.Format("A folder does not exist for {0}.  {1} will be left in the OK TO FILE folder.", companyName, file), "Alert");
                        return;
                    }

                    if (File.Exists(@"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\Invoices\" + companyName + @"\" + file))
                    {
                        // Determine which file is more current
                        FileInfo sourceLocationFile= new FileInfo(filePaths[fileCount]);
                        FileInfo destLocationFile = new FileInfo(@"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\Invoices\" + companyName + @"\" + file);

                        if (sourceLocationFile.LastWriteTime > destLocationFile.LastWriteTime)
                        {
                            try
                            {
                                // Replace file in the customer's folder with the newer one 
                                File.Copy(sourceLocationFile.FullName, destLocationFile.FullName, true);
                                sourceLocationFile.Delete();
                            }
                            catch (Exception)
                            {
                                MessageBox.Show(String.Format("An unexpected error occured when attempting to copy file {0}.", sourceLocationFile.Name), "Error");
                            }
                        }
                        else
                        {
                            // Delete older file
                            sourceLocationFile.Delete();
                        }
                    }
                    else
                    {
                        try
                        {
                            File.Move(filePaths[fileCount],
                                  @"\\SRVDATA1\Data\ACCTNG\Accounts Receivable\Invoices\" + companyName + @"\" + file);
                        }
                        catch (Exception)
                        {
                            MessageBox.Show(String.Format("An unexpected error occured when attempting to move file {0}.", filePaths[fileCount]), "Error");
                        }
                    }
                }
            }
            MessageBox.Show("Transfer complete.", "Message");
        }


    }
}

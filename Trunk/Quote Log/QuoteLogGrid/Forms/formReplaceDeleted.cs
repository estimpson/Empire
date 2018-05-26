using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuoteLogGrid.Interfaces;
using QuoteLogData.Models;
using DevExpress.Data.Linq;
using System.Data.Objects;
using System.Data.Entity;

namespace QuoteLogGrid.Forms
{
    public partial class formReplaceDeleted : Form
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        public string SelectedReplacementValue { get; private set; } 

        public formReplaceDeleted(Enum setupType, string deleted)
        {
            InitializeComponent();

            switch (setupType.ToString())
            {
                case "Customer":
                    GetCustomers(deleted);
                    break;
                case "Applications":
                    GetApplications(deleted);
                    break;
                case "Function":
                    GetFunctions(deleted);
                    break;
            }
        }

        private void GetCustomers(string deletedCustomer)
        {
            // Query the entity model to retrieve the customer list 
            //  excluding the one that is to be deleted
            var query = (from c in Context.Customers
                         where c.CustomerCode != deletedCustomer
                         select c);
            if (query.Count() == 0) return;

            // Pull data from the DbSet so that it will be ready for the listbox control
            var x = query.ToArray()[0].CustomerCode;

            // Bind the listbox to a local view of the entity
            lbxControl.DataSource = Context.Customers.Local.ToBindingList();
            lbxControl.DisplayMember = "CustomerCode";
            lbxControl.ValueMember = "CustomerCode";
        }

        private void GetApplications(string deletedAppCode)
        {
            // Query the entity model to retrieve the customer list 
            //  excluding the one that is to be deleted
            var query = (from a in Context.Applications
                         where a.ApplicationCode != deletedAppCode
                         select a);
            if (query.Count() == 0) return;

            // Pull data from the DbSet so that it will be ready for the listbox control
            var x = query.ToArray()[0].ApplicationCode;

            // Bind the listbox to a local view of the entity
            lbxControl.DataSource = Context.ApplicationNames.Local.ToBindingList();
            lbxControl.DisplayMember = "ApplicationCode";
            lbxControl.ValueMember = "ApplicationCode";
        }

        private void GetFunctions(string deletedFunction)
        {
            // Query the entity model to retrieve the customer list 
            //  excluding the one that is to be deleted
            var query = (from f in Context.vw_QT_Functions
                         where f.FunctionCode != deletedFunction
                         select f);
            if (query.Count() == 0) return;

            // Pull data from the DbSet so that it will be ready for the listbox control
            var x = query.ToArray()[0].FunctionCode;

            // Bind the listbox to a local view of the entity
            lbxControl.DataSource = Context.vw_QT_Functions.Local.ToBindingList();
            lbxControl.DisplayMember = "FunctionCode";
            lbxControl.ValueMember = "FunctionCode";
        }


        private void btnOK_Click(object sender, EventArgs e)
        {
            SelectedReplacementValue = lbxControl.SelectedValue.ToString();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }




    }
}

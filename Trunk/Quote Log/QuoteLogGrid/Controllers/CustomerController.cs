using System;
using System.Data.Objects;
using QuoteLogData.Models;
using System.Collections.Generic;
using QuoteLogGrid.Forms;

namespace QuoteLogGrid.Controllers
{
    public class CustomerController
    {
        formCustomer _view; 

        public String Error { get; private set; }
        public String OperatorCode { get; set; }

        public int FormState { get; set; }


        private String _customerCode;
        public String CustomerCode
        {
            get { return _customerCode; }
            set { _customerCode = _view.tbxCode.Text = _view.cbxCode.Text = value; }
        }

        private String _customerName;
        public String CustomerName
        {
            get { return _customerName; }
            set { _customerName = _view.tbxName.Text = value; }
        }

        private String _address1;
        public String Address1
        {
            get { return _address1; }
            set { _address1 = _view.tbxAddress1.Text = value; }
        }

        private String _address2;
        public String Address2
        {
            get { return _address2; }
            set { _address2 = _view.tbxAddress2.Text = value; }
        }

        private String _address3;
        public String Address3
        {
            get { return _address3; }
            set { _address3 = _view.tbxAddress3.Text = value; }
        }

        private String _city;
        public String City
        {
            get { return _city; }
            set { _city = _view.tbxCity.Text = value; }
        }

        private String _state;
        public String State
        {
            get { return _state; }
            set { _state = _view.cbxState.Text = value; }
        }

        private String _country;
        public String Country
        {
            get { return _country; }
            set { _country = _view.tbxCountry.Text = value; }
        }

        private String _postalCode;
        public String PostalCode
        {
            get { return _postalCode; }
            set { _postalCode = _view.tbxPostalCode.Text = value; }
        }

        private String _terms;
        public String Terms
        {
            get { return _terms; }
            set { _terms = _view.cbxTerms.Text = value; }
        }

        private String _ltaType;
        public String LtaType
        {
            get { return _ltaType; }
            set { _ltaType = _view.cbxLtaType.Text = value; }
        }


        public List<String> CustomerCodesList = new List<string>();
        public List<String> TermsList = new List<string>();
        public List<String> LtasList = new List<string>();
        public List<String> StatesList = new List<string>();



        public CustomerController(formCustomer view)
        {
            _view = view;

            GetStates();
            if (Error == "") GetTerms();
            if (Error == "") GetLtaTypes();

            _view.tbxCountry.Text = "USA";
            FormState = 1;
        }



        public void GetCodes()
        {
            Error = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            CustomerCodesList.Clear();
            CustomerCodesList.Add("");
            try
            {
                using (var context = new QuoteLogContext())
                {
                    var collection = context.usp_QT_Customer_Codes_Get();
                    foreach(var item in collection) CustomerCodesList.Add(item.CustomerCode);

                    _view.cbxCode.DataSource = CustomerCodesList;
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) 
                    ? "Failed to return customer codes. " + ex.InnerException.Message 
                    : "Failed to return customer codes. " + ex.Message;
            }
        }

        public void GetStates()
        {
            Error = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            StatesList.Clear();
            StatesList.Add("");
            try
            {
                using (var context = new QuoteLogContext())
                {
                    var collection = context.usp_QT_Customer_States_Get();
                    foreach (var item in collection) StatesList.Add(item.Abbreviation);

                    _view.cbxState.DataSource = StatesList;
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) 
                    ? "Failed to return states. " + ex.InnerException.Message 
                    : "Failed to return states. " + ex.Message;
            }
        }

        public void GetTerms()
        {
            Error = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            TermsList.Clear();
            TermsList.Add("");
            try
            {
                using (var context = new QuoteLogContext())
                {
                    var collection = context.usp_QT_Customer_Terms_Get();
                    foreach (var item in collection) TermsList.Add(item.Term);

                    _view.cbxTerms.DataSource = TermsList;
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) 
                    ? "Failed to return terms. " + ex.InnerException.Message 
                    : "Failed to return terms. " + ex.Message;
            }
        }

        public void GetLtaTypes()
        {
            Error = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            LtasList.Clear();
            LtasList.Add("");
            try
            {
                using (var context = new QuoteLogContext())
                {
                    var collection = context.usp_QT_Customer_LtaTypes_Get();
                    foreach (var item in collection) LtasList.Add(item.LtaType);

                    _view.cbxLtaType.DataSource = LtasList;
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) 
                    ? "Failed to return LTA types. " + ex.InnerException.Message 
                    : "Failed to return LTA types. " + ex.Message;
            }
        }

        public void GetCustomer()
        {
            Error = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                using (var context = new QuoteLogContext())
                {
                    var collection = context.usp_QT_Customer_Get(_view.cbxCode.Text);
                    foreach(var item in collection)
                    {
                        _view.tbxName.Text = item.CustomerName;
                        _view.tbxAddress1.Text = item.Address1;
                        _view.tbxAddress2.Text = item.Address2;
                        _view.tbxAddress3.Text = item.Address3;
                        _view.tbxCity.Text = item.City;
                        _view.cbxState.Text = item.State;
                        _view.tbxCountry.Text = item.Country;
                        _view.tbxPostalCode.Text = item.PostalCode;
                        _view.cbxTerms.Text = item.Terms;
                        _view.cbxLtaType.Text = item.LtaType;
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void ToggleForm()
        {
            if (FormState == 1) // New customer
            {
                _view.cbxCode.Visible = false;
                _view.tbxCode.Visible = true;

                _view.pnlEdit.Enabled = true;
            }
            else // Editing existing customer
            {
                _view.cbxCode.Visible = true;
                _view.tbxCode.Visible = false;

                _view.pnlEdit.Enabled = false;

                GetCodes();
            }
        }

        public int ValidateForm()
        {
            OperatorCode = _view.tbxOperator.Text.Trim();

            CustomerCode = (FormState == 1)
                ? _view.tbxCode.Text.Trim().ToUpper()
                : _view.cbxCode.Text;

            CustomerName = _view.tbxName.Text.Trim();
            Address1 = _view.tbxAddress1.Text.Trim();
            Address2 = _view.tbxAddress2.Text.Trim();
            Address3 = _view.tbxAddress3.Text.Trim();
            City = _view.tbxCity.Text.Trim();
            State = _view.cbxState.Text;
            Country = _view.tbxCountry.Text.Trim();
            PostalCode = _view.tbxPostalCode.Text.Trim();
            Terms = _view.cbxTerms.Text;
            LtaType = _view.cbxLtaType.Text;

            if (CustomerCode == "") _view.lblCodeReq.Visible = true;
            if (CustomerName == "") _view.lblNameReq.Visible = true;
            if (Address1 == "") _view.lblAddress1Req.Visible = true;
            if (Terms == "") _view.lblTermsReq.Visible = true;
            if (LtaType == "") _view.lblLtaTypeReq.Visible = true;

            if (CustomerCode == "" || CustomerName == "" || Address1 == "" || Terms == "" || LtaType == "") return 0;

            return 1;
        }

        public void InsertCustomer()
        {
            Error = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                using (var context = new QuoteLogContext())
                {
                    context.usp_QT_Customer_Insert(OperatorCode, CustomerCode, CustomerName, Address1, Address2, Address3, City, State, Country, PostalCode, Terms, LtaType,
                    tranDt, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) 
                    ? "Failed to save the customer. " + ex.InnerException.Message 
                    : "Failed to save the customer. " + ex.Message;
            }
        }

        public void UpdateCustomer()
        {
            Error = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                using (var context = new QuoteLogContext())
                {
                    context.usp_QT_Customer_Update(OperatorCode, CustomerCode, CustomerName, Address1, Address2, Address3, City, State, Country, PostalCode, Terms, LtaType,
                    tranDt, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) 
                    ? "Failed to update the customer. " + ex.InnerException.Message 
                    : "Failed to update the customer. " + ex.Message;
            }
        }

        public void SendEmail()
        {
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                using (var context = new QuoteLogContext())
                {
                    context.usp_QT_Customer_Request_SendEmail(CustomerCode, tranDt, result);
                }
            }
            catch (Exception)
            {
            }
        }

        public void ClearForm()
        {
            CustomerCode = CustomerName = Address1 = Address2 = Address3 = City = State = Country = PostalCode = Terms = LtaType = "";

            _view.lblCodeReq.Visible = _view.lblNameReq.Visible = _view.lblAddress1Req.Visible = _view.lblTermsReq.Visible = _view.lblLtaTypeReq.Visible = false;
        }


    }
}

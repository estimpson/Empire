using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity.Core.Objects;
using DevExpress.Utils.OAuth.Provider;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.DataModels;

namespace WebPortal.NewSalesAward.PageViewModels
{
    [Serializable]
    public class CreateAwardedQuoteViewModel
    {
        #region Properties

        public string OperatorCode => HttpContext.Current.Session["OpCode"].ToString();
        public String QuoteNumber { get; set; }
        public DateTime? AwardDate { get; set; }
        public String FormOfCommitment { get; set; }
        public String QuoteReason { get; set; }
        public String ReplacingBasePart { get; set; }
        public String Salesperson { get; set; }
        public String ProgramManager { get; set; }
        public String Comments { get; set; }
        public String QuotedEau { get; set; }
        public String QuotedPrice { get; set; }
        public String QuotedMaterialCost { get; set; }
        public String Error { get; private set; }

        #endregion

        public List<String> QuoteNumberList = new List<String>();


        #region Methods

        public void GetQuoteLog()
        {
            Error = "";
            QuoteNumberList.Clear();
            QuoteNumberList.Add("");

            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = from ql in context.QuoteLogs
                                select ql;

                    foreach (var result in query) QuoteNumberList.Add(result.QuoteNumber);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void GetAwardedQuoteDetails()
        {
            ObjectParameter awardDate = new ObjectParameter("AwardDate", typeof(DateTime?));
            ObjectParameter formOfCommitment = new ObjectParameter("FormOfCommitment", typeof(string));
            //ObjectParameter quoteReason = new ObjectParameter("QuoteReason", typeof(Int16?));
            ObjectParameter quoteReason = new ObjectParameter("QuoteReason", typeof(string));
            ObjectParameter replacingBasePart = new ObjectParameter("ReplacingBasePart", typeof(string));
            ObjectParameter salesperson = new ObjectParameter("Salesperson", typeof(string));
            ObjectParameter programManager = new ObjectParameter("ProgramManager", typeof(string));
            ObjectParameter comments = new ObjectParameter("Comments", typeof(string));
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;
            Error = "";

            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_GetAwardedQuoteDetails(QuoteNumber, awardDate, formOfCommitment, quoteReason, replacingBasePart, salesperson, programManager, comments, tranDT, result, debug, debugMsg);

                    if (awardDate.Value != DBNull.Value) AwardDate = Convert.ToDateTime(awardDate.Value);
                    FormOfCommitment = formOfCommitment.Value.ToString();
                    //if (quoteReason.Value != DBNull.Value) QuoteReason = Convert.ToByte(quoteReason.Value);
                    QuoteReason = quoteReason.Value.ToString();
                    ReplacingBasePart = replacingBasePart.Value.ToString();
                    Salesperson = salesperson.Value.ToString();
                    ProgramManager = programManager.Value.ToString();
                    Comments = comments.Value.ToString();
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public List<SalespersonDataModel> GetSalespeople()
        {
            Error = "";
            var list = new List<SalespersonDataModel>();

            var empty = new SalespersonDataModel { UserCode = "", UserName = "", UserInitials = "", EmailAddress = "" };
            list.Add(empty);

            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = from s in context.Salespeoples
                                orderby s.UserName ascending
                                select s;

                    foreach (var result in query)
                    {
                        var salesPerson = new SalespersonDataModel();
                        salesPerson.UserCode = result.UserCode;
                        salesPerson.UserName = result.UserName;
                        salesPerson.UserInitials = result.UserInitials;
                        salesPerson.EmailAddress = result.EmailAddress;
                        list.Add(salesPerson);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return list;
        }

        public List<ProgramManagerDataModel> GetProgramManagers()
        {
            Error = "";
            var list = new List<ProgramManagerDataModel>();

            var empty = new ProgramManagerDataModel { UserCode = "", UserName = "", UserInitials = "", EmailAddress = "" };
            list.Add(empty);

            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = from pm in context.ProgramManagers
                                orderby pm.UserName ascending
                                select pm;

                    foreach (var result in query)
                    {
                        var programManager = new ProgramManagerDataModel();
                        programManager.UserCode = result.UserCode;
                        programManager.UserName = result.UserName;
                        programManager.UserInitials = result.UserInitials;
                        programManager.EmailAddress = result.EmailAddress;
                        list.Add(programManager);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return list;
        }

        public List<QuoteReasonDataModel> GetQuoteReasons()
        {
            Error = "";
            var list = new List<QuoteReasonDataModel>();

            var empty = new QuoteReasonDataModel { QuoteReasonId = 0, QuoteReason = "" };
            list.Add(empty);

            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = from qr in context.QuoteReasons
                                orderby qr.QuoteReason1 ascending
                                select qr;

                    foreach (var result in query)
                    {
                        var quoteReason = new QuoteReasonDataModel();
                        quoteReason.QuoteReasonId = result.QuoteReasonID;
                        quoteReason.QuoteReason = result.QuoteReason1;
                        list.Add(quoteReason);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return list;
        }

        public List<CustomerCommitmentFormDataModel> GetCustomerCommitmentForms()
        {
            Error = "";
            var list = new List<CustomerCommitmentFormDataModel>();

            var empty = new CustomerCommitmentFormDataModel { FormOfcommitment = "" };
            list.Add(empty);

            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = from ccf in context.CustomerCommitmentForms
                                orderby ccf.FormOfCommitment ascending
                                select ccf;

                    foreach (var result in query)
                    {
                        var customerCommitmentForm = new CustomerCommitmentFormDataModel();
                        customerCommitmentForm.FormOfcommitment = result.FormOfCommitment;
                        list.Add(customerCommitmentForm);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return list;
        }

        public List<ActiveBasePartDataModel> GetActiveBaseParts()
        {
            Error = "";
            var list = new List<ActiveBasePartDataModel>();

            var empty = new ActiveBasePartDataModel { BasePart = "" };
            list.Add(empty);

            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = from abp in context.ActiveBaseParts
                                orderby abp.BasePart ascending
                                select abp;

                    foreach (var result in query)
                    {
                        var activeBasePart = new ActiveBasePartDataModel();
                        activeBasePart.BasePart = result.BasePart;
                        list.Add(activeBasePart);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return list;
        }

        public void CreateAwardedQuote()
        {
            Error = "";

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_CreateAwardedQuote(OperatorCode, QuoteNumber, AwardDate, FormOfCommitment, QuoteReason, ReplacingBasePart, Salesperson, ProgramManager, Comments, tranDT, result, debug, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void FixAwardedQuote(string oldQuoteNumber, string newQuoteNumber)
        {
            Error = "";

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_AwardedQuote_ChangeQuoteNumber(OperatorCode, oldQuoteNumber, newQuoteNumber, tranDT, result, debug, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity.Core.Objects;
using WebPortal.QuoteLogIntegration.Models;
using WebPortal.QuoteLogIntegration.DataModels;

namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    [Serializable]
    public class QtSignOffViewModel
    {
        public String OperatorCode { get; set; }
        public String Error { get; private set; }

        public List<String> QuoteEngineerList;
        public List<String> MaterialRepList;
        public List<String> ProductEngineerList;
        public List<String> ProgramManagerList;

        public List<QtSignOffDataModel> SignOffList;

        public List<QtSignOffEmployees> SignOffEmployeesList;


        #region Constructor

        public QtSignOffViewModel()
        {
        }

        #endregion


        #region Methods

        public void GetEmployees()
        {
            Error = "";

            try
            {
                SignOffEmployeesList = new List<QtSignOffEmployees>();
                QtSignOffEmployees dataModel;

                using (var context = new NewSalesAward.Models.FxPLMEntities())
                {
                    var query = (from u in context.Users
                                 orderby u.UserName
                                 select u);

                    foreach (var item in query)
                    {
                        dataModel = new QtSignOffEmployees();
                        dataModel.Initials = item.Initials;
                        dataModel.EmployeeCode = item.UserCode;
                        dataModel.EmployeeName = item.UserName;

                        SignOffEmployeesList.Add(dataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public string GetEmployeeInitials(string employeeCode)
        {
            Error = "";
            string initials = "";

            try
            {
                using (var context = new NewSalesAward.Models.FxPLMEntities())
                {
                    var query = (from u in context.Users
                                 where u.UserCode == employeeCode
                                 select u);

                    foreach (var item in query) initials = item.Initials;
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return initials;
        }

        //public void GetSignOffInitialsQuoteEngineer()
        //{
        //    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
        //    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
        //    Error = "";

        //    QuoteEngineerList = new List<String>();
        //    QuoteEngineerList.Add("");
        //    try
        //    {
        //        using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
        //        {
        //            var collection = context.usp_QL_QuoteTransfer_GetSignOffInitials("QuoteEngineer", tranDT, result);
        //            foreach (var item in collection) QuoteEngineerList.Add(item.Initials);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //    }
        //}

        //public void GetSignOffInitialsMaterialRep()
        //{
        //    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
        //    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
        //    Error = "";

        //    MaterialRepList = new List<String>();
        //    MaterialRepList.Add("");
        //    try
        //    {
        //        using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
        //        {
        //            var collection = context.usp_QL_QuoteTransfer_GetSignOffInitials("MaterialRep", tranDT, result);
        //            foreach (var item in collection) MaterialRepList.Add(item.Initials);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //    }
        //}

        //public void GetSignOffInitialsProductEngineer()
        //{
        //    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
        //    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
        //    Error = "";

        //    ProductEngineerList = new List<String>();
        //    ProductEngineerList.Add("");
        //    try
        //    {
        //        using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
        //        {
        //            var collection = context.usp_QL_QuoteTransfer_GetSignOffInitials("ProductEngineer", tranDT, result);
        //            foreach (var item in collection) ProductEngineerList.Add(item.Initials);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //    }
        //}

        //public void GetSignOffInitialsProgramManager()
        //{
        //    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
        //    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
        //    Error = "";

        //    ProgramManagerList = new List<String>();
        //    ProgramManagerList.Add("");
        //    try
        //    {
        //        using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
        //        {
        //            var collection = context.usp_QL_QuoteTransfer_GetSignOffInitials("ProgramManager", tranDT, result);
        //            foreach (var item in collection) ProgramManagerList.Add(item.Initials);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //    }
        //}

        public void GetSignedOffEmployees()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            string quote = (System.Web.HttpContext.Current.Session["Quote"] != null)
                ? quote = System.Web.HttpContext.Current.Session["Quote"].ToString()
                : "";

            SignOffList = new List<QtSignOffDataModel>();
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    var collection = context.usp_QL_QuoteTransfer_GetSignOff(quote, tranDT, result);
                    foreach (var item in collection)
                    {
                        var dataModel = new QtSignOffDataModel
                        {
                            RowID = item.RowID,
                            Title = item.Title,
                            SignOffDate = item.SignOffDate,
                            EmployeeCode = item.EmployeeCode,
                            EmployeeName = item.EmployeeName,
                            Initials = item.Initials
                        };

                        SignOffList.Add(dataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SignOffInsert()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            string quote = (System.Web.HttpContext.Current.Session["Quote"] != null)
                ? quote = System.Web.HttpContext.Current.Session["Quote"].ToString()
                : "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    context.usp_QL_QuoteTransfer_SignOff_Insert(OperatorCode, quote, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SignOffUpdate(int rowId, string employeeCode, string initials, DateTime? signOffDate)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    context.usp_QL_QuoteTransfer_SignOff_Update(OperatorCode, rowId, employeeCode, initials, signOffDate, tranDT, result);
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
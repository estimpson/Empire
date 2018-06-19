using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using WebPortal.DataModels;
using WebPortal.Models;

namespace WebPortal.PageViewModels
{
    [Serializable]
    public class LoginViewModel
    {
        //private MONITOREntities _context;
        public List<UserWebPagesDataModel> UserWebPagesList = new List<UserWebPagesDataModel>();


        public LoginViewModel()
        {
            //_context = new MONITOREntities();
        }

        public string ValidateOperatorLogin(string operatorCode, string password, out string error)
        {
            string employeeName = "";
            error = "";

            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            using (var context = new MONITOREntities2())
            { 
                try
                {
                    usp_Web_Login_Result result = context.usp_Web_Login(operatorCode, password, tranDt, res, debug, debugMsg).FirstOrDefault();
                    employeeName = result.name;
                }
                catch (Exception ex)
                {
                    error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return employeeName;
        }

        public string GetUserWebPages(string operatorCode)
        {
            string result = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));

            UserWebPagesList.Clear();
            using (var context = new MONITOREntities2())
            {
                try
                {
                    var query = context.usp_Web_GetPages(operatorCode, tranDt, res);
                    foreach (var item in query)
                    {
                        var page = new UserWebPagesDataModel();
                        page.WebPage = item.PageName;
                        page.FilePath = item.FilePath;
                        page.DefaultPage = item.DefaultPage;

                        UserWebPagesList.Add(page);
                    }
                }
                catch (Exception ex)
                {
                    result = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return result;
        }


    }
}
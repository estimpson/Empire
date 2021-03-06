﻿using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using WebPortal.QuoteLogIntegration.Models;
using WebPortal.QuoteLogIntegration.DataModels;
using System.Linq;
using System.Web;
using System.Net;

namespace WebPortal.NewSalesAward.PageViewModels
{
    [Serializable]
    public class DocumentationViewModel
    {
        public String OperatorCode { get; set; }
        public String QuoteFileName { get; private set; }
        public String Error { get; private set; }
        public String FileName { get; private set; }
        public byte[] FileContents { get; private set; }


        #region Constructor

        public DocumentationViewModel()
        {
            OperatorCode = System.Web.HttpContext.Current.Session["OpCode"].ToString();
        }

        #endregion


        #region Methods

        public void ShowQuoteFileInfo(string quote, string attachmentCategory)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = QuoteFileName = "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    var collection = context.usp_QT_FileManagement_Get(quote, attachmentCategory, tranDT, result).ToList();
                    foreach (var item in collection) QuoteFileName = item.FileName;
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void GetQuoteFile(string quote, string attachmentCategory, out string fileName, out byte[] fileContents)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            fileName = "";
            fileContents = null;

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    var collection = context.usp_QT_FileManagement_Get(quote, attachmentCategory, tranDT, result);
                    var item = collection.ToList().First();
                    fileName = item.FileName;
                    fileContents = item.FileContents;
                }
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SaveQuoteFile(string quote, string attachmentCategory, string fileName, byte[] fileContents)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    context.usp_QT_FileManagement_Save(quote, attachmentCategory, fileName, fileContents, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void DeleteQuoteFile(string quote, string attachmentCategory)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    context.usp_QT_FileManagement_Delete(quote, attachmentCategory, tranDT, result);
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
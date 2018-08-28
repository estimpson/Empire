using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using WebPortal.QuoteLogIntegration.Models;
using WebPortal.QuoteLogIntegration.DataModels;
using System.Linq;
using System.Web;

namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    [Serializable]
    public class QtSpecialReqNotesViewModel
    {
        public String OperatorCode { get; set; }
        public String Error { get; private set; }


        public List<QtSpecialReqNotesDataModel> NotesList;
            
                   
        #region Constructor

        public QtSpecialReqNotesViewModel()
        {
        }

        #endregion


        #region Methods

        public void GetSpecialReqNotes()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            string quote = (System.Web.HttpContext.Current.Session["Quote"] != null)
                ? quote = System.Web.HttpContext.Current.Session["Quote"].ToString()
                : "";

            NotesList = new List<QtSpecialReqNotesDataModel>();
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    var collection = context.usp_QL_QuoteTransfer_GetSpecialReqNotes(quote, tranDT, result);
                    foreach(var item in collection)
                    {
                        var dataModel = new QtSpecialReqNotesDataModel {
                            RowID = item.RowID,
                            Description = item.Description,
                            Answer = item.Answer,
                            Notes = item.Notes };

                        NotesList.Add(dataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SpecialReqNotesUpdate(int rowId, string answer, string notes)
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
                    context.usp_QL_QuoteTransfer_SpecialReqNotes_Update(OperatorCode, rowId, answer, notes, tranDT, result);
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
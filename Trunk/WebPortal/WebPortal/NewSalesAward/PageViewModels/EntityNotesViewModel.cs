﻿using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using WebPortal.NewSalesAward.Models;

namespace WebPortal.NewSalesAward.PageViewModels
{
    public class EntityNotesViewModel
    {
        public List<usp_GetEntityNotes_Result> GetEntityNotes(string userCode, string entityURI)
        {
            using (var context = new EntityNotesEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                var debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                return context.usp_GetEntityNotes(userCode, entityURI, tranDT, result, 0, debugMsg).ToList();
            }
        }

        public void AddEntityNote(string userCode, string entityURI, string subjectLine, string body, string referencedURI, string categoryName, int? importanceFlag, int? privacyFlag, int? parentNote)
        {
            using (var context = new EntityNotesEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                var debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                context.usp_AddEntityNote(userCode, entityURI, subjectLine, body, referencedURI,
                    categoryName, importanceFlag, privacyFlag, parentNote, tranDT, result, 0, debugMsg);
            }
        }

        public void AddEntityNote(string userCode, string entityURI, string body)
        {
            AddEntityNote(userCode, entityURI, null, body, null, null, null, 0, null);
        }

        public void ModifyEntityNote(string userCode, string entityURI, int rowID, string subjectLine, string body, string referencedURI, string categoryName, int? importanceFlag, int? privacyFlag)
        {
            using (var context = new EntityNotesEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                var debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                context.usp_ModifyEntityNote(userCode, entityURI, rowID, subjectLine, body,
                    referencedURI, categoryName, importanceFlag, privacyFlag, tranDT, result, 0, debugMsg);
            }
        }

        public void ModifyEntityNote(string userCode, string entityURI, int rowID, string body)
        {
            ModifyEntityNote(userCode, entityURI, rowID, null, body, null, null, null, null);
        }


    }
}
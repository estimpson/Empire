﻿using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using WebPortal.NewSalesAward.Models;

namespace WebPortal.NewSalesAward.PageViewModels
{
    [Serializable]
    public class CsmDemandViewModel
    {
        public string OperatorCode => HttpContext.Current.Session["OpCode"].ToString();
        public List<usp_GetAwardedQuoteCSMData_Result> CSMDataList;
        public string Error { get; private set; }


        #region Constructor

        #endregion



        #region Methods

        public List<usp_GetAwardedQuoteCSMData_Result> GetAwardedQuoteCSMData(string quote)
        {
            if (CSMDataList != null) return CSMDataList;
            CSMDataList = new List<usp_GetAwardedQuoteCSMData_Result>();
            using (var context = new FxPLMEntities())
            {
                CSMDataList = context.usp_GetAwardedQuoteCSMData(quote).ToList();
            }

            return CSMDataList;
        }

        public string GetActiveMnemonics(string quote)
        {
            var mnemonics = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    var collection = context.usp_GetAwardedQuoteActiveMnemonics(quote);
                    foreach (var item in collection) mnemonics = item;
                }
            }
            catch (Exception ex)
            {
                Error = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
            }

            return mnemonics;
        }

        //public void GetCsmData()
        //{
        //    CsmDataList = new List<CsmDemandDataModel>();

        //    Error = "";
        //    try
        //    {
        //        using (var context = new FxPLMEntities())
        //        {
        //            var query = (from c in context.CSMDatas
        //            select c);

        //            foreach (var item in query)
        //            {
        //                var dataModel = new CsmDemandDataModel
        //                {
        //                    VehiclePlantMnemonic = item.VehiclePlantMnemonic,
        //                    Platform = item.Platform,
        //                    Program = item.Program,
        //                    Vehicle = item.Vehicle,
        //                    Manufacturer = item.Manufacturer,
        //                    SourcePlant = item.SourcePlant,
        //                    SourcePlantCountry = item.SourcePlantCountry,
        //                    SourcePlantRegion = item.SourcePlantRegion,
        //                    CsmSop = item.CSM_SOP,
        //                    CsmEop = item.CSM_EOP
        //                };
        //                CsmDataList.Add(dataModel);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //    }
        //}

        public List<usp_GetAwardedQuoteBasePartMnemonic_Result> GetAwardedQuoteBasePartMnemonic(string quote,
            string mnemonic)
        {
            var list = new List<usp_GetAwardedQuoteBasePartMnemonic_Result>();
            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    list = context.usp_GetAwardedQuoteBasePartMnemonic(quote, mnemonic).ToList();
                }
            }
            catch (Exception ex)
            {
                Error = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
            }

            return list;
        }

        public void AssignCsmMnemonic(string quote, string mnemonic, decimal? qtyPer, decimal? takeRate,
            decimal? familyAllocation)
        {
            var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            var result = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetBasePartMnemonic(OperatorCode, quote, mnemonic, qtyPer, takeRate, familyAllocation,
                        tranDT, result, 0, debugMsg);
                    CSMDataList = new List<usp_GetAwardedQuoteCSMData_Result>();
                    CSMDataList = context.usp_GetAwardedQuoteCSMData(quote).ToList();
                }
            }
            catch (Exception ex)
            {
                Error = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
            }
        }

        public void RemoveCsmMnemonic(string quote, string mnemonic)
        {
            var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            var result = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_RemoveBasePartMnemonic(quote, mnemonic, tranDT, result, 0, debugMsg);
                    CSMDataList = new List<usp_GetAwardedQuoteCSMData_Result>();
                    CSMDataList = context.usp_GetAwardedQuoteCSMData(quote).ToList();
                }
            }
            catch (Exception ex)
            {
                Error = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
            }
        }

        public void GetCalculatedTakeRate(string quote, out decimal? qtyPer, out decimal? familyAlloc,
            out decimal? quotedEau, out decimal? awardedEau, out decimal? csmDemand, out decimal? takeRate)
        {
            Error = "";
            qtyPer = familyAlloc = quotedEau = awardedEau = csmDemand = takeRate = 0;
            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = context.usp_GetCalculatedTakeRate(quote);
                    foreach (var item in query)
                    {
                        qtyPer = item.QtyPer;
                        familyAlloc = item.FamilyAllocation;
                        quotedEau = item.QuotedEau;
                        awardedEau = item.AwardedEau;
                        csmDemand = item.CsmForeCastDemand;
                        takeRate = item.TakeRate;
                    }
                }
            }
            catch (Exception ex)
            {
                Error = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SendFirstMnemonicEmail(string basePart, string mnemonic)
        {
            Error = "";
            var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            var result = new ObjectParameter("Result", typeof(int?));

            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_AwardedQuoteFirstMnemonicEmail(basePart, mnemonic, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion
    }
}
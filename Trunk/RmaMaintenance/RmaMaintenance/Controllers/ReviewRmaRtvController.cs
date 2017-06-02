using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using RmaMaintenance.DataModels;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class ReviewRmaRtvController
    {
        #region Class Objects

        private ReviewRmaRtvDataModel _reviewRmaRtvDataModel;
        public List<ReviewRmaRtvDataModel> ReviewList = new List<ReviewRmaRtvDataModel>();

        #endregion


        #region Methods 

        public void GetRmaRtvDetails(string operatorCode, string rmaRtvNumber, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                ReviewList.Clear();

                using (var context = new MONITOREntities())
                {
                    var results = context.usp_CreatedRmaRtvSummary(operatorCode, rmaRtvNumber, dt, result).ToList();
                    foreach (var item in results)
                    {
                        _reviewRmaRtvDataModel = new ReviewRmaRtvDataModel
                            {
                                ShipperType = item.ShipperType,
                                Shipper = item.Shipper,
                                Part = item.Part,
                                GlSegment = item.GlSegment,
                                TotalSerials = item.TotalSerials,
                                TotalQuantity = item.TotalQuantity
                            };
                        ReviewList.Add(_reviewRmaRtvDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
        }

        public void UndoRmaRtv(string operatorCode, string rmaRtvNumber, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreatedRmaRtvRollback(operatorCode, rmaRtvNumber, dt, result);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
        }

        #endregion


    }
}

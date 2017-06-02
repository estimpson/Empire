using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using RmaMaintenance.DataModels;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class CreateRmaRtvConroller
    {
        #region Class Objects

        private NewShippersDataModel _newShippersDataModel;
        public List<NewShippersDataModel> NewShippersList = new List<NewShippersDataModel>();

        #endregion


        #region Properties

        public string ReturnedRmaRtvNumber { get; private set; } 

        #endregion


        #region Methods

        public void ProcessSerials(string operatorCode, string rmaNumber, int transactionType, string notes, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));
            var rmaRtv = new ObjectParameter("RmaRtvNumber", typeof(int)) {Value = rmaNumber};

            ReturnedRmaRtvNumber = "";
            NewShippersList.Clear();

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    var query = context.usp_CreateRma_ProcessByDestGl2(operatorCode, rmaRtv, transactionType, notes, dt, result);

                    foreach (var item in query)
                    {
                        _newShippersDataModel = new NewShippersDataModel
                        {
                            RmaShipper = (item.RmaShipper == null) ? "" : item.RmaShipper.ToString(),
                            RtvShipper = (item.RtvShipper == null) ? "" : item.RtvShipper.ToString()
                        };
                        NewShippersList.Add(_newShippersDataModel);
                    }

                    ReturnedRmaRtvNumber = rmaRtv.Value.ToString();
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                error = String.Format("Failed to create RMA.  Error: {0}", errorMsg);
            }
        }

        public void ProcessSerialsRtvOnly(string operatorCode, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));
            var rtv = new ObjectParameter("RtvNumber", typeof(int));
            var firstNewRtvShipper = new ObjectParameter("FirstNewRTVShipper", typeof (int));
            var rtvShipperCount = new ObjectParameter("RTVShipperCount", typeof (int));
            var rtvShipperList = new ObjectParameter("RtvShipperList", typeof(string));

            ReturnedRmaRtvNumber = "";
            NewShippersList.Clear();

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreateRTV_ImportSerials(operatorCode, firstNewRtvShipper, rtvShipperCount, rtvShipperList, rtv, dt, result);

                    List<string> stringList = rtvShipperList.Value.ToString().Split(',').ToList();

                    foreach (var item in stringList)
                    {
                        _newShippersDataModel = new NewShippersDataModel
                            {
                                RmaShipper = "",
                                RtvShipper = item
                            };
                        NewShippersList.Add(_newShippersDataModel);
                    }

                    ReturnedRmaRtvNumber = rtv.Value.ToString();
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                error = String.Format("Failed to create RTV.  Error: {0}", errorMsg);
            }
        }

        //public int ProcessData(string operatorCode, string rmaNumber, int createRtvShipper, int placeSerialsOnHold, string note)
        //{
        //    var dt = new ObjectParameter("TranDT", typeof(DateTime));
        //    var result = new ObjectParameter("Result", typeof(int));

        //    try
        //    {
        //        using (var context = new MONITOREntities())
        //        {
        //            var query = context.usp_CreateRma_ProcessByDestGl(operatorCode, rmaNumber, createRtvShipper, placeSerialsOnHold, note, dt, result);

        //            foreach (var item in query)
        //            {
        //                _newShippersDataModel = new NewShippersDataModel
        //                {
        //                    RmaShipper = (item.RmaShipper == null) ? "" : item.RmaShipper.ToString(),
        //                    RtvShipper = (item.RtvShipper == null) ? "" : item.RtvShipper.ToString()
        //                };

        //                NewShippersList.Add(_newShippersDataModel);
        //            }

        //            string resultMessage = (createRtvShipper == 1)
        //                                       ? "Success.  Highlight a row to ship a RTV or to transfer serials."
        //                                       : "Success.";

        //            _messages.Message = resultMessage;
        //            _messages.ShowDialog();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
        //        _messages.Message = String.Format("Failed to create RMA.  Error: {0}", error);
        //        _messages.ShowDialog();
        //        return 0;
        //    }
        //    return 1;
        //}

        #endregion


    }
}

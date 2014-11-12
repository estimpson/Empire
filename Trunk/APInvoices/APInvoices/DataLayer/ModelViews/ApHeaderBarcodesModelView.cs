#region Using

using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using APInvoices.DataLayer.Model;

#endregion

namespace APInvoices.DataLayer.ModelViews
{
    public class ApHeaderBarcodesModelView
    {
        private readonly MONITOREntities _context;
        public List<ApHeaderBarcode> ApHeaderBarcodesList;
        public List<String> VendorsList; 
        public List<String> FlagsList;
        public List<String> InvoicesList; 

        #region Construction

        public ApHeaderBarcodesModelView()
        {
            _context = new MONITOREntities();
            ApHeaderBarcodesList = new List<ApHeaderBarcode>();
            VendorsList = new List<String>();
            FlagsList = new List<String>();
            InvoicesList = new List<String>();
        }

        #endregion


        #region Print Methods

        public void GetApHeaderData(out string error)
        {
            error = "";
            ObjectParameter dt = new ObjectParameter("TranDT", typeof(DateTime));
            ObjectParameter result = new ObjectParameter("Result", typeof(int));

            try
            {
                var query = _context.usp_APHeaderBarcodes_Get(dt, result).ToList();
                if (!query.Any()) return;

                foreach (var item in query)
                {
                    var apHeaderBarcode = new ApHeaderBarcode
                    {
                        RowId = item.RowID,
                        Vendor = item.Vendor,
                        InvoiceNumber = item.InvoiceCM,
                        InvoiceCmFlag = item.InvCMFlag
                    };
                    ApHeaderBarcodesList.Add(apHeaderBarcode);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void UpdateApHeaderData(int rowId, out string error)
        {
            error = "";
            ObjectParameter dt = new ObjectParameter("TranDT", typeof(DateTime));
            ObjectParameter result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_APHeaderBarcodes_Update(rowId, dt, result);
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Reprint Methods

        public void GetPrintedVendors(out string error)
        {
            error = "";
            try
            {
                var query = (from a in _context.APHeaderBarcodes
                             where a.Status == 1
                             group a by a.Vendor
                                 into newGroup
                                 select newGroup);

                if (!query.Any()) return;

                VendorsList.Add("");
                foreach (var vendorGroup in query)
                {
                    VendorsList.AddRange(vendorGroup.Select(item => item.Vendor));
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void GetPrintedCmFlags(string vendor, out string error)
        {
            error = "";
            try
            {
                var query = (from a in _context.APHeaderBarcodes
                             where a.Vendor == vendor
                             select a);

                if (!query.Any()) return;

                FlagsList.Add("");
                FlagsList.AddRange(query.Select(item => item.InvCMFlag));
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void GetPrintedInvoices(string vendor, string flag, out string error)
        {
            error = "";
            try
            {
                var query = (from a in _context.APHeaderBarcodes
                             where a.Vendor == vendor && a.InvCMFlag == flag
                             select a);

                if (!query.Any()) return;

                InvoicesList.Add("");
                InvoicesList.AddRange(query.Select(item => item.InvoiceCM));
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public int GetRowId(string vendor, string flag, string invoice, out string error)
        {
            error = "";
            try
            {
                var query = (from a in _context.APHeaderBarcodes
                             where a.Vendor == vendor && a.InvCMFlag == flag && a.InvoiceCM == invoice
                             select a);

                if (!query.Any()) return 0;

                foreach (var item in query)
                {
                    return item.RowID;
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return 0;
        }

        #endregion
    }

    public class ApHeaderBarcode
    {
        public int RowId { get; set; }
        public string Vendor { get; set; }
        public string InvoiceNumber { get; set; }
        public string InvoiceCmFlag { get; set; }
    }
}

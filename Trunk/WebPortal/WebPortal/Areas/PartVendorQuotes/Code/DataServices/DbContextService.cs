using System.Collections.Generic;
using System.Linq;
using DevExpress.Web;
using WebPortal.Areas.PartVendorQuotes.Models;
using WebPortal.Areas.PartVendorQuotes.ViewModels;

namespace WebPortal.Areas.PartVendorQuotes.Code.DataServices
{
    public static class DbContextService
    {
        private static MONITOREntities4 _context = new MONITOREntities4();

        public static IList<PartViewModel> GetParts()
        {
            return _context.usp_GetParts().Select(p => new PartViewModel
            {
                PartCode = p.PartCode,
                PartName = p.PartName,
            }).ToList();
        }

        public static IEnumerable<PartViewModel> GetPartsRange(ListEditItemsRequestedByFilterConditionEventArgs args)
        {
            var skip = args.BeginIndex;
            var take = args.EndIndex - args.BeginIndex + 1;
            return _context.usp_GetParts().Where(p => p.PartCode.Contains(args.Filter)).OrderBy(p => p.PartCode)
                .Skip(skip).Take(take).Select(p => new PartViewModel
                {
                    PartCode = p.PartCode,
                    PartName = p.PartName,
                }).ToList();
        }

        public static PartViewModel GetPartByPartCode(ListEditItemRequestedByValueEventArgs args)
        {
            if (!(args.Value is string partCode))
            {
                return null;
            }

            return _context.usp_GetParts().Where(p => p.PartCode == partCode).Select(p=> new PartViewModel
            {
                PartCode = p.PartCode,
                PartName = p.PartName,
            }).SingleOrDefault();
        }

        public static IList<VendorViewModel> GetVendors()
        {
            var result = _context.usp_GetVendors().Select(v => new VendorViewModel
            {
                VendorCode = v.VendorCode,
                VendorName = v.VendorName,
            }).ToList();

            return result;
        }

        public static IEnumerable<VendorViewModel> GetVendorsRange(ListEditItemsRequestedByFilterConditionEventArgs args)
        {
            var skip = args.BeginIndex;
            var take = args.EndIndex - args.BeginIndex + 1;
            return _context.usp_GetVendors().Where(v => v.VendorCode.Contains(args.Filter)).OrderBy(v => v.VendorCode)
                .Skip(skip).Take(take).Select(p => new VendorViewModel
                {
                    VendorCode = p.VendorCode,
                    VendorName = p.VendorName,
                }).ToList();
        }

        public static VendorViewModel GetVendorByPartCode(ListEditItemRequestedByValueEventArgs args)
        {
            if (!(args.Value is string vendorCode))
            {
                return null;
            }

            return _context.usp_GetVendors().Where(v => v.VendorCode == vendorCode).Select(p => new VendorViewModel
            {
                VendorCode = p.VendorCode,
                VendorName = p.VendorName,
            }).SingleOrDefault();
        }

        public static IList<OEMViewModel> GetOems()
        {
            var result = _context.usp_GetOems().Select(o => new OEMViewModel
            {
                Oem = o.Oem,
            }).ToList();

            return result;
        }
    }
}
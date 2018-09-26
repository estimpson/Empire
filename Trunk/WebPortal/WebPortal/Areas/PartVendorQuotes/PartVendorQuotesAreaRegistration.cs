using System.Web.Mvc;

namespace WebPortal.Areas.PartVendorQuotes
{
    public class PartVendorQuotesAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "PartVendorQuotes";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "PartVendorQuotes_default",
                "PartVendorQuotes/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
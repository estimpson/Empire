using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class FixAwardedQuote : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            try
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;

                //SqlDataSource1.ConnectionString = "data source=eeisql1.empireelect.local;initial catalog=FxPLM;persist security info=True;user id=cdipaola;password=emp1reFt1";
                SqlDataSource1.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["FxPLMEntities"].ConnectionString; 

                SqlDataSource1.SelectCommand =
                       @"SELECT [QuoteNumber], [EEIPartNumber], [Program] FROM (select [QuoteNumber], [EEIPartNumber], [Program], row_number()over(order by q.[QuoteNumber]) as [rn] from [NSA].[QuoteLog] as q where (([QuoteNumber] + ' ' + [EEIPartNumber] + ' ' + [Program]) LIKE @filter)) as st where st.[rn] between @startIndex and @endIndex";

                SqlDataSource1.SelectParameters.Clear();
                SqlDataSource1.SelectParameters.Add("filter", TypeCode.String, string.Format("%{0}%", e.Filter));
                SqlDataSource1.SelectParameters.Add("startIndex", TypeCode.Int64, (e.BeginIndex + 1).ToString());
                SqlDataSource1.SelectParameters.Add("endIndex", TypeCode.Int64, (e.EndIndex + 1).ToString());
                comboBox.DataSource = SqlDataSource1;
                comboBox.DataBind();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                //lblError.Text = String.Format("Failed to return quote data. {0}", error);
                //pcError.ShowOnPageLoad = true;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {

        }


    }
}
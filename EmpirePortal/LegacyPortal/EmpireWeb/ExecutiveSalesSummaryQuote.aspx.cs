using System;
using System.Web;
using System.Data;
using System.Design;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik;
using Telerik.Web.UI;
using Telerik.Web.Data;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;



public partial class ExecutiveSalesSummaryQuote : System.Web.UI.Page 
{

	protected void Page_Load(object sender, EventArgs e)
	{
		if (Page.IsPostBack)
	    	{
		}
		else 
		{
			string quote = Request.QueryString["id"];
			GetQuoteDetails(quote);
		}
	}	
	private void GetQuoteDetails(string quoteNumber)
	{		
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_GetQuoteDetails", connection);
				command.CommandTimeout = 120;
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@QuoteNumber", SqlDbType.VarChar).Value = quoteNumber;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						QuoteNumber.Text = reader["QuoteNumber"].ToString();
						Customer.Text = reader["Customer"].ToString();
						CustomerRFQNumber.Text = reader["CustomerRFQNumber"].ToString();
						CustomerPartNumber.Text = reader["CustomerPartNumber"].ToString();
						EEIPartNumber.Text = reader["EEIPartNumber"].ToString();
						ModelYear.Text = reader["ModelYear"].ToString();
						Requote.Text = reader["Requote"].ToString();
						StraightMaterialCost.Text = ReaderToDecimal(reader, "StraightMaterialCost").ToString();
						StdHours.Text = ReaderToDecimal(reader, "StdHours").ToString();
						Tooling.Text = ReaderToDecimal(reader, "Tooling").ToString();
						QuotePrice.Text = ReaderToDecimal(reader, "QuotePrice").ToString();
						PrototypePrice.Text = ReaderToDecimal(reader, "PrototypePrice").ToString();
						SOP.Text = reader["SOP"].ToString();
						ReceiptDate.Text = reader["ReceiptDate"].ToString();
						RequestedDueDate.Text = reader["RequestedDueDate"].ToString();
						EEIPromisedDueDate.Text = reader["EEIPromisedDueDate"].ToString();
						OEM.Text = reader["OEM"].ToString();
						ApplicationCode.Text = reader["ApplicationCode"].ToString();
						ApplicationName.Text = reader["ApplicationName"].ToString();
						FunctionName.Text = reader["FunctionName"].ToString();
						EAU.Text = reader["EAU"].ToString();
						Awarded.Text = reader["Awarded"].ToString();
						Program.Text = reader["Program"].ToString();
						Nameplate.Text = reader["Nameplate"].ToString();
						PackageNumber.Text = reader["PackageNumber"].ToString();
						EOP.Text = reader["EOP"].ToString();
						ProgramManagerInitials.Text = reader["ProgramManagerInitials"].ToString();
						EngineeringInitials.Text = reader["EngineeringInitials"].ToString();
						SalesInitials.Text = reader["SalesInitials"].ToString();
						EngineeringMaterialsInitials.Text = reader["EngineeringMaterialsInitials"].ToString();
						EngineeringMaterialsDate.Text = reader["EngineeringMaterialsDate"].ToString();
						QuoteReviewInitials.Text = reader["QuoteReviewInitials"].ToString();
						QuoteReviewDate.Text = reader["QuoteReviewDate"].ToString();
						QuotePricingInitials.Text = reader["QuotePricingInitials"].ToString();
						QuotePricingDate.Text = reader["QuotePricingDate"].ToString();
						CustomerQuoteInitials.Text = reader["CustomerQuoteInitials"].ToString();
						CustomerQuoteDate.Text = reader["CustomerQuoteDate"].ToString();
						Notes.Text = reader["Notes"].ToString();
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
		}
	}













	private decimal? ReaderToDecimal(SqlDataReader reader, string columnName)
	{
		return reader.IsDBNull(reader.GetOrdinal(columnName)) ? (decimal?) null : Convert.ToDecimal(reader[columnName]);
	}

}



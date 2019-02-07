using System;
using System.Web;
using System.Data;
using System.Design;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik;
using Telerik.Web.UI;
using Telerik.Web.Data;
using DevExpress.Web;
using DevExpress;
using System.Collections.Generic;
using System.Data.SqlClient;


public partial class SalesForecastSummaries2 : System.Web.UI.Page 
   {

	public RadGrid grid;
	public Button btn;
	public TextBox tbx1;


	public bool SelectedIndexChanged
	{
        	get { return Session["SelectedIndexChanged"] != null ? (bool)Session["SelectedIndexChanged"] : false; }
        	set { Session["SelectedIndexChanged"] = value; }
    	}

	public string Filter
    	{
        	get { return Session["Filter"] != null ? (string)Session["Filter"] : ""; }
        	set { Session["Filter"] = value; }
    	}



    	protected void Page_Load(object sender, EventArgs e)
	{
		if (!Page.IsPostBack)
        	{
			//if (!SelectedIndexChanged) LoadDataForQuoteGrid();
		}
		else
		{
			LoadDataForQuoteGrid();
		}
	}

   
   	protected void Page_Init(object source, System.EventArgs e)
   	{
       		//CreateQuoteLogGrid();
	
       		//grid.NeedDataSource += new GridNeedDataSourceEventHandler(Grid_NeedDataSource);
   	}
 


 	private void CreateQuoteLogGrid()
   	{
		//RadWindowManager1.RadAlert("CreateQuoteLogGrid", 330, 180, "Message", "");

        	grid = new RadGrid();
        	grid.ID = "RadGrid1";
		grid.MasterTableView.AutoGenerateColumns = false;
            	grid.EnableViewState = true;
		
		//grid.NeedDataSource += Grid_NeedDataSource;

		GridBoundColumn boundColumn = new GridBoundColumn();
                grid.MasterTableView.Columns.Add(boundColumn);
                boundColumn.DataField = "QuoteNumber";
                boundColumn.HeaderText = "QuoteNumber";
		
		PlaceHolder1.Controls.Add(grid);   

		btn = new Button();
		PlaceHolder1.Controls.Add(btn); 


		tbx1 = new TextBox();
		tbx1.ID = "tbx1";
		PlaceHolder1.Controls.Add(tbx1);
   	}

	//protected void Grid_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	//{
	//	RadWindowManager1.RadAlert("Need Data Source", 330, 180, "Message", "");
		
		
	//	(sender as RadGrid).DataSource = PopulateQuoteLogGrid();
//PopulateQuoteLogGrid();
   	//}



	protected void SalesForeCastSummariesRadGrid_SelectedIndexChanged(object sender, EventArgs e)
	{
		foreach (GridDataItem item in SalesForeCastSummariesRadGrid.SelectedItems)
   		{
        		Filter = item["Filter"].Text;

			Session["selectedItem"] = item["Filter"].Text;

			//tbx1.Text = item["Filter"].Text;

			//ViewState.Add("myFilter", item["Filter"].Text);
    		}


		
		




		List<string> x = new List<string>();
		x= PopulateQuoteLogGrid();
		string y = string.Concat(x.ToArray());
		RadWindowManager1.RadAlert(y, 330, 180, "Message", "");
		//grid.DataSource = x;


		QuoteLog2RadGrid.DataSource = x;


		//SelectedIndexChanged = true;
	}


	private void LoadDataForQuoteGrid()
	{
		QuoteLog2RadGrid.DataSource = PopulateQuoteLogGrid();
	}

	private List<string> PopulateQuoteLogGrid()
	{
		List<string> quoteList = new List<string>();
		//quoteList.Add("Hi");
		string query;

		


		//string f = ViewState["myFilter"].ToString();
		//RadWindowManager1.RadAlert("Filter: " + f, 330, 180, "Message", "");

		string item = "";
		if (Session["selectedItem"] != null) item = Session["selectedItem"].ToString();
		
		RadWindowManager1.RadAlert("Filter: " + item, 330, 180, "Message", "");
		
		if (item == "")
		{
			query = "SELECT top(10) QuoteNumber from eeiuser.QT_QuoteLog ql";
		}
		else
		{
			query = "SELECT QuoteNumber from eeiuser.QT_QuoteLog ql where Customer = '" + item + "'";
		}	


		using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
		{
    			SqlCommand command = new SqlCommand(query, connection);
    			connection.Open();
    			using (SqlDataReader reader = command.ExecuteReader())
    			{
        			while (reader.Read())
				{
					quoteList.Add(reader["QuoteNumber"].ToString());
				}
				
				//grid.DataSource = quoteList;
    			}
    			connection.Close();
		}
		return quoteList;
	}




	protected void Btn_OnCommand(Object sender, CommandEventArgs e)
        {
            switch (e.CommandArgument.ToString())
            {
                case "radalert":
                    //RadWindowManager1.RadAlert("RadAlert is called from the server", 330, 180, "Server RadAlert", "alertCallBackFn");
			RadWindowManager1.RadAlert("RadAlert is called from the server", 330, 180, "Server RadAlert", "");
                    	break;
                case "radconfirm":
                    	RadWindowManager1.RadConfirm("Server radconfirm: Are you sure?", "confirmCallBackFn", 330, 180, null, "Server RadConfirm");
                    	break;
                case "radprompt":
                    	RadWindowManager1.RadPrompt("Server RadPrompt: What is the answer of Life, Universe and Everything?", "promptCallBackFn", 350, 230, null, "Server RadPrompt", "42");
                    	break;
            }
        }



   }

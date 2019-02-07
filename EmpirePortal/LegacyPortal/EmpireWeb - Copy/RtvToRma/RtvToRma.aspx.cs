using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class RtvToRma : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnRun_Clicked(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        string connectionString = "Data Source=eehsql;Initial Catalog=EEH;persist security info=True;User ID=sa";
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.eeisp_insert_EEH_RMA_from_EEI_RTV", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@OperatorPWD", SqlDbType.VarChar).Value = tbxOperatorPassword.Text;
                    cmd.Parameters.Add("@ShipperID", SqlDbType.Int).Value = Convert.ToInt32(ddlRtvShipper.Text);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = "Failed.  Error thrown from procedure dbo.eeisp_insert_EEH_RMA_from_EEI_RTV.  " + ex.Message;
        }
        lblMessage.Text = "Success.  RMA generated.";
    }


}
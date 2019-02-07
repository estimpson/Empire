using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PFAApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SqlDataSourcePFAApproval.SelectCommandType = SqlDataSourceCommandType.Text;
        SqlDataSourcePFAApproval.SelectCommand = "SELECT * FROM [eeiuser].[Freight_PFA] WHERE [PFA_STATUS] = 'New' order by [PFA_ID]";
        SqlDataSourcePFAApproval.Select(DataSourceSelectArguments.Empty);    
    }

    protected void btnSubmit_Clicked(object sender, EventArgs e)
    {
        foreach (GridViewRow row in GridView1.Rows)
        {
            string id = ((LinkButton)row.FindControl("lbtnPFAID")).Text;
            string status = ((DropDownList) row.FindControl("ddlStatus")).SelectedValue;

            if (status == "Approved")
            {
                UpdateDatabase(id, status);
            }
        }

        if (lblMessage.Text == "") Response.Redirect("PFAMenu.aspx");
    }

    private void UpdateDatabase(string pfaid, string status)
    {
        lblMessage.Text = "";
        string connectionString = "Data Source=eeisql1.empireelect.local;Initial Catalog=MONITOR;persist security info=True;User ID=Andre";
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("eeiuser.freight_update_pfa_status", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@PFA_ID", SqlDbType.VarChar).Value = pfaid;
                    cmd.Parameters.Add("@PFA_STATUS", SqlDbType.VarChar).Value = status;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = String.Format("Failed to approve {0}.  Error thrown from procedure dbo.freight_update_pfa_status:  {1}", pfaid, ex.Message);
        }
    }

    protected void btnCancel_Clicked(object sender, EventArgs e)
    {
        Response.Redirect("PFAMenu.aspx");
    }

}
using System;
using System.Web.UI;
using Telerik.Web.UI;

public partial class RadGridRelatedForm : System.Web.UI.Page 
{
		protected void Page_Load(object sender, EventArgs e)
		{

		}
		
		 protected void Page_PreRender(object sender, EventArgs e)
        {
            //if (RadGrid1.SelectedIndexes.Count == 0)
            //    RadGrid1.SelectedIndexes.Add(0);
            //if (RadGrid2.SelectedIndexes.Count == 0)
            //{
            //    RadGrid2.Rebind();
            //    RadGrid2.SelectedIndexes.Add(0);
            //}
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            //RadGrid2.SelectedIndexes.Clear();
        }


        protected void RadButton2_Click(object sender, EventArgs e)
        {
                  
            
 //           foreach (GridDataItem item in this.RadGrid2.SelectedItems)
 //           {string BasePart2 = item.GetDataKeyValue("MnemonicVehiclePlant").ToString();
           
 //           SqlDataSource5.InsertParameters.Add("basepart", BasePart2.ToString());
            
 //           SqlDataSource5.Insert();
 //}
   
        }

        protected void RadButton3_Click(object sender, EventArgs e)
        {
            SqlDataSource7.Insert();
        }


        protected void RadButtonInsertPart_Click(object sender, EventArgs e)
        {
            SqlDataSourceInsertPart.Insert();
        }






        protected void RadGrid2_SelectedIndexChanged(object sender, EventArgs e)
        {
                  
            RadTextBox2.Text = RadGrid2.SelectedValue.ToString();
            
        }
}

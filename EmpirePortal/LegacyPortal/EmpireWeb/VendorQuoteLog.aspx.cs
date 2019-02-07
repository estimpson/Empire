using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DevExpress.Web;
using DevExpress.Data;
using Telerik.Web.UI;
using Telerik.Web.Data;
using Telerik.Web;
using System.IO;


public partial class Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void Page_PreRender(object sender, EventArgs e)
    {
       // if (RadGrid1.SelectedIndexes.Count == 0)
         //   RadGrid1.SelectedIndexes.Add(0);
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        RadGrid1.ItemCommand += new GridCommandEventHandler(RadGrid1_ItemCommand);
    }
    public void RadAsyncUpload1_FileUploaded(object sender, FileUploadedEventArgs e)
    {
        GridDataItem item1 = (GridDataItem)RadGrid1.MasterTableView.Items[RadGrid1.SelectedItems[0].ItemIndex];
        string strVendorName = item1["VendorName"].Text;

        GridDataItem item2 = (GridDataItem)RadGrid1.MasterTableView.Items[RadGrid1.SelectedItems[0].ItemIndex];
        string strVendorQuoteNumber = item2["VendorQuoteNumber"].Text;

        GridDataItem item3 = (GridDataItem)RadGrid1.MasterTableView.Items[RadGrid1.SelectedItems[0].ItemIndex];
        DateTime strQuoteDate = DateTime.Parse(item3["QuoteDate"].Text);

        string targetFolder = RadAsyncUpload1.TargetFolder;
        string fileName = strVendorName + strVendorQuoteNumber + strQuoteDate.ToString("yyyyMMdd") + e.UploadResult.FileName;
        //e.File.SaveAs(Path.Combine(@"\\srvdata1\data\groups\Everyone\VendorQuotes", fileName));
        e.File.SaveAs(Path.Combine(Server.MapPath(targetFolder), fileName));

        SqlDataSource1.UpdateParameters.Add(new Parameter("VendorQuoteFileName", System.TypeCode.String, fileName));
        SqlDataSource1.UpdateParameters.Add(new Parameter("VendorName", System.TypeCode.String, strVendorName));
        SqlDataSource1.UpdateParameters.Add(new Parameter("VendorQuoteNumber", DbType.String, strVendorQuoteNumber));
        SqlDataSource1.UpdateParameters.Add(new Parameter("QuoteDate", DbType.DateTime, strQuoteDate.ToString()));
        SqlDataSource1.Update();
    }

    protected void RadGrid1_ItemCommand(object source, GridCommandEventArgs e)
    {
        if (e.CommandName == RadGrid.DeleteCommandName)
            ((GridDataItem)e.Item)["QuotedPrice"].Text = ((GridDataItem)e.Item)["QuotedPrice"].Text.Replace("$", "");
    }
    public void Button1_Click(object sender, EventArgs e)
    {

        //SqlDataSource1.Update();
    }

}

//    protected void FileUploaded(object sender, FileUploadedEventArgs e)
//    {
        //string relativePath ="~/Uploads/";

        //var filename = e.File.FileName;
        //var parentID = Convert.ToInt32(RadGrid1.SelectedValue);
        //var filesize = Convert.ToInt32(e.File.ContentLength);
        //var physicalSavePath = MapPath(relativePath) + filename;

        //Store file info in database
        //var filesAdapter = new filesAdapter Table;
        //filesAdapter.Insert(filename, relativePath + filename, parentID, filesize);
        //Save physical file on disk
        //e.File.SaveAs(physicalSavePath, true);
    //    }

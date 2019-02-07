<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecast.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

</head>
<body>
    <form id="SalesForecastEntry" runat="server" method="post">
 
        <telerik:RadScriptManager ID="RadScriptManager1" Runat="server">
        </telerik:RadScriptManager>

        <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="radMultiPage1" SelectedIndex="1" >
            <Tabs>
                <telerik:RadTab runat="server" 
                    Text="Add New Part">
                </telerik:RadTab>
                <telerik:RadTab runat="server" 
                    Text="Sales Forecast" Selected="True">
                </telerik:RadTab>
            </Tabs>
        </telerik:RadTabStrip>

  
        <telerik:RadMultiPage ID="RadMultiPage1" Runat="server"  SelectedIndex="1" >
            <telerik:RadPageView ID="RadPageView1" runat="server" ContentUrl="CSMDemand.aspx" Width="1850px" Height="900px">
            </telerik:RadPageView>
            <telerik:RadPageView ID="RadPageView2" runat="server" ContentUrl="RadGridRelatedForm.aspx" Width="1850px" Height="900px" Selected="true">
            </telerik:RadPageView>
        </telerik:RadMultiPage>

  
    </form>
</body>
</html>

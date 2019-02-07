<%@ Page Language="C#" AutoEventWireup="true" CodeFile="KomaxProduction_DevExpress.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            
            <dx:ASPxComboBox ID="ComboBox1_Increment" runat="server" Theme="BlackGlass">
                <Items>
                    <dx:ListEditItem Text="Day" Value="dd" />
                    <dx:ListEditItem Text="Week" Value="wk" />
                    <dx:ListEditItem Text="Month" Value="mm" />
                    <dx:ListEditItem Text="Quarter" Value="qq" />
                    <dx:ListEditItem Text="Year" Value="yy" />
                </Items>
            </dx:ASPxComboBox>
            <dx:ASPxDateEdit ID="DateEdit1_BeginDate" runat="server" Theme ="Moderno">
            </dx:ASPxDateEdit>
            <dx:ASPxDateEdit ID="DateEdit2_EndDate" runat="server" Theme ="Moderno" >
            </dx:ASPxDateEdit>
            <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Submit" OnClick="ASPxButton1_Click" Theme="Moderno">
            </dx:ASPxButton>
            <dx:aspxgridview ID="DataGrid1_KomaxProductionbyPeriod" runat="server"  DataSourceID="SDS_KomaxProduction1" Theme="Moderno" OnDataBound="DataGrid1_KomaxProductionbyPeriod_DataBound">
                <SettingsPager Mode="ShowAllRecords">
                </SettingsPager>
                <Settings ShowFilterRow="True" HorizontalScrollBarMode="Visible"  VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" />
                <SettingsBehavior AllowSelectByRowClick="True" />
                <Settings ShowFooter="true"  />
            </dx:aspxgridview>            
            <asp:SqlDataSource ID="SDS_KomaxProduction1" runat="server" ConnectionString="<%$ ConnectionStrings:EEHMONITORConnectionString %>" SelectCommand="eeiuser.acctg_pac_production_by_machine" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID ="ComboBox1_Increment" PropertyName="Value" Name="Increment" Type="String" DefaultValue="wk" />
                    <asp:ControlParameter ControlID ="DateEdit1_BeginDate" PropertyName="Value" Name="Begin_date" Type="DateTime" DefaultValue="2018-05-01" />
                    <asp:ControlParameter ControlID ="DateEdit2_EndDate" PropertyName="Value" Name="End_date" Type="DateTime" DefaultValue="2018-06-01" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>

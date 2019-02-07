<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="OpenShippers.aspx.cs" Inherits="Default2" %>

<%@ Register assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="server">
   
    <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" 
        DataSourceID="OpenShippersDataSource1" 
       Width="1235px" 
        oncelleditorinitialize="ASPxGridView1_CellEditorInitialize">
        <Columns>
            <dx:GridViewDataTextColumn FieldName="id" VisibleIndex="0">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataDateColumn FieldName="date_stamp" VisibleIndex="1">
            </dx:GridViewDataDateColumn>
            <dx:GridViewDataDateColumn FieldName="release_date" VisibleIndex="2">
            </dx:GridViewDataDateColumn>
            <dx:GridViewDataTextColumn FieldName="status"        VisibleIndex="3" >
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="ship_via"     VisibleIndex="4">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="customer" VisibleIndex="5">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="destination" VisibleIndex="6">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="part" VisibleIndex="7">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="customer_part" VisibleIndex="8">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="qty_original" VisibleIndex="9">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="qty_required" VisibleIndex="10">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="qty_packed" VisibleIndex="11">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="boxes_staged" VisibleIndex="12">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="order_no" VisibleIndex="13">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="customer_po" VisibleIndex="14">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="release_no" VisibleIndex="15">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="notes" VisibleIndex="16">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="IN_EEI_Warehouse" ReadOnly="True" VisibleIndex="17">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="IN_TRAN_Location" ReadOnly="True" VisibleIndex="18">
            </dx:GridViewDataTextColumn>
        </Columns>
        <SettingsBehavior ConfirmDelete="True" AllowGroup="False" 
            AutoFilterRowInputDelay="800" ColumnResizeMode="NextColumn" />

        <SettingsPager Mode="ShowAllRecords" Visible="False">
        </SettingsPager>

        <SettingsEditing Mode="Inline" />
        <Settings ShowFilterRow="True" ShowHeaderFilterButton="True"  
            VerticalScrollBarMode="Visible" ShowFilterRowMenu="True" 
            ShowFilterRowMenuLikeItem="True" ShowGroupButtons="False" 
            VerticalScrollableHeight="500" />
        <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
    </dx:ASPxGridView>
    <asp:SqlDataSource ID="OpenShippersDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:aspnetdbConnectionString %>" SelectCommand="exec monitor.eeiuser.planning_open_shippers"></asp:SqlDataSource>
    <asp:SqlDataSource ID="NALPriceDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
        
        SelectCommand="SELECT [customer_part], [price], [comments] FROM [acctg_nal_pricing]" 
        ConflictDetection="CompareAllValues" 
        DeleteCommand="DELETE FROM [acctg_nal_pricing] WHERE [customer_part] = @original_customer_part AND (([price] = @original_price) OR ([price] IS NULL AND @original_price IS NULL)) AND (([comments] = @original_comments) OR ([comments] IS NULL AND @original_comments IS NULL))" 
        InsertCommand="INSERT INTO [acctg_nal_pricing] ([customer_part], [price], [comments]) VALUES (@customer_part, @price, @comments)" 
        OldValuesParameterFormatString="original_{0}" 
        UpdateCommand="UPDATE [acctg_nal_pricing] SET [price] = @price, [comments] = @comments WHERE [customer_part] = @original_customer_part AND (([price] = @original_price) OR ([price] IS NULL AND @original_price IS NULL)) AND (([comments] = @original_comments) OR ([comments] IS NULL AND @original_comments IS NULL))">
        <DeleteParameters>
            <asp:Parameter Name="original_customer_part" Type="String" />
            <asp:Parameter Name="original_price" Type="Decimal" />
            <asp:Parameter Name="original_comments" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="customer_part" Type="String" />
            <asp:Parameter Name="price" Type="Decimal" />
            <asp:Parameter Name="comments" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="price" Type="Decimal" />
            <asp:Parameter Name="comments" Type="String" />
            <asp:Parameter Name="original_customer_part" Type="String" />
            <asp:Parameter Name="original_price" Type="Decimal" />
            <asp:Parameter Name="original_comments" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>
    
</asp:Content>


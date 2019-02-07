<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="NALPriceList.aspx.cs" Inherits="Default2" %>

<%@ Register assembly="DevExpress.Web.v12.2, Version=12.2.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.v12.2, Version=12.2.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="server">
   
    <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" 
        DataSourceID="NALPriceDataSource" KeyFieldName="customer_part" 
        Theme="DevEx" Width="560px" 
        oncelleditorinitialize="ASPxGridView1_CellEditorInitialize">
        <Columns>
            <dx:GridViewCommandColumn VisibleIndex="0">
                <EditButton Visible="True">
                </EditButton>
                <NewButton Visible="True">
                </NewButton>
                <DeleteButton Visible="True">
                </DeleteButton>
                <ClearFilterButton Visible="True">
                </ClearFilterButton>
            </dx:GridViewCommandColumn>
            <dx:GridViewDataTextColumn FieldName="customer_part" ReadOnly="True" VisibleIndex="1">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="price"        VisibleIndex="2" >
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="comments"     VisibleIndex="3">
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
    </dx:ASPxGridView>
    <asp:SqlDataSource ID="NALPriceDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:NALPriceConnectionString %>" 
        
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


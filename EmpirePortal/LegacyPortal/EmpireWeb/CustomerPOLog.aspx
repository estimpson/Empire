<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerPOLog.aspx.cs" Inherits="Default2" MasterPageFile="~/MasterPage.master" %>

<%@ Register assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="server">

        <span class="style1"><strong>Customer PO Log</strong></span>
        <dx:ASPxGridView ID="ASPxGridView1" runat="server" 
            AutoGenerateColumns="False" 
            DataSourceID="SqlDataSource1" 
            KeyFieldName="CustomerCode;CustomerPO;CustomerPORev" 
            Width="100%" 
            SettingsBehavior-AllowSelectByRowClick="True" 
            SettingsBehavior-ColumnResizeMode="Control" 
            SettingsBehavior-ConfirmDelete="True" 
            Settings-ShowHeaderFilterButton="True" 
            SettingsText-ConfirmDelete="Are you sure you  want to delete?" 
            EnablePagingGestures="False" >
            <Columns>
                <dx:GridViewCommandColumn ShowSelectCheckbox="False" VisibleIndex="0">
                    <EditButton Visible="True">
                    </EditButton>
                    <NewButton Visible="True">
                    </NewButton>
                    <DeleteButton Visible="True">
                    </DeleteButton>
                </dx:GridViewCommandColumn>
                <dx:GridViewDataComboBoxColumn FieldName="CustomerCode" ReadOnly="False" 
                    VisibleIndex="1" Caption="Customer">
                    <PropertiesComboBox DataSourceID="SqlDataSourceCustomerCode" 
                        TextField="Customer" ValueField="Customer" 
                        IncrementalFilteringMode="StartsWith">
                    </PropertiesComboBox>
                    <Settings HeaderFilterMode="CheckedList" />
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataHyperLinkColumn FieldName="CustomerPO" Caption="Customer PO" ReadOnly="False" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="2">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataHyperLinkColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPORev" Caption="PO Rev" ReadOnly="False" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="3">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataComboBoxColumn FieldName="CustomerPOType" Caption="PO Type" VisibleIndex="4">
                    <PropertiesComboBox  IncrementalFilteringMode="StartsWith" >
                        <Items>
                            <dx:ListEditItem Selected="True" Text="Blanket" Value="Blanket" />
                            <dx:ListEditItem Text="Spot Buy" Value="Spot Buy" />
                            <dx:ListEditItem Text="Tooling" Value="Tooling" />
                            <dx:ListEditItem Text="Non-Production" Value="Non-Production" />
                        </Items>
                    </PropertiesComboBox>
                    <Settings HeaderFilterMode="CheckedList" />
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataDateColumn FieldName="CustomerPODateReceived" Caption="PO Date" VisibleIndex="5" Settings-HeaderFilterMode="CheckedList">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataDateColumn FieldName="CustomerPOEffDate" Caption="PO Eff Date" VisibleIndex="6" Settings-HeaderFilterMode="CheckedList">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataComboBoxColumn FieldName="CustomerPOSalesTerms" Caption="Sales Terms" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="7">
                    <PropertiesComboBox DataSourceID="SqlDataSourceCustomerPOSalesTerms" 
                        TextField="terms" ValueField="terms" IncrementalFilteringMode="StartsWith" IncrementalFilteringDelay=0>
                    </PropertiesComboBox>

<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPOShippingTerms" Caption="Shipping Terms" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="8">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPOFreightPayer" Caption="Freight Payer" VisibleIndex="9" Settings-HeaderFilterMode="CheckedList">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPart" Caption="Customer Part" VisibleIndex="10" Settings-HeaderFilterMode="CheckedList">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPartRev" Caption="Part Rev" VisibleIndex="11" Settings-HeaderFilterMode="CheckedList">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPartDescription" Caption="Part Description" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="12">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPOQuantity" Caption = "PO Qty" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="13">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerSellingPrice" Caption="Price" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="14">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="CustomerSellingPriceBegDate"  Caption = "Price Eff Date" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="15">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataDateColumn FieldName="CustomerSellingPriceEndDate" Caption = "Price End Date" Settings-HeaderFilterMode="CheckedList"
                    VisibleIndex="16">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataTextColumn FieldName="CustomerPOFileLocation" Caption = "PO File" VisibleIndex="17" Settings-HeaderFilterMode="CheckedList">
<Settings HeaderFilterMode="CheckedList"></Settings>
                </dx:GridViewDataTextColumn>
            </Columns>

<SettingsBehavior ConfirmDelete="True" AllowSelectByRowClick="True" 
                ColumnResizeMode="Control" AllowDragDrop="False"></SettingsBehavior>

<Settings ShowHeaderFilterButton="True" ShowFilterBar="Auto" ShowFilterRow="True" 
                 VerticalScrollBarMode="Auto" VerticalScrollableHeight="300"></Settings>

<SettingsText ConfirmDelete="Are you sure you  want to delete?"></SettingsText>
            <SettingsPopup>
                <EditForm Modal="True" />
            </SettingsPopup>
        </dx:ASPxGridView>
    
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConflictDetection="CompareAllValues" 
            ConnectionString="<%$ ConnectionStrings:MonitorConnectionString %>" 
            DeleteCommand="DELETE FROM [eeiuser].[customer_po] WHERE [CustomerCode] = @original_CustomerCode AND [CustomerPO] = @original_CustomerPO AND [CustomerPORev] = @original_CustomerPORev AND (([CustomerPOType] = @original_CustomerPOType) OR ([CustomerPOType] IS NULL AND @original_CustomerPOType IS NULL)) AND (([CustomerPODateReceived] = @original_CustomerPODateReceived) OR ([CustomerPODateReceived] IS NULL AND @original_CustomerPODateReceived IS NULL)) AND (([CustomerPOEffDate] = @original_CustomerPOEffDate) OR ([CustomerPOEffDate] IS NULL AND @original_CustomerPOEffDate IS NULL)) AND (([CustomerPOSalesTerms] = @original_CustomerPOSalesTerms) OR ([CustomerPOSalesTerms] IS NULL AND @original_CustomerPOSalesTerms IS NULL)) AND (([CustomerPOShippingTerms] = @original_CustomerPOShippingTerms) OR ([CustomerPOShippingTerms] IS NULL AND @original_CustomerPOShippingTerms IS NULL)) AND (([CustomerPOFreightPayer] = @original_CustomerPOFreightPayer) OR ([CustomerPOFreightPayer] IS NULL AND @original_CustomerPOFreightPayer IS NULL)) AND (([CustomerPart] = @original_CustomerPart) OR ([CustomerPart] IS NULL AND @original_CustomerPart IS NULL)) AND (([CustomerPartRev] = @original_CustomerPartRev) OR ([CustomerPartRev] IS NULL AND @original_CustomerPartRev IS NULL)) AND (([CustomerPartDescription] = @original_CustomerPartDescription) OR ([CustomerPartDescription] IS NULL AND @original_CustomerPartDescription IS NULL)) AND (([CustomerPOQuantity] = @original_CustomerPOQuantity) OR ([CustomerPOQuantity] IS NULL AND @original_CustomerPOQuantity IS NULL)) AND (([CustomerSellingPrice] = @original_CustomerSellingPrice) OR ([CustomerSellingPrice] IS NULL AND @original_CustomerSellingPrice IS NULL)) AND (([CustomerSellingPriceBegDate] = @original_CustomerSellingPriceBegDate) OR ([CustomerSellingPriceBegDate] IS NULL AND @original_CustomerSellingPriceBegDate IS NULL)) AND (([CustomerSellingPriceEndDate] = @original_CustomerSellingPriceEndDate) OR ([CustomerSellingPriceEndDate] IS NULL AND @original_CustomerSellingPriceEndDate IS NULL)) AND (([CustomerPOFileLocation] = @original_CustomerPOFileLocation) OR ([CustomerPOFileLocation] IS NULL AND @original_CustomerPOFileLocation IS NULL))" 
            InsertCommand="INSERT INTO [eeiuser].[customer_po] ([CustomerCode], [CustomerPO], [CustomerPORev], [CustomerPOType], [CustomerPODateReceived], [CustomerPOEffDate], [CustomerPOSalesTerms], [CustomerPOShippingTerms], [CustomerPOFreightPayer], [CustomerPart], [CustomerPartRev], [CustomerPartDescription], [CustomerPOQuantity], [CustomerSellingPrice], [CustomerSellingPriceBegDate], [CustomerSellingPriceEndDate], [CustomerPOFileLocation]) VALUES (@CustomerCode, @CustomerPO, @CustomerPORev, @CustomerPOType, @CustomerPODateReceived, @CustomerPOEffDate, @CustomerPOSalesTerms, @CustomerPOShippingTerms, @CustomerPOFreightPayer, @CustomerPart, @CustomerPartRev, @CustomerPartDescription, @CustomerPOQuantity, @CustomerSellingPrice, @CustomerSellingPriceBegDate, @CustomerSellingPriceEndDate, @CustomerPOFileLocation)" 
            OldValuesParameterFormatString="original_{0}" 
            SelectCommand="SELECT * FROM [eeiuser].[customer_po]" 
            UpdateCommand="UPDATE [eeiuser].[customer_po] SET [CustomerCode] = @CustomerCode, [CustomerPO] = @CustomerPO, [CustomerPORev] = @CustomerPORev, [CustomerPOType] = @CustomerPOType, [CustomerPODateReceived] = @CustomerPODateReceived, [CustomerPOEffDate] = @CustomerPOEffDate, [CustomerPOSalesTerms] = @CustomerPOSalesTerms, [CustomerPOShippingTerms] = @CustomerPOShippingTerms, [CustomerPOFreightPayer] = @CustomerPOFreightPayer, [CustomerPart] = @CustomerPart, [CustomerPartRev] = @CustomerPartRev, [CustomerPartDescription] = @CustomerPartDescription, [CustomerPOQuantity] = @CustomerPOQuantity, [CustomerSellingPrice] = @CustomerSellingPrice, [CustomerSellingPriceBegDate] = @CustomerSellingPriceBegDate, [CustomerSellingPriceEndDate] = @CustomerSellingPriceEndDate, [CustomerPOFileLocation] = @CustomerPOFileLocation WHERE [CustomerCode] = @original_CustomerCode AND [CustomerPO] = @original_CustomerPO AND [CustomerPORev] = @original_CustomerPORev AND (([CustomerPOType] = @original_CustomerPOType) OR ([CustomerPOType] IS NULL AND @original_CustomerPOType IS NULL)) AND (([CustomerPODateReceived] = @original_CustomerPODateReceived) OR ([CustomerPODateReceived] IS NULL AND @original_CustomerPODateReceived IS NULL)) AND (([CustomerPOEffDate] = @original_CustomerPOEffDate) OR ([CustomerPOEffDate] IS NULL AND @original_CustomerPOEffDate IS NULL)) AND (([CustomerPOSalesTerms] = @original_CustomerPOSalesTerms) OR ([CustomerPOSalesTerms] IS NULL AND @original_CustomerPOSalesTerms IS NULL)) AND (([CustomerPOShippingTerms] = @original_CustomerPOShippingTerms) OR ([CustomerPOShippingTerms] IS NULL AND @original_CustomerPOShippingTerms IS NULL)) AND (([CustomerPOFreightPayer] = @original_CustomerPOFreightPayer) OR ([CustomerPOFreightPayer] IS NULL AND @original_CustomerPOFreightPayer IS NULL)) AND (([CustomerPart] = @original_CustomerPart) OR ([CustomerPart] IS NULL AND @original_CustomerPart IS NULL)) AND (([CustomerPartRev] = @original_CustomerPartRev) OR ([CustomerPartRev] IS NULL AND @original_CustomerPartRev IS NULL)) AND (([CustomerPartDescription] = @original_CustomerPartDescription) OR ([CustomerPartDescription] IS NULL AND @original_CustomerPartDescription IS NULL)) AND (([CustomerPOQuantity] = @original_CustomerPOQuantity) OR ([CustomerPOQuantity] IS NULL AND @original_CustomerPOQuantity IS NULL)) AND (([CustomerSellingPrice] = @original_CustomerSellingPrice) OR ([CustomerSellingPrice] IS NULL AND @original_CustomerSellingPrice IS NULL)) AND (([CustomerSellingPriceBegDate] = @original_CustomerSellingPriceBegDate) OR ([CustomerSellingPriceBegDate] IS NULL AND @original_CustomerSellingPriceBegDate IS NULL)) AND (([CustomerSellingPriceEndDate] = @original_CustomerSellingPriceEndDate) OR ([CustomerSellingPriceEndDate] IS NULL AND @original_CustomerSellingPriceEndDate IS NULL)) AND (([CustomerPOFileLocation] = @original_CustomerPOFileLocation) OR ([CustomerPOFileLocation] IS NULL AND @original_CustomerPOFileLocation IS NULL))">
            <DeleteParameters>
                <asp:Parameter Name="original_CustomerCode" Type="String" />
                <asp:Parameter Name="original_CustomerPO" Type="String" />
                <asp:Parameter Name="original_CustomerPORev" Type="String" />
                <asp:Parameter Name="original_CustomerPOType" Type="String" />
                <asp:Parameter Name="original_CustomerPODateReceived" Type="DateTime" />
                <asp:Parameter Name="original_CustomerPOEffDate" Type="DateTime" />
                <asp:Parameter Name="original_CustomerPOSalesTerms" Type="String" />
                <asp:Parameter Name="original_CustomerPOShippingTerms" Type="String" />
                <asp:Parameter Name="original_CustomerPOFreightPayer" Type="String" />
                <asp:Parameter Name="original_CustomerPart" Type="String" />
                <asp:Parameter Name="original_CustomerPartRev" Type="String" />
                <asp:Parameter Name="original_CustomerPartDescription" Type="String" />
                <asp:Parameter Name="original_CustomerPOQuantity" Type="Decimal" />
                <asp:Parameter Name="original_CustomerSellingPrice" Type="Decimal" />
                <asp:Parameter Name="original_CustomerSellingPriceBegDate" Type="DateTime" />
                <asp:Parameter Name="original_CustomerSellingPriceEndDate" Type="DateTime" />
                <asp:Parameter Name="original_CustomerPOFileLocation" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="CustomerCode" Type="String" />
                <asp:Parameter Name="CustomerPO" Type="String" />
                <asp:Parameter Name="CustomerPORev" Type="String" />
                <asp:Parameter Name="CustomerPOType" Type="String" />
                <asp:Parameter Name="CustomerPODateReceived" Type="DateTime" />
                <asp:Parameter Name="CustomerPOEffDate" Type="DateTime" />
                <asp:Parameter Name="CustomerPOSalesTerms" Type="String" />
                <asp:Parameter Name="CustomerPOShippingTerms" Type="String" />
                <asp:Parameter Name="CustomerPOFreightPayer" Type="String" />
                <asp:Parameter Name="CustomerPart" Type="String" />
                <asp:Parameter Name="CustomerPartRev" Type="String" />
                <asp:Parameter Name="CustomerPartDescription" Type="String" />
                <asp:Parameter Name="CustomerPOQuantity" Type="Decimal" />
                <asp:Parameter Name="CustomerSellingPrice" Type="Decimal" />
                <asp:Parameter Name="CustomerSellingPriceBegDate" Type="DateTime" />
                <asp:Parameter Name="CustomerSellingPriceEndDate" Type="DateTime" />
                <asp:Parameter Name="CustomerPOFileLocation" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="CustomerCode" Type="String" />
                <asp:Parameter Name="CustomerPO" Type="String" />
                <asp:Parameter Name="CustomerPORev" Type="String" />
                <asp:Parameter Name="CustomerPOType" Type="String" />
                <asp:Parameter Name="CustomerPODateReceived" Type="DateTime" />
                <asp:Parameter Name="CustomerPOEffDate" Type="DateTime" />
                <asp:Parameter Name="CustomerPOSalesTerms" Type="String" />
                <asp:Parameter Name="CustomerPOShippingTerms" Type="String" />
                <asp:Parameter Name="CustomerPOFreightPayer" Type="String" />
                <asp:Parameter Name="CustomerPart" Type="String" />
                <asp:Parameter Name="CustomerPartRev" Type="String" />
                <asp:Parameter Name="CustomerPartDescription" Type="String" />
                <asp:Parameter Name="CustomerPOQuantity" Type="Decimal" />
                <asp:Parameter Name="CustomerSellingPrice" Type="Decimal" />
                <asp:Parameter Name="CustomerSellingPriceBegDate" Type="DateTime" />
                <asp:Parameter Name="CustomerSellingPriceEndDate" Type="DateTime" />
                <asp:Parameter Name="CustomerPOFileLocation" Type="String" />
                <asp:Parameter Name="original_CustomerCode" Type="String" />
                <asp:Parameter Name="original_CustomerPO" Type="String" />
                <asp:Parameter Name="original_CustomerPORev" Type="String" />
                <asp:Parameter Name="original_CustomerPOType" Type="String" />
                <asp:Parameter Name="original_CustomerPODateReceived" Type="DateTime" />
                <asp:Parameter Name="original_CustomerPOEffDate" Type="DateTime" />
                <asp:Parameter Name="original_CustomerPOSalesTerms" Type="String" />
                <asp:Parameter Name="original_CustomerPOShippingTerms" Type="String" />
                <asp:Parameter Name="original_CustomerPOFreightPayer" Type="String" />
                <asp:Parameter Name="original_CustomerPart" Type="String" />
                <asp:Parameter Name="original_CustomerPartRev" Type="String" />
                <asp:Parameter Name="original_CustomerPartDescription" Type="String" />
                <asp:Parameter Name="original_CustomerPOQuantity" Type="Decimal" />
                <asp:Parameter Name="original_CustomerSellingPrice" Type="Decimal" />
                <asp:Parameter Name="original_CustomerSellingPriceBegDate" Type="DateTime" />
                <asp:Parameter Name="original_CustomerSellingPriceEndDate" Type="DateTime" />
                <asp:Parameter Name="original_CustomerPOFileLocation" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
     <asp:SqlDataSource ID="SqlDataSourceCustomerCode" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MonitorConnectionString %>" 
            SelectCommand="SELECT distinct(customer) as customer FROM [Empower].[dbo].[customers]" >
        </asp:SqlDataSource>
     <asp:SqlDataSource ID="SqlDataSourceCustomerPOSalesTerms" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MonitorConnectionString %>" 
            SelectCommand="SELECT distinct(payment_term) as terms FROM [Empower].[dbo].[customer_ar_defaults]" >
        </asp:SqlDataSource>
             <asp:SqlDataSource ID="SqlDataSourceCustomerPOType" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MonitorConnectionString %>" 
            SelectCommand="SELECT 'Blanket' as POType union SELECT 'Spot Buy' as POType" >
        </asp:SqlDataSource>
</asp:Content>


<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorQuoteLog.aspx.cs" Inherits="Default" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>






<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>VendorQuoteLog</title>
	<telerik:RadStyleSheetManager id="RadStyleSheetManager1" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
	<telerik:RadScriptManager ID="RadScriptManager1" runat="server">
		<Scripts>
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
		</Scripts>
	</telerik:RadScriptManager>
	<script type="text/javascript">

    </script>
	<telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" >
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ASPxFormLayout1" />
                    <telerik:AjaxUpdatedControl ControlID="SqlDataSource2" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                </UpdatedControls>
                </telerik:AjaxSetting>
        </AjaxSettings>
	</telerik:RadAjaxManager>
   <telerik:RadGrid ID="RadGrid1" runat="server"  AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" 
                                                 AllowFilteringByColumn="True" AllowSorting="True" AutoGenerateColumns="False" 
                                                CellSpacing="0" DataSourceID="VendorQuoteLogSQLDataSource" 
                                                EnableHeaderContextMenu="True" GridLines="None" Skin="Metro" Width="820px">
        <GroupingSettings CaseSensitive="False" />
        <ExportSettings ExportOnlyData="True" HideStructureColumns="True" IgnorePaging="True">
            <Excel Format="ExcelML" />
        </ExportSettings>
        <ClientSettings AllowColumnHide="True" EnablePostBackOnRowClick="true" >
           
            <Selecting AllowRowSelect="True" />
            <Scrolling AllowScroll="True" UseStaticHeaders="True" />
            <Resizing AllowColumnResize="True" />
        </ClientSettings>
        <MasterTableView ClientDataKeyNames="QuoteID" CommandItemDisplay="Top" DataKeyNames="QuoteID" 
                        DataSourceID="VendorQuoteLogSQLDataSource" EditMode="InPlace" TableLayout="Fixed">
            <CommandItemSettings ShowExportToExcelButton="True" />
            <Columns>
                <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="Are you sure you want to delete the selected row?" FilterControlAltText="Filter column column" Text="Delete" UniqueName="column">
                    <HeaderStyle Width="30px" />
                </telerik:GridButtonColumn>
                <telerik:GridEditCommandColumn>
                    <HeaderStyle Width="50px" />
                </telerik:GridEditCommandColumn>
                <telerik:GridBoundColumn DataField="QuoteID" DataType="System.Guid" FilterControlAltText="Filter QuoteID column" ReadOnly="True" UniqueName="QuoteID" Visible="False">
<ColumnValidationSettings>
<ModelErrorMessage Text=""></ModelErrorMessage>
</ColumnValidationSettings>
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn AutoPostBackOnFilter="True" CurrentFilterFunction="Contains" DataField="Buyer" FilterControlAltText="Filter Buyer column" FilterControlWidth="100%" FilterDelay="800" HeaderText="Buyer" ShowFilterIcon="False" SortExpression="Buyer" UniqueName="Buyer">
<ColumnValidationSettings>
<ModelErrorMessage Text=""></ModelErrorMessage>
</ColumnValidationSettings>

                    <HeaderStyle Width="100px" />
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn AutoPostBackOnFilter="True" CurrentFilterFunction="Contains" DataField="VendorName" FilterControlAltText="Filter VendorName column" FilterControlWidth="100%" FilterDelay="800" HeaderText="Vendor Name" ShowFilterIcon="False" SortExpression="VendorName" UniqueName="VendorName">
<ColumnValidationSettings>
<ModelErrorMessage Text=""></ModelErrorMessage>
</ColumnValidationSettings>

                    <HeaderStyle Width="100px" />
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn AutoPostBackOnFilter="True" CurrentFilterFunction="Contains" DataField="Part" FilterControlAltText="Filter Part column" FilterControlWidth="100%" FilterDelay="800" HeaderText="Part" ShowFilterIcon="False" SortExpression="Part" UniqueName="Part">
<ColumnValidationSettings>
<ModelErrorMessage Text=""></ModelErrorMessage>
</ColumnValidationSettings>

                    <HeaderStyle Width="150px" />
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn AllowFiltering="False" DataField="QuotedPrice" DataFormatString="{0:C6}" DataType="System.Decimal" FilterControlAltText="Filter QuotedPrice column" FilterControlWidth="70%" HeaderText="Quoted Price" SortExpression="QuotedPrice" UniqueName="QuotedPrice">
<ColumnValidationSettings>
<ModelErrorMessage Text=""></ModelErrorMessage>
</ColumnValidationSettings>

                    <HeaderStyle Width="90px" />
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn AutoPostBackOnFilter="True" CurrentFilterFunction="Contains" DataField="QuoteDate" DataFormatString="{0:d}" DataType="System.DateTime" FilterControlAltText="Filter QuoteDate column" FilterControlWidth="100%" FilterDelay="1000" HeaderText="Quote Date" ShowFilterIcon="False" UniqueName="QuoteDate">
<ColumnValidationSettings>
<ModelErrorMessage Text=""></ModelErrorMessage>
</ColumnValidationSettings>

                    <HeaderStyle Width="90px" />
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn AutoPostBackOnFilter="True" CurrentFilterFunction="Contains" DataField="VendorQuoteNumber" FilterControlAltText="Filter VendorQuoteNumber column" FilterControlWidth="100%" FilterDelay="10" HeaderText="Vendor Quote Number" ShowFilterIcon="False" UniqueName="VendorQuoteNumber">
<ColumnValidationSettings>
<ModelErrorMessage Text=""></ModelErrorMessage>
</ColumnValidationSettings>

                    <HeaderStyle Width="110px" />
                </telerik:GridBoundColumn>
                <telerik:GridHyperLinkColumn AllowFiltering="False" AllowSorting="False" DataNavigateUrlFields="VendorQuoteFileName" DataNavigateUrlFormatString="file:///S:/VendorQuotes/{0}" DataTextField="VendorQuoteNumber" FilterControlAltText="Filter VendorQuoteFileName column" HeaderText="Vendor Quote Document" ShowFilterIcon="False" Target="_new" UniqueName="VendorQuoteFileName">
                    <HeaderStyle Width="90px" />
                </telerik:GridHyperLinkColumn>
            </Columns>
            <EditFormSettings>
                <EditColumn FilterControlAltText="Filter EditCommandColumn1 column" UniqueName="EditCommandColumn1">
                </EditColumn>
            </EditFormSettings>
        </MasterTableView>
    </telerik:RadGrid>

	    <asp:SqlDataSource ID="VendorQuoteLogSQLDataSource" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:EEHConnectionString %>" 
            OldValuesParameterFormatString="original_{0}"
            SelectCommand= "SELECT QuoteId, Buyer, VendorName, Part, QuotedPrice, QuoteDate, VendorQuoteNumber, VendorQuoteFileName FROM [eeiuser].[purchasing_VendorQuoteLog] order by VendorName, Part" 
            
            InsertCommand= "INSERT INTO [eeiuser].[purchasing_VendorQuoteLog] ([Buyer], [VendorName], [Part], [QuotedPrice], [QuoteDate], [VendorQuoteNumber]) 
                            VALUES (@Buyer, @VendorName, @Part, @QuotedPrice, @QuoteDate, @VendorQuoteNumber)" 
             
            UpdateCommand= "UPDATE [eeiuser].[purchasing_VendorQuoteLog] 
                            SET [VendorName] = @VendorName, 
                                [Part] = @Part, 
                                [QuotedPrice] = @QuotedPrice, 
                                [QuoteDate] = @QuoteDate, 
                                [VEndorQuoteNumber] = @VendorQuoteNumber
                            WHERE [QuoteID] = @original_QuoteID 
                            AND (([Buyer] = @original_Buyer) or ([Buyer] IS NULL AND @original_Buyer IS NULL))
                            AND (([VendorName] = @original_VendorName) or ([VendorName] IS NULL AND @original_VendorName IS NULL)) 
                            AND (([Part] = @original_Part) OR ([Part] IS NULL AND @original_Part IS NULL)) 
                            AND (([QuotedPrice] = @original_QuotedPrice) OR ([QuotedPrice] IS NULL AND @original_QuotedPrice IS NULL)) 
                            AND (([QuoteDate] = @original_QuoteDate) OR ([QuoteDate] IS NULL AND @original_QuoteDate IS NULL)) 
                            AND (([VendorQuoteNumber] = @original_VendorQuoteNumber) OR ([VendorQuoteNumber] IS NULL AND @original_VendorQuoteNumber IS NULL))"
            
            DeleteCommand= "DELETE FROM [eeiuser].[purchasing_VendorQuoteLog] 
                            WHERE [QuoteID] = @original_QuoteID 
                            AND (([Buyer] = @original_Buyer) or ([Buyer] IS NULL AND @original_Buyer IS NULL))
                            AND (([VendorName] = @original_VendorName) or ([VendorName] IS NULL AND @original_VendorName IS NULL)) 
                            AND (([Part] = @original_Part) OR ([Part] IS NULL AND @original_Part IS NULL)) 
                            AND (([QuotedPrice] = @original_QuotedPrice) OR ([QuotedPrice] IS NULL AND @original_QuotedPrice IS NULL)) 
                            AND (([QuoteDate] = @original_QuoteDate) OR ([QuoteDate] IS NULL AND @original_QuoteDate IS NULL)) 
                            AND (([VendorQuoteNumber] = @original_VendorQuoteNumber) OR ([VendorQuoteNumber] IS NULL AND @original_VendorQuoteNumber IS NULL))">

            <InsertParameters>
                <asp:Parameter Name="QuoteID" DbType="Guid"/>
                <asp:Parameter Name="Buyer" Type="String" />
                <asp:Parameter Name="VendorName" Type="String" />
                <asp:Parameter Name="Part" Type="String" />
                <asp:Parameter Name="QuotedPrice" Type="Decimal" />
                <asp:Parameter Name="QuoteDate" Type="DateTime" />
                <asp:Parameter Name="VendorQuoteNumber" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Buyer" Type="String" />
                <asp:Parameter Name="VendorName" Type="String" />
                <asp:Parameter Name="Part" Type="String" />
                <asp:Parameter Name="QuotedPrice" Type="Decimal" />
                <asp:Parameter Name="QuoteDate" Type="DateTime" />
                <asp:Parameter Name="VendorQuoteNumber" Type="String" />
                <asp:Parameter Name="original_QuoteID" DbType="Guid" />
                <asp:Parameter Name="original_Buyer" Type="String" />
                <asp:Parameter Name="original_VendorName" Type="String" />
                <asp:Parameter Name="original_Part" Type="String" />
                <asp:Parameter Name="original_QuotedPrice" Type="Decimal" />
                <asp:Parameter Name="original_QuoteDate" Type="DateTime" />
                <asp:Parameter Name="original_VendorQuoteNumber" Type="String" />
            </UpdateParameters>            
            <DeleteParameters> 
                <asp:Parameter Name="Buyer" Type="String" />
                <asp:Parameter Name="VendorName" Type="String" />
                <asp:Parameter Name="Part" Type="String" />
                <asp:Parameter Name="QuotedPrice" Type="Decimal" />
                <asp:Parameter Name="QuoteDate" Type="DateTime" />
                <asp:Parameter Name="VendorQuoteNumber" Type="String" />
                <asp:Parameter Name="original_QuoteID" DbType="Guid" />
                <asp:Parameter Name="original_Buyer" Type="String" />
                <asp:Parameter Name="original_VendorName" Type="String" />
                <asp:Parameter Name="original_Part" Type="String" />
                <asp:Parameter Name="original_QuotedPrice" Type="Decimal" />
                <asp:Parameter Name="original_QuoteDate" Type="DateTime" />
                <asp:Parameter Name="original_VendorQuoteNumber" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
              
	    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:EEHConnectionString %>" 
            SelectCommand="select vendorquotefilename from eeiuser.purchasing_vendorQuotelog" 
            UpdateCommand="UPDATE EEIUser.purchasing_VendorQuoteLog SET VendorQuoteFileName = @VendorQuoteFileName 
            WHERE (VendorName = @VendorName ) and (VendorQuoteNumber = @VendorQuoteNumber) AND (QuoteDate = @QuoteDate) ">
        </asp:SqlDataSource>

        <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" DataSourceID="SqlDataSource2" EnableTheming="True" Theme="Metropolis" BackColor="#D8DEE7" >
            <Items>
                <dx:LayoutItem FieldName="QuoteID" Visible="false">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E37" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="VendorName">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E38" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="Part">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E39" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="PartName">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E40" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="CrossReference">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E41" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="QuotedPrice">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E42" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="VendorQuoteNumber">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E43" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="QuoteDate">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxDateEdit ID="ASPxFormLayout1_E44" runat="server">
                            </dx:ASPxDateEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="QuoteExirationDate">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxDateEdit ID="ASPxFormLayout1_E45" runat="server">
                            </dx:ASPxDateEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="VendorQuoteFileName">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E46" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="ActiveQuote">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxComboBox ID="ASPxFormLayout1_E47" runat="server" Width="170px">
                                    <Items>
                                    <dx:ListEditItem Text="Yes" Value="Yes" />
                                    <dx:ListEditItem Text="No" Value="No" />
                                </Items>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="RolledUpDate">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxDateEdit ID="ASPxFormLayout1_E48" runat="server">
                            </dx:ASPxDateEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="QuotedEAU">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer13" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E49" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="StdPack">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer14" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E50" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="MinOrderQuantity">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer15" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E51" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="MetalSurcharge">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer16" runat="server" SupportsDisabledAttribute="True">
                             <dx:ASPxComboBox ID="ASPxFormLayout1_E52" runat="server" Width="170px">
                                <Items>
                                    <dx:ListEditItem Text="Yes" Value="Yes" />
                                    <dx:ListEditItem Text="No" Value="No" />
                                </Items>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="MetalBasePriceLB">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer17" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E53" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="MetalContentLB">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer18" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E54" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="AmortizedTooling">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer19" runat="server" SupportsDisabledAttribute="True">
                             <dx:ASPxComboBox ID="ASPxFormLayout1_E55" runat="server" Width="170px">
                                <Items>
                                    <dx:ListEditItem Text="Yes" Value="Yes" />
                                    <dx:ListEditItem Text="No" Value="No" />
                                </Items>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="AmortizedToolingPrice">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer20" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E56" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="AmortizedToolingTotalAmount">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer21" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E57" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="LeadTime">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer22" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxSpinEdit ID="ASPxFormLayout1_E58" runat="server" Number="0">
                            </dx:ASPxSpinEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="FreightTerms">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer23" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E59" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="PaymentTerms">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer24" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E60" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="ShipTo">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer25" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E61" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="ShipFromLocation">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer26" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E62" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="ManufacturingLocation">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer27" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E63" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="OEMContractPricing">
                    <LayoutItemNestedControlCollection>
                         <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer28" runat="server" SupportsDisabledAttribute="True">  
                             <dx:ASPxComboBox ID="ASPxFormLayout1_E64" runat="server" Width="170px">
                                <Items>
                                    <dx:ListEditItem Text="Yes" Value="Yes" />
                                    <dx:ListEditItem Text="No" Value="No" />
                                </Items>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="OEM">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer29" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E65" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="Program">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer30" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E66" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="Vehicle">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer31" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E67" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="FGQuoteNumber">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer32" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E68" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="FGPartNumber">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer33" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E69" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="Buyer">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer34" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxComboBox ID="ASPxFormLayout1_E70" runat="server" Width="170px">
                                <Items>
                                    <dx:ListEditItem Text="George Doman" Value="George Doman" />
                                    <dx:ListEditItem Text="John Doman" Value="John Doman" />
                                    <dx:ListEditItem Text="Brandon Krider" Value="Brandon Krider" />
                                </Items>

                            </dx:ASPxComboBox>

                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem FieldName="Comments">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer35" runat="server" SupportsDisabledAttribute="True">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E71" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
            </Items>
            <Paddings PaddingTop="0px" />
            <Border BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px" />
        </dx:ASPxFormLayout>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:EEHConnectionString %>" SelectCommand="SELECT * FROM [eeiuser].[purchasing_VendorQuoteLog] WHERE ([QuoteID] = @QuoteID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="RadGrid1" DefaultValue="9F519A77-2689-47AA-941E-495CB78AD3A3" Name="QuoteID" PropertyName="SelectedValue" DbType="Guid" />
            </SelectParameters>
        </asp:SqlDataSource>             
    <div>
        <telerik:RadAsyncUpload ID="RadAsyncUpload1" runat="server" Skin="Metro" TargetFolder="~/VendorQuotes" 
            OnFileUploaded="RadAsyncUpload1_FileUploaded"  >
        </telerik:RadAsyncUpload>
<asp:Button ID="Button1" Text="Submit" runat="server" OnClick="Button1_Click"/>

            </div>
	</form>
</body>
</html>

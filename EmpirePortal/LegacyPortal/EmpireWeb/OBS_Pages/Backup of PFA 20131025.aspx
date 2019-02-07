﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Backup of PFA 20131025.aspx.cs" Inherits="PremiumFreightRequest" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web" Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
 <title>PFA</title>
    <%--    <style type="text/css">
            .Inline {
                display: inline;
            }
        </style>--%>	

<%--	<telerik:RadStyleSheetManager id="RadStyleSheetManager1" runat="server" />
    <link rel="Stylesheet" type="text/css" href="CSS/StyleSheet.css" />--%>

<%--<script src ="http://code.jquery.com/jquery-1.9.1.js"></script>
        <script >
            $(document).ready(function () {
                $("#divProfileLabel").click(function(){
                $("#divProfile").slideToggle("slow");
            });
            });
        </script>--%>
</head>

<body>
     
    <form id="form1" runat="server" style="width:1000px">
	
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server" CdnSettings-TelerikCdn="Enabled">
		<Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />    
		</Scripts>
	</telerik:RadScriptManager>

        <script type="text/javascript">
            function UpdateItemsVisibility(ASPxFormLayout1_E7) {
                if (ASPxFormLayout1_E7.GetValue() === "Yes") {
                    formLayout.GetItemByName("CMLDate").SetVisible(true);
                    formLayout.GetItemByName("CMLEmpty").SetVisible(true);
                } else {
                    formLayout.GetItemByName("CMLDate").SetVisible(false);
                    formLayout.GetItemByName("CMLEmpty").SetVisible(false);
                }
            }
            function OnInit(s, e) {
                UpdateItemsVisibility(s);
            }
            function OnCMLListChanged(s, e) {
                UpdateItemsVisibility(s);
            }
        </script>
        
        <script type="text/javascript">
            function UpdatePaymentMethodVisibility(ResponsiblePartyComboBox) {
                    if (ResponsiblePartyComboBox.GetValue() === "Customer") {
                        formLayout.GetItemByName("PaymentMethod").SetVisible(true);
                        formLayout.GetItemByName("PaymentDetail").SetVisible(true);
                    } else {
                        formLayout.GetItemByName("PaymentMethod").SetVisible(false);
                        formLayout.GetItemByName("PaymentDetail").SetVisible(true);
                        }
                    }
                    function OnInit2(s, e) {
                        UpdatePaymentMethodVisibility(s);
                    }
                    function OnResponsiblePartyChanged(s, e) {
                        UpdatePaymentMethodVisibility(s);
                    }
        </script>

        <script type="text/javascript">
            function UpdateFromAddress(ShipFromComboBox) {
                if (ShipFromComboBox.GetValue() === "EEI") {
                    SendorText.SetText("Empire Electronics Inc");
                    SendorStreetAddressText.SetText("214 E Maple Rd");
                    SendorCityText.SetText("Troy");
                    SendorStateText.SetText("MI");
                    SendorZIPText.SetText("48083");
                } else
                    if (ShipFromComboBox.GetValue() === "EEA") {
                        SendorText.SetText("Empire Electronics Inc");
                        SendorStreetAddressText.SetText("602 John Aldridge Dr Ste C");
                        SendorCityText.SetText("Tuscumbia");
                        SendorStateText.SetText("AL");
                        SendorZIPText.SetText("35674");
                    } else
                        if (ShipFromComboBox.GetValue() === "EEP") {
                            SendorText.SetText("Empire Electronics Inc c/o Trans-Expedite Inc");
                            SendorStreetAddressText.SetText("7 Founders Blvd");
                            SendorCityText.SetText("El Paso");
                            SendorStateText.SetText("TX");
                            SendorZIPText.SetText("79906");
                        } else
                            if (ShipFromComboBox.GetValue() === "EEH") {
                                SendorText.SetText("Empire of Honduras SA");
                                SendorStreetAddressText.SetText("7km Carretera a la Lima");
                                SendorCityText.SetText("San Pedro Sula");
                                SendorStateText.SetText("HN");
                                SendorZIPText.SetText("");
                            }
                            else{
                                SendorText.SetText("");
                                SendorStreetAddressText.SetText("");
                                SendorCityText.SetText("");
                                SendorStateText.SetText("");
                                SendorZIPText.SetText("");
                                }
            }          
            
            function OnShipFromChanged(s, e) {
              UpdateFromAddress(s);
            }        
        </script>
<script type="text/javascript">
    function UpdateToAddress(ShipToComboBox) {
        if (ShipToComboBox.GetValue() === "EEI") {
            ReceipientText.SetText("Empire Electronics Inc");
            ReceipientStreetAddressText.SetText("214 E Maple Rd");
            ReceipientCityText.SetText("Troy");
            ReceipientStateText.SetText("MI");
            ReceipientZIPText.SetText("48083");
            ReceipientCountryText.SetText("US");
        } else
            if (ShipToComboBox.GetValue() === "EEA") {
                ReceipientText.SetText("Empire Electronics Inc");
                ReceipientStreetAddressText.SetText("602 John Aldridge Dr Ste C");
                ReceipientCityText.SetText("Tuscumbia");
                ReceipientStateText.SetText("AL");
                ReceipientZIPText.SetText("35674");
                ReceipientCountryText.SetText("US");
            } else
                if (ShipToComboBox.GetValue() === "EEP") {
                    ReceipientText.SetText("Empire Electronics Inc c/o Trans-Expedite Inc");
                    ReceipientStreetAddressText.SetText("7 Founders Blvd");
                    ReceipientCityText.SetText("El Paso");
                    ReceipientStateText.SetText("TX");
                    ReceipientZIPText.SetText("79906");
                    ReceipientCountryText.SetText("US");
                } else
                    if (ShipToComboBox.GetValue() === "EEH") {
                        ReceipientText.SetText("Empire of Honduras SA");
                        ReceipientStreetAddressText.SetText("7km Carretera a la Lima");
                        ReceipientCityText.SetText("San Pedro Sula");
                        ReceipientStateText.SetText("");
                        ReceipientZIPText.SetText("");
                        ReceipientCountryText.SetText("HN");
                    }
                    else {
                        ReceipientText.SetText("");
                        ReceipientStreetAddressText.SetText("");
                        ReceipientCityText.SetText("");
                        ReceipientStateText.SetText("");
                        ReceipientZIPText.SetText("");
                        ReceipientCountryText.SetText("");
                    }
    }

    function OnShipToChanged(s, e) {
        UpdateToAddress(s);
    }




        </script>

        <script type="text/javascript">
	    //<![CDATA[
	    var $ = $telerik.$;
	    function pageLoad() {
	        if (!Telerik.Web.UI.RadAsyncUpload.Modules.FileApi.isAvailable()) {
	            $(".qsf-demo-canvas").html("<strong>Your browser does not support Drag and Drop.</strong>");
	        }
	        else {
	            $(document).bind({ "drop": function (e) { e.preventDefault(); } });

	           // var dropZone1 = $(document).find(".DropZone1");
	           // dropZone1.bind({ "dragenter": function (e) { dragEnterHandler(e, dropZone1); } })
               //         .bind({ "dragleave": function (e) { dragLeaveHandler(e, dropZone1); } })
               //         .bind({ "drop": function (e) { dropHandler(e, dropZone1); } });
	        }
	    }

	    function dropHandler(e, dropZone) {
	        dropZone[0].style.backgroundColor = "#357A2B";
	    }

	    function dragEnterHandler(e, dropZone) {
	        var dt = e.originalEvent.dataTransfer;
	        var isFile = (dt.types != null && (dt.types.indexOf ? dt.types.indexOf('Files') != -1 : dt.types.contains('application/x-moz-file')));
	        if (isFile || $telerik.isSafari5 || $telerik.isIE10Mode || $telerik.isOpera)
	            dropZone[0].style.backgroundColor = "#000000";
	    }

	    function dragLeaveHandler(e, dropZone) {
	        if (!$telerik.isMouseOverElement(dropZone[0], e.originalEvent))
	            dropZone[0].style.backgroundColor = "#357A2B";
	    }
        //]]>

    </script>
<%--	<telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
	</telerik:RadAjaxManager>
 
	<telerik:RadSkinManager ID="RadSkinManager1" Runat="server" Skin="MetroTouch">
	</telerik:RadSkinManager>--%>

        <dx:ASPxRoundPanel ID="ASPxRoundPanel3" runat="server" Width="100%" HorizontalAlign="Left">
            <HeaderTemplate>
                <asp:Table ID="Table1" runat="server" Height="40px" Width="100%">
                    <asp:TableRow runat="server" Height="20px">
                        <asp:TableCell runat="server" Width="33%" Font-Bold="true" Font-Size="Larger">Premium Freight Authorization</asp:TableCell>
                        <asp:TableCell runat="server" Width="33%"> Requested by: Ana Ortiz on 10/1/2013</asp:TableCell>
                        <asp:TableCell runat="server" Width="33%" RowSpan="2">
                            <telerik:RadBarcode ID="RadBarcode1" runat="server" ShowText="false" Height="35px" Text="154012035" Type="Code39Extended" >
                            </telerik:RadBarcode></asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow runat="server" Height="20px" Width="100%">
                        <asp:TableCell runat="server" Font-Bold="true" Font-Size="Larger">#2013-0001</asp:TableCell>
                        <asp:TableCell runat="server" Width="33%" >Status: Approved by Barry Moore on 10/14/2013 </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                
            
            </HeaderTemplate>
            <PanelCollection>
        <dx:PanelContent runat="server" SupportsDisabledAttribute="True">

    <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" Width="100%" ColCount="2" ClientInstanceName="formLayout" Styles-LayoutGroupBox-Caption-ForeColor="#6666FF" DataSourceID="SqlDataSourcePFA" >
                    <Items>
                        <dx:LayoutGroup Caption="Ship From" Width="50%">
                            <Items>
                                <dx:LayoutItem Caption="Ship From Paretto:" FieldName="FROM_PARETTO">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxComboBox ID="ShipFromComboBox" runat="server" Width="100%" IncrementalFilteringMode="Contains" ClientInstanceName="ShipFromComboBox" EnableClientSideAPI="True">
                                            <ClientSideEvents SelectedIndexChanged="OnShipFromChanged" />    
                                                <Items>
                                                    <dx:ListEditItem Text="Empire Electronics Michigan (EEI)" Value="EEI" />
                                                    <dx:ListEditItem Text="Empire Electronics Alabama (EEA)" Value="EEA" />
                                                    <dx:ListEditItem Text="Empire Electronics Texas (EEP)" Value="EEP" />
                                                    <dx:ListEditItem Text="Empire Electronics Honduras (EEH)" Value="EEH" />
                                                    <dx:ListEditItem Text="Customer" Value="Customer" />
                                                    <dx:ListEditItem Text="Vendor" Value="Vendor" />
                                                    <dx:ListEditItem Text="Third Party" Value="Third Party" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:EmptyLayoutItem Height="10px">
                                </dx:EmptyLayoutItem>
                                <dx:LayoutItem Caption="Sendor" Name ="Sendor" FieldName="FROM_NAME">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E16" runat="server" Width="100%" ClientInstanceName="SendorText" EnableClientSideAPI="True">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Street Address" Name="SendorStreetAddress" FieldName="FROM_STREET_ADDRESS">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E15" runat="server" Width="100%" ClientInstanceName="SendorStreetAddressText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="City" Name="SendorCity" FieldName="FROM_CITY">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E11" runat="server" Width="100%" ClientInstanceName="SendorCityText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="State" Name="SendorState" FieldName="FROM_STATE">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E17" runat="server" Width="100%" ClientInstanceName="SendorStateText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="ZIP" Name="SendorZIP" FieldName="FROM_ZIP_CODE">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E18" runat="server" Width="100%" ClientInstanceName="SendorZIPText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Country" Name="SendorCountry" FieldName="FROM_COUNTRY">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxTextBox5" runat="server" Width="100%" ClientInstanceName="SendorCountry" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:EmptyLayoutItem Height="10px">
                                </dx:EmptyLayoutItem>
                                <dx:LayoutItem Caption="Contact:" FieldName="FROM_CONTACT">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E19" runat="server" Width="100%">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Contact Phone:" FieldName="FROM_CONTACT_PHONE">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E20" runat="server" Width="100%">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                        </dx:LayoutGroup>
                        
                        <dx:LayoutGroup Caption="Ship To" Width="50%">
                            <Items>
                                <dx:LayoutItem Caption="Ship To Paretto" FieldName="TO_PARETTO">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxComboBox ID="ShipToComboBox" runat="server" Width="100%" IncrementalFilteringMode="Contains" ClientInstanceName="ShipToComboBox" EnableClientSideAPI="true">    
                                            <ClientSideEvents SelectedIndexChanged="OnShipToChanged" /> 
                                                <Items>
                                                    <dx:ListEditItem Text="Empire Electronics Michigan (EEI)" Value="EEI" />
                                                    <dx:ListEditItem Text="Empire Electronics Alabama (EEA)" Value="EEA" />
                                                    <dx:ListEditItem Text="Empire Electronics Texas (EEP)" Value="EEP" />
                                                    <dx:ListEditItem Text="Empire Electronics Honduras (EEH)" Value="EEH" />
                                                    <dx:ListEditItem Text="Customer" Value="Customer" />
                                                    <dx:ListEditItem Text="Vendor" Value="Vendor" />
                                                    <dx:ListEditItem Text="Third Party" Value="Third Party" />
                                                </Items>
                                                </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:EmptyLayoutItem Height="10px">
                                </dx:EmptyLayoutItem>
                                <dx:LayoutItem Caption="Receipient" Name="Receipient" FieldName="TO_NAME">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E21" runat="server" Width="100%" ClientInstanceName="ReceipientText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Street Address" Name="ReceipientStreetAddress" FieldName="TO_STREET_ADDRESS">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True" >
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E22" runat="server" Width="100%" ClientInstanceName="ReceipientStreetAddressText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="City" Name="ReceipientCity" FieldName="TO_CITY">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True" >
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E23" runat="server" Width="100%" ClientInstanceName="ReceipientCityText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="State" Name="ReceipientState" FieldName="TO_STATE" >
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E24" runat="server" Width="100%" ClientInstanceName="ReceipientStateText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="ZIP" Name="ReceipientZIP" FieldName="TO_ZIP_CODE">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E25" runat="server" Width="100%" ClientInstanceName="ReceipientZIPText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>                                
                                <dx:LayoutItem Caption="Country" Name="ReceipientCountry" FieldName="TO_COUNTRY">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxTextBox4" runat="server" Width="100%" ClientInstanceName="ReceipientCountryText" EnableClientSideAPI="true">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:EmptyLayoutItem Height="10px">
                                </dx:EmptyLayoutItem>
                                <dx:LayoutItem Caption="Contact:" FieldName="TO_CONTACT">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E26" runat="server" Width="100%">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Contact Phone:" FieldName="TO_CONTACT_PHONE">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E27" runat="server" Width="100%">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                        </dx:LayoutGroup>
                        
                        <dx:LayoutGroup Caption="Shipment Information" ColCount="3" Width="100%" ShowCaption="True" ColSpan="2">
                            <Items>
                                <dx:LayoutItem Caption="Part Type Paretto:" ColSpan="3" HorizontalAlign="Left">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxComboBox ID="ASPxFormLayout1_E37" runat="server" IncrementalFilteringMode="StartsWith">
                                                 <Items>
                                                    <dx:ListEditItem Text="Raw Material" Value="RM" />
                                                    <dx:ListEditItem Text="WIP Material" Value="WIP" />
                                                    <dx:ListEditItem Text="Finished Goods" Value="FG" />
                                                    <dx:ListEditItem Text="Tooling" Value="Tooling" />
                                                    <dx:ListEditItem Text="Perishable Tooling" Value="Perishable Tooling" />
                                                    <dx:ListEditItem Text="Documents" Value="Documents" />
                                                    <dx:ListEditItem Text="Other" Value="Other" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Part Number(s):" ColSpan="3" Width="95%" FieldName="PART">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E5" runat="server" Width="100%">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Part Description:" ColSpan="3" Width="95%" FieldName="PART_DESCRIPTION">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True" >
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E4" runat="server" Width="100%">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Quantity to Ship:" VerticalAlign="Top" FieldName="QTY">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E3" runat="server" Width="200px">
                                            </dx:ASPxTextBox>
                                            <dx:ASPxComboBox ID="ASPxFormLayout1_E8" runat="server" SelectedIndex="0" Width="200px" DropDownStyle="DropDownList" IncrementalFilteringMode="StartsWith">
                                                <Items>
                                                    <dx:ListEditItem Selected="True" Text="EA" Value="EA" />
                                                    <dx:ListEditItem Text="GAL" Value="GAL" />
                                                    <dx:ListEditItem Text="FT" Value="FT" />
                                                    <dx:ListEditItem Text="MT" Value="MT" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                    <CaptionSettings Location="Top" />
                                </dx:LayoutItem>
                               
                                <dx:LayoutItem Caption="Estimated Weight:" VerticalAlign="Top" FieldName="EST_WEIGHT">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True" CssClass="Inline">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E1" runat="server" Width="100px">
                                            </dx:ASPxTextBox>
                                            <dx:ASPxComboBox ID="ASPxFormLayout1_E9" runat="server" EnableClientSideAPI="True" IncrementalFilteringMode="StartsWith" SelectedIndex="0" Width="50px">
                                                <Items>
                                                    <dx:ListEditItem Selected="True" Text="LBS" Value="LBS" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                    <CaptionSettings Location="Top" />
                                </dx:LayoutItem>
                                   
                                <dx:LayoutItem Caption="Package Dimensions:" VerticalAlign="Top" CssClass="Inline">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True" CssClass="Inline">
                                            <dx:ASPxTextBox ID="ASPxFormLayout1_E2" runat="server" Width="150px">
                                            </dx:ASPxTextBox>
                                            <dx:ASPxTextBox ID="ASPxTextBox1" runat="server" Width="150px">
                                            </dx:ASPxTextBox>
                                            <dx:ASPxTextBox ID="ASPxTextBox2" runat="server" Width="150px">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                    <CaptionSettings Location="Top" />
                                </dx:LayoutItem>
                                   
                            </Items>
                        </dx:LayoutGroup>
 
            <dx:LayoutGroup Caption="Due Date" ColCount="2" ColSpan="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Date Required In-House:" Width="50%">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxDateEdit ID="ASPxFormLayout1_E6" runat="server">
                                </dx:ASPxDateEdit>   
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>                   
                    <dx:LayoutItem Caption="Is this item on a Critical Material List?" Width="50%" FieldName="CML_ITEM">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxComboBox ID="ASPxFormLayout1_E7" runat="server" EnableClientSideAPI="True" IncrementalFilteringDelay="0" IncrementalFilteringMode="StartsWith" Width="150px">
                                    <ClientSideEvents Init="OnInit" SelectedIndexChanged="OnCMLListChanged" />
                                    <Items>
                                        <dx:ListEditItem Text="Yes" Value="Yes" />
                                        <dx:ListEditItem Text="No" Value="No" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem Name="CMLEmpty">
                    </dx:EmptyLayoutItem>
                    <dx:LayoutItem Caption="CML Date:" Name="CMLDate" HorizontalAlign="Left">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxDateEdit ID="ASPxFormLayout1_E10" runat="server" Width="150px">
                                </dx:ASPxDateEdit>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                </Items>
            </dx:LayoutGroup>
            <dx:LayoutGroup Caption="Where Used" ColSpan="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Which FG use these Parts?" FieldName="FG_WHERE_USED">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxTextBox ID="ASPxTextBox3" runat="server" Width="100%">
                                            </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="FG Customer Paretto" HelpTextSettings-Position="Bottom" HelpTextSettings-VerticalAlign="Middle" HelpText="Which FG Customer is MOST benefited by this shipment" FieldName="FG_CUSTOMER_PARETTO">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxComboBox ID="ASPxComboBox1" runat="server">
                                                 <Items>
                                                    <dx:ListEditItem Text="ALC" Value="ALC" />
                                                    <dx:ListEditItem Text="ALI" Value="ALI" />
                                                    <dx:ListEditItem Text="AUT" Value="AUT" />
                                                    <dx:ListEditItem Text="CHR" Value="CHR" />
                                                    <dx:ListEditItem Text="Other" Value="Other" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>

<HelpTextSettings Position="Right"></HelpTextSettings>
                                </dx:LayoutItem>
                </Items>
            </dx:LayoutGroup>
                        <dx:LayoutGroup Caption="Reason For Premium Freight Shipment" ColCount="2" ColSpan="2" Width="100%">
                            <Items>
                                <dx:LayoutItem Caption="Root Cause Paretto Category" HelpText="Choose the category that best describes the reason for this shipment" FieldName="REASON_PARETTO">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxComboBox ID="ASPxComboBox4" runat="server" IncrementalFilteringMode="StartsWith">
                                                    <Items>
                                                    <dx:ListEditItem Text="Customer Release Fluctuation" Value="Customer Release FLuctuation" />
                                                    <dx:ListEditItem Text="Customer New Launch" Value="Customer New Launch" />
                                                    <dx:ListEditItem Text="Customer Quality Issue" Value="Customer Quality Issue" />
                                                    <dx:ListEditItem Text="Vendor Late Delivery" Value="Vendor Late Delivery" />
                                                    <dx:ListEditItem Text="Empire Inventory Discrepancy" Value="Empire Inventory Discrepancy" />
                                                    <dx:ListEditItem Text="Empire Container Shortage" Value="Empire Container Shortage" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:EmptyLayoutItem>
                                </dx:EmptyLayoutItem>
                                <dx:LayoutItem Caption="Provide a detailed explanation for this freight shipment" ColSpan="2" Width="95%" FieldName="ROOT_CAUSE">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxMemo ID="ASPxFormLayout2_E1" runat="server" Height="66px" Width="100%">
                                            </dx:ASPxMemo>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                    <CaptionSettings Location="Top" />
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Provide a Corrective Action:" ColSpan="2" Width="95%">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxMemo ID="ASPxMemo1" runat="server" Height="44px" Width="100%">
                                            </dx:ASPxMemo>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                    <CaptionSettings Location="Top" />
                                </dx:LayoutItem>
                            </Items>
                                </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Who is Responsible to Pay for this Shipment?" ColSpan="1" AlignItemCaptions="False" Width="50%">
                                <Items>
                                    <dx:LayoutItem Caption="Responsible Party">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxComboBox ID="ResponsiblePartyComboBox" runat="server" EnableClientSideAPI="True" IncrementalFilteringDelay="0" IncrementalFilteringMode="StartsWith">
                                                    <ClientSideEvents Init="OnInit2" SelectedIndexChanged="OnResponsiblePartyChanged" />
                                                    <Items>
                                                    <dx:ListEditItem Text="Empire" Value="Empire" />
                                                    <dx:ListEditItem Text="Customer" Value="Customer" />
                                                    <dx:ListEditItem Text="Vendor" Value="Vendor" />
                                                    <dx:ListEditItem Text="Third Party" Value="Third Party" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    
                                </Items>
                        </dx:LayoutGroup>
                        
                        <dx:LayoutGroup Caption="How Will This Shipment Be Paid?" Name="PaymentMethod" ColSpan="1" AlignItemCaptions="False"  Width="50%">
                                <Items>
                                    <dx:LayoutItem Caption="Payment Method">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxComboBox ID="ASPxComboBox3" runat="server" EnableClientSideAPI="True"  IncrementalFilteringDelay="0" IncrementalFilteringMode="StartsWith">
                                                    <Items>
                                                    <dx:ListEditItem Text="Customer Account" Value="Customer Account" />
                                                    <dx:ListEditItem Text="Customer PO" Value="Customer PO" />
                                                    <dx:ListEditItem Text="Vendor Account" Value="Vendor Account" />
                                                    <dx:ListEditItem Text="Vendor Chargeback" Value="Vendor Chargeback" />
                                                    <dx:ListEditItem Text="Third Party Account" Value="Third Party Account" />
                                                    <dx:ListEditItem Text="Third Party Chargeback" Value="Third Party Chargeback" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    
                                </Items>
                        </dx:LayoutGroup>
                        <dx:LayoutGroup Caption="Enter Payment Detail" Name="PaymentDetail" ColCount="3" ColSpan="2" AlignItemCaptions="False" Width="100%">
                                <Items>
                                    <dx:LayoutItem Caption="Payment Details" ColSpan="3">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox ID="ASPxFormLayout1_E14" runat="server" Width="170px">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <CaptionSettings Location="Left" />
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Attach Customer PO" ColSpan="3">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server" SupportsDisabledAttribute="True">
                                                <telerik:RadAsyncUpload ID="RadAsyncUpload3" runat="server" ChunkSize="0" DropZones=".DropZone1" MultipleFileSelection="Automatic" Skin="Metro" UploadedFilesRendering="BelowFileInput" OnClientFileDropped="" OnClientFileSelected="" OnClientFilesSelected="">
                                                </telerik:RadAsyncUpload>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <CaptionSettings Location="Top" />
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Customer Carrier">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox ID="ASPxFormLayout1_E31" runat="server" Width="170px">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <CaptionSettings Location="Left" />
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Customer Carrier Mode">
                                        <LayoutItemNestedControlCollection>
                                     <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server" SupportsDisabledAttribute="True">
                                         <dx:ASPxTextBox ID="ASPxFormLayout1_E38" runat="server" Width="170px">
                                         </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Customer Carrier Account">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox ID="ASPxFormLayout1_E39" runat="server" Width="170px">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <CaptionSettings Location="Left" />
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Attach Customer Authorization to Ship on Their Account" ColSpan="3">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <telerik:RadAsyncUpload ID="RadAsyncUpload2" runat="server" ChunkSize="0" DropZones=".DropZone1" MultipleFileSelection="Automatic" Skin="Metro" UploadedFilesRendering="BelowFileInput" OnClientFileDropped="" OnClientFileSelected="" OnClientFilesSelected="">
                                                </telerik:RadAsyncUpload>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <CaptionSettings Location="Top" />
                                    </dx:LayoutItem>
                                </Items>
                        </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Shipping Instructions" ColCount="3" ColSpan="2" Width="100%">
                                <Items>
                                    <dx:LayoutItem Caption="Carrier" ColSpan="1" Width="33%">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxComboBox ID="ASPxFormLayout1_E30" runat="server" Width="80%">
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Mode" ColSpan="1" Width="33%" FieldName="MODE">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxComboBox ID="ASPxFormLayout1_E32" runat="server" Width="80%">
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Account" ColSpan="1" Width="33%" FieldName="ACCOUNT_NUMBER">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox ID="ASPxFormLayout1_E33" runat="server" Width="80%">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Special Instructions" ColSpan="3" Width="100%">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox ID="ASPxFormLayout1_E36" runat="server" Width="95.5%">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Estimated Cost" ColSpan="1" Width="33%" FieldName="EST_COST">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox ID="ASPxFormLayout1_E34" runat="server" Width="80%">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Tracking Number" ColSpan="1" Width="33%" FieldName="TRACKING_NUMBER">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox ID="ASPxFormLayout1_E35" runat="server" Width="80%">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                        </dx:LayoutGroup>
                            </Items>
                        <SettingsItems HorizontalAlign="Left" />
                        <Paddings Padding="0px" />
<Styles>
<LayoutGroupBox>
<Caption ForeColor="#6666FF"></Caption>
    <Border BorderColor="#9999FF" BorderWidth="2px" />
</LayoutGroupBox>
</Styles>
                    </dx:ASPxFormLayout>	    



                <asp:SqlDataSource ID="SqlDataSourcePFA" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" SelectCommand="SELECT * FROM [eeiuser].[Freight_PFA] WHERE ([PFA_ID] = @PFA_ID)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="3792" Name="PFA_ID" Type="Int32" />
                    </SelectParameters>
            </asp:SqlDataSource>



                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>            
        <br />
       <asp:Table ID="DecisionTable" runat="server" Width="1000px">
            <asp:TableRow ID="TableRow1" runat="server" Height="35px" Width="100%">
                <asp:TableCell ID="TableCell1" runat="server" Width="35%"/>
                <asp:TableCell ID="TableCell2" runat="server" Width="15%" Font-Bold="true" Font-Size="Larger">
                    <dx:ASPxButton ID="ASPxButton1" runat="server" Height="30px" HorizontalAlign="Center" Text="Cancel" Width="100px">
                    </dx:ASPxButton>
                </asp:TableCell>
                <asp:TableCell ID="TableCell3" runat="server" Width="15%">
                    <dx:ASPxButton ID="ASPxButton2" runat="server" Height="30px" HorizontalAlign="Center" Text="Submit" Width="100px">
                    </dx:ASPxButton>
                </asp:TableCell>
                <asp:TableCell ID="TableCell4" runat="server" Width="35%"/>
            </asp:TableRow>
        </asp:Table>      
        
	</form>
</body>
</html>

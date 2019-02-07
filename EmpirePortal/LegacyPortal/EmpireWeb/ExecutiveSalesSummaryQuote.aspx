<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExecutiveSalesSummaryQuote.aspx.cs" Inherits="ExecutiveSalesSummaryQuote" %> 

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quote Log</title>

<telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
<style type="text/css">
    body {
	font-family: Arial;
    	font-size: 17px;
    }
    #mainContainer {
	margin-top: 20px;
	padding: 10px;
	
    }
    .tableContainer {
	float: left;
	margin-right: 10px;
    }
    .header {
	color: #808080;
    }
    .data {
	color: #000000;
    }
    #space {
	clear: both;
	margin-left: 3px;
    }
    th, td {
    	padding: 2px;
    	text-align: left;
    }
</style>
<script type="text/javascript">
</script>
</head>

<body>
<form id="form1" runat="server">
<telerik:RadScriptManager ID="RadScriptManager1" runat="server">
	<Scripts>
		<%--Needed for JavaScript IntelliSense in VS2010--%>
        <%--For VS2008 replace RadScriptManager with ScriptManager--%>
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
	</Scripts>
</telerik:RadScriptManager>
<div id="mainContainer">
	<div class="tableContainer">
		<table>
			<tr>
				<td class="header">
					<asp:label ID="lblQuoteNumber" runat="server" Text="Quote Number:" />					
				</td>
				<td class="data">
					<asp:label ID="QuoteNumber" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblCustomer" runat="server" Text="Customer:" />					
				</td>
				<td class="data">
					<asp:label ID="Customer" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblCustRFQNumber" runat="server" Text="Customer RFQ Number:" />					
				</td>
				<td class="data">
					<asp:label ID="CustomerRFQNumber" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblCustPartNumber" runat="server" Text="Customer Part Number:" />					
				</td>
				<td class="data">
					<asp:label ID="CustomerPartNumber" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblEEIPartNumber" runat="server" Text="EEI Part Number:" />					
				</td>
				<td class="data">
					<asp:label ID="EEIPartNumber" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblModelYear" runat="server" Text="Model Year:" />					
				</td>
				<td class="data">
					<asp:label ID="ModelYear" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblRequote" runat="server" Text="Requote:" />					
				</td>
				<td class="data">
					<asp:label ID="Requote" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblStraightMaterialCost" runat="server" Text="Straight Material Cost:" />					
				</td>
				<td class="data">
					<asp:label ID="StraightMaterialCost" runat="server" Text="" DataFormatString = "{0:C0}" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblStdHours" runat="server" Text="Std Hours:" />					
				</td>
				<td class="data">
					<asp:label ID="StdHours" runat="server" Text="" DataFormatString = "{0:N0}" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblTooling" runat="server" Text="Tooling Cost:" />					
				</td>
				<td class="data">
					<asp:label ID="Tooling" runat="server" Text="" DataFormatString = "{0:C0}"/>
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblQuotePrice" runat="server" Text="Quote Price:" />					
				</td>
				<td class="data">
					<asp:label ID="QuotePrice" runat="server" Text="" DataFormatString = "{0:C0}" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblPrototypePrice" runat="server" Text="Prototype Price:" />					
				</td>
				<td class="data">
					<asp:label ID="PrototypePrice" runat="server" Text="" DataFormatString = "{0:C0}" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblSop" runat="server" Text="SOP:" />					
				</td>
				<td class="data">
					<asp:label ID="SOP" runat="server" Text="" />
				</td>
			</tr>
		</table>
	</div>
	<div class="tableContainer">
		<table>
			<tr>
				<td class="header">
					<asp:label ID="lblReceiptDate" runat="server" Text="Receipt Date:" />					
				</td>
				<td class="data">
					<asp:label ID="ReceiptDate" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblRequestedDueDate" runat="server" Text="Requested Due Date:" />					
				</td>
				<td class="data">
					<asp:label ID="RequestedDueDate" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblEEIPromisedDueDate" runat="server" Text="EEI Promised Due Date:" />					
				</td>
				<td class="data">
					<asp:label ID="EEIPromisedDueDate" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblOEM" runat="server" Text="OEM:" />					
				</td>
				<td class="data">
					<asp:label ID="OEM" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblApplicationCode" runat="server" Text="Application Code:" />					
				</td>
				<td class="data">
					<asp:label ID="ApplicationCode" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblApplicationName" runat="server" Text="Application Name:" />					
				</td>
				<td class="data">
					<asp:label ID="ApplicationName" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblFunctionName" runat="server" Text="Function Name:" />					
				</td>
				<td class="data">
					<asp:label ID="FunctionName" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblEAU" runat="server" Text="EAU:" />					
				</td>
				<td class="data">
					<asp:label ID="EAU" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblAwarded" runat="server" Text="Awarded:" />					
				</td>
				<td class="data">
					<asp:label ID="Awarded" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblProgram" runat="server" Text="Program:" />					
				</td>
				<td class="data">
					<asp:label ID="Program" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblNameplate" runat="server" Text="Nameplate:" />					
				</td>
				<td class="data">
					<asp:label ID="Nameplate" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblPackageNumber" runat="server" Text="Package Number:" />					
				</td>
				<td class="data">
					<asp:label ID="PackageNumber" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblEOP" runat="server" Text="EOP:" />					
				</td>
				<td class="data">
					<asp:label ID="EOP" runat="server" Text="" />
				</td>
			</tr>
		</table>
	</div>
	<div class="tableContainer">
		<table>
			<tr>
				<td class="header">
					<asp:label ID="lblProgramManagerInitials" runat="server" Text="Program Manager Initials:" />					
				</td>
				<td class="data">
					<asp:label ID="ProgramManagerInitials" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblEngineeringInitials" runat="server" Text="Engineering Initials:" />					
				</td>
				<td class="data">
					<asp:label ID="EngineeringInitials" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblSalesInitials" runat="server" Text="Sales Initials:" />					
				</td>
				<td class="data">
					<asp:label ID="SalesInitials" runat="server" Text="" />
				</td>
			</tr>
		</table>
	</div>
	<div class="tableContainer">
		<table>
			<tr>
				<td class="header">
					<asp:label ID="lblEngineeringMaterialsInitials" runat="server" Text="Engineering Materials Initials:" />					
				</td>
				<td class="data">
					<asp:label ID="EngineeringMaterialsInitials" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblEngineeringMaterialsDate" runat="server" Text="Engineering Materials Date:" />					
				</td>
				<td class="data">
					<asp:label ID="EngineeringMaterialsDate" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblQuoteReviewInitials" runat="server" Text="Quote Review Initials:" />					
				</td>
				<td class="data">
					<asp:label ID="QuoteReviewInitials" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblQuoteReviewDate" runat="server" Text="Quote Review Date:" />					
				</td>
				<td class="data">
					<asp:label ID="QuoteReviewDate" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblQuotePricingInitials" runat="server" Text="Quote Pricing Initials:" />					
				</td>
				<td class="data">
					<asp:label ID="QuotePricingInitials" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblQuotePricingDate" runat="server" Text="Quote Pricing Date:" />					
				</td>
				<td class="data">
					<asp:label ID="QuotePricingDate" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblCustomerQuoteInitials" runat="server" Text="Customer Quote Initials:" />					
				</td>
				<td class="data">
					<asp:label ID="CustomerQuoteInitials" runat="server" Text="" />
				</td>
			</tr>
			<tr>
				<td class="header">
					<asp:label ID="lblCustomerQuoteDate" runat="server" Text="Customer Quote Date:" />					
				</td>
				<td class="data">
					<asp:label ID="CustomerQuoteDate" runat="server" Text="" />
				</td>
			</tr>
		</table>
	</div>
	<div id="space">&nbsp;
	</div>
	<div>
		<div style="margin-top: 10px; margin-left: 3px; color: #808080;">
			<asp:label ID="lblNotes" runat="server" Text="Notes:" />
		</div>
		<div style="margin-left: 3px;">
			<asp:label ID="Notes" runat="server" Text="" />
		</div>
	</div>
</div>
</form>
</body>
</html>
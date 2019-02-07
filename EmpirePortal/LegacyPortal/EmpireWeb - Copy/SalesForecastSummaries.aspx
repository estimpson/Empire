<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastSummaries.aspx.cs" Inherits="SalesForecastSummaries" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web.ASPxGridView" Assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>
<%@ Register tagprefix="dx" namespace="DevExpress.Web.ASPxEditors" Assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sales Forecast Summaries</title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <style type="text/css">
        .RadInput_Default{font:12px "segoe ui",arial,sans-serif}
        .RadInput{vertical-align:middle}
        .style1
        {
            border-collapse: collapse;
            width: 100%;
            vertical-align: bottom;
            border-style: none;
            border-color: inherit;
            border-width: 0;
        }
        .style2
        {
            width: 100%;
            padding-right: 4px;
        }
        .style3 {
            display: inline-table;
        }
    </style>
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
    	<telerik:RadAjaxManager runat="server">
        	<AjaxSettings>
            		<telerik:AjaxSetting AjaxControlID="FilterTypeComboBox">
                		<UpdatedControls>
				
					<telerik:AjaxUpdatedControl ControlID="FilterComboBox" />
                    			<telerik:AjaxUpdatedControl ControlID="FilterComboBoxDataSource" />
           
                		</UpdatedControls>
            		</telerik:AjaxSetting>
		</AjaxSettings>
	</telerik:RadAjaxManager>


	<asp:Panel ID="Panel1" runat="server">
		<div style="margin-bottom: 20px">
            	
	        	<strong>Choose Filter Type:&nbsp;&nbsp;</strong>
        		<telerik:RadComboBox ID="FilterComboBox" runat="server" DataSourceID="FilterComboBoxDataSource"
                		DataTextField="Filter" DataValueField="Filter" MarkFirstMatch="true" AutoPostBack="true">
            		</telerik:RadComboBox>

	            	<asp:SqlDataSource ID="FilterComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
        	        	SelectCommand="select Filter from eeiuser.WP_SalesForecastSummaries_Filter order by Filter">
            		</asp:SqlDataSource>
		
		</div>
            	


		<div>

            <telerik:RadGrid ID="SalesForeCastSummariesRadGrid" runat="server" CellSpacing="1" DataSourceID="SalesForecastSummariesRadGridDataSource"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True">
                
		<MasterTableView DataSourceID="SalesForecastSummariesRadGridDataSource" HeaderStyle-HorizontalAlign="Left"
                    	ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                    	FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
			AutoGenerateColumns="False">
		
		<Columns>
                        <telerik:GridBoundColumn DataField="Filter" FilterControlAltText=""
                            HeaderText="" ReadOnly="True" SortExpression="Filter" UniqueName="Filter">
				<HeaderStyle Width="175px" />
                        </telerik:GridBoundColumn> 
                        <telerik:GridBoundColumn DataField="Sales_2016" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column"
                            HeaderText="2016 Sales" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column"
                            HeaderText="2017 Sales" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2018" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column"
                            HeaderText="2018 Sales" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2019" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column"
                            HeaderText="2019 Sales" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2020" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column"
                            HeaderText="2020 Sales" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2021" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column"
                            HeaderText="2021 Sales" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2022" DataType="System.Decimal" FilterControlAltText="Filter Sales_2022 column"
                            HeaderText="2022 Sales" ReadOnly="True" SortExpression="Sales_2022" UniqueName="Sales_2022"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        
			<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                            HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                            HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                            HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                            HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                            HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                            HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
		</Columns>
        
                </MasterTableView>
            </telerik:RadGrid>


            <asp:SqlDataSource ID="SalesForecastSummariesRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.usp_WP_SalesForecastSummaries" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="FilterComboBox" DefaultValue="Customer" Name="Filter" PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>


        </div>
    </asp:Panel>
    </form>

</body>
</html>     


<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSMDemand2.aspx.cs" Inherits="RadGridRelatedForm" %>
<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add New Base Part to Master Sales Forecast</title>
  
</head>
<body>
    <form id="form1" runat="server">
  
        <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" EnableTheming="True" Theme="DevEx">
            <Items>
                <dx:LayoutItem Caption="Release ID">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxDropDownEdit ID="ASPxFormLayout1_E22" runat="server">
                            </dx:ASPxDropDownEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Base Part">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E4" runat="server">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="SalesPerson">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxListBox ID="ASPxFormLayout1_E5" runat="server" DataSourceID="SqlDataSource1">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="product_line">
                                    </dx:ListBoxColumn>
                                </Columns>
                            </dx:ASPxListBox>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:EEHMONITORConnectionString %>" SelectCommand="select distinct(id) as product_line from product_line order by 1"></asp:SqlDataSource>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Date of Award">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxDateEdit ID="ASPxFormLayout1_E6" runat="server">
                            </dx:ASPxDateEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Type of Award">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxDropDownEdit ID="ASPxFormLayout1_E7" runat="server">
                            </dx:ASPxDropDownEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Family">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E8" runat="server">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Customer">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTokenBox ID="ASPxFormLayout1_E9" runat="server" AllowMouseWheel="True" Tokens="">
                            </dx:ASPxTokenBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Parent Customer">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E10" runat="server">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Product Line">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxComboBox ID="ASPxFormLayout1_E26" runat="server" DataSourceID="SqlDataSource1">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="product_line">
                                    </dx:ListBoxColumn>
                                </Columns>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Empire Market Segment">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxListBox ID="ASPxFormLayout1_E12" runat="server">
                            </dx:ASPxListBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Empire Market SubSegment">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxListBox ID="ASPxFormLayout1_E13" runat="server">
                            </dx:ASPxListBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Empire Application">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E14" runat="server">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Empire SOP">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxDateEdit ID="ASPxFormLayout1_E15" runat="server">
                            </dx:ASPxDateEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Empire EOP">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxDateEdit ID="ASPxFormLayout1_E16" runat="server">
                            </dx:ASPxDateEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Customer Selling Price">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E17" runat="server">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Material Cost">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E18" runat="server">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Part Used for Cost">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxTextBox ID="ASPxFormLayout1_E19" runat="server">
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                <dx:LayoutItem Caption="Include in Master Sales Forecast?">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer runat="server">
                            <dx:ASPxCheckBox ID="ASPxFormLayout1_E20" runat="server" CheckState="Unchecked">
                            </dx:ASPxCheckBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
            </Items>
        </dx:ASPxFormLayout>
     
        <div id="Div1" runat="server" >
            <center>
                <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>           
                    <telerik:RadButton  ID="RadButtonInsertPart" 
                                        runat="server"  
                                        onclick="RadButtonInsertPart_Click"
                                        Text="Create New Base Part" 
                                        Height="22px" 
                                        Width="200px">
                    </telerik:RadButton>
            <asp:SqlDataSource ID="SqlDataSourceAM" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        SelectCommand="select account_manager,account_manager_description from empower.dbo.account_managers where inactive &lt;&gt; 1"></asp:SqlDataSource>
            <asp:SqlDataSource  ID="SqlDataSourceInsertPart" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        InsertCommand="eeiuser.acctg_csm_sp_insert_new_base_part" 
                                        InsertCommandType="StoredProcedure" >
                                            <InsertParameters>
                                                <asp:ControlParameter Name="release_id"                 ControlID="RadTextBox50"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="base_part"                  ControlID="RadTextBox51"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="salesperson"                  ControlID="RadTextBox4"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="date_of_award"                     ControlID="RadTextBox5"        Type="DateTime"       PropertyName="Text" />
                                                <asp:ControlParameter Name="type_of_award"                   ControlID="RadTextBox6"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="family"                     ControlID="RadTextBox52"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="customer"                   ControlID="RadTextBox53"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="parent_customer"            ControlID="RadTextBox54"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="product_line"               ControlID="RadTextBox55"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_market_segment"      ControlID="RadTextBox56"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_market_subsegment"   ControlID="RadTextBox57"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_application"         ControlID="RadTextBox58"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_sop"                 ControlID="RadTextBox59"        Type="DateTime"     PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_eop"                 ControlID="RadTextBox60"        Type="DateTime"     PropertyName="Text" />
                                                <asp:ControlParameter Name="sp"                         ControlID="RadNumericTextBox1"  Type="Decimal"      PropertyName="Text" />
                                                <asp:controlParameter Name="mc"                         ControlID="RadNumericTextBox2"  Type="Decimal"      PropertyName="Text" />
                                                <asp:ControlParameter Name="part_used_for_mc"           ControlID="RadTextBox61"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="include_in_forecast"        ControlID="CheckBox1"           Type="Boolean"      PropertyName="Checked" />
                                            </InsertParameters>
                    </asp:SqlDataSource>
              </center>
            </div>                          
    </form>
</body>
</html>

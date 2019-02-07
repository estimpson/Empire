<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixTransferPrice.aspx.cs" Inherits="Default3" %>

<%@ Register assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" KeyFieldName="id" Width="100%" Settings-HorizontalScrollBarMode="Visible">
      
            <Columns>
                <dx:GridViewBandColumn Caption ="Part" HeaderStyle-Border-BorderStyle="Double" HeaderStyle-BackColor="#99ccff">
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="id" ReadOnly="True" VisibleIndex="0" Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="P_ProductLine" Caption="Product Line" Width="125" ReadOnly="true" VisibleIndex="1">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="P_part" Caption= "Part" Width="120" ReadOnly="True" VisibleIndex="3">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PS_price" Caption="Price" Width="80" VisibleIndex="4">
                        <CellStyle BackColor = "lightGreen"></CellStyle>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PS_material_cum" Caption= "Transfer Price" Width="80" VisibleIndex="5">
                        <CellStyle BackColor = "MintCream"></CellStyle>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PS_frozen_material_cum" Caption="EEH Material" Width="80" ReadOnly="true" VisibleIndex="6">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataDateColumn FieldName="date_updated" Caption="Date Updated" Width="80" PropertiesDateEdit-AllowNull="true"  VisibleIndex="7" CellStyle-HorizontalAlign="Center" CellStyle-BorderRight-BorderWidth="3">
                    </dx:GridViewDataDateColumn>
                </Columns>
                </dx:GridViewBandColumn>
                
                <dx:GridViewBandColumn Caption="NJB / ECN">
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="NJB_Number" Caption="NJB" ReadOnly="True" Width="70" VisibleIndex="8">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="NJB_QuoteNumber" Caption="Quote Number" Width="70" ReadOnly="true" VisibleIndex="9">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="NJB_ProductionSelling" Caption="Production Price" Width="80" ReadOnly="true" VisibleIndex="10">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="NJB_SellingPrice" Caption="Prototype Price" Width = "80" ReadOnly="True" VisibleIndex="11" CellStyle-BorderRight-BorderWidth="3">
                    </dx:GridViewDataTextColumn>
                </Columns>
                </dx:GridViewBandColumn>
                
                <dx:GridViewBandColumn Caption ="Quote Log" HeaderStyle-Border-BorderStyle="Double" HeaderStyle-BackColor="#99ccff">
                    <Columns>

                        <dx:GridViewDataTextColumn FieldName="QL_ProductionPrice" Caption ="Production Price" Width="80" ReadOnly="true" VisibleIndex="16">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="QL_PrototypePrice" Caption="Prototype Price" Width="80" ReadOnly="True" VisibleIndex="17">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="QL_LTAs" ReadOnly="True" VisibleIndex="19" CellStyle-BorderRight-BorderWidth="3">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    </dx:GridViewBandColumn>
                    
                    <dx:GridViewBandColumn Caption="Sales Order">
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="SO_order_no" Caption="Order No" Width="70" ReadOnly="true" VisibleIndex="20">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="SO_customer_part" Caption = "customer Part" Width="100" ReadOnly="true" VisibleIndex="21">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="SO_customer" Caption = "Customer" Width="90" ReadOnly="True" VisibleIndex="22">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="SO_destination" Caption = "Destination" Width="110" ReadONly="true" VisibleIndex="23">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="SO_price" Caption = "Price" Width="80" ReadOnly="True" VisibleIndex="24">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    </dx:GridViewBandColumn>

                 <dx:GridViewBandColumn Caption="Object Historical">
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="OH_qty_on_hand" Caption="Beg Qty" Width="80" ReadOnly="true" VisibleIndex="25">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="OH_price" Caption = "Price" Width="80" ReadOnly="True" VisibleIndex="26">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="OH_TransferPrice" Caption = "Transfer Price" Width="80" ReadOnly="True" VisibleIndex="27">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    </dx:GridViewBandColumn>

            </Columns>
            <SettingsBehavior AllowSelectByRowClick="True" ColumnResizeMode="Control" ConfirmDelete="True" />
            <SettingsPager Mode="ShowAllRecords">
            </SettingsPager>
            <SettingsEditing Mode="Batch">
                <BatchEditSettings EditMode="Row" StartEditAction="DblClick" />
            </SettingsEditing>
            <Settings ShowFilterBar="Visible" UseFixedTableLayout="True" VerticalScrollableHeight="700" VerticalScrollBarMode="Visible" ShowHeaderFilterButton="True" />
            <Styles Header-Wrap="True"></Styles>
        </dx:ASPxGridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" 
            SelectCommand="SELECT [id], [P_ProductLine],  [P_part], [PS_price], [PS_material_cum], [PS_frozen_material_cum], [date_updated],[NJB_Number],[NJB_QuoteNumber],[NJB_ProductionSelling],[NJB_SellingPrice],[QL_Part],[QL_ProductionPrice],[QL_PrototypePrice],[QL_TransferPrice],[QL_LTAs],[SO_order_no],[SO_customer_part],[SO_customer],[SO_destination],[SO_price],[OH_qty_on_hand],[OH_price],[OH_TransferPrice] FROM [eeiuser].[acctg_inv_reconciliation] WHERE [date_updated] >= '2017-05-01' or isnull([date_updated],'')='' ORDER BY [P_ProductLine], [P_type], [P_part]" 
            UpdateCommand="UPDATE [eeiuser].[acctg_inv_reconciliation] set [PS_price] = @PS_price,  [PS_material_cum] = @PS_material_cum where [id] = @id">
            <UpdateParameters>
                <asp:Parameter Name="PS_price" />
                <asp:Parameter Name="PS_material_cum" />
                <asp:Parameter Name="id" />
            </UpdateParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>

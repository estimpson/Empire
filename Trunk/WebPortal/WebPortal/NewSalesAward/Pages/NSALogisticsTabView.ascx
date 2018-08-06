<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSALogisticsTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSALogisticsTabView" %>

<script>
    var postponedCallbackRequired = false;

    function OnSaveLogisticsClicked(s, e) {
        if (LogisticsCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            LogisticsCallbackPanel.PerformCallback();
    }

    function OnEndLogisticsCallback(s, e) {
        if (postponedCallbackRequired) {
            LogisticsCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="LogisticsCallbackPanel" runat="server" OnCallback="LogisticsCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndLogisticsCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxFormLayout ID="LogisticsFormLayout" runat="server" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Empire Facility" FieldName="EmpireFacility">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="EmpireFacilityComboBox" runat="server" DropDownStyle="DropDownList" TextField="Code" DataSourceID="EmpireFacilityEntityDataSource" 
                                                 ValueField="Code" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteLogistics.EmpireFacility'); }" 
                                    />
                                    <Columns>
                                        <dx:ListBoxColumn Caption="Code" FieldName="Code" Name="Code" Width="80" />
                                        <dx:ListBoxColumn Caption="Name" FieldName="Name" Name="Name" Width="160" />
                                    </Columns>
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="EmpireFacilityEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EmpireFacilities" Select="" OrderBy="it.Code">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Freight Terms" FieldName="FreightTerms">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="FreightTermsComboBox" runat="server" DropDownStyle="DropDown" TextField="Code" DataSourceID="FreightTermsEntityDataSource" 
                                                 ValueField="FreightTerms" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteLogistics.FreightTerms'); }" 
                                    />
                                    <Columns>
                                        <dx:ListBoxColumn Caption="FreightTerms" FieldName="FreightTerms" Name="FreightTerms" Width="200" />
                                    </Columns>
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="FreightTermsEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="FreightTerms" Select="" OrderBy="it.FreightTerms">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Customer Ship Tos" FieldName="CustomerShipTos">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="CustomerShipTosComboBox" runat="server" DropDownStyle="DropDownList" TextField="Code" DataSourceID="CustomerShipTosEntityDataSource" 
                                                 ValueField="ShipToCode" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteLogistics.CustomerShipTos'); }" 
                                    />
                                    <Columns>
                                        <dx:ListBoxColumn Caption="ShipToCode" FieldName="ShipToCode" Name="ShipToCode" Width="90" />
                                        <dx:ListBoxColumn Caption="ShipToName" FieldName="ShipToName" Name="ShipToName" Width="200" />
                                        <dx:ListBoxColumn Caption="CustomerCode" FieldName="CustomerCode" Name="CustomerCode" Width="100" />
                                        <dx:ListBoxColumn Caption="CustomerName" FieldName="CustomerName" Name="CustomerName" Width="220" />
                                    </Columns>
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="CustomerShipTosEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="CustomerShipTos" Select="" OrderBy="it.ShipToCode">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem>
                    </dx:EmptyLayoutItem>
                    <dx:LayoutItem ShowCaption="False">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxButton ID="btnSaveLogistics" runat="server" AutoPostBack="False" Text="Save">
                                    <ClientSideEvents Click="OnSaveLogisticsClicked"></ClientSideEvents>
                                </dx:ASPxButton>
                                <dx:ASPxButton ID="SaveCheckMark" runat="server" RenderMode="Link" Enabled="False" Visible="True">
                                    <Image IconID="actions_apply_32x32office2013"/>
                                </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.SalesForecast.PageViewModels;
using System.Drawing;
using DevExpress.Web;
using System.Data;
using WebPortal.SalesForecast.Models;

namespace WebPortal.SalesForecast.Pages
{
    public partial class SalesForecastUpdated : System.Web.UI.Page
    {
        private PageViewModels.SalesForecastUpdatedViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (SalesForecastUpdatedViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new SalesForecastUpdatedViewModel();
                return ViewModel;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            Session["op"] = Request.QueryString["op"];
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                AuthenticateUser();

                if (GetEopYears() == 1) GetSalesForecastUpdated(); // Populate grid
            }
        }


        #region Control Events
        protected void cbxYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            ObjectDataSource1.SelectParameters["eop"].DefaultValue = cbxEopYears.Text;
            gvSalesForecastUpdated.DataBind();
        }

        protected void gvSalesForecastUpdated_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (gvSalesForecastUpdated.IsNewRowEditing) return;
            string column = e.Column.FieldName;
            ASPxEditBase editor = e.Editor;

            EditModeDisableColumns(column, editor); // Disable editing of non-base-part-closeout columns

            if (column == "VerifiedEop") EditModePopulateVerifiedEop(editor); // Populate the VerifiedEOP combobox

            if (column == "SchedulerResponsible") EditModePopulateSchedulerResponsible(editor); // Populate the SchedulerResponsible combobox 
        }

        protected void gvSalesForecastUpdated_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "ClearSort") gvSalesForecastUpdated.ClearSort();
        }

        protected void btnEx_Click(object sender, EventArgs e)
        {
            ExportData();
        }

        #endregion



        #region Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        private int GetEopYears()
        {
            ViewModel.GetEopYears();
            if (ViewModel.Error != "")
            {
                lblError.Text = "Failed to return EOP years list. " + ViewModel.Error + " GetEopYears().";
                pcError.ShowOnPageLoad = true;
                return 0;
            }

            cbxEopYears.DataSource = ViewModel.EopYearList;
            cbxEopYears.TextField = "EmpireEopYear";
            cbxEopYears.ValueField = "EmpireEopYear";
            cbxEopYears.DataBind();

            // If the current year does not exist in the list, set selected year as the min year in the list
            int? minYear = ViewModel.EopYearList.FirstOrDefault().EmpireEopYear;
            cbxEopYears.Text = ViewModel.EopYearList.FirstOrDefault(i => i.EmpireEopYear == DateTime.Now.Year).EmpireEopYear.ToString();
            if (cbxEopYears.Text == "") cbxEopYears.Text = minYear.ToString();

            return 1;
        }

        private void GetSalesForecastUpdated()
        {
            ObjectDataSource1.SelectParameters["eop"].DefaultValue = cbxEopYears.Text;
            gvSalesForecastUpdated.DataBind();
        }

        private void EditModeDisableColumns(string column, ASPxEditBase e)
        {
            if (column == "Status" || column == "BasePart" || column == "ParentCustomer" || column == "Program" || column == "Vehicle" || column == "EmpireSop" ||
                column == "MidModelYear" || column == "EmpireEop" || column == "EmpireEopNote" || column == "VerifiedEopDate" || column == "CsmSop" || 
                column == "CsmEop" || column == "Sales2016" || column == "Sales2017" || column == "Sales2018" || column == "Sales2019" || column == "Sales2020" ||
                column == "Sales2021" || column == "Sales2022" || column == "Sales2023" || column == "Sales2024" || column == "Sales2025")
            {
                e.ReadOnly = true;
                e.ClientEnabled = false;
            }
        }

        private void EditModePopulateVerifiedEop(ASPxEditBase e)
        {
            List<String> eopTypes = new List<string> { "", "CSM", "Empire", "MidModel" };
  
            var cmb = e as ASPxComboBox;
            cmb.DataSource = eopTypes;
            cmb.DataBind();
        }

        private void EditModePopulateSchedulerResponsible(ASPxEditBase e)
        {
            if (GetSchedulers() == 0) return;

            var cmb = e as ASPxComboBox;
            cmb.DataSource = ViewModel.SchedulersList;
            cmb.ValueField = "Scheduler";
            cmb.TextField = "Scheduler";
            cmb.DataBind();
        }

        private int GetSchedulers()
        {
            ViewModel.GetSchedulers();
            if (ViewModel.Error != "")
            {
                lblError.Text = "Failed to return schedulers list. " + ViewModel.Error + " GetSchedulers().";
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void RefreshDataSource()
        {
            ObjectDataSource1.SelectParameters["eop"].DefaultValue = cbxEopYears.Text;
            gvSalesForecastUpdated.DataBind();
        }

        private void ExportData()
        {
            try
            {
                gridExporter.WriteXlsToResponse();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                lblError.Text = "Export failed. " + error + " ExportData().";
                pcError.ShowOnPageLoad = true;
            }
        }

        #endregion


    }
}
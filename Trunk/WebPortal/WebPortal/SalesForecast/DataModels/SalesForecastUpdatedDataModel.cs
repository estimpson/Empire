using System;

namespace WebPortal.SalesForecast.DataModels
{
    [Serializable]
    public class SalesForecastUpdatedDataModel
    {
        public int? RowId { get; set; }
        public String Status { get; set; }
        public String ParentCustomer { get; set; }
        public String Program { get; set; }
        public String Vehicle { get; set; }
        public String BasePart { get; set; }
        public String EmpireSop { get; set; }
        public String MidModelYear { get; set; }
        public String EmpireEop { get; set; }
        public String EmpireEopNote { get; set; }
        public String VerifiedEop { get; set; }
        public String VerifiedEopDate { get; set; }
        public String CsmSop { get; set; }
        public String CsmEop { get; set; }
        public String Sales2016 { get; set; }
        public String Sales2017 { get; set; }
        public String Sales2018 { get; set; }
        public String Sales2019 { get; set; }
        public String Sales2020 { get; set; }
        public String Sales2021 { get; set; }
        public String Sales2022 { get; set; }
        public String Sales2023 { get; set; }
        public String Sales2024 { get; set; }
        public String Sales2025 { get; set; }
        public String SchedulerResponsible { get; set; }
        public String RfMpsLink { get; set; }
        public String SchedulingTeamComments { get; set; }
        public String MaterialsComments { get; set; }
        public String ShipToLocation { get; set; }
        public String FgInventoryAfterBuildout { get; set; }
        public String CostEach { get; set; }
        public String ExcessFgAfterBuildout { get; set; }
        public String ExcessRmAfterBuildout { get; set; }
        public String ProgramExposure { get; set; }
        public String DateToSendCoLetter { get; set; }
    }
}
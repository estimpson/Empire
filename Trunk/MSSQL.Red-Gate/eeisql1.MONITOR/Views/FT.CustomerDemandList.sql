SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [FT].[CustomerDemandList]
AS
	SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI2040ic.CurrentPlanningReleases() c
		JOIN	EDI2040ic.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
	SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI3030ic.CurrentPlanningReleases() c
		JOIN	EDI3030ic.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
	SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI3040ic.CurrentPlanningReleases() c
		JOIN	EDI3040ic.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI3060ic.CurrentPlanningReleases() c
		JOIN	EDI3060ic.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI5050ic.CurrentPlanningReleases() c
		JOIN	EDI5050ic.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI4010.CurrentPlanningReleases() c
		JOIN	EDI4010.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIADAC.CurrentPlanningReleases() c
		JOIN	EDIADAC.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIAutoLiv.CurrentPlanningReleases() c
		JOIN	EDIAutoLiv.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIChryslerIC.CurrentPlanningReleases() c
		JOIN	EDIChryslerIC.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIEDIFACT04A.CurrentPlanningReleases() c
		JOIN	EDIEDIFACT04A.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIEDIFACT97A.CurrentPlanningReleases() c
		JOIN	EDIEDIFACT97A.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIFordIC.CurrentPlanningReleases() c
		JOIN	EDIFordIC.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDILearMexico.CurrentPlanningReleases() c
		JOIN	EDILearMexico.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIMagnaITC.CurrentPlanningReleases() c
		JOIN	EDIMagnaITC.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDINAL.CurrentPlanningReleases() c
		JOIN	EDINAL.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIVarrocIC.CurrentPlanningReleases() c
		JOIN	EDIVarrocIC.PlanningHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI2040ic.CurrentShipSchedules() c
		JOIN	EDI2040ic.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
	SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI3030ic.CurrentShipSchedules() c
		JOIN	EDI3030ic.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
	SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI3040ic.CurrentShipSchedules() c
		JOIN	EDI3040ic.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI3060ic.CurrentShipSchedules() c
		JOIN	EDI3060ic.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI5050ic.CurrentShipSchedules() c
		JOIN	EDI5050ic.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
	UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDI4010.CurrentShipSchedules() c
		JOIN	EDI4010.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIADAC.CurrentShipSchedules() c
		JOIN	EDIADAC.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIAutoLiv.CurrentShipSchedules() c
		JOIN	EDIAutoLiv.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIChryslerIC.CurrentShipSchedules() c
		JOIN	EDIChryslerIC.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIEDIFACT04A.CurrentShipSchedules() c
		JOIN	EDIEDIFACT04A.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIEDIFACT97A.CurrentShipSchedules() c
		JOIN	EDIEDIFACT97A.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIFordIC.CurrentShipSchedules() c
		JOIN	EDIFordIC.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDILearMexico.CurrentShipSchedules() c
		JOIN	EDILearMexico.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIMagnaITC.CurrentShipSchedules() c
		JOIN	EDIMagnaITC.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDInal.CurrentShipSchedules() c
		JOIN	EDINAL.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID
		UNION
		SELECT  h.TradingPartner, c.CustomerPart, c.ShipToCode,  h.DocumentImportDT
		FROM EDIVarrocIC.CurrentShipSchedules() c
		JOIN	EDIVarrocIC.ShipScheduleHeaders h ON h.RawDocumentGUID = c.RawDocumentGUID



		



GO

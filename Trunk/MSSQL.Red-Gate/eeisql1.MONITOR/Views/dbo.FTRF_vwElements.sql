SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_vwElements](ID,ModuleID,ModuleName,"Name",Settings) as select FTRF_Elements.ID,FTRF_Modules.ID,FTRF_Modules."Name",FTRF_Elements."Name",FTRF_Elements.Settings from dbo.FTRF_Elements join dbo.FTRF_Modules on FTRF_Modules.ID=FTRF_Elements.ModuleID
GO

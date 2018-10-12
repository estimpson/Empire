SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[SP_MAT_RPT_SOP]( 
		@ListaOFParts varchar(1000),
		@UseCustomPO char(1) = 'N',
		@Vendor varchar(10),
		@OnlyCompounds char(1) = 'N',
		@WeeksInventory smallint = 0 )
as
exec EEH.HN.SP_MAT_RPT_SOP
		@ListaOFParts = @ListaOFParts,
		@UseCustomPO = @UseCustomPO,
		@Vendor  = @Vendor,
		@OnlyCompounds = @OnlyCompounds,
		@WeeksInventory = @WeeksInventory
GO

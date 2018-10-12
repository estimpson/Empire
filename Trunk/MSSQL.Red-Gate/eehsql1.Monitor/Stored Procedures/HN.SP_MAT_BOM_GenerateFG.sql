SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [HN].[SP_MAT_BOM_GenerateFG]( 
	@ListaOFParts varchar(1000), 
	@Required int, 
	@Fecha datetime,
	@AddMachineMoldingInventory int = 1,
	@ShowWipParts smallint = 1,
	@ObsoleteReport smallint = 0)
as


Exec EEH.HN.SP_MAT_BOM_GenerateFG
	@ListaOFParts= @ListaOFParts, 
	@Required = @Required,
	@Fecha = @Fecha,
	@AddMachineMoldingInventory= @AddMachineMoldingInventory,
	@ShowWipParts = @ShowWipParts,
	@ObsoleteReport = @ObsoleteReport


GO

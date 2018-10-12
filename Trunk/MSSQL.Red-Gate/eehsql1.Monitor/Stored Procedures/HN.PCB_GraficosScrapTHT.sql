SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [HN].[PCB_GraficosScrapTHT] 
(	 @FechaInicial as date,	 @FechaFinal as date	 )
as
/*

*/
begin
	delete from [dbo].[HN.PCB_Graficas_ScrapsTHT]
	insert into [dbo].[HN.PCB_Graficas_ScrapsTHT] (Part,Defect,Qty,Tipo)
	select  part, defectcode, ABS(sum(qtyscrapped)) QtyScrapped, tipo=1
			from eeh.dbo.Defects
			where part like '%rtr%' 
				and machine ='tht'
				and transactiondt between @fechaInicial and @FechaFInal
				and wodid>0
			group by part, defectcode

	insert into [dbo].[HN.PCB_Graficas_ScrapsTHT] (Part,Defect,Qty,Tipo)
	select  top 10 part, defectcode, ABS(sum(qtyscrapped)) QtyScrapped, tipo=2
			from eeh.dbo.Defects
			where part like '%rtr%' 
				and machine ='tht'
				and transactiondt between @fechaInicial and @FechaFInal
				and wodid>0
			group by part, defectcode
end		
GO

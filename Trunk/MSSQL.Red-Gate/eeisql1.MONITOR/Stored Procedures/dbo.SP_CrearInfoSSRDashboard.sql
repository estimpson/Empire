SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CrearInfoSSRDashboard]

AS
BEGIN
	IF Exists(Select 1 from [dbo].[TemporalDataDashboardSSR])
	Begin
		TRUNCATE TABLE [dbo].[TemporalDataDashboardSSR]
	End

Insert into [dbo].[TemporalDataDashboardSSR]
	SELECT	 OBJ.Serial
		,OBJ.Part
		,OBJ.Objectbirthday
		,OBJ.Location
		,OBJ.Quantity
		,OBJ.Status
		,Lot=datediff(wk,OBJ.objectbirthday,getdate())
		,OBJ.Note
		,SSR_Number=case when isnull(ssr.ssr_id,'ssrnull')='ssrnull' then ( case when OBJ.note='OPEN SSR - ON HOLD DUE TO FIFO' then 'release_certify' else 'NO SSR' end ) else ssr.ssr_id end
		,defect
		,Hour_time=(isnull(Acum_SecondsPieceRate,6))/3600
		,Hour_needed=((isnull(Acum_SecondsPieceRate,6))/3600)*OBJ.Quantity
		,Opera=(((isnull(Acum_SecondsPieceRate,6))/3600)*OBJ.Quantity)/35
		,Historial.status
		,NoSSR=case when ssr.ssr_id is null
					then 1  --else '' end ) 
					else 0 end
		,Fifo=''
FROM MONITOR.dbo.object OBJ
left join	location on location.code = OBJ.location
left join  monitor.dbo.SSR_LogbySerial SSR on ssr.serial=OBJ.serial  
left join    eehsql1.Sistema.dbo.SSR_Historial Historial on Historial.SSR_ID = SSR.SSR_ID
left join (
				select part,Acum_SecondsPieceRate=sum(isnull(PieceRate,10)) from HN.SSR_Historial
				WHERE  PART IS NOT NULL 
				AND PART<>'' 
				AND (SUBSTRING(PART,1,1)<>'"' AND  SUBSTRING(PART,1,1)<>',' AND  SUBSTRING(PART,1,1)<>'´')   
				and status not in(0,3)
				group by part

		   ) XdatapieceRate on XdatapieceRate.part=OBJ.Part
WHERE   (OBJ.status='H') 
		AND (OBJ.part<>'pallet') 
		AND OBJ.quantity>0
		and OBJ.location not like 'LTL-CLAIMS%' 
		and OBJ.location not like 'DMCAGE%'
		--and obj.location not like 'TRAN%' 
		--and isnull(location.secured_location,'N')='N'
		AND (historial.status<>0  or historial.status is Null)

order by part


--Declare	@MaxLote int
--SET	MaxLote = (select max(Lote) from TemporalDataDashboardSSR)					

--begin tran

update [dbo].[TemporalDataDashboardSSR]
set		Fifo = '*'
from	[dbo].[TemporalDataDashboardSSR] Temp
join	(	select Part,MaxLote=max(Lote) 
			from TemporalDataDashboardSSR
			group by Part
		)MaxLotes on MaxLotes.MaxLote = Temp.Lote
				and MaxLotes.Part = Temp.Part


--select	*
--from	TemporalDataDashboardSSR
--where	Fifo = '*' and  Part='AUT0092-HA00'

--rollback tran

--UPDATE	TemporalDataDashboardSSR
--set	Fifo = '*'
--where Lote= @MaxLote

END

--exec [dbo].[SP_CrearInfoSSRDashboard]




 
GO

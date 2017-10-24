SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <2017-25-04>
-- Description:	<crea tablas temporates para almacenar la informacion del Dashboard >
-- =============================================


--exec [dbo].[SP_CrearInfoDashboard]
CREATE PROCEDURE [dbo].[SP_CrearInfoDashboard]

AS
BEGIN

	IF OBJECT_ID (N'dbo.#DATA', N'U') IS NOT NULL  
	DROP TABLE dbo.#DATA

								Create table #DATA (rowID int 
											,Part_Number varchar(25)
											,Quantity int
											,Due_date date
											,Customer_Part varchar(25)
											,Cum_Order int
											,Approve int
											,OnHold int
											,Show_After_App int
											,Cum_HoldNeed int
											,Sort_needed INT
											,Show_on_Dashboard INT
											,Week int
											,YEAR int)
			

	IF OBJECT_ID (N'dbo.#acumulado', N'U') IS NOT NULL  
	DROP TABLE dbo.#acumulado

	create table #acumulado (rowID int identity (1,1) primary key,Part varchar(25),Quantity int,Due_date date)

	insert #acumulado
		SELECT part_number,quantity,due_date
		FROM order_detail
		GROUP BY part_number,quantity,due_date
		order by 1,3


		IF OBJECT_ID (N'dbo.#Sort_Needed', N'U') IS NOT NULL  
	DROP TABLE dbo.#Sort_Needed

	create table #Sort_Needed (rowID int identity (1,1) primary key,Part_Number varchar(25),Quantity int,Due_date date,Customer_Part varchar(25),Cum_Order int,Approve int,OnHold int,Show_After_App int,Cum_HoldNeed int)

	Insert #sort_Needed
	--SELECT   Origen.Part_Number
	--		,Quantity=convert(int,origen.quantity)
	--		,Origen.Due_Date
	--		,Origen.Customer_Part
	--		,Cum_Order=Acumulado.Acumulado
	--		,Approve=convert(int,isnull(PartAprob.qty_approved,0))
	--		,OnHold=convert(int,isnull(Hold.qty_hold,0))

	--		,Show_After_App=Case When Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0))<=0 
	--						Then 0 
	--						Else Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0)) 
	--						End

	--		,Cum_HoldNeed=Case When (
	--									Case When Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0))<=0 
	--									Then 0 Else Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0)) End
	--														) - ( convert(int,isnull(Hold.qty_hold,0))) <0 
	--						Then  ( 
	--									Case When Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0))<=0 
	--									Then 0 Else Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0)) End
	--								) 
	--						Else 
	--						convert(int,isnull(Hold.qty_hold,0))
	--						End

	--FROM order_detail origen 

	--	left join (	 
	--			SELECT origen.Part,origen.Quantity,Acumulado=Sum(Acumulado.Quantity),origen.due_date FROM #acumulado as origen
	--			left join #acumulado as Acumulado on origen.RowID>=Acumulado.RowID and origen.part=Acumulado.part
		
	--			GROUP BY origen.Part,origen.Quantity,origen.due_date
		
	--			) Acumulado  on acumulado.part=origen.part_number and Acumulado.Due_date=origen.Due_date
select dataOriginal.*
			,Cum_Order=Acumulado.Acumulado
			,Approve=convert(int,isnull(PartAprob.qty_approved,0))
			,OnHold=convert(int,isnull(Hold.qty_hold,0))
			,Show_After_App=Case When Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0))<=0 
							Then 0 
							Else Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0)) 
							End

			,Cum_HoldNeed=Case When (
										Case When Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0))<=0 
										Then 0 Else Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0)) End
															) - ( convert(int,isnull(Hold.qty_hold,0))) <0 
							Then  ( 
										Case When Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0))<=0 
										Then 0 Else Acumulado.Acumulado-convert(int,isnull(PartAprob.qty_approved,0)) End
									) 
							Else 
							convert(int,isnull(Hold.qty_hold,0))
							End
 from (
SELECT   Origen.Part_Number
			,Quantity=sum(convert(int,origen.quantity))
			,Origen.Due_Date
			,Origen.Customer_Part
	FROM order_detail origen 
--	where part_number='ADC0144-HF00'
	group by Origen.Part_Number,Origen.Due_Date,Origen.Customer_Part
	)dataOriginal
	
		inner join (	 
				SELECT origen.Part,origen.Quantity,Acumulado=Sum(Acumulado.Quantity),origen.due_date FROM #acumulado as origen
				inner join #acumulado as Acumulado on origen.RowID>=Acumulado.RowID and origen.part=Acumulado.part
		
				GROUP BY origen.Part,origen.Quantity,origen.due_date
				--order by 4
				) Acumulado  on acumulado.part=dataOriginal.part_number and convert(date,Acumulado.Due_date)=convert(date,dataOriginal.Due_date) and  Acumulado.Acumulado >=dataOriginal.quantity

		left join  (
					SELECT obj.part, qty_approved=sum(obj.quantity) 
					FROM object obj
					left join	location on location.code = obj.location
					WHERE	obj.status='A' 
							and obj.location not like 'TRAN%' 
							and obj.location not like 'LTL-CLAIMS%' 
							and obj.location not like 'DMCAGE%' 							
							and isnull(location.secured_location,'N')='N'
					GROUP BY part 
				
				) PartAprob on PartAprob.part=dataOriginal.part_number

		inner join (
				SELECT obj.part, qty_hold=sum(obj.quantity) 
					FROM object obj
					left join	location on location.code = obj.location
					WHERE	obj.status='H' 
							and obj.location not like 'LTL-CLAIMS%' 
							and obj.location not like 'DMCAGE%' 
							--and isnull(location.secured_location,'N')='N'
					GROUP BY part 
				) Hold on hold.part=dataOriginal.part_number
		--left join  (
		--			SELECT part, qty_approved=sum(quantity) 
		--			FROM object WHERE status='a'  
		--			and location not like 'TRAN%' GROUP BY part 
		--		) PartAprob on PartAprob.part=origen.part_number

		--left join (
		--		SELECT part, qty_hold=sum(quantity) 
		--		FROM object WHERE status='h' 
		--		GROUP BY part 	
		--		) Hold on hold.part=origen.part_number


	INSERT INTO #DATA
				SELECT Need.*
						,Sort_needed = isnull((Need.Cum_HoldNeed - NeedSub.Cum_HoldNeed),Need.Cum_HoldNeed)
						,Show_on_Dashboard=Case When (isnull((Need.Cum_HoldNeed - NeedSub.Cum_HoldNeed),Need.Cum_HoldNeed))=0 Then 0 else 1 end
						,Week=DATEPART(week,need.Due_date)
						,year=year(need.Due_date)
					FROM #sort_Needed Need 
						left join 
						(SELECT RowID = RowID + 1,Cum_HoldNeed,Part_Number FROM #sort_Needed) NeedSub 
					on  Need.RowID = NeedSub.RowID  and Need.Part_Number = NeedSub.Part_Number

	TRUNCATE TABLE [dbo].[TemporalDataDashboard]

	Insert into dbo.TemporalDataDashboard						
	SELECT DATA.*
			,Destination=substring(isnull(PTI.distribution_plant,''),1,3) 
			,Acum_SecondsPieceRate=isnull(XdatapieceRate.Acum_SecondsPieceRate,6)
			,Hours_required=(isnull(XdatapieceRate.Acum_SecondsPieceRate,10)*data.Sort_needed)/3600
			,Resources=((isnull(XdatapieceRate.Acum_SecondsPieceRate,10)*data.Sort_needed)/3600)/40
			,CreateBy=Null
			,CreateDT=getdate()
	FROM #DATA DATA  
				Left JOIN eehsql1.monitor.dbo.part_inventory PTI on Data.Part_Number=PTI.Part 
				Left JOIN eehsql1.monitor.dbo.part PARTE  on PARTE.part=PTI.Part	
				left join (
						
								SELECT part,Acum_SecondsPieceRate=sum(isnull(PieceRate,6)) FROM HN.SSR_Historial
								WHERE  PART IS NOT NULL 
								AND PART<>'' 
								AND (SUBSTRING(PART,1,1)<>'"' AND  SUBSTRING(PART,1,1)<>',' 
								AND  SUBSTRING(PART,1,1)<>'´') 
								AND status not in(0,3) 
								GROUP BY part--,PieceRate	
							) XdatapieceRate on XdatapieceRate.part=DATA.Part_Number
							
	WHERE Upper(PARTE.type)='F'

	order by 2
					
	--Drop table #acumulado
	--Drop table #Sort_Needed
	--DROP TABLE #DATA

	exec [dbo].[SP_CrearInfoSSRDashboard]

END


		/* 

		EXEC SP_CrearInfoDashboard

		*/


		--select distinct * from [dbo].[TemporalDataDashboard] where part_number='ADC0144-HF00' 






GO

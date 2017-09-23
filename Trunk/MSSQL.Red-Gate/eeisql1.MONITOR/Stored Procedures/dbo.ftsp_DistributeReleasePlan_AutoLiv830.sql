SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE  procedure [dbo].[ftsp_DistributeReleasePlan_AutoLiv830]
as
/*
Assertions:
1) EDI must contain "Net" quantities because if we are shipping against other orders, the accums will get out of "whack."
2) Customer must only send 830's, otherwise we should be focussing on splitting 862's.
3) Release dates are shipping dates.
4) Exactly one part will be marked as the CurrentRevLevel.
5) Only one blanket order will exist for any revision.
*/
--begin transaction ProcessReleasePlan

--delete	log
--where	spid = @@spid

/*
insert	log
(	spid,
	id,
	message )
select	@@spid,
	(	select	isnull (max (id), 0) + 1
		from	log
		where	spid = @@spid),
	'Log purged successfully.'
*/
--execute ftsp_LogComment
--	@Comment = 'Log purged successfully.'


--execute ftsp_LogBegin --'Start processing ' + convert ( varchar ( 20 ), getdate ( ) ) + '.'
--	@StartDT = GetDate()

--execute ftsp_LogComment
--	@Comment = 'Searching for blanket order for customer part :  (' + @customerpart + ', destination :' + @shipto + ', customer po :' + @customerpo + ' & model year :'+ @modelyear+'.  Processing release #  (' + @releaseno+') due ' + convert ( varchar(20), @releasedt, 113) + '.'

--Clear API table
TRUNCATE TABLE m_in_release_plan

UPDATE	dbo.raw_830_release
SET		n104_1 = EDIAddresses.ShipToID
FROM	dbo.raw_830_release
CROSS JOIN	(SELECT MAX(address_id) ShipToID FROM dbo.raw_830_address WHERE address_type = 'ST') EDIAddresses

UPDATE	dbo.raw_830_shp
SET		n104_1 = EDIAddresses.ShipToID
FROM	dbo.raw_830_release
CROSS JOIN	(SELECT MAX(address_id) ShipToID FROM dbo.raw_830_address WHERE address_type = 'ST') EDIAddresses


TRUNCATE TABLE dbo.raw_830_address
							
Create table #CumulativereleasePlan (
							lineid			integer identity,
							customerpart	varchar (35),
							destination		varchar (20),
							customerPO		varchar	(20),
							modelYear		varchar	(4),
							ReleaseNumber	varchar(30),
							QtyQual			char(1),
							Qty				numeric(20,6),
							DateType		char(1),
							ReleaseDate		DATETIME,
							Accum			numeric (20,6),
							CustomerAccum	numeric (20,6),
							EmpireAccum		numeric (20,6))
							
Create table #releasePlan (
							lineid	integer identity,
							customerpart	varchar (35),
							destination		varchar (20),
							customerPO		varchar	(20),
							modelYear			varchar	(4),
							ReleaseNumber	varchar(30),
							QtyQual				char(1),
							Qty						numeric(20,6),
							DateType			char(1),
							ReleaseDate		DATETIME,
							CustomerAccum	numeric (20,6))
						

insert #releasePlan(		customerpart	,
							destination		,
							customerPO		,
							modelYear			,
							ReleaseNumber	,
							QtyQual				,
							Qty						,
							DateType			,
							ReleaseDate		,
							customerAccum		)
	
	
	
	select 	rtrim(lin03),
			COALESCE((SELECT		MAX(order_header.destination) 
				FROM	order_header
				JOIN	edi_setups ON order_header.destination = edi_setups.destination
				WHERE	order_header.customer_part = RTRIM(raw_830_release.lin03) AND
						edi_setups.parent_destination = RTRIM(raw_830_release.n104_1)), RTRIM(raw_830_release.n104_1) ),
			rtrim(lin05),
			'',
			rtrim(bfr_rel)+'*830',
			'N',
			convert(numeric(20,6),fst01),
			'S',		
			dateadd(dd, -1*isNULL ((SELECT		MAX(edi_setups.id_code_type) 
				FROM	order_header
				JOIN	edi_setups ON order_header.destination = edi_setups.destination
				WHERE	order_header.customer_part = RTRIM(raw_830_release.lin03) AND
						edi_setups.parent_destination = RTRIM(raw_830_release.n104_1)),0),convert(datetime,fst04)),
				(SELECT	MAX(CONVERT(numeric(20,6), shp02))
					FROM 	"raw_830_shp"
					WHERE	RTRIM(raw_830_shp.lin03) = RTRIM(raw_830_release.lin03) AND
							RTRIM(raw_830_shp.n104_1) = RTRIM(raw_830_release.n104_1) AND
					RTRIM(shp01)= '02')
	 FROM "raw_830_release" 
ORDER BY 1,2,9

INSERT #CumulativereleasePlan
        ( customerpart ,
          destination ,
          customerPO ,
          modelYear ,
          ReleaseNumber ,
          QtyQual ,
          Qty ,
          DateType ,
          ReleaseDate ,
          Accum ,
          CustomerAccum ,
          EmpireAccum
        )

	select 	customerpart,
			destination,
			customerPO,
			ModelYear,
			ReleaseNumber,
			QtyQual,
			Qty,
			DateType,
			ReleaseDate,
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid),
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid)+COALESCE(CustomerAccum,0),
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid)+COALESCE((SELECT	MIN(order_header.our_cum )
																FROM	order_header 
																JOIN	part_eecustom ON order_header.blanket_part = part_eecustom.part 
																WHERE	ISNULL(NULLIF(order_header.status,''),'C') = 'A' AND 
																		order_header.customer_part = #releasePlan.CustomerPart AND
																		order_header.destination = #releasePlan.destination), CustomerAccum,0)
	 FROM #releasePlan
	 order by destination, customerpart, ReleaseDate       
DELETE	#CumulativereleasePlan
WHERE	(Accum-(EmpireAccum-CustomerAccum))<=0



UPDATE	#CumulativereleasePlan
SET		#CumulativereleasePlan.Qty = (#CumulativereleasePlan.Accum-(#CumulativereleasePlan.EmpireAccum-#CumulativereleasePlan.CustomerAccum))
FROM	#CumulativereleasePlan
JOIN	(SELECT MIN(lineid)FIRSTLINEID
				 FROM	#CumulativereleasePlan
				 GROUP BY	customerpart,
							destination) FIRSTROWCRP ON #CumulativereleasePlan.Lineid =FIRSTROWCRP.FIRSTLINEID


INSERT	dbo.m_in_release_plan
        ( customer_part ,
          shipto_id ,
          customer_po ,
          model_year ,
          release_no ,
          quantity_qualifier ,
          quantity ,
          release_dt_qualifier ,
          release_dt
        )
SELECT	customerpart,
		destination,
		customerPO,
		modelYear,
		ReleaseNumber,
		'N',
		ISNULL(Qty,0),
		'S',
		ReleaseDate
FROM	#CumulativereleasePlan CRP
LEFT JOIN	(
                      select
						oh.customer_part as CP
                      , oh.customer_po AS CPO
                      , oh.destination as ST
                      , max(od.the_cum) as FirmAccum
                      from
                        dbo.order_detail od
                      JOIN
						order_header oh ON od.order_no = oh.order_no
					  WHERE
						od.release_no LIKE '%*862' AND
						EXISTS (SELECT 1 FROM dbo.m_in_release_plan mrp2 WHERE mrp2.customer_part=oh.customer_part AND mrp2.shipto_id = oh.destination AND mrp2.customer_po = oh.customer_po) 
                      group by
                        oh.customer_part
                      , oh.destination
                      , oh.customer_po
                     ) CustomerPartDestination
                    on CRP.customerpart = CP
                       and CRP.destination = ST
                       AND	CRP.customerpo = CPO
WHERE	COALESCE(Accum,1) > COALESCE(FirmAccum,0)
 

 insert  m_in_release_plan
            select
                order_detail.customer_part
            ,   order_detail.destination
            ,   order_header.customer_po
            ,   ''
            ,   order_detail.release_no
            ,   'N'
            ,  order_detail.quantity
            ,   'S'
            ,   order_detail.due_date
            from
                order_detail
                join order_header
                    on order_detail.order_no = order_header.order_no
                join (
                      select
                        max(release_dt) as LastDate
                      , customer_part as CP
                      , customer_po AS CPO
                      , shipto_id as ST
                      , sum(quantity) as FirmAccum
                      from
                        m_in_release_plan
                      group by
                        customer_part
                      , shipto_id
                      ,customer_po
                     ) CustomerPartDestination
                    on order_detail.customer_part = CP
                       and order_detail.destination = ST
                       AND	order_header.customer_po = CPO
            where
              order_detail.release_no LIKE '%*862'
            order by
                2
            ,   1
            ,   9


 

Update		order_header
set			custom01 = rtrim(udf9)
FROM 		"raw_830_shp"
	LEFT OUTER JOIN 	"edi_setups"  ON rtrim("raw_830_shp"."n104_1") = "edi_setups"."parent_destination"
	  JOIN	"order_header"   ON edi_setups.destination = order_header.destination
	  WHERE rtrim(raw_830_shp.lin03) = order_header.customer_part

 
--EXEC dbo.ftsp_DistributeReleasePlan


	  
	  SELECT	'Inserted m_in_release_plan'




GO

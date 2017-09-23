SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [FT].[fn_CSM_ActiveFinishedPart]()


RETURNS @ActiveParts TABLE
(	BasePart CHAR(7) PRIMARY KEY
,	ActiveOrderPart VARCHAR(25)
,	CurrentRevLevel VARCHAR(25)
,	LastShippedPart VARCHAR(25)
,	LastHN VARCHAR(25)
,	LastPT VARCHAR(25)
,	ActiveOrderPart1 VARCHAR(25)
,	CurrentRevLevel1 VARCHAR(25)
,	LastShippedPart1 VARCHAR(25)
)
AS
BEGIN 

--Get BOM from EEH
DECLARE @EEHBOMs TABLE
 (	Toppart VARCHAR(25),
	ChildPart VARCHAR(25),
	Quantity NUMERIC(20,6)
)

INSERT @EEHBOMs
        ( Toppart, ChildPart, Quantity )

		SELECT 
		* 
		FROM
		OPENQUERY
		(	EEHSQL1
		,	' Select * from Monitor.dbo.vw_RawQtyPerFinPart
		'

		) BOMS






INSERT
	@ActiveParts
(	BasePart
,	ActiveOrderPart
,	CurrentRevLevel
,	LastShippedPart
,	LastHN
,	LastPT
,	ActiveOrderPart1
,	CurrentRevLevel1
,	LastShippedPart1
)
SELECT
	ap.BasePart
,	(	SELECT
 			MAX(BOM.TopPart)
 		FROM
 			@EEHBOMs BOM
		WHERE
			BOM.TopPart LIKE
				CASE
					WHEN ap.ActiveOrderPart LIKE '___[ABC]___ 'THEN LEFT(ap.ActiveOrderPart, 3) + '%' + RIGHT(ap.ActiveOrderPart, LEN(ap.ActiveOrderPart)-4)
					ELSE ap.ActiveOrderPart
				END
 	)
,	(	SELECT
 			MAX(BOM.TopPart)
 		FROM
 			@EEHBOMs BOM
		WHERE
			BOM.TopPart LIKE
				CASE
					WHEN ap.CurrentRevLevel LIKE '___[ABC]___' THEN LEFT(ap.CurrentRevLevel, 3) + '%' + RIGHT(ap.CurrentRevLevel, LEN(ap.CurrentRevLevel)-4)
					ELSE ap.CurrentRevLevel
				END
 	)
,	(	SELECT
 			MAX(BOM.TopPart)
 		FROM
 			@EEHBOMs BOM
		WHERE
			BOM.TopPart LIKE
				CASE
					WHEN ap.LastShippedPart LIKE '___[ABC]___' THEN LEFT(ap.LastShippedPart, 3) + '%' + RIGHT(ap.LastShippedPart, LEN(ap.LastShippedPart)-4)
					ELSE ap.LastShippedPart
				END
 	)
,	(	SELECT
 			MAX(BOM.TopPart)
 		FROM
 			@EEHBOMs BOM
		WHERE
			BOM.TopPart LIKE
				CASE
					WHEN ap.BasePart LIKE '___[ABC]___' THEN LEFT(ap.BasePart, 3) + '%' + RIGHT(ap.BasePart, 3)
					ELSE ap.BasePart
				END + '%-H%'
 	)
,	(	SELECT
 			MAX(BOM.TopPart)
 		FROM
 			@EEHBOMs BOM
		WHERE
			BOM.TopPart LIKE
				CASE
					WHEN ap.BasePart LIKE '___[ABC]___' THEN LEFT(ap.BasePart, 3) + '%' + RIGHT(ap.BasePart, 3)
					ELSE ap.BasePart
				END + '%-PT%'
 	)
,	(ap.ActiveOrderPart)
,	(ap.CurrentRevLevel)
,	(ap.LastShippedPart)
FROM
	(

select
	acvssf.BasePart
,	ActiveOrderPart = max(coalesce(xr1.ChildPart, acvssf.ActiveOrderPart))
,	CurrentRevLevel = max(coalesce(xr2.ChildPart, acvssf.CurrentRevLevel))
,	LastShippedPart = max(coalesce(xr3.ChildPart, acvssf.LastShippedPart))
from
	(	select
			BasePart = acvssf.base_part
		,	ActiveOrderPart = max(ohActive.blanket_part)
		,	CurrentRevLevel = max(pe.part)
		,	LastShippedPart = max(lastShip.part)
		from
			MONITOR.eeiuser.acctg_csm_vw_select_sales_forecast acvssf
			left join MONITOR.dbo.order_header ohActive
				on ohActive.status = 'A'
				and left(ohActive.blanket_part, 7) = acvssf.base_part
			left join MONITOR.dbo.part_eecustom pe
				on pe.CurrentRevLevel = 'Y'
				and left(pe.part, 7) = acvssf.base_part
			outer apply
				(	select top 1
						part = sd.part_original
					from
						MONITOR.dbo.shipper_detail sd
					where
						left(sd.part_original, 7) = acvssf.base_part
						and sd.date_shipped is not null
						and sd.part_original not like '%-PT%'
					order by
						sd.date_shipped desc
				) lastShip
		group by
			acvssf.base_part
	) acvssf
	left join Monitor.FT.XRt xr1
		join Monitor.dbo.po_header ph1
			on ph1.blanket_part = xr1.ChildPart
			and ph1.vendor_code = 'EEH'
		on xr1.TopPart = acvssf.ActiveOrderPart
		and xr1.TopPart != xr1.ChildPart
	left join Monitor.FT.XRt xr2
		join Monitor.dbo.po_header ph2
			on ph2.blanket_part = xr2.ChildPart
			and ph2.vendor_code = 'EEH'
		on xr2.TopPart = acvssf.CurrentRevLevel
		and xr2.TopPart != xr2.ChildPart
	left join Monitor.FT.XRt xr3
		join Monitor.dbo.po_header ph3
			on ph3.blanket_part = xr3.ChildPart
			and ph3.vendor_code = 'EEH'
		on xr3.TopPart = acvssf.LastShippedPart
		and xr3.TopPart != xr3.ChildPart
group by
	acvssf.BasePart

		) ap





	RETURN
END

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_capture_badAudit_trail] ( @beginDate datetime )
as

	-- dbo.usp_capture_badAudit_trail '2015-01-01'
	begin
		declare @Audittrail table

		(	atpart varchar (25),
			atquantity int,
			atPackCount int,
			atshipper int )



		Declare @ShipperDetail table

			(	sdpart varchar (25),
			sdquantity int,
			sdPackCount int,
			sdshipper int ,
			sdDateShipped datetime)

	insert @Audittrail
		Select  part,
				sum(quantity),
				count(1),
				shipper
			From
				audit_trail 
				Where date_stamp>=  @BeginDate and type = 'S'
			Group by 
				part,
				shipper

		insert @ShipperDetail
		Select  part_original,
				qty_packed,
				boxes_staged,
				shipper,
				shipper.date_shipped
			From
				shipper_detail 
			join
				shipper on shipper_detail.shipper = shipper.id and shipper.type is NULL
				Where shipper.date_shipped>=  @BeginDate 
				



	Select *
From @ShipperDetail sd
	left join
		@AuditTrail at on at.atshipper = sd.sdshipper and
		at.atpart = sd.sdpart
	Where
		(coalesce(at.atquantity,0) !=sd.sdquantity or coalesce(at.atpackCount,0) != sd.sdPackCount)

end


GO

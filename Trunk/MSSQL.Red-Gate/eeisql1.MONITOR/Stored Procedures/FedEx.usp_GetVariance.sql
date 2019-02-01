SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FedEx].[usp_GetVariance] 
	@StartDate datetime
,	@EndDate datetime
as
set nocount on
set ansi_warnings on


-- Insert unique identities and tracking identities into temp table
declare @Variance table
(
	ID int
,	ExpressOrGroundTrackingId bigint
,	NetChargeAmount decimal(20,6) null
,	SumOfEstimate decimal(20,6) null
,	SumOfVariance decimal(20,6) null
)

insert into @Variance
(
	ID
,	ExpressOrGroundTrackingId
,	NetChargeAmount
,	SumOfEstimate
,	SumOfVariance
)
select
	v.ID
,	v.ExpressOrGroundTrackingId
,	v.NetChargeAmount
,	null
,	null
from
	FedEx.Variance v
where
	v.InvoiceDate between @StartDate and @EndDate
order by
	v.ID asc



--Prepare for processing
declare @UniqueIdentities table
(
	ID int
,	Processed int
)

insert into @UniqueIdentities
(
	ID
,	Processed
)
select
	v.ID
,	0
from
	@Variance v
order by
	v.ID asc



-- Loop through identities to get sum of estimate
declare 
	@ID int
,	@ServiceType varchar(50)
,	@Estimate decimal(20,6)

while ((select count(*) from @UniqueIdentities ui where ui.Processed = 0) > 0) begin

	select
		@ID = min(ui.ID)
	from 
		@UniqueIdentities ui
	where
		ui.Processed = 0

	select
		@ServiceType = v.ServiceType
	from 
		FedEx.Variance v
	where
		v.ID = @ID
		


	if (@ServiceType = 'FedEx Intl Economy') begin
				
		select @Estimate = 
			case
				when v.ZoneCode = 'A' then (select r.ZoneA from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'B' then (select r.ZoneB from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'C' then (select r.ZoneC from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'D' then (select r.ZoneD from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'E' then (select r.ZoneE from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'F' then (select r.ZoneF from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'G' then (select r.ZoneG from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'H' then (select r.ZoneH from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'I' then (select r.ZoneI from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'J' then (select r.ZoneJ from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'K' then (select r.ZoneK from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'L' then (select r.ZoneL from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'M' then (select r.ZoneM from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'N' then (select r.ZoneN from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'O' then (select r.ZoneO from fedex.IE_Rates r where r.Weight = v.NormalizedWeightRounded)
			end 
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx Intl Priority') begin

		select @Estimate = 
			case
				when v.ZoneCode = 'A' then (select r.ZoneA from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'B' then (select r.ZoneB from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'C' then (select r.ZoneC from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'D' then (select r.ZoneD from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'E' then (select r.ZoneE from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'F' then (select r.ZoneF from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'G' then (select r.ZoneG from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'H' then (select r.ZoneH from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'I' then (select r.ZoneI from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'J' then (select r.ZoneJ from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'K' then (select r.ZoneK from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'L' then (select r.ZoneL from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'M' then (select r.ZoneM from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'N' then (select r.ZoneN from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'O' then (select r.ZoneO from fedex.IP_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end	
	else if (@ServiceType = 'FedEx Intl Economy Frt') begin
	           	
		select @Estimate = 
			case
				when v.ZoneCode = 'A' then (select r.ZoneA from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'B' then (select r.ZoneB from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'C' then (select r.ZoneC from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'D' then (select r.ZoneD from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'E' then (select r.ZoneE from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'F' then (select r.ZoneF from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'G' then (select r.ZoneG from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'H' then (select r.ZoneH from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'I' then (select r.ZoneI from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'J' then (select r.ZoneJ from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'K' then (select r.ZoneK from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'L' then (select r.ZoneL from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'M' then (select r.ZoneM from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'N' then (select r.ZoneN from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'O' then (select r.ZoneO from fedex.IPE_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx Intl Priority Frt') begin

		select @Estimate = 
			case
				when v.ZoneCode = 'A' then (select r.ZoneA from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'B' then (select r.ZoneB from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'C' then (select r.ZoneC from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'D' then (select r.ZoneD from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'E' then (select r.ZoneE from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'F' then (select r.ZoneF from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'G' then (select r.ZoneG from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'H' then (select r.ZoneH from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'I' then (select r.ZoneI from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'J' then (select r.ZoneJ from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'K' then (select r.ZoneK from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'L' then (select r.ZoneL from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'M' then (select r.ZoneM from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'N' then (select r.ZoneN from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = 'O' then (select r.ZoneO from fedex.IPF_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx Express Saver') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.ESP_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx Priority Overnight') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.PO_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx Standard Overnight') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.SO_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'Ground') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.GR_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx 2Day') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.E2_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx First Overnight') begin

		select 
			@Estimate = v.NetChargeAmount
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx 2Day A.M.') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.E2AM_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx 1Day Freight') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.F1_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx 2Day Freight') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.F2_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end
	else if (@ServiceType = 'FedEx 3Day Freight') begin

		select @Estimate = 
			case
				when v.ZoneCode in ('2', '02') then (select r.Zone02 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('3', '03') then (select r.Zone03 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('4', '04') then (select r.Zone04 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('5', '05') then (select r.Zone05 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('6', '06') then (select r.Zone06 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('7', '07') then (select r.Zone07 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('8', '08') then (select r.Zone08 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode in ('9', '09') then (select r.Zone09 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '10' then (select r.Zone10 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '11' then (select r.Zone11 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '12' then (select r.Zone12 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '13' then (select r.Zone13 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '14' then (select r.Zone14 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '15' then (select r.Zone15 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
				when v.ZoneCode = '16' then (select r.Zone16 from fedex.F3_Rates r where r.Weight = v.NormalizedWeightRounded)
			end
		from
			FedEx.Variance v
		where
			v.ID = @ID

	end



	update
		@Variance
	set
		SumOfEstimate = @Estimate
	where
		ID = @ID



	update
		@UniqueIdentities
	set
		Processed = 1
	where
		ID = @ID

end



-- Get sum of variance
update
	@Variance
set
	SumOfVariance = NetChargeAmount - SumOfEstimate



-- Return results
select
	v.ID
,	v.ExpressOrGroundTrackingId
,	v.NetChargeAmount
,	v.SumOfEstimate
,	v.SumOfVariance
from
	@Variance v
order by
	v.SumOfVariance desc


return

GO

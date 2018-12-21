SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FedEx].[usp_GetVariance2] 
	@StartDate datetime
,	@EndDate datetime
as
set nocount on
set ansi_warnings on



declare @Variance table
(
	ID int identity primary key 
,	FuelSurchargeID int null
,	OtherChargesID int null
,	ExpressOrGroundTrackingId bigint
,	TransportationChargeAmount decimal(20,6)
,	NetChargeAmount decimal(20,6)
,	TransChargeAmtPlusChargesLessDiscounts decimal(20,6)
,	RateEstimate decimal(20,6) null
,	VarianceAmount decimal(20,6) null
,	VariancePercentageOfNetCharge decimal(10,2) null
,	ServiceType varchar(50)
,	Origin varchar(50)
,	Destination varchar(50)
,	RecipientCountry varchar(50)
,	ShipperCountry varchar(50)
,	TrackingIdChargeDescription1 varchar(500)
,	TrackingIdChargeAmount1 varchar(50)
,	TrackingIdChargeDescription2 varchar(500)
,	TrackingIdChargeAmount2 varchar(50)
,	TrackingIdChargeDescription3 varchar(500)
,	TrackingIdChargeAmount3 varchar(50)
,	TrackingIdChargeDescription4 varchar(500)
,	TrackingIdChargeAmount4 varchar(50)
,	TrackingIdChargeDescription5 varchar(500)
,	TrackingIdChargeAmount5 varchar(50)
,	TrackingIdChargeDescription6 varchar(500)
,	TrackingIdChargeAmount6 varchar(50)
,	TrackingIdChargeDescription7 varchar(500)
,	TrackingIdChargeAmount7 varchar(50)
,	TrackingIdChargeDescription8 varchar(500)
,	TrackingIdChargeAmount8 varchar(50)
,	TrackingIdChargeDescription9 varchar(500)
,	TrackingIdChargeAmount9 varchar(50)
,	TrackingIdChargeDescription10 varchar(500)
,	TrackingIdChargeAmount10 varchar(50)
,	TrackingIdChargeDescription11 varchar(500)
,	TrackingIdChargeAmount11 varchar(50)
,	TrackingIdChargeDescription12 varchar(500)
,	TrackingIdChargeAmount12 varchar(50)
,	TrackingIdChargeDescription13 varchar(500)
,	TrackingIdChargeAmount13 varchar(50)
,	TrackingIdChargeDescription14 varchar(500)
,	TrackingIdChargeAmount14 varchar(50)
,	TrackingIdChargeDescription15 varchar(500)
,	TrackingIdChargeAmount15 varchar(50)
,	TrackingIdChargeDescription16 varchar(500)
,	TrackingIdChargeAmount16 varchar(50)
,	ZoneCode varchar(50)
,	NumberOfPieces int
,	NormalizedWeightRounded decimal(27,0)
,	RateTable varchar(50)
,	Processed int
)

-- Identify tracking IDs with multiple records
declare @MultiVar table
(
	ID int identity primary key 
,	ExpressOrGroundTrackingId bigint
,	Processed int
)

insert into @MultiVar
(
	ExpressOrGroundTrackingId
,	Processed
)
select
	v.ExpressOrGroundTrackingId
,	0
from
	FedEx.Variance v
where
	v.InvoiceDate between @StartDate and @EndDate
group by
	v.ExpressOrGroundTrackingId
having
	count(v.ExpressOrGroundTrackingId) > 1



declare
	@TrackingId bigint

while ( (select count(*) from @MultiVar where Processed = 0) > 0 ) begin

	select
		@TrackingId = min(mv.ExpressOrGroundTrackingId)
	from
		@MultiVar mv
	where
		mv.Processed = 0

	-- Create one record from two
	insert into
		@Variance
		(
			FuelSurchargeID
		,	OtherChargesID
		,	ExpressOrGroundTrackingId
		,	TransportationChargeAmount
		,	NetChargeAmount
		,	TransChargeAmtPlusChargesLessDiscounts
		,	RateEstimate
		,	VarianceAmount
		,	VariancePercentageOfNetCharge
		,	ServiceType
		,	Origin
		,	Destination
		,	RecipientCountry
		,	ShipperCountry
		,	TrackingIdChargeDescription1
		,	TrackingIdChargeAmount1
		,	TrackingIdChargeDescription2
		,	TrackingIdChargeAmount2
		,	TrackingIdChargeDescription3
		,	TrackingIdChargeAmount3
		,	TrackingIdChargeDescription4
		,	TrackingIdChargeAmount4
		,	TrackingIdChargeDescription5
		,	TrackingIdChargeAmount5
		,	TrackingIdChargeDescription6
		,	TrackingIdChargeAmount6
		,	TrackingIdChargeDescription7
		,	TrackingIdChargeAmount7
		,	TrackingIdChargeDescription8
		,	TrackingIdChargeAmount8
		,	TrackingIdChargeDescription9
		,	TrackingIdChargeAmount9
		,	TrackingIdChargeDescription10
		,	TrackingIdChargeAmount10
		,	TrackingIdChargeDescription11
		,	TrackingIdChargeAmount11
		,	TrackingIdChargeDescription12
		,	TrackingIdChargeAmount12
		,	TrackingIdChargeDescription13
		,	TrackingIdChargeAmount13
		,	TrackingIdChargeDescription14
		,	TrackingIdChargeAmount14
		,	TrackingIdChargeDescription15
		,	TrackingIdChargeAmount15
		,	TrackingIdChargeDescription16
		,	TrackingIdChargeAmount16
		,	ZoneCode
		,	NumberOfPieces
		,	NormalizedWeightRounded
		,	RateTable
		,	Processed
		)
		select
			FuelSurchargeID = v.ID
		,	OtherChargesID = null
		,	ExpressOrGroundTrackingId = v.ExpressOrGroundTrackingId
		,	TransportationChargeAmount = v.TransportationChargeAmount
		,	NetChargeAmount = v.NetChargeAmount
		,	TransChargeAmtPlusChargesLessDiscounts = (
					v.TransportationChargeAmount +
					case when v.TrackingIdChargeAmount1 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount1) end +
					case when v.TrackingIdChargeAmount2 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount2) end +
					case when v.TrackingIdChargeAmount3 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount3) end +
					case when v.TrackingIdChargeAmount4 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount4) end +
					case when v.TrackingIdChargeAmount5 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount5) end +
					case when v.TrackingIdChargeAmount6 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount6) end +
					case when v.TrackingIdChargeAmount7 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount7) end +
					case when v.TrackingIdChargeAmount8 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount8) end )
		,	RateEstimate = null
		,	VarianceAmount = null
		,	VariancePercentageOfNetCharge = null
		,	ServiceType = v.ServiceType
		,	Origin = v.ShipperCity
		,	Destination = v.RecipientCity
		,	RecipientCountry = v.RecipientCountry
		,	ShipperCountry = v.ShipperCountry 
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription1
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount1
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription2
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount2
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription3
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount3
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription4
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount4
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription5
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount5
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription6
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount6
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription7
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount7
		,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription8
		,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount8
		,	TrackingIdChargeDescription9 = ''
		,	TrackingIdChargeAmount9 = ''
		,	TrackingIdChargeDescription10 = ''
		,	TrackingIdChargeAmount10 = ''
		,	TrackingIdChargeDescription11 = ''
		,	TrackingIdChargeAmount11 = ''
		,	TrackingIdChargeDescription12 = ''
		,	TrackingIdChargeAmount12 = ''
		,	TrackingIdChargeDescription13 = ''
		,	TrackingIdChargeAmount13 = ''
		,	TrackingIdChargeDescription14 = ''
		,	TrackingIdChargeAmount14 = ''
		,	TrackingIdChargeDescription15 = ''
		,	TrackingIdChargeAmount15 = ''
		,	TrackingIdChargeDescription16 = ''
		,	TrackingIdChargeAmount16 = ''
		,	ZoneCode = v.ZoneCode
		,	NumberOfPieces = v.NumberOfPieces
		,	NormalizedWeightRounded = v.NormalizedWeightRounded
		,	RateTable = null
		,	Processed = 0
		from
			FedEx.Variance v
		where
			v.ExpressOrGroundTrackingId = @TrackingId
			and v.ZoneCode <> ''


		update
			tempV
		set
			tempV.OtherChargesID = v.ID
		,	tempV.NetChargeAmount = (tempV.NetChargeAmount + v.NetChargeAmount)
		,	tempV.TransChargeAmtPlusChargesLessDiscounts = (
					tempV.TransChargeAmtPlusChargesLessDiscounts +
					case when v.TrackingIdChargeAmount1 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount1) end +
					case when v.TrackingIdChargeAmount2 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount2) end +
					case when v.TrackingIdChargeAmount3 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount3) end +
					case when v.TrackingIdChargeAmount4 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount4) end +
					case when v.TrackingIdChargeAmount5 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount5) end +
					case when v.TrackingIdChargeAmount6 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount6) end +
					case when v.TrackingIdChargeAmount7 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount7) end +
					case when v.TrackingIdChargeAmount8 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount8) end )
		,	tempV.TrackingIdChargeDescription9 = v.TrackingIdChargeDescription1
		,	tempV.TrackingIdChargeAmount9 = v.TrackingIdChargeAmount1
		,	tempV.TrackingIdChargeDescription10 = v.TrackingIdChargeDescription2
		,	tempV.TrackingIdChargeAmount10 = v.TrackingIdChargeAmount2
		,	tempV.TrackingIdChargeDescription11 = v.TrackingIdChargeDescription3
		,	tempV.TrackingIdChargeAmount11 = v.TrackingIdChargeAmount3
		,	tempV.TrackingIdChargeDescription12 = v.TrackingIdChargeDescription4
		,	tempV.TrackingIdChargeAmount12 = v.TrackingIdChargeAmount4
		,	tempV.TrackingIdChargeDescription13 = v.TrackingIdChargeDescription5
		,	tempV.TrackingIdChargeAmount13 = v.TrackingIdChargeAmount5
		,	tempV.TrackingIdChargeDescription14 = v.TrackingIdChargeDescription6
		,	tempV.TrackingIdChargeAmount14 = v.TrackingIdChargeAmount6
		,	tempV.TrackingIdChargeDescription15 = v.TrackingIdChargeDescription7
		,	tempV.TrackingIdChargeAmount15 = v.TrackingIdChargeAmount7
		,	tempV.TrackingIdChargeDescription16 = v.TrackingIdChargeDescription8
		,	tempV.TrackingIdChargeAmount16 = v.TrackingIdChargeAmount8
		from
			FedEx.Variance v
			join @Variance tempV
				on tempV.ExpressOrGroundTrackingId = v.ExpressOrGroundTrackingId
				and v.ExpressOrGroundTrackingId = @TrackingId
				and rtrim(v.ZoneCode) = ''
			


	update
		@MultiVar
	set
		Processed = 1
	where
		ExpressOrGroundTrackingId = @TrackingId

end


-- Process single-line records
insert into @Variance
(
	FuelSurchargeID
,	OtherChargesID
,	ExpressOrGroundTrackingId
,	TransportationChargeAmount
,	NetChargeAmount
,	TransChargeAmtPlusChargesLessDiscounts
,	RateEstimate
,	VarianceAmount
,	VariancePercentageOfNetCharge
,	ServiceType
,	Origin
,	Destination
,	RecipientCountry
,	ShipperCountry
,	TrackingIdChargeDescription1
,	TrackingIdChargeAmount1
,	TrackingIdChargeDescription2
,	TrackingIdChargeAmount2
,	TrackingIdChargeDescription3
,	TrackingIdChargeAmount3
,	TrackingIdChargeDescription4
,	TrackingIdChargeAmount4
,	TrackingIdChargeDescription5
,	TrackingIdChargeAmount5
,	TrackingIdChargeDescription6
,	TrackingIdChargeAmount6
,	TrackingIdChargeDescription7
,	TrackingIdChargeAmount7
,	TrackingIdChargeDescription8
,	TrackingIdChargeAmount8
,	TrackingIdChargeDescription9
,	TrackingIdChargeAmount9
,	TrackingIdChargeDescription10
,	TrackingIdChargeAmount10
,	TrackingIdChargeDescription11
,	TrackingIdChargeAmount11
,	TrackingIdChargeDescription12
,	TrackingIdChargeAmount12
,	TrackingIdChargeDescription13
,	TrackingIdChargeAmount13
,	TrackingIdChargeDescription14
,	TrackingIdChargeAmount14
,	TrackingIdChargeDescription15
,	TrackingIdChargeAmount15
,	TrackingIdChargeDescription16
,	TrackingIdChargeAmount16
,	ZoneCode
,	NumberOfPieces
,	NormalizedWeightRounded
,	RateTable
,	Processed
)
select
	FuelSurchargeID = v.ID
,	OtherChargesID = null
,	ExpressOrGroundTrackingId = v.ExpressOrGroundTrackingId
,	TransportationChargeAmount = v.TransportationChargeAmount
,	NetChargeAmount = v.NetChargeAmount
,	TransChargeAmtPlusChargesLessDiscounts = (
			v.TransportationChargeAmount +
			case when v.TrackingIdChargeAmount1 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount1) end +
			case when v.TrackingIdChargeAmount2 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount2) end +
			case when v.TrackingIdChargeAmount3 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount3) end +
			case when v.TrackingIdChargeAmount4 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount4) end +
			case when v.TrackingIdChargeAmount5 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount5) end +
			case when v.TrackingIdChargeAmount6 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount6) end +
			case when v.TrackingIdChargeAmount7 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount7) end +
			case when v.TrackingIdChargeAmount8 = '' then 0 else convert(decimal(12,2), v.TrackingIdChargeAmount8) end )
,	RateEstimate = null
,	VarianceAmount = null
,	VariancePercentageOfNetCharge = null
,	ServiceType = v.ServiceType
,	Origin = v.ShipperCity
,	Destination = v.RecipientCity
,	RecipientCountry = v.RecipientCountry
,	ShipperCountry = v.ShipperCountry
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription1
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount1
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription2
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount2
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription3
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount3
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription4
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount4
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription5
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount5
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription6
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount6
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription7
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount7
,	TrackingIdChargeDescription1 = v.TrackingIdChargeDescription8
,	TrackingIdChargeAmount1 = v.TrackingIdChargeAmount8
,	TrackingIdChargeDescription9 = ''
,	TrackingIdChargeAmount9 = ''
,	TrackingIdChargeDescription10 = ''
,	TrackingIdChargeAmount10 = ''
,	TrackingIdChargeDescription11 = ''
,	TrackingIdChargeAmount11 = ''
,	TrackingIdChargeDescription12 = ''
,	TrackingIdChargeAmount12 = ''
,	TrackingIdChargeDescription13 = ''
,	TrackingIdChargeAmount13 = ''
,	TrackingIdChargeDescription14 = ''
,	TrackingIdChargeAmount14 = ''
,	TrackingIdChargeDescription15 = ''
,	TrackingIdChargeAmount15 = ''
,	TrackingIdChargeDescription16 = ''
,	TrackingIdChargeAmount16 = ''
,	ZoneCode = v.ZoneCode
,	NumberOfPieces = v.NumberOfPieces
,	NormalizedWeightRounded = v.NormalizedWeightRounded
,	RateTable = null
,	Processed = 0
from
	FedEx.Variance v
where
	v.InvoiceDate between @StartDate and @EndDate
	and v.ExpressOrGroundTrackingId not in
		(	select
				mv.ExpressOrGroundTrackingId
			from
				@MultiVar mv )






-- Loop through all inserted tracking IDs, and update rate estimates
declare 
	@TID bigint
,	@ServiceType varchar(50)
,	@Zone varchar(50)
,	@RecipientCountry varchar(50)
,	@ShipperCountry varchar(50)
,	@Weight decimal(27,0)
,	@NetCharge decimal(20,6)
,	@TableName varchar(50)
,	@RateEst decimal(10,2)

while ( (select count(*) from @Variance v where v.Processed = 0) > 0 ) begin

	select
		@TID = min(v.ExpressOrGroundTrackingId)
	from 
		@Variance v
	where
		v.Processed = 0

	select
		@ServiceType = v.ServiceType
	,	@Zone = v.ZoneCode
	,	@Weight= convert(decimal(27,0), v.NormalizedWeightRounded)
	,	@NetCharge = v.NetChargeAmount
	,	@RecipientCountry = v.RecipientCountry
	,	@ShipperCountry = v.ShipperCountry
	from 
		@Variance v
	where
		v.ExpressOrGroundTrackingId = @TID
		

	if (@ServiceType = 'FedEx Intl Economy') begin

		select @TableName = 'IE_Rates'

		if (@ShipperCountry = 'US' or @RecipientCountry = 'US') begin
			
			select @RateEst = case
				when @Zone = 'A' then (select r.ZoneA from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'B' then (select r.ZoneB from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'C' then (select r.ZoneC from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'D' then (select r.ZoneD from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'E' then (select r.ZoneE from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'F' then (select r.ZoneF from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'G' then (select r.ZoneG from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'H' then (select r.ZoneH from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'I' then (select r.ZoneI from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'J' then (select r.ZoneJ from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'K' then (select r.ZoneK from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'L' then (select r.ZoneL from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'M' then (select r.ZoneM from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'N' then (select r.ZoneN from fedex.IE_Rates r where r.Weight = @Weight)
				when @Zone = 'O' then (select r.ZoneO from fedex.IE_Rates r where r.Weight = @Weight)
			end 

		end
		else begin

			select @TableName = 'ThirdPartyRates_IntlEconomy'

			exec @RateEst = FedEx.fn_ThirdPartyRatesCalculator_InternationalEconomy 
				@Zone
			,	@Weight

		end

	end
	else if (@ServiceType = 'FedEx Intl Priority') begin

		select @TableName = 'IP_Rates'

		if (@ShipperCountry = 'US' or @RecipientCountry = 'US') begin

			select @RateEst = case
				when @Zone = 'A' then (select r.ZoneA from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'B' then (select r.ZoneB from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'C' then (select r.ZoneC from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'D' then (select r.ZoneD from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'E' then (select r.ZoneE from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'F' then (select r.ZoneF from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'G' then (select r.ZoneG from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'H' then (select r.ZoneH from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'I' then (select r.ZoneI from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'J' then (select r.ZoneJ from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'K' then (select r.ZoneK from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'L' then (select r.ZoneL from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'M' then (select r.ZoneM from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'N' then (select r.ZoneN from fedex.IP_Rates r where r.Weight = @Weight)
				when @Zone = 'O' then (select r.ZoneO from fedex.IP_Rates r where r.Weight = @Weight)
			end
		
		end
		else begin

			select @TableName = 'ThirdPartyRates_IntlPriority'

			exec @RateEst = FedEx.fn_ThirdPartyRatesCalculator_InternationalPriority
				@Zone
			,	@Weight

		end

	end	
	else if (@ServiceType = 'FedEx Intl Economy Frt') begin

		select @TableName = 'IPE_Rates'
	           	
		select @RateEst = case
			when @Zone = 'A' then (select r.ZoneA from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'B' then (select r.ZoneB from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'C' then (select r.ZoneC from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'D' then (select r.ZoneD from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'E' then (select r.ZoneE from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'F' then (select r.ZoneF from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'G' then (select r.ZoneG from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'H' then (select r.ZoneH from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'I' then (select r.ZoneI from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'J' then (select r.ZoneJ from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'K' then (select r.ZoneK from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'L' then (select r.ZoneL from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'M' then (select r.ZoneM from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'N' then (select r.ZoneN from fedex.IPE_Rates r where r.Weight = @Weight)
			when @Zone = 'O' then (select r.ZoneO from fedex.IPE_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx Intl Priority Frt') begin

		select @TableName = 'IPF_Rates'

		select @RateEst = case
			when @Zone = 'A' then (select r.ZoneA from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'B' then (select r.ZoneB from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'C' then (select r.ZoneC from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'D' then (select r.ZoneD from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'E' then (select r.ZoneE from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'F' then (select r.ZoneF from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'G' then (select r.ZoneG from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'H' then (select r.ZoneH from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'I' then (select r.ZoneI from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'J' then (select r.ZoneJ from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'K' then (select r.ZoneK from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'L' then (select r.ZoneL from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'M' then (select r.ZoneM from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'N' then (select r.ZoneN from fedex.IPF_Rates r where r.Weight = @Weight)
			when @Zone = 'O' then (select r.ZoneO from fedex.IPF_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx Express Saver') begin

		select @TableName = 'ESP_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.ESP_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.ESP_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx Priority Overnight') begin

		select @TableName = 'PO_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.PO_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.PO_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx Standard Overnight') begin

		select @TableName = 'SO_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.SO_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.SO_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'Ground') begin

		select @TableName = 'GR_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.GR_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.GR_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx 2Day') begin

		select @TableName = 'E2_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.E2_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.E2_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx First Overnight') begin

		select @TableName = ''

		select 
			@RateEst = @NetCharge

	end
	else if (@ServiceType = 'FedEx 2Day A.M.') begin

		select @TableName = 'E2AM_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.E2AM_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.E2AM_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx 1Day Freight') begin

		select @TableName = 'F1_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.F1_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.F1_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx 2Day Freight') begin

		select @TableName = 'F2_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.F2_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.F2_Rates r where r.Weight = @Weight)
		end 

	end
	else if (@ServiceType = 'FedEx 3Day Freight') begin

		select @TableName = 'F3_Rates'

		select @RateEst = case
			when @Zone in ('2', '02') then (select r.Zone02 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone in ('3', '03') then (select r.Zone03 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone in ('4', '04') then (select r.Zone04 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone in ('5', '05') then (select r.Zone05 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone in ('6', '06') then (select r.Zone06 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone in ('7', '07') then (select r.Zone07 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone in ('8', '08') then (select r.Zone08 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone in ('9', '09') then (select r.Zone09 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone = '10' then (select r.Zone10 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone = '11' then (select r.Zone11 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone = '12' then (select r.Zone12 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone = '13' then (select r.Zone13 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone = '14' then (select r.Zone14 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone = '15' then (select r.Zone15 from fedex.F3_Rates r where r.Weight = @Weight)
			when @Zone = '16' then (select r.Zone16 from fedex.F3_Rates r where r.Weight = @Weight)
		end 

	end



	update
		@Variance
	set
		RateEstimate = @RateEst
	,	RateTable = @TableName
	where
		ExpressOrGroundTrackingId = @TID



	update
		@Variance
	set
		Processed = 1
	where
		ExpressOrGroundTrackingId = @TID

end



-- Get variance results
update
	@Variance
set
	VarianceAmount = NetChargeAmount - RateEstimate
,	VariancePercentageOfNetCharge = (NetChargeAmount - RateEstimate) / NetChargeAmount



-- Return results
select
	FuelSurchargeID
,	OtherChargesID
,	ExpressOrGroundTrackingId
,	TransportationChargeAmount
,	NetChargeAmount
,	TransChargeAmtPlusChargesLessDiscounts
,	RateEstimate
,	VarianceAmount
,	VariancePercentageOfNetCharge
,	ServiceType
,	Origin
,	Destination
,	RateTable
,	TrackingIdChargeDescription1
,	TrackingIdChargeAmount1
,	TrackingIdChargeDescription2
,	TrackingIdChargeAmount2
,	TrackingIdChargeDescription3
,	TrackingIdChargeAmount3
,	TrackingIdChargeDescription4
,	TrackingIdChargeAmount4
,	TrackingIdChargeDescription5
,	TrackingIdChargeAmount5
,	TrackingIdChargeDescription9
,	TrackingIdChargeAmount9
,	TrackingIdChargeDescription10
,	TrackingIdChargeAmount10
,	TrackingIdChargeDescription11
,	TrackingIdChargeAmount11
,	TrackingIdChargeDescription6
,	TrackingIdChargeAmount6
,	TrackingIdChargeDescription7
,	TrackingIdChargeAmount7
,	TrackingIdChargeDescription12
,	TrackingIdChargeAmount12
,	TrackingIdChargeDescription13
,	TrackingIdChargeAmount13
,	TrackingIdChargeDescription14
,	TrackingIdChargeAmount14
,	TrackingIdChargeDescription15
,	TrackingIdChargeAmount15
,	TrackingIdChargeDescription16
,	TrackingIdChargeAmount16
,	TrackingIdChargeDescription8
,	TrackingIdChargeAmount8
,	ZoneCode
,	NumberOfPieces
,	NormalizedWeightRounded
from
	@Variance v
order by
	v.VarianceAmount desc


return

GO

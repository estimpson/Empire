SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [FedEx].[fn_ThirdPartyRatesCalculator_InternationalEconomy]
(	
	@Zone varchar(50)
,	@Weight decimal(20, 0)
)
returns	decimal(10, 2)
as
begin
	declare
		@RateEst decimal(10, 2)
		

	if (@Weight < 101) begin
				
		select @RateEst = case
			when @Zone = 'A' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneA r where r.Weight = @Weight)
			when @Zone = 'B' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneB r where r.Weight = @Weight)
			when @Zone = 'C' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneC r where r.Weight = @Weight)
			when @Zone = 'D' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneD r where r.Weight = @Weight)
			when @Zone = 'E' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneE r where r.Weight = @Weight)
			when @Zone = 'F' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneF r where r.Weight = @Weight)
			when @Zone = 'G' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneG r where r.Weight = @Weight)
			when @Zone = 'H' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneH r where r.Weight = @Weight)
			when @Zone = 'I' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneI r where r.Weight = @Weight)
			when @Zone = 'J' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneJ r where r.Weight = @Weight)
			when @Zone = 'K' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneK r where r.Weight = @Weight)
			when @Zone = 'L' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneL r where r.Weight = @Weight)
			when @Zone = 'M' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneM r where r.Weight = @Weight)
			when @Zone = 'N' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneN r where r.Weight = @Weight)
			when @Zone = 'O' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneO r where r.Weight = @Weight)
			when @Zone = 'P' then (select r.InternationalEconomy from fedex.ThirdPartyRates_ZoneP r where r.Weight = @Weight)
		end

	end
	else if (@Weight between 101 and 150) begin

		select @RateEst = case
			when @Zone = 'A' then ((select r.ZoneA from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'B' then ((select r.ZoneB from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'C' then ((select r.ZoneC from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'D' then ((select r.ZoneD from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'E' then ((select r.ZoneE from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'F' then ((select r.ZoneF from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'G' then ((select r.ZoneG from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'H' then ((select r.ZoneH from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'I' then ((select r.ZoneI from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'J' then ((select r.ZoneJ from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'K' then ((select r.ZoneK from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'L' then ((select r.ZoneL from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'M' then ((select r.ZoneM from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'N' then ((select r.ZoneN from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'O' then ((select r.ZoneO from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
			when @Zone = 'P' then ((select r.ZoneP from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '100:150') * @Weight)
		end

	end
	else if (@Weight between 151 and 999) begin

		select @RateEst = case
			when @Zone = 'A' then ((select r.ZoneA from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'B' then ((select r.ZoneB from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'C' then ((select r.ZoneC from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'D' then ((select r.ZoneD from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'E' then ((select r.ZoneE from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'F' then ((select r.ZoneF from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'G' then ((select r.ZoneG from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'H' then ((select r.ZoneH from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'I' then ((select r.ZoneI from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'J' then ((select r.ZoneJ from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'K' then ((select r.ZoneK from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'L' then ((select r.ZoneL from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'M' then ((select r.ZoneM from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'N' then ((select r.ZoneN from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'O' then ((select r.ZoneO from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
			when @Zone = 'P' then ((select r.ZoneP from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange = '151:999') * @Weight)
		end

	end
	else if (@Weight > 999) begin

		select @RateEst = case
			when @Zone = 'A' then ((select r.ZoneA from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'B' then ((select r.ZoneB from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'C' then ((select r.ZoneC from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'D' then ((select r.ZoneD from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'E' then ((select r.ZoneE from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'F' then ((select r.ZoneF from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'G' then ((select r.ZoneG from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'H' then ((select r.ZoneH from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'I' then ((select r.ZoneI from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'J' then ((select r.ZoneJ from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'K' then ((select r.ZoneK from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'L' then ((select r.ZoneL from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'M' then ((select r.ZoneM from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'N' then ((select r.ZoneN from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'O' then ((select r.ZoneO from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
			when @Zone = 'P' then ((select r.ZoneP from fedex.ThirdPartyRates_OverOneHundredPounds_InternationalEconomy r where r.WeightRange like '1000%') * @Weight)
		end

	end


	return	@RateEst
end
GO

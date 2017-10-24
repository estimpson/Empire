SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[freight_insert_pfa] 
	( @pfa_date datetime
	, @requestor varchar(50) 
	)
as 

--declare @pfa_date datetime;
--declare @requestor varchar(50);
--select @pfa_date = '2013-12-19'
--select @requestor = 'DW'

begin

declare @pfa_id			varchar(15) = (select 'PFA-'+convert(char(4), datepart(year, @pfa_date)) + '-' + right('00000' + convert(varchar(6),(select next_number from identifier_formats where identifier_type = 'PFA')), 5))
declare @requestor_name varchar(50) = (select name from employee where operator_code = @requestor)


insert into eeiuser.freight_pfa(PFA_ID, PFA_DATE, PFA_STATUS, REQUESTOR)
select @pfa_id, @pfa_date, 'New', (select name from employee where operator_code = @requestor) 

update identifier_formats set next_number = next_number+1 where identifier_type = 'PFA'

end
GO

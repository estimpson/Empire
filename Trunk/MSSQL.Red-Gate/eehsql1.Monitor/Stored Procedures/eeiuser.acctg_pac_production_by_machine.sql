SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [eeiuser].[acctg_pac_production_by_machine] @increment varchar(4), @begin_date date, @end_date date

as

--1.  To test:

-- exec eeiuser.acctg_pac_production_by_machine 'mm','2018-01-01','2018-05-31'

--test:
--declare @increment varchar(4) = 'd';
--declare @begin_date date = '05/01/2018'
--declare @end_date date = '2018-05-31';


--2.  Change the begin date to the first day of the selected increment

declare @adjusted_begin_date date = case when @increment = 'wk' then dateadd(d,-1,ft.fn_truncDate_monday(@increment,@begin_date)) else @begin_date end

--test:
-- select @adjusted_begin_date


--3.  Change the end date to the first day after the selected increment

declare @adjusted_end_date date = case when @increment = 'wk' then dateadd(d,6,ft.fn_truncdate_monday(@increment, @end_date)) else @end_date end

--test:
--select @adjusted_end_Date


--3.  Get the dynamic syntax for the query

declare @date_function nvarchar(MAX) = 'datepart('+@increment+',date_stamp)'  

--test:
--select @date_function


--4.  Write the dynamic query statement to get the columns for the pivot query

declare @cols_query as NVARCHAR(MAX)

set @cols_query = 'SELECT STUFF((Select '','' + QUOTENAME(datepart(' + @increment + ', date_stamp))
				    from audit_trail
					where date_stamp >= ''' + cast(@adjusted_begin_date as varchar(10)) + ''' 
						and date_stamp < ''' + cast(@adjusted_end_date as varchar(10)) + '''
						and type = ''J''
						and from_loc like ''KOMAX%''
					  group by datepart(' + @increment + ',date_stamp)
					  order by datepart(' + @increment + ',date_stamp)
					  for xml PATH(''''), TYPE
					  ).value(''.'', ''NVARCHAR(MAX)'')
					  ,1,1,'''')'

--test:				
--select @cols_query

declare @col table ( query_text varchar(max))
insert into @col
execute (@cols_query)

declare @cols varchar(max);
select @cols =  min(query_text) from @col a group by query_text


--select @cols = STUFF((Select distinct ',' + QUOTENAME(datepart(wk,date_stamp)) 
--						from audit_trail
--						where date_stamp >= @adjusted_begin_date and date_stamp < @adjusted_end_date and type = 'J' and from_loc like 'KOMAX%' 
--						order by 1	
--						for xml PATH(''), TYPE
--						).value('.', 'NVARCHAR(MAX)')
--					,1,1,'')


--select @cols = STUFF((select ',' + QUOTENAME(datepart(wk,date_stamp))
--				      from audit_trail
--					  where date_stamp >= @adjusted_begin_date 
--						and date_stamp < dateadd(d,-1,@adjusted_end_date)
--						and type = 'J'
--						and from_loc like 'KOMAX%'
--					  group by datepart(wk,date_stamp)
--					  order by datepart(wk,date_stamp)
--					  for xml PATH(''), TYPE
--					  ).value('.', 'NVARCHAR(MAX)')
--					  ,1,1,'')



-- test:
--Select @cols


--4.  Write the dynamic query statement

declare @query as NVARCHAR(MAX)

set @query = 'Select from_loc,  ' + @cols + 

			'from
			(
				select (case when from_loc = ''KOMAX8'' then ''KOMAX08'' else from_loc end) as from_loc, ' + @date_function + ' as week, quantity
				from audit_trail
				where	date_stamp >= ''' + cast(@adjusted_begin_date as varchar(10)) +''' 
					and date_stamp <  ''' + cast(@adjusted_end_date as varchar(10)) + '''	
					and type = ''J'' 
			        and from_loc like ''KOMAX%''
			) x
			pivot
			(
				sum(quantity)
				for week in (' +@Cols +')
			) p '

--test:
--select @query


--5.  Execute the dynamic query statement

execute(@query)


GO

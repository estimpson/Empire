SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_SplitOnWordsToRows]
(	@InputString varchar(8000)
,	@MaxInterval smallint
)
as
create table #ValueRows
(
	ID int not null IDENTITY(1, 1) primary key
,	Value varchar(8000)
)

while datalength(@InputString) > @MaxInterval begin
	if	charindex(' ', left(@InputString, @MaxInterval)) > 0 begin
		declare
			@roughPartition varchar(8000)
		
		set	@roughPartition = left(@InputString, @MaxInterval + 1)
		
		insert
			#ValueRows
			(	Value
			)
		values
			(	substring(@InputString, 1, @MaxInterval - charindex(' ', reverse(@roughPartition)) + 2)
			)
		
		set	@InputString = ltrim(substring(@InputString, @MaxInterval - charindex(' ', reverse(@roughPartition)) + 2, 8000))
	end
	else begin
		insert
			#ValueRows
			(	Value
			)
		values
			(	left(@InputString, @MaxInterval)
			)
		
		set	@InputString = substring(@InputString, @MaxInterval + 1, 8000)
	end
end

insert
	#ValueRows
	(	Value
	)
values
	(	@InputString
	)

select	Value
from	#ValueRows
GO

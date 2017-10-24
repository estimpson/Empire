
if	objectproperty(object_id('FT.udf_SplitOnWordsToRows'), 'IsTableFunction') = 1 begin
	drop function FT.udf_SplitOnWordsToRows
end
go

create function FT.udf_SplitOnWordsToRows
(	@InputString varchar(8000)
,	@MaxInterval smallint
)
returns @ValueRows table
(
	ID int not null IDENTITY(1, 1) primary key
,	Value varchar(8000)
)
as
begin
--- <Body>
	while datalength(@InputString) > @MaxInterval begin
		if	charindex(' ', left(@InputString, @MaxInterval)) > 0 begin
			declare
				@roughPartition varchar(8000)
			
			set	@roughPartition = left(@InputString, @MaxInterval + 1)
			
			insert
				@ValueRows
			(	value
			)
			values
			(	substring(@InputString, 1, @MaxInterval - charindex(' ', reverse(@roughPartition)) + 2)
			)
			
			set	@InputString = ltrim(substring(@InputString, @MaxInterval - charindex(' ', reverse(@roughPartition)) + 2, 8000))
		end
		else begin
			insert
				@ValueRows
			(	value
			)
			values
			(	left(@InputString, @MaxInterval)
			)
			
			set	@InputString = substring(@InputString, @MaxInterval + 1, 8000)
		end
	end
	
	insert
		@ValueRows
	(	value
	)
	values
	(	@InputString
	)
--- </Body>

---	<Return>
	return
end
go

print '1234567 890123 4567890'

select
	*
from
	FT.udf_SplitOnWordsToRows('1234567 890 123 4567890', 6)
go

print '12345678901234567890'

select
	*
from
	FT.udf_SplitOnWordsToRows('12345678901234567890', 6)

select
	*
from
	FT.udf_SplitOnWordsToRows('TK8A RCL T-20 Dual Filament Socket Assembly', 16)


if	objectproperty(object_id('FT.udf_SplitStringToRows'), 'IsTableFunction') = 1 begin
	drop function FT.udf_SplitStringToRows
end
go

create function FT.udf_SplitStringToRows
(	@InputString varchar(8000)
,	@Splitter varchar(8000)
)
returns @ValueRows table
(
	ID int not null IDENTITY(1, 1) primary key
,	Value varchar(8000)
)
as
begin
--- <Body>
	while charindex(@Splitter, @InputString) > 0 begin
		insert
			@ValueRows
		(	value
		)
		values
		(	substring(@InputString, 1, charindex(@Splitter, @InputString) -1)
		)
		
		set	@InputString = substring(@InputString, charindex(@Splitter, @InputString) + datalength(@Splitter), 8000)
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

select
	*
from
	FT.udf_SplitStringToRows('123,456,789,234', ',')

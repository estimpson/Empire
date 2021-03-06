
if	objectproperty(object_id('FT.udf_Rows'), 'IsTableFunction') = 1 begin
	drop function FT.udf_Rows
end
go

create function FT.udf_Rows
(	@Rows int)
returns @RowTable table 
(	RowNumber int primary key)
as
begin
	declare	@RowNumber int
	set	@RowNumber = 0
	
	while	@RowNumber < @Rows begin
		set	@RowNumber = @RowNumber + 1
		
		insert	@RowTable
		select	@RowNumber
	end
	
	return
end
go

select
	*
from
	FT.udf_Rows(5)
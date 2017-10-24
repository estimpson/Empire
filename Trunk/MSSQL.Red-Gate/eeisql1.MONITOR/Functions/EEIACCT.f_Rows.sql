SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EEIACCT].[f_Rows]
(	@RowCount int
)
returns @Rows table
(	RowNo int
)
as
begin
--- <Body>
	declare
		@RowNo int

	set	@RowNo = 0

	while
		@RowNo <= @RowCount begin

		insert
			@Rows
		(
			RowNo
		)
		select
			@RowNo

		set @RowNo = @RowNo + 1
	end
--- </Body>

---	<Return>
	return
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EEIACCT].[f_WeekColumnDeclaration]
(
	@RowCount int
)
returns nvarchar(4000)
as
begin
--- <Body>
	declare
		@DeclarationSyntax nvarchar(4000)

	set	@DeclarationSyntax = ''

--	,	[1 12/29 - 1/4] n null
	select
		@DeclarationSyntax = @DeclarationSyntax + ',	[' + EEIACCT.f_WeekName(RowNo) + '] n null
'
	from
		EEIACCT.f_Rows(@RowCount)

--- </Body>

---	<Return>
	return
		@DeclarationSyntax
end
GO

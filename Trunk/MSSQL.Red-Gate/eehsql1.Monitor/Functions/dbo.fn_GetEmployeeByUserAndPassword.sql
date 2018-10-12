SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fn_GetEmployeeByUserAndPassword]
(	@UserID varchar(255)
,	@Password varchar(255)
)
returns @Employee table
(	name varchar(40)
,	operator_code varchar(5)
)
as
/*

declare
	@UserID varchar(255)
,	@Password varchar(255)

set	@UserID = ''
set @Password = ''

select	*
from	dbo.fn_GetEmployeeByUserAndPassword(@UserID, @Password)

*/
begin

    insert
		@Employee
	(	name
	,	operator_code 
	)
	select
		e.name
	,   e.operator_code
	from
		eeh.dbo.employee e with (readuncommitted)
	where
		e.operator_code = @UserID
		and pwdcompare(@Password, e.npassword, 0) = 1

    return
end
GO

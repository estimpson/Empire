SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fn_GetEmployeeByPassword]
(	@Password varchar(255))
returns	@Employee table
(	name  varchar(40),
	operator_code varchar(5),
	EmployeeID varchar(15))
as
/*

declare	@Password varchar(255)

set @Password = ''

select	*
from	fn_GetEmployeeByPassword( @Password )

*/
begin
	insert	@Employee
	(	name,
		operator_code,
		EmployeeID)
	select	name,
		operator_code,
		EmployeeID
	from	monitor.dbo.employee with (readuncommitted)
	--where	password = @Password
	where	pwdcompare (@Password, npassword, 0) = 1
	
	return
end

GO

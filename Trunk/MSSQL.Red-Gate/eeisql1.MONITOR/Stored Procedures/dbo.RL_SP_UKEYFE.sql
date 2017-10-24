SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[RL_SP_UKEYFE]
(
	@nPassword varchar(255),
	@Operator varchar(5),
	@OldPassword varchar(255)	
)
AS
	SET NOCOUNT OFF;
--UPDATE employee SET password = @nPassword, npassword = convert(varbinary(255), pwdencrypt (@nPassword)) WHERE operator_code = @Operator and 1 = pwdcompare(@OldPassword,npassword,0)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[fn_LesserDT]
(	@Value1 datetime,
	@Value2 datetime)
returns	datetime
as
begin
	declare	@LesserDT datetime
	
	if	@Value1 is Null and @Value2 is Null
		Begin
		Select	@LesserDT = @Value1
		return	@lesserDT
		End
	else
	if	@Value1 is Null and @Value2 is not Null
		Begin
		Select	@LesserDT = @Value2
		return	@lesserDT
		End
	else
	if	@Value1 is not Null and @Value2 is Null
		Begin
		Select	@LesserDT = @Value1
		return	@lesserDT
		End
	else
	if	@Value1<=@Value2 
		Begin
		Select	@LesserDT = @Value1
		return	@lesserDT
		End
	else
	if	@Value2<=@Value1
		Begin
		Select	@LesserDT = @Value2
		End
		
return	@LesserDT
	
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_ZeroPad] 
(	@Value integer,
	@Padding smallint)
returns	varchar (1000)
as
/*
$Workfile: FT.fn_ZeroPad.sql $

Name: FT.fn_ZeroPad

Description: This function returns a zero padded value as a string.

Parameters
Argument	Description
------------	----------------------------------------------------------------
Value		The number to be padded.
Padding		The number of digits to pad.  Negative numbers will begin with a
		negative sign, followed by zeros and the number.  If the length
		of the value exceeds the padding, the function returns the value.

Example:
select	serial, FT.fn_ZeroPad (quantity, 3), quantity
from	object
:End Example

Process:
--	I.	Results.
*/
--	I.	Results.
begin
	declare	@PaddedValue varchar (1000)

	if	len (convert (varchar, @Value)) > @Padding begin
		set	@PaddedValue = convert (varchar, @Value)
	end
	else if @Value > 0 begin
		set	@PaddedValue = Right (Replicate ('0', @Padding) + convert (varchar, @Value), @Padding)
	end
	else begin
		set	@PaddedValue = '-' + Right (Replicate ('0', @Padding-1) + convert (varchar, -@Value), @Padding-1)
	end		
	return	@PaddedValue
end
GO

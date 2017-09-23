SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create function [dbo].[ReturnInverse]
(@NumbertoInv numeric(20,6))
RETURNS numeric(20,6)
AS
begin

---
if @NumbertoInv is null 
set @NumbertoInv = 0

If @NumbertoInv != 0
set @NumbertoInv = 1/@NumbertoInv

return @NumbertoInv


end
GO

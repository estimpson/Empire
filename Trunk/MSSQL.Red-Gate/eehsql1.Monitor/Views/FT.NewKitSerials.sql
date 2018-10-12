SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[NewKitSerials] as
	select	* from EEH.ft.NewKitSerials with (readuncommitted)
GO

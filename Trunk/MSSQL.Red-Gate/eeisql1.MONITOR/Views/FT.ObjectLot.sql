SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[ObjectLot]
as
select	Serial,
	HRLot =
	case when ascii ('A') + LotBase / (9 * 25 * 9 * 25) % 25 < ascii ('O') then char (ascii ('A') + LotBase / (9 * 25 * 9 * 25) % 25) else char (ascii ('A') + LotBase / (9 * 25 * 9 * 25) % 25 + 1) end +
	case when ascii ('A') + LotBase / (9 * 25 * 9) % 25 < ascii ('O') then char (ascii ('A') + LotBase / (9 * 25 * 9) % 25) else char (ascii ('A') + LotBase / (9 * 25 * 9) % 25 + 1) end +
	char (ascii ('1') + LotBase / (25 * 9) % 9) +
	case when ascii ('A') + LotBase / 9 % 25 < ascii ('O') then char (ascii ('A') + LotBase / 9 % 25) else char (ascii ('A') + LotBase / 9 % 25 + 1) end
from	(	select	LotBase, Serial
		from	(	select	LotBase = convert (int, 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * ((power (2,30) * 99.0) / nullif (serial, 0) - convert (int, (power (2,30) * 99.0) / nullif (serial, 0)))), Serial = object.serial
				from	object) ObjectLots) ObjectHRLots

GO
GRANT SELECT ON  [FT].[ObjectLot] TO [APPUser]
GO

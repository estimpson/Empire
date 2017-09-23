SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[addresses_clean]
as
select	address_id,
	address_1,
	address_2 = nullif (rtrim (address_2), ''),
	address_3 = case when address_3 like city + '%' + state + '%' + postal_code then null else nullif (rtrim (address_3), '') end,
	city,
	state,
	postal_code,
	country
from	addresses
where	state > ''
union all
select	address_id,
	address_1,
	address_2 = null,
	address_3 = null,
	city = coalesce (nullif (rtrim (city), ''),
		case	when address_2 like '%,%' then ltrim (left (address_2, patindex ('%,%', address_2)-1))
			when address_2 like '% [A-Z][A-Z] %' then ltrim (left (address_2, patindex ('% [A-Z][A-Z] %', address_2)))
			when address_2 like '% [A-Z][A-Z].%' then ltrim (left (address_2, patindex ('% [A-Z][A-Z] %', address_2)))
		end),
	state = Upper (coalesce (nullif (rtrim (state), ''),
		case	when address_2 like '%, [A-Z]%' then rtrim (ltrim (substring (address_2, patindex ('%, [A-Z]%', address_2) + 2, 2)))
			when address_2 like '% [A-Z][A-Z] %' then rtrim (ltrim (substring (address_2, patindex ('% [A-Z][A-Z] %', address_2) + 1, 2)))
			when address_2 like '% [A-Z][A-Z].%' then rtrim (ltrim (substring (address_2, patindex ('% [A-Z][A-Z].%', address_2) + 1, 2)))
		end)),
	postal_code = rtrim (ltrim (address_3)),
	country
from	addresses
where	coalesce (state, '') !> '' and
	address_3 like '[0-9][0-9][0-9][0-9]%[0-9]'
union all
select	address_id,
	address_1,
	address_2 = nullif (rtrim (address_2), ''),
	address_3 =
		case	when address_3 like '%,%[A-Z]%' then null
			when address_3 like '% [A-Z][A-Z] %' then null
			when address_3 like '% [A-Z][A-Z].%' then null
			when address_3 like '[0-9][0-9][0-9][0-9]%[0-9]' then null
			else nullif (rtrim (address_3), '')
		end,
	city = coalesce (nullif (rtrim (city), ''),
		case	when address_3 like '%,%' then ltrim (left (address_3, patindex ('%,%', address_3)-1))
			when address_3 like '% [A-Z][A-Z] %' then ltrim (left (address_3, patindex ('% [A-Z][A-Z] %', address_3)))
			when address_3 like '% [A-Z][A-Z].%' then ltrim (left (address_3, patindex ('% [A-Z][A-Z] %', address_3)))
		end),
	state = Upper (coalesce (nullif (rtrim (state), ''),
		case	when address_3 like '%, [A-Z]%' then rtrim (ltrim (substring (address_3, patindex ('%, [A-Z]%', address_3) + 2, 2)))
			when address_3 like '% [A-Z][A-Z] %' then rtrim (ltrim (substring (address_3, patindex ('% [A-Z][A-Z] %', address_3) + 1, 2)))
			when address_3 like '% [A-Z][A-Z].%' then rtrim (ltrim (substring (address_3, patindex ('% [A-Z][A-Z].%', address_3) + 1, 2)))
		end)),
	postal_code = left (coalesce (nullif (rtrim (postal_code), ''),
		case	when address_3 like '[A-Z][A-Z]%[0-9][0-9][0-9][0-9]' then rtrim (ltrim (substring (address_3, patindex ('%[0-9][0-9][0-9][0-9]%', address_3), 30)))
			when address_3 like '[0-9][0-9][0-9][0-9]%[0-9]' then rtrim (ltrim (address_3))
		end), 10),
	country
from	addresses
where	coalesce (state, '') !> '' and
	coalesce (
		case	when address_3 like '%,%[A-Z]%' then address_3
			when address_3 like '% [A-Z][A-Z] %' then address_3
			when address_3 like '% [A-Z][A-Z].%' then address_3
		end, '') > ''
union all
select	address_id,
	address_1 = nullif (rtrim (address_1), ''),
	address_2 =
		case	when address_2 like '%,%[A-Z]%' then null
			when address_2 like '% [A-Z][A-Z] %' then null
			when address_2 like '% [A-Z][A-Z].%' then null
			when address_2 like '[0-9][0-9][0-9][0-9]%[0-9]' then null
			else nullif (rtrim (address_2), '')
		end,
	address_3 = nullif (rtrim (address_3), ''),
	city = coalesce (nullif (rtrim (city), ''),
		case	when address_2 like '%,%' then ltrim (left (address_2, patindex ('%,%', address_2)-1))
			when address_2 like '% [A-Z][A-Z] %' then ltrim (left (address_2, patindex ('% [A-Z][A-Z] %', address_2)))
			when address_2 like '% [A-Z][A-Z].%' then ltrim (left (address_2, patindex ('% [A-Z][A-Z] %', address_2)))
		end),
	state = Upper (coalesce (nullif (rtrim (state), ''),
		case	when address_2 like '%, [A-Z]%' then rtrim (ltrim (substring (address_2, patindex ('%, [A-Z]%', address_2) + 2, 2)))
			when address_2 like '% [A-Z][A-Z] %' then rtrim (ltrim (substring (address_2, patindex ('% [A-Z][A-Z] %', address_2) + 1, 2)))
			when address_2 like '% [A-Z][A-Z].%' then rtrim (ltrim (substring (address_2, patindex ('% [A-Z][A-Z].%', address_2) + 1, 2)))
		end)),
	postal_code = left (coalesce (nullif (rtrim (postal_code), ''),
		case	when address_2 like '[A-Z][A-Z]%[0-9][0-9][0-9][0-9]' then rtrim (ltrim (substring (address_2, patindex ('%[0-9][0-9][0-9][0-9]%', address_2), 30)))
			when address_2 like '[0-9][0-9][0-9][0-9]%[0-9]' then rtrim (ltrim (address_2))
		end), 10),
	country
from	addresses
where	coalesce (state, '') !> '' and
	coalesce (
		case	when address_3 like '%,%[A-Z]%' then address_3
			when address_3 like '% [A-Z][A-Z] %' then address_3
			when address_3 like '% [A-Z][A-Z].%' then address_3
			when address_3 like '[0-9][0-9][0-9][0-9]%[0-9]' then address_3
		end, '') !> '' and
	address_2 > ''
union all
select	address_id,
	address_1 = nullif (rtrim (address_1), ''),
	address_2 = nullif (rtrim (address_2), ''),
	address_3 = nullif (rtrim (address_3), ''),
	city = nullif (rtrim (city), ''),
	state = nullif (rtrim (state), ''),
	postal_code = nullif (rtrim (postal_code), ''),
	country
from	addresses
where	coalesce (state, '') !> '' and
	coalesce (
		case	when address_3 like '%,%[A-Z]%' then address_3
			when address_3 like '% [A-Z][A-Z] %' then address_3
			when address_3 like '% [A-Z][A-Z].%' then address_3
			when address_3 like '[0-9][0-9][0-9][0-9]%[0-9]' then address_3
		end, '') !> '' and
	coalesce (address_2, '') !> ''
GO

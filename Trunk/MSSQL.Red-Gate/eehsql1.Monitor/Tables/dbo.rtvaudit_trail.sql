CREATE TABLE [dbo].[rtvaudit_trail]
(
[serial] [int] NOT NULL,
[date_stamp] [datetime] NOT NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quantity] [numeric] (20, 6) NULL,
[rma] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [numeric] (20, 6) NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[from_loc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[to_loc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[on_hand] [numeric] (20, 6) NULL,
[weight] [numeric] (20, 6) NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[origin] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[shipper] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[std_quantity] [numeric] (20, 6) NULL,
[cost] [numeric] (20, 6) NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_account] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[std_cost] [numeric] (20, 6) NULL,
[user_defined_status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[posted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_serial] [numeric] (10, 0) NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_name] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO

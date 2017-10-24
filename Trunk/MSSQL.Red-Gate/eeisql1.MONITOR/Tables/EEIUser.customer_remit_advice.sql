CREATE TABLE [EEIUser].[customer_remit_advice]
(
[invoice] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[purchase_order] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[line_number] [int] NOT NULL,
[original_order_no] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[due_date] [datetime] NULL,
[quantity] [decimal] (18, 6) NULL,
[unit_price] [decimal] (18, 6) NULL,
[amount_paid] [decimal] (18, 6) NULL,
[discount] [decimal] (18, 6) NULL,
[currency] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_number] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_date] [datetime] NULL,
[check_amount] [decimal] (18, 6) NULL,
[part_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[customer_remit_advice] ADD CONSTRAINT [PK_customer_remit_advice] PRIMARY KEY CLUSTERED  ([invoice], [purchase_order], [line_number]) ON [PRIMARY]
GO

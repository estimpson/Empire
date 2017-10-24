CREATE TABLE [EEIUser].[ar_4]
(
[time_stamp] [datetime] NOT NULL,
[customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[0-30] [decimal] (18, 6) NULL,
[30-60] [decimal] (18, 6) NULL,
[60-90] [decimal] (18, 6) NULL,
[Over 90] [decimal] (18, 6) NULL,
[total_due] [decimal] (18, 6) NULL,
[wavg_total_days_past_doc] [decimal] (18, 6) NULL,
[past_due] [decimal] (18, 6) NULL,
[percent_past_due] [decimal] (18, 6) NULL,
[wavg_days_past_due] [decimal] (18, 6) NULL,
[wavg_days_past_doc] [decimal] (18, 6) NULL,
[past_due_rank] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ar_4] ADD CONSTRAINT [PK_ar_4] PRIMARY KEY CLUSTERED  ([time_stamp], [customer]) ON [PRIMARY]
GO

CREATE TABLE [EEIUser].[acctg_csm_base_part_notes]
(
[release_id] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[base_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[time_stamp] [datetime] NOT NULL,
[status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_acctg_csm_base_part_notes_status] DEFAULT ('Open'),
[note] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_base_part_notes] ADD CONSTRAINT [PK_acctg_csm_base_part_notes] PRIMARY KEY CLUSTERED  ([release_id], [base_part], [time_stamp]) ON [PRIMARY]
GO

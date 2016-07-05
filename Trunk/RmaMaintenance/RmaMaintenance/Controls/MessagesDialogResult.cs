﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace RmaMaintenance.Controls
{
    public partial class MessagesDialogResult : Form
    {
        #region Properties

        private string _message;
        public string Message
        {
            get { return _message; }
            set
            {
                _message = tbxMessage.Text = value;
            }
        }

        #endregion


        #region Constructor, Activated

        public MessagesDialogResult()
        {
            InitializeComponent();
        }

        private void MessagesDialogResult_Activated(object sender, EventArgs e)
        {
            mesBtnYes.Focus();
        }

        #endregion


        #region Panel Events

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            int thickness = 1;
            int halfThickness = thickness / 2;
            using (var p = new Pen(Color.FromArgb(0, 122, 204), thickness))
            {
                e.Graphics.DrawRectangle(p, new Rectangle(halfThickness,
                                                          halfThickness,
                                                          panel1.ClientSize.Width - thickness,
                                                          panel1.ClientSize.Height - thickness));
            }
        }

        #endregion


        #region Control Events

        private void mesBtnYes_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void mesBtnNo_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion
    
    
    }
}
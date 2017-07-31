using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuoteLogGrid.Forms
{
    public partial class formChooseQuoteType : Form
    {
        public QuoteTypes QuoteType = new QuoteTypes();


        public formChooseQuoteType()
        {
            InitializeComponent();

            rbtnModifyExisting.Checked = true;
        }


        private void rbtnModifyExisting_CheckedChanged(object sender, EventArgs e)
        {
            if (rbtnModifyExisting.Checked) QuoteType = QuoteTypes.ModifyExisting;
        }

        private void rbtnNewQuote_CheckedChanged(object sender, EventArgs e)
        {
            if (rbtnNewQuote.Checked) QuoteType = QuoteTypes.New;
        }

        private void rbtnCopyQuote_CheckedChanged(object sender, EventArgs e)
        {
            if (rbtnCopyQuote.Checked) QuoteType = QuoteTypes.Copy;
        }

        private void rbtnBomModification_CheckedChanged(object sender, EventArgs e)
        {
            if (rbtnBomModification.Checked) QuoteType = QuoteTypes.BomMod;
        }

        private void rbtnPriceChange_CheckedChanged(object sender, EventArgs e)
        {
            if (rbtnPriceChange.Checked) QuoteType = QuoteTypes.PriceChange;
        }



        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            this.Close();
        }


    }
}

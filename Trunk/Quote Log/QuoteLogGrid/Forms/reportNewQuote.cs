using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;
using DevExpress.Xpf.Printing;

namespace QuoteLogGrid.Forms
{
    public partial class reportNewQuote : DevExpress.XtraReports.UI.XtraReport
    {
        public reportNewQuote()
        {
            InitializeComponent();
        }

        private void xrLabelEAU_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string EAU = xrLabelEAU.Text;
            if (EAU == "") return;

            EAU = EAU.Remove(0, 1); // removes dollar sign

            int i = EAU.IndexOf(".");
            EAU = EAU.Remove(i); // removes decimals

            xrLabelEAU.Text = EAU;
        }

        private void xrLabelReceiptDate_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string Date = xrLabelReceiptDate.Text;
            if (Date == "") return;

            int i = Date.IndexOf(" ");
            Date = Date.Remove(i); // removes time

            xrLabelReceiptDate.Text = Date;
        }

        private void xrLabelRequestedDueDate_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string Date = xrLabelRequestedDueDate.Text;
            if (Date == "") return;

            int i = Date.IndexOf(" ");
            Date = Date.Remove(i); // removes time

            xrLabelRequestedDueDate.Text = Date;
        }

        private void xrLabelEEIPromisedDueDate_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string Date = xrLabelEEIPromisedDueDate.Text;
            if (Date == "") return;

            int i = Date.IndexOf(" ");
            Date = Date.Remove(i); // removes time

            xrLabelEEIPromisedDueDate.Text = Date;
        }

        private void xrLabelLTAYear1_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string Percentage = xrLabelLTAYear1.Text;
            if (Percentage == "") return;

            int i = Percentage.IndexOf(".");
            if (i > 0) Percentage = Percentage.Remove(i);

            if (Percentage == "0") Percentage = "";

            xrLabelLTAYear1.Text = Percentage;
        }

        private void xrLabelLTAYear2_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string Percentage = xrLabelLTAYear2.Text;
            if (Percentage == "") return;

            int i = Percentage.IndexOf(".");
            if (i > 0) Percentage = Percentage.Remove(i);

            if (Percentage == "0") Percentage = "";

            xrLabelLTAYear2.Text = Percentage;
        }

        private void xrLabelLTAYear3_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string Percentage = xrLabelLTAYear3.Text;
            if (Percentage == "") return;

            int i = Percentage.IndexOf(".");
            if (i > 0) Percentage = Percentage.Remove(i);

            if (Percentage == "0") Percentage = "";
           
            xrLabelLTAYear3.Text = Percentage;
        }

        private void xrLabelLTAYear4_PrintOnPage(object sender, PrintOnPageEventArgs e)
        {
            string Percentage = xrLabelLTAYear4.Text;
            if (Percentage == "") return;

            int i = Percentage.IndexOf(".");
            if (i > 0) Percentage = Percentage.Remove(i);

            if (Percentage == "0") Percentage = "";

            xrLabelLTAYear4.Text = Percentage;
        }



    }
}

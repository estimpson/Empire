using System;
using System.Windows.Forms;
using Connection;

namespace Controls
{
    public class ErrorAlert
    {
        public void ShowError(Enum alertLevel, string errorMessage, string title)
        {
            string level = alertLevel.ToString();
            switch (level) // Medium = icon.none; High = icon.exclamation
            {
                case "Medium":
                    FXRFGlobals.MyRFGun.Beep();

                    FXRFGlobals.MyRFGun.StopRead();
                    DialogResult drMedium = MessageBox.Show(errorMessage, title, MessageBoxButtons.OK, MessageBoxIcon.None,
                                    MessageBoxDefaultButton.Button1);
                    if (drMedium == DialogResult.OK)
                    {
                        FXRFGlobals.MyRFGun.StartRead();
                    }
                    break;
                case "High":
                    FXRFGlobals.MyRFGun.Beep();

                    FXRFGlobals.MyRFGun.StopRead();
                    DialogResult drHigh =  MessageBox.Show(errorMessage, title, MessageBoxButtons.OK, MessageBoxIcon.Exclamation,
                                    MessageBoxDefaultButton.Button1);
                    if (drHigh == DialogResult.OK)
                    {
                        FXRFGlobals.MyRFGun.StartRead();
                    }
                    break;
            }
        }


    }
}

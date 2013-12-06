#region Using

using System;
using System.Windows.Forms;
using Connection;

#endregion

namespace SuperObject
{
    public partial class MainView : Form
    {
        protected string Operator { get; set; }

        private readonly ISuperObjectController _myController;

        public MainView(ISuperObjectController myController)
        {
            InitializeComponent();
            logOnOffControl1.ConnectionString = FXRFGlobals._eehConnectionString;
            _myController = myController;
            _myController.SuccessfulLogin += MyControllerSuccessfulLogin;
            _myController.FailedLogin += MyControllerFailedLogin;
        }

        private void MenuItemCloseClick(object sender, EventArgs e)
        {
            _myController.Close();
        }

        //private void UxPwdKeyDown(object sender, KeyEventArgs e)
        //{
        //    if ((Int32)e.KeyCode == 134)
        //    {
        //        uxConfirmPWD.Focus();
        //        e.Handled = false;
        //    }
        //}

        private void MyControllerSuccessfulLogin(object sender, LogInArgs e)
        {
        }

        private void MyControllerFailedLogin(object sender, EventArgs e)
        {
        }

        private void logOnOffControl1_LogOnOffChanged(bool state)
        {

        }

        private void logOnOffControl1_OperatorCodeChanged(string opCode)
        {

        }
    }
}
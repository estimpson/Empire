#region Using

using System;
using System.Windows.Forms;
using DataLayer.DataAccess;

#endregion

namespace Controls
{
    public partial class LogOnOffControl : UserControl
    {
        private readonly Logon _logon;
        private readonly ErrorAlert _alert;

        private enum AlertLevel
        {
            Medium,
            High
        }

        #region Properties

        private bool _isLoggedOn;

        public bool IsLoggedOn
        {
            get { return _isLoggedOn; }
            set
            {
                _isLoggedOn = value;
                if (LogOnOffChanged != null) // check for listener
                {
                    LogOnOffChanged(value);
                }
            }
        }

        private string _operatorCode;

        public string OperatorCode
        {
            get { return _operatorCode; }
            set
            {
                _operatorCode = value;
                if (OperatorCodeChanged != null) // check for listener
                {
                    OperatorCodeChanged(value);
                }
            }
        }

        public string ConnectionString { get; set; }

        #endregion

        public LogOnOffControl()
        {
            InitializeComponent();

            _logon = new Logon();
            _alert = new ErrorAlert();

            ToggleView("LogOn");
        }

        #region Control Events

        private void BtnLogOnOffClick(object sender, EventArgs e)
        {
            if (btnLogOnOff.Text == "Log On")
            {
                UserLogOn(tbxOpCode.Text.Trim());
            }
            else
            {
                UserLogOff();
            }
        }

        private void TxtOperatorKeyPress(object sender, KeyPressEventArgs e)
        {
        }

        private void TbxOpCodeKeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char) 13)
            {
                if (btnLogOnOff.Text == "Log On")
                {
                    UserLogOn(tbxOpCode.Text.Trim());
                }
                else
                {
                    UserLogOff();
                }
            }
        }

        #endregion

        #region Methods

        private void UserLogOn(string password)
        {
            if (password == "")
            {
                _alert.ShowError(AlertLevel.Medium, "Enter password.", "Error");
                return;
            }

            string error, opName, opCode;
            _logon.ValidatePassword(ConnectionString, password, out opName, out opCode, out error);
            if (error != "")
            {
                _alert.ShowError(AlertLevel.High, error, "ValidatePassword() Error");
                tbxOpCode.Text = "";
                return;
            }
            if (opCode == "")
            {
                _alert.ShowError(AlertLevel.Medium, "Invalid password.", "Log on failed");
                tbxOpCode.Text = "";
                return;
            }
            // Valid password
            txtOperator.Text = opName;
            OperatorCode = opCode;
            ToggleView("LogOff");
            IsLoggedOn = true;
        }

        private void UserLogOff()
        {
            ToggleView("LogOn");
            IsLoggedOn = false;
        }

        private void ToggleView(string state)
        {
            if (state == "LogOn")
            {
                lblOperator.Text = "Password:";
                tbxOpCode.Visible = true;
                txtOperator.Visible = false;
                txtOperator.Text = tbxOpCode.Text = "";
                btnLogOnOff.Text = "Log On";
            }
            else
            {
                lblOperator.Text = "Operator:";
                tbxOpCode.Visible = false;
                txtOperator.Visible = true;
                txtOperator.Enabled = false;
                btnLogOnOff.Text = "Log Off";
            }
        }

        #endregion

        #region Events

        public class LogInArgs : EventArgs
        {
            public string OperatorCode;
            public string OperatorName;
        }

        public delegate void SuccessfulLogin(object sender, LogInArgs args);

        public delegate void FailedLogin(object sender, EventArgs args);

        public delegate void LoggedOff(object sender, EventArgs args);


        public event SuccessfulLogin SuccessfulLogin;

        private void OnRaiseSuccessfulLogin(LogInArgs e)
        {
            SuccessfulLogin handler = SuccessfulLogin;
            if (handler != null)
            {
                handler(this, e);
            }
        }

        #endregion
    }
}
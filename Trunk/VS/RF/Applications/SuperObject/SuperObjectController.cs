#region Using

using System;
using System.Data.SqlClient;
using System.Windows.Forms;
using CommonData.dsLoginTableAdapters;
using Connection;

#endregion

namespace SuperObject
{
    internal class SuperObjectController : ISuperObjectController
    {
        private readonly MainView _mainView;

        public SuperObjectController()
        {
            _mainView = new MainView(this);
            Application.Run(_mainView);
        }

        public void Close()
        {
            _mainView.Close();
        }

        public void Login(string password)
        {
            try
            {
                using (var eta = new EmployeeTableAdapter())
                {
                    eta.Connection = new SqlConnection {ConnectionString = FXRFGlobals._eehConnectionString};
                    var edt = eta.GetEmployeeByPassword(password);

                    switch (edt.Rows.Count)
                    {
                        case 1:
                            OnRaiseSuccessfulLogin(new LogInArgs{OperatorCode = edt[0].operator_code, OperatorName = edt[0].name});
                            break;
                        case 0:
                            OnRaiseFailedLogin(new EventArgs());
                            throw new Exception("Invalid password.");
                        default:
                            OnRaiseFailedLogin(new EventArgs());
                            throw new Exception("Unknown error validating password.");
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void Logoff()
        {
            throw new System.NotImplementedException();
        }

        public event SuccessfulLogin SuccessfulLogin;

        private void OnRaiseSuccessfulLogin(LogInArgs e)
        {
            SuccessfulLogin handler = SuccessfulLogin;
            if (handler != null)
            {
                handler(this, e);
            }
        }

        public event FailedLogin FailedLogin;

        private void OnRaiseFailedLogin(EventArgs e)
        {
            FailedLogin handler = FailedLogin;
            if (handler != null)
            {
                handler(this, e);
            }
        }
    }
}
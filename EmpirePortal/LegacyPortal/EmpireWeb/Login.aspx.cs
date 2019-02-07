using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // To disable authenticated cookie
        //HttpCookie myCookie = new HttpCookie("UserSettings");
        //myCookie.Expires = DateTime.Now.AddDays(-1d);
        //Response.Cookies.Add(myCookie);

        if (Page.IsPostBack)
        {
            lblMessage.Text = "";
        }

        if (User.Identity.IsAuthenticated)
        {
            //if (Roles.IsUserInRole(User.Identity.Name, "Managers"))
            //{ 
            Response.Redirect("Default.aspx");
            //}
        }
    }

    protected void Login2_LoggedIn(object sender, EventArgs e)
    {
        //if (Roles.IsUserInRole(Login2.UserName, "Managers"))
        //{
            Login2.DestinationPageUrl = "Default.aspx";
        //}
    }

    protected void lbtnForgotPassword_Click(object sender, EventArgs e)
    {
        divPasswordRecovery.Visible = true;
    }

    protected void btnRecoverPassword_Click(object sender, EventArgs e)
    {
        string userName = Login2.UserName;
        string email = tbxEmail.Text.Trim();

        if (userName == "")
        {
            lblMessage.Text = "You must enter a User Name.";
            return;
        }
        if (email == "")
        {
            lblMessage.Text = "You must enter an email address.";
            return;
        }
        GetUserPassord(userName, email);
    }

    private void GetUserPassord(string userName, string email)
    {
        string message = "";
        string password = "";
        try
        {
            MembershipUser u = Membership.GetUser(userName);

            if (email == u.Email)
            {
                password = u.GetPassword();
            }
            else
            {
                message = "Entered email address does not match the stored email for user.";
            }
        }
        catch (Exception)
        {
            message = String.Format("Unable to find user {0}.", userName);
        }

        if (message == "")
        {
            //EmailPassword(password, email);
            lblMessage.Text = String.Format("Your password is:  {0}", password);
        }
        else
        {
            lblMessage.Text = message;
        }
    }

    private void EmailPassword(string password, string email)
    {
        try
        {
            MailMessage message = new MailMessage();
            message.From = new MailAddress("admin@empireelect.com");

            message.To.Add(new MailAddress(email));
            //message.To.Add(new MailAddress("recipient2@foo.bar.com"));
            //message.To.Add(new MailAddress("recipient3@foo.bar.com"));

            //message.CC.Add(new MailAddress("carboncopy@foo.bar.com"));
            message.Subject = "PW";
            message.Body = password;

            SmtpClient client = new SmtpClient();
            client.Send(message);

            lblMessage.Text = "Your password has been emailed.";
        }
        catch (Exception ex)
        {
            lblMessage.Text = "Failed to email password.";
        }
    }

}
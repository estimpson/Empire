using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Profile.FirstName != "")
        {
            lblProfile.Text = String.Format("{0}, {1} (update profile)", Profile.LastName, Profile.FirstName);
        }
        else
        {
            lblProfile.Text = "(update profile)";
        }
    }

    protected void btnSave_OnClick(object sender, EventArgs e)
    {
        Profile.FirstName = tbxFirstName.Text.Trim();
        Profile.LastName = tbxLastName.Text.Trim();
        Profile.Save();

        lblProfile.Text = String.Format("{0}, {1} (update profile)", Profile.LastName, Profile.FirstName);
        tbxFirstName.Text = tbxLastName.Text = "";
    }


}
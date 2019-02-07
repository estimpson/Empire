<%@ Application Language="C#" %>
<%@ Import Namespace="EmpireWeb" %>
<%@ Import Namespace="System.Web.Optimization" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        BundleConfig.RegisterBundles(BundleTable.Bundles);
        AuthConfig.RegisterOpenAuth();
    }
    
    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Application_BeginRequest(object sender, EventArgs e)
    {
        var app = (HttpApplication)sender;
        if (app.Context.Request.Url.LocalPath.EndsWith("/"))
        {
            app.Context.RewritePath(
                string.Concat(app.Context.Request.Url.LocalPath, "default.aspx"));
        }
    }

</script>

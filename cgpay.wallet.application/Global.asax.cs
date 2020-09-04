using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using cgpay.wallet.application.Library;
using cgpay.wallet.business.ErrorHandler;

namespace cgpay.wallet.application
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            Bootstrapper.Initialise();
        }
        protected void Application_Error(object sender, EventArgs e)
        {
            bool customRedirect = true;
            if (ConfigurationManager.AppSettings["CustomRedirect"] != null && ConfigurationManager.AppSettings["CustomRedirect"].ToString().ToLower() == "false")
                customRedirect = false;
            ErrorHandlerBusiness buss = new ErrorHandlerBusiness();
            Exception exception = HttpContext.Current.Error;
            var Session = HttpContext.Current.Session;
            var err = Server.GetLastError();
            if (err != null)
            {
                System.Diagnostics.Debug.WriteLine(exception.GetType());
                if (exception.GetType() == typeof(HttpException) || exception.GetType() == typeof(NullReferenceException) || exception.GetType() == typeof(HttpAntiForgeryException) || exception.GetType() == typeof(ArgumentNullException)) //It's an Http Exception
                {
                    int statusCode = 0;
                    if (exception.GetType() == typeof(HttpException))
                        statusCode = ((HttpException)exception).GetHttpCode();
                    var page = HttpContext.Current.Request.Url.ToString();
                    string userName = "System";
                    if (Session != null && Session["UserName"] != null)
                    {
                        userName = HttpContext.Current.Session["UserName"].ToString();
                        //userName = string.IsNullOrEmpty(Session["UserName"].ToString()) ? "" : Session["UserName"].ToString();

                    }
                    else
                        userName = "system";
                    string ipAddress = ApplicationUtilities.GetIP();
                    var id = buss.LogError(err, page, userName, ipAddress);
                    switch (statusCode)
                    {
                        //case 400:
                        //    routeData.Values.Add("status", "400 - Bad Request");
                        //    break;
                        //case 401:
                        //    routeData.Values.Add("status", "401 - Access Denied");
                        //    break;
                        case 403:
                            break;
                        case 404:
                            break;
                        default:
                            //routeData.Values.Add("status", "500 - Internal Server Error");
                            if (customRedirect)
                                HttpContext.Current.Response.Redirect("/Error/Index?Id=" + id);
                            break;
                    }
                }

            }
        }
    }
}

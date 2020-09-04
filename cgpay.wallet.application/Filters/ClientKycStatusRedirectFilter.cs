using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace cgpay.wallet.application.Filters
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
    public class ClientKycStatusRedirectFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpContext ctx = HttpContext.Current;
            // If the browser session or authentication session has expired...
            if (ctx.Session["KycStatus"] != null)
            {
                var routeValues = HttpContext.Current.Request.RequestContext.RouteData.Values;
                var dataTokens = HttpContext.Current.Request.RequestContext.RouteData.DataTokens;
                var areaName = String.Empty;

                if (routeValues != null)
                {
                    var area = dataTokens.Where(x => x.Key.ToLower() == "area");
                    if (routeValues.ContainsKey("area"))
                    {
                        areaName = routeValues["area"].ToString();
                    }
                    else if (dataTokens != null && area != null)
                    {
                        areaName = area.FirstOrDefault().Value.ToString();
                    }
                    var kycStatus=ctx.Session["KycStatus"].ToString()??"";
                    if (areaName.ToUpper() == "CLIENT"&&kycStatus.ToLower()=="n")
                    {
                        filterContext.Result = new RedirectToRouteResult(
                                             new RouteValueDictionary {
                                { "Controller", "Kyc" },
                                { "Action", "error_403" },
                                {"Area","Client" }
                        });
                    }

                }

            }
        }
    }
}
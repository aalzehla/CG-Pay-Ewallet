using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using cgpay.wallet.application.Library;
using cgpay.wallet.business.Login;

namespace cgpay.wallet.application.Filters
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
    public class SessionExpiryFilterAttribute : ActionFilterAttribute
    {

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpContext ctx = HttpContext.Current;
            // If the browser session or authentication session has expired...
            if (ctx.Session["UserName"] == null)
            {
                filterContext.Result = new RedirectToRouteResult(
                        new RouteValueDictionary {
                        { "Controller", "Home" },
                        { "Action", "LogOff" }
                        });

            }
            else
            {
                ILoginUserBusiness ILUB = new LoginUserBusiness();
                shared.Models.SessionIdMapping map = ILUB.getUserSessionId(ctx.Session["UserName"].ToString());

                if (map.Session != ctx.Session.SessionID && !map.Allowd_Multiple_Login.Equals("Y"))
                {
                    filterContext.Result = new RedirectToRouteResult(
                           new RouteValueDictionary {
                        { "Controller", "Home" },
                        { "Action", "LogOff" }
                           });
                }
                if (map.Session.Contains("|") && !map.Session.Substring(1).Equals(ctx.Session.SessionID))
                {
                    filterContext.Result = new RedirectToRouteResult(
                           new RouteValueDictionary {
                        { "Controller", "Home" },
                        { "Action", "LogOff" }
                           });
                }

                var areaName = String.Empty;
                var controllerName = string.Empty;
                var actionName = string.Empty;
                var routeValues = HttpContext.Current.Request.RequestContext.RouteData.Values;
                var dataTokens = HttpContext.Current.Request.RequestContext.RouteData.DataTokens;

                if (routeValues != null)
                {
                    var area = dataTokens.Where(x => x.Key.ToLower() == "area");
                    if (routeValues.ContainsKey("area"))
                    {
                        areaName = routeValues["area"].ToString();
                    }
                    else if (dataTokens != null && area != null)
                    {
                        areaName = area.FirstOrDefault().Value == null ? "" : area.FirstOrDefault().Value.ToString();
                    }
                    if (routeValues.ContainsKey("action"))
                    {
                        actionName = routeValues["action"].ToString();
                    }
                    if (routeValues.ContainsKey("controller"))
                    {
                        controllerName = routeValues["controller"].ToString();
                    }

                    var Role = ctx.Session["UserType"] != null ? ctx.Session["UserType"].ToString() : "";

                    #region check menu rights
                    var functions = ctx.Session["functions"] as List<string>;
                    if (controllerName.ToUpper() == "HOME" && (actionName.ToUpper() == "INDEX" || actionName.ToUpper() == "LOGOFF" || actionName.ToUpper() == "VERIFYCODE"
                        || actionName.ToUpper() == "DASHBOARD2" || actionName.ToUpper() == "DASHBOARD3"))
                    {

                    }
                    else
                    {
                        var redirectArea = "";
                        if (Role.ToUpper() == "ADMIN" || Role.ToUpper() == "DISTRIBUTOR" || Role.ToUpper() == "SUB-DISTRIBUTOR")
                        {
                            redirectArea = "ADMIN";
                        }
                        else if (Role.ToUpper() == "WALLETUSER" || Role.ToUpper() == "MERCHANT" || Role.ToUpper() == "AGENT" || Role.ToUpper() == "SUB-AGENT")
                            redirectArea = "CLIENT";
                        var func = functions.ConvertAll(x => x.ToUpper());
                        var actionUrl = "/" + ((String.IsNullOrEmpty(areaName) ? "" : areaName + "/") +
                                               controllerName + "/" + actionName).ToUpper();
                        if (func.Contains(actionUrl) == false && func.Equals(actionUrl) == false)
                        {
                            filterContext.Result = new RedirectToRouteResult(
                                new RouteValueDictionary
                                {
                                        {"Controller", "Error"},
                                        {"Action", "error_403"},
                                    { "Area",redirectArea}
                                });
                        }
                    }
                    #endregion check menu rights

                    if (Role.ToUpper() == "ADMIN" || Role.ToUpper() == "DISTRIBUTOR" || Role.ToUpper() == "SUB-DISTRIBUTOR")
                    {
                        if (areaName.ToUpper() != "ADMIN")
                        {
                            filterContext.Result = new RedirectToRouteResult(
                                                 new RouteValueDictionary {
                                { "Controller", "Error" },
                                { "Action", "error_403" },
                                {"Area","Admin" }
                            });
                        }
                    }
                    else if (Role.ToUpper() == "WALLETUSER" || Role.ToUpper() == "MERCHANT" || Role.ToUpper() == "AGENT" || Role.ToUpper() == "SUB-AGENT")
                    {
                        if (areaName.ToUpper() != "CLIENT")
                        {
                            filterContext.Result = new RedirectToRouteResult(
                                                 new RouteValueDictionary {
                                { "Controller", "Error" },
                                { "Action", "error_403" },
                                {"Area","Client" }
                            });
                        }
                    }
                }
                ApplicationUtilities.LogRequest();
            }
            base.OnActionExecuting(filterContext);
        }
    }
}
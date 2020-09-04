using cgpay.wallet.business.Log;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Filters
{
    public class ActivityLogFilter: ActionFilterAttribute
    {
       
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpContext httpCtx = HttpContext.Current;
            string url = httpCtx.Request.Url.AbsoluteUri;
            string pageName = httpCtx.Request.RequestContext.RouteData.GetRequiredString("action");
            var browserDetails = httpCtx.Request.Headers["User-Agent"];
            string username = httpCtx.Session["UserName"]== null ? "system": httpCtx.Session["UserName"].ToString();
            string ip = httpCtx.Request.UserHostAddress;

            AddActitivies(pageName,url,browserDetails,ip,"", username);
            
               

            base.OnActionExecuting(filterContext);
        }

        public CommonDbResponse AddActitivies(string page_name, string page_url, string browser, string ip, string logtype, string usernname)
        {
            CommonDbResponse cResponse = new CommonDbResponse();
            ActivityLogBusiness ab = new ActivityLogBusiness();
            ActivityLog al = new ActivityLog()
            {
                page_name = page_name,
                page_url = page_url,
                browser_detail = browser,
                ipaddress = ip,
                log_type = logtype,
                user_name = usernname
            };
            cResponse = ab.InsertActivityLog(al);
            return cResponse;
        }
    }
}
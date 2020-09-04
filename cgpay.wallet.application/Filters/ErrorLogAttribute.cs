using cgpay.wallet.business.Log;
using cgpay.wallet.shared.Models.Errors;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Filters
{
    public class ErrorLogAttribute: HandleErrorAttribute
    {
        
        
        public override void OnException(ExceptionContext filterContext)
        {
            CustomErrorHandler(filterContext);
            base.OnException(filterContext);
        }

        public void CustomErrorHandler(ExceptionContext filterContext)
        {
            string errorMessage = filterContext.Exception.Message;
            string errorSource = filterContext.Exception.Source;
            string errorTarget = filterContext.Exception.TargetSite.ToString();
            string errorType = filterContext.Exception.GetType().Name;
            string errorTime = DateTime.Now.ToString();
            

            StringBuilder sBuilder = new StringBuilder();
            sBuilder.AppendLine("Source: "+errorSource);
            sBuilder.AppendLine(",");
            sBuilder.AppendLine("Target: " + errorTarget);
            sBuilder.AppendLine(",");
            sBuilder.AppendLine("Type: " + errorType);
            sBuilder.AppendLine(",");
            sBuilder.AppendLine("Time: " + errorTime);

            string errorPage = HttpContext.Current.Request.RequestContext.RouteData.GetRequiredString("action");
            string userName = HttpContext.Current.Session["UserName"].ToString();
            string errorDetails = sBuilder.ToString();
            AddErrors(errorPage,
                errorMessage,
                errorDetails,
                userName
                );


        }

        public void AddErrors(string errorpage, string errormsg, string errordetail, string username)
        {
            ErrorLogBusiness errb = new ErrorLogBusiness();
            ErrorsLog err = new ErrorsLog()
            {
                error_page = errorpage,
                error_msg = errormsg,
                error_detail = errordetail,
                user = username
            };
            errb.InsertErrors(err);
        }
    }
}
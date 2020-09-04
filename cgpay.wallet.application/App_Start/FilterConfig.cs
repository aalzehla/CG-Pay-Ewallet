using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Filters;

namespace cgpay.wallet.application
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            //filters.Add(new HandleErrorAttribute());
            filters.Add(new SessionExpiryFilterAttribute());
            //filters.Add(new ClientKycStatusRedirectFilter());
            filters.Add(new ActivityLogFilter());
        }
    }
}

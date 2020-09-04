using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    [OverrideActionFilters]
    public class ErrorController : Controller
    {
        // GET: Client/Error
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult error_403()
        {
            return View();
        }
        public ActionResult error_404()
        {
            return View();
        }
    }
}
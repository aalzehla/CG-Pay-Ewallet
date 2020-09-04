using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Controllers
{
    [OverrideActionFilters]
    public class ErrorController : Controller
    {
        // GET: Error
        public ActionResult Index(string Id = "")
        {
            if (string.IsNullOrEmpty(Id))
                return RedirectToAction("Index", "Home");
            @ViewBag.ErrorId = Id;
            return View();
        }

        public ActionResult error_404()
        {
            return View();
        }
        public ActionResult error_403()
        {
            return View();
        }
    }
}
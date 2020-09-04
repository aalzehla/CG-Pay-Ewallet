using cgpay.wallet.business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Client;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class HomeController : Controller
    {
        IServicesManagementBusiness _services;
        private IWalletUserBusiness _walletUser;
        public HomeController(IServicesManagementBusiness services, IWalletUserBusiness walletUserBusiness)
        {
            _services = services;
            _walletUser = walletUserBusiness;

        }
        // GET: Client/Home
        // GET: Admin/Home
        public ActionResult Index()
        {
            string UserId = Session["UserId"].ToString();
            //Start Search balance from userid
            Session["Balance"] = _walletUser.UserInfo(UserId).Balance.ToString();
            //Ends
            var lst = _services.GetServicesList(UserId).MapObjects<ServicesModel>();
            List<ServicesModel> servicesModels = new List<ServicesModel>();
            foreach (var item in lst)
            {
                ServicesModel model = new ServicesModel();
                model.ProductId = item.ProductId.EncryptParameter();
                model.ProductLogo = item.ProductLogo;
                model.ProductLabel = item.ProductLabel;
                model.ProductCategory = item.ProductCategory;
                model.ClientPmtUrl = string.IsNullOrEmpty(item.ProductUrl) ? item.ClientPmtUrl : item.ProductUrl;
                model.CommissionValue = item.CommissionValue;
                model.CommissionType = item.CommissionType;
                model.Company = item.Company;
                model.Status = item.Status.Trim();//== "Y" ? "checked" : "";
                servicesModels.Add(model);
            }
            return View(servicesModels);
            //return View();
        }
        [OverrideActionFilters]
        public ActionResult LogOff()
        {
            Session.Abandon();
            Session.RemoveAll();
            Session.Clear();
            return RedirectToAction("", "Home", new { area = "" });
        }
        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> GetBalance()
        {
            string UserId = Session["UserId"].ToString();
            //Start Search balance from userid
            Session["Balance"] = _walletUser.UserInfo(UserId).Balance.ToString();
            //Ends
            return Json(new { balance = Session["Balance"].ToString() });
        }


    }
}
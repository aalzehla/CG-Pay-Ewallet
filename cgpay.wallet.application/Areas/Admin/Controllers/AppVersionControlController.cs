using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.AppVersionControl;
using cgpay.wallet.shared.Models.AppVersionControl;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    
    public class AppVersionControlController : Controller
    {
        IAppVersionControlBusiness buss;
        public AppVersionControlController(IAppVersionControlBusiness _buss)
        {
            buss = _buss;
        }
        public ActionResult Index()
        {
            var lst = buss.GetAppVersionList();
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("AppPlatform", "Platform");
            param.Add("AppVersion", "Version");
            param.Add("IsMajorUpdate", "Major Update");
            param.Add("IsMinorUpdate", "Minor Update");
            param.Add("CreatedBy", "Created By");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(lst, "List", "", 0, true, "", "", "Home", "App Version", "/Admin/AppVersionControl", "/Admin/AppVersionControl/Manage");
            ViewData["grid"] = grid;
            return View();
        }
        [HttpGet]
        public ActionResult Manage(string id)
        {
            AppVersionControlModel mnm = new AppVersionControlModel();
            string username = ApplicationUtilities.GetSessionValue("username").ToString();
           ViewBag.platform = ApplicationUtilities.SetDDLValue(LoadDropdownList("platform"), "", "--Select Application Platform--");
           
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Manage(AppVersionControlModel AVM)
        {
            ViewBag.platform = ApplicationUtilities.SetDDLValue(LoadDropdownList("platform"), "", "--Select Application Platform--");
            if (ModelState.IsValid)
            {
                if (AVM.IsMajorUpdate.ToUpper() != "Y")
                    AVM.IsMajorUpdate = "N";
                if (AVM.IsMinorUpdate.ToUpper() != "Y")
                    AVM.IsMinorUpdate = "N";
                if(AVM.IsMinorUpdate.ToUpper()=="N" && AVM.IsMajorUpdate.ToUpper() == "N")
                {
                    ModelState.AddModelError("IsMajorUpdate","Invalid Parameter");
                   
                    return View(AVM);
                }
                AppVersionControlCommon AVC = new AppVersionControlCommon();
                AVC = AVM.MapObject<AppVersionControlCommon>();                
                AVC.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                AVC.IpAddress = ApplicationUtilities.GetIP();
                var dbresp = buss.ManageAppVersion(AVC);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, "Successfully Inserted");
                    return RedirectToAction("Index");
                }
            }
            this.ShowPopup(1, "Error");
            return View(AVM);
        }
        public Dictionary<string, string> LoadDropdownList(string flag, string search1 = "")
        {
            switch (flag)
            {
                case "platform":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("Android", "Android");
                        dict.Add("IOS", "IOS");
                        return dict;
                    };
                default:
                    return null;

            }
        }
    }
}
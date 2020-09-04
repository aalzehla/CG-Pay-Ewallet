using cgpay.wallet.business.Common;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Filters;
using cgpay.wallet.business.MobileNotification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.shared.Models.MobileNotification;
using cgpay.wallet.application.Models;
using System.IO;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    
    public class MobileNotificationController : Controller
    {
        IMobileNotificationBusiness buss;
        ICommonBusiness ICB;
        public MobileNotificationController(IMobileNotificationBusiness _buss, ICommonBusiness _ICB)
        {
            buss = _buss;
            ICB = _ICB;
        }
        [HttpGet]

        public ActionResult Index()
        {

            var lst = buss.GetNotificationList();
           
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("NotificationSubject", "Subject");
            param.Add("NotificationSubtitle", "SubTitle");
            param.Add("NotificationType", "Type");
            param.Add("NotificationStatus", "status");
          
            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(lst, "List", "", 0, true, "", "", "Home", "Mobile Notification", "/Admin/MobileNotification", "/Admin/MobileNotification/Manage");
            ViewData["grid"] = grid;
            return View();
        }
        [HttpGet]
        public ActionResult Manage(string id)
        {
            MobileNotificationModel mnm = new MobileNotificationModel();
            string username = ApplicationUtilities.GetSessionValue("username").ToString();
            ViewBag.importancelevel= ApplicationUtilities.SetDDLValue(LoadDropdownList("importance"), "", "--Select Importance Level--");
            if (!string.IsNullOrEmpty(id))
            {
                if (!string.IsNullOrEmpty(id.DecryptParameter()))
                {
                    MobileNotificationCommon mnc = new MobileNotificationCommon();
                    mnc = buss.GetNotificationById(id.DecryptParameter(), username);
                }
            }
            return View(mnm);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Manage(MobileNotificationModel mnm, HttpPostedFileBase Image_Upload)
        {
            var ImagePath = "";

            ViewBag.importancelevel = ApplicationUtilities.SetDDLValue(LoadDropdownList("importance"), "", "--select Importance Level--");
            if (ModelState.IsValid)
            {
                MobileNotificationCommon mnc = new MobileNotificationCommon();
                mnc = mnm.MapObject<MobileNotificationCommon>();
                if (!string.IsNullOrEmpty(mnc.NotificationId))
                {
                    if (string.IsNullOrEmpty(mnc.NotificationId.DecryptParameter()))
                    {
                        return View("Manage", mnm);
                    }
                    mnc.NotificationId = mnc.NotificationId.DecryptParameter();
                }
                if (Image_Upload != null)
                {
                    var contentType = Image_Upload.ContentType;
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Image_Upload.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Image_Upload.FileName);
                    if (Image_Upload.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(mnm);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + ext.ToLower();
                        ImagePath = Path.Combine(Server.MapPath("~/Content/userupload/Notification"), myfilename);
                        mnc.ImageUpload = "/Content/userupload/Notification/" + myfilename;
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(mnm);
                    }
                }
                mnc.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                var dbresp = buss.ManageNotification(mnc);
                if (dbresp.Code == 0)
                {
                    if (Image_Upload != null)
                    {
                        Image_Upload.SaveAs(ImagePath);
                    }
                    this.ShowPopup(0, "successfully Inserted");
                    return RedirectToAction("Index");
                }
            }
            this.ShowPopup(1, "Error");
            return View(mnm);
        }
        public Dictionary<string, string> LoadDropdownList(string flag, string search1 = "")
        {
            switch (flag)
            {
                case "importance":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("0", "Low");
                        dict.Add("1", "High");
                        return dict;
                    };
                default:
                    return null;

            }
        }
    }
}
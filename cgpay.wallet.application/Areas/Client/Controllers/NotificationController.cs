using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.business.Notification;
using System.Data;
using cgpay.wallet.shared.Models;
using cgpay.wallet.application.Library;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class NotificationController : Controller
    {
        INotificationBusiness _notifications;
        string ControllerName = "Notification";
        public NotificationController(INotificationBusiness notifications)
        {
            _notifications = notifications;

        }
        // GET: Client/Notification
        public ActionResult Index()
        {
            var notifications = _notifications.GetAllNotification(Session["UserId"].ToString(), null, null);
            if (notifications.Count == 0)
            {
                TempData["notificationmsg"] = " You don't have any notifications.";

            }
            return View(notifications);
        }

        // POST: Client/Notification
        [HttpPost]
        public ActionResult Index(string fromdate, string todate)
        {

            NotificationCommon nc = new NotificationCommon();
            nc.fromDate = fromdate;
            nc.toDate = todate;
            var notifications = _notifications.GetAllNotification(Session["UserId"].ToString(), fromdate, todate);

            //if ((nc.toDate) == "")
            //{
            //    this.ShowPopup(1, "Please select To Date");
            //}
            if (notifications.Count == 0)
            {
                TempData["notificationmsg"] = " You don't have any notifications.";

            }
            return View(notifications);
        }

        // GET: Client/Notification/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult GetNotifications()
        {
            List<NotificationCommon> obj = new List<NotificationCommon>();

            var ds = _notifications.GetNotificationByUser(Session["UserId"].ToString());

            if (ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow rows in ds.Tables[0].Rows)
                {
                    NotificationCommon objData = new NotificationCommon();
                    objData.Id = rows["Id"].ToString();
                    objData.Subject = rows["Subject"].ToString();
                    objData.CreatedDate = rows["CreatedDate"].ToString();
                    objData.Notification = rows["Notification"].ToString();
                    objData.ReadStatus = rows["ReadStatus"].ToString();
                    obj.Add(objData);

                }
            }


            var res = Json(obj);
            return res;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult UpdateNotificationReadStatus(int id, string updateFlag)
        {
            string agentId = ((updateFlag == "a" || updateFlag == "d") ? Session["UserId"].ToString() : "");

            CommonDbResponse dbresponse = _notifications.UpdateNotificationReadStatus(id, agentId, updateFlag);

            return Json(dbresponse);


        }
    }
}

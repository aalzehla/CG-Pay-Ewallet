using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.business.Dashboard;
using cgpay.wallet.shared.Models;
using System.Data;
using cgpay.wallet.business.User;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class HomeController : Controller
    {

        IDashboardBusiness _das;
        IUserBusiness _ubus;

        public HomeController(IDashboardBusiness das, IUserBusiness ubus)
        {
            _das = das;
            _ubus = ubus;
        }

        // GET: Admin/Home
        public ActionResult Index()
        {
            string UserId = Session["userid"].ToString();
            Session["Balance"] = _ubus.UserInfo(UserId).Balance.ToString();

            var UserType = Session["UserType"].ToString();
            string dashboard_name = "Index";

            if (UserType.ToUpper() == "DISTRIBUTOR")
            {
                dashboard_name = "Dashboard2";
                return RedirectToAction(dashboard_name);
            }
            else if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                dashboard_name = "Dashboard3";
                return RedirectToAction(dashboard_name);
            }

            return View();
        }
        public ActionResult Dashboard2()
        {
            var UserType = Session["UserType"].ToString();
            string dashboard_name = "Dashboard2";

            if (UserType.ToUpper() == "ADMIN")
            {
                dashboard_name = "Index";
                return RedirectToAction(dashboard_name);
            }
            else if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                dashboard_name = "Dashboard3";
                return RedirectToAction(dashboard_name);
            }
            return View();
        }
        public ActionResult Dashboard3()
        {
            var UserType = Session["UserType"].ToString();
            string dashboard_name = "Index";

            if (UserType.ToUpper() == "DISTRIBUTOR")
            {
                dashboard_name = "Dashboard2";
                return RedirectToAction(dashboard_name);
            }
            else if (UserType.ToUpper() == "ADMIN")
            {
                dashboard_name = "Index";
                return RedirectToAction(dashboard_name);
            }
            return View();
        }
        [OverrideActionFilters]
        public ActionResult LogOff()
        {
            Session.Abandon();
            Session.RemoveAll();
            Session.Clear();
            return RedirectToAction("", "Home", new { area = "" });
        }
        [HttpPost][ValidateAntiForgeryToken]
        public JsonResult GetChartData()
        {

            ChartDataCommon[] obj = new ChartDataCommon[3];
            ChartDataCommon objData = new ChartDataCommon();

            var ds = _das.CountTransactionByProduct(StaticData.GetUser());

            DataTable dt1 = new DataTable();
            dt1.Columns.Add("Label");
            dt1.Columns.Add("Value");

            if (ds.Tables[0].Rows.Count > 0)
            {
                var dt = ds.Tables[0];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow dr = dt1.NewRow();
                    dr[0] = dt.Rows[i]["Label"].ToString(); //"NT Mobile Prepaid (GSM)";
                    dr[1] = dt.Rows[i]["Value"].ToString(); //"56";
                    dt1.Rows.Add(dr);
                }
            }

            objData.ChartDataList = dt1.DataTableToList<ChartData>();
            obj[0] = objData;

            DataTable dt2 = new DataTable();
            dt2.Columns.Add("Label");
            dt2.Columns.Add("Value");

            if (ds.Tables[1].Rows.Count > 0)
            {
                var dt = ds.Tables[1];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow dr = dt2.NewRow();
                    dr[0] = dt.Rows[i]["Label"].ToString(); 
                    dr[1] = dt.Rows[i]["Value"].ToString(); 
                    dt2.Rows.Add(dr);
                }
            }

        
            objData = new ChartDataCommon();
            objData.ChartDataList = dt2.DataTableToList<ChartData>();
            obj[1] = objData;


            DataTable dt3 = new DataTable();
            dt3.Columns.Add("Label");
            dt3.Columns.Add("Value");
            dt3.Columns.Add("Type");

            if (ds.Tables[2].Rows.Count > 0)
            {
                var dt = ds.Tables[2];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow dr = dt3.NewRow();
                    dr[0] = dt.Rows[i]["Label"].ToString(); 
                    dr[1] = dt.Rows[i]["Value"].ToString(); 
                    dr[2] = dt.Rows[i]["Type"].ToString();
                    dt3.Rows.Add(dr);
                }
            }

          

            objData = new ChartDataCommon();
            objData.ChartDataList = dt3.DataTableToList<ChartData>();
            obj[2] = objData;

            var res = Json(obj);
            return res;
        }

        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> GetBalance()
        {
            string UserId = Session["UserId"].ToString();
            //Start Search balance from userid
            Session["Balance"] = _ubus.UserInfo(UserId).Balance.ToString();
            //Ends
            return Json(new { balance = Session["Balance"].ToString() });
        }


    }
}
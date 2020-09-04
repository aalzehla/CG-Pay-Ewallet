using cgpay.wallet.application.Library;
using cgpay.wallet.business.AdminCommission;
using cgpay.wallet.business.Common;
using cgpay.wallet.shared.Models.DynamicReport;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    
    public class AdminCommissionController : Controller
    {
        IAdminCommissionBusiness ACom;
        ICommonBusiness ICB;
        public AdminCommissionController(IAdminCommissionBusiness _ACom, ICommonBusiness _ICB)
        {
            ICB = _ICB;
            ACom = _ACom;
        }

        // GET: Admin/AdminCommission
        public ActionResult Index(string FromDate ="",string ToDate = "",string NepFromDate ="",string NepToDate ="")
        {
            var list = ACom.GetAdminCommissionReport(FromDate, ToDate);

            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("AdminCommissionReport", item.ProductId.EncryptParameter(), this, "", "", item.TransactionDate, "");
                //item.Status = "<span class='badge badge-" + (item.Status.Trim().ToUpper() == "SUCCESS" ? "success" : "danger") + "'>" + (item.Status.Trim().ToUpper() == "SUCCESS" ? "Active" : "Blocked") + "</span>";
            }

            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("TransactionDate", "Transaction Date");
            param.Add("Service", "Service");
            param.Add("TransactionType", "Transaction Type");
            param.Add("TotalTransaction", "Total Transaction");
            param.Add("TotalAmount", "Total Amount");
            param.Add("CommissionEarned", "Commission Earned");
            param.Add("Action", "Action");

            ProjectGrid.column = param;

           // var grid = ProjectGrid.MakeGrid(list, "hidebreadcrumb", "", 0, true, "", "", "Home", "Transaction Report", "", "", "datatable-total", showtotal: true);

            var grid = ProjectGrid.MakeGrid(list, "hidebreadcrumb", "", 0, false, "", "", "Home", "AdminCommission", "", "","datatable-total",true);
            ViewData["grid"] = grid;

            return View();
        }

        public ActionResult ViewReportDetailList(string ProductId,string CurrentDate)
        {
            //DateTime aDate = DateTime.Now;
            //aDate.ToString("MM/dd/yyyy")
            //DateTime oDate = Convert.ToDateTime(CurrentDate);
            var list = ACom.GetAdminCommissionDetailList(ProductId.DecryptParameter(), CurrentDate);

            foreach (var item in list)
            {
                item.TransactionId = "<a href='#' class='commission-report-detail' data-txnid='"+ item.TransactionId.EncryptParameter()+ "'>" + item.TransactionId.ToString() + "</a>";
                //item.Action = StaticData.GetActions("AdminCommissionReport", item.ProductId.EncryptParameter(), this, "", "", item.TransactionDate, "");
                //item.Status = "<span class='badge badge-" + (item.Status.Trim().ToUpper() == "SUCCESS" ? "success" : "danger") + "'>" + (item.Status.Trim().ToUpper() == "SUCCESS" ? "Active" : "Blocked") + "</span>";
            }

            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("TransactionId", "Transaction Id");
            param.Add("TransactionDate", "Transaction Date");
            param.Add("Service", "Service");
            param.Add("TransactionType", "Transaction Type");
            param.Add("SubscriberNo", "Subscriber No");
            param.Add("TotalAmount", "Amount");
            param.Add("AdminCommission", "Commission");
            //param.Add("Action", "Action");

            ProjectGrid.column = param;

            // var grid = ProjectGrid.MakeGrid(list, "hidebreadcrumb", "", 0, true, "", "", "Home", "Transaction Report", "", "", "datatable-total", showtotal: true);

            var grid = ProjectGrid.MakeGrid(list, "hidebreadcrumb", "", 0, false, "", "", "Home", "AdminCommission", "", "", "datatable-total",true);
            ViewData["grid"] = grid;

            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult ViewReportDetail(string TxnId)
        {
            AdminCommissionReportCommon common = new AdminCommissionReportCommon();
            var list = ACom.GetAdminCommissionDetail(TxnId.DecryptParameter());

            if (list != null)
            {
                foreach (var item in list)
                {


                    common.TransactionId = item.TransactionId.ToString();
                    common.Service = item.Service.ToString();
                    common.SubscriberNo = item.SubscriberNo.ToString();
                    common.TotalAmount = item.TotalAmount.ToString();
                    common.CreatedDate = item.CreatedDate.ToString();
                    common.GatewayTxnId = item.GatewayTxnId.ToString();
                    common.CreatedBy = item.CreatedBy.ToString();
                    common.AdminCommission = item.AdminCommission.ToString();
                    common.AdminCostAmount = item.AdminCostAmount.ToString();
                    common.AdminRemark = item.AdminRemark.ToString();
                    common.AgentRemark = item.AgentRemark.ToString();
                    common.GatewayName = item.GatewayName.ToString();
                    common.TransactionType = item.TransactionType.ToString();
                    common.AgentName = item.AgentName.ToString();
                    common.Status = item.Status.ToString();
                    common.ServiceCharge = item.ServiceCharge.ToString();
                    common.BonusAmount = item.BonusAmount.ToString();
                    common.Company = item.Company.ToString();
                   
                }
            }


            //var jsonResponse = JsonConvert.SerializeObject(list);


            return Json(common);


            
        }
    }
}
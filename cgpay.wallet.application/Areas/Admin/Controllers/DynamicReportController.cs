using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Balance;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.DynamicReport;
using cgpay.wallet.business.User;
using cgpay.wallet.shared.Models.Balance;
using cgpay.wallet.shared.Models.DynamicReport;
using Microsoft.Ajax.Utilities;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class DynamicReportController : Controller
    {
        private IDynamicReportBusiness _dynamicReport;
        string ControllerName = "DynamicReport";
        IUserBusiness _buss;
        ICommonBusiness _ICB;
        public DynamicReportController(IDynamicReportBusiness dynamicReportBusiness, IUserBusiness buss, ICommonBusiness ICB)
        {
            _dynamicReport = dynamicReportBusiness;
            _buss = buss;
            _ICB = ICB;
        }

        #region Transaction Report
        public ActionResult TransactionReport(string Search = "", int Pagesize = 10)
        {
            DynamicReportFilter model = new DynamicReportFilter();
            List<DynamicReportCommon> dynamicReportCommons = _dynamicReport.GetTransactionReport(model);
            List<DynamicReportModel> reportModel = dynamicReportCommons.MapObjects<DynamicReportModel>();

            foreach (var item in reportModel)
            {
                item.Action = StaticData.GetActions("TransactionReport", item.AgentId.EncryptParameter(), this, "", "", item.TxnId);
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("TxnDate", "Txn Date");
            param.Add("TxnId", "Txn Id");
            param.Add("ProductName", "Product");
            //param.Add("AgentId", "Agent Id");
            param.Add("SubscriberNo", "Subscriber No.");
            param.Add("Amount", "Amount");
            param.Add("TxnStatus", "Txn Status");
            //param.Add("UserId", "User Id");
            param.Add("Remarks", "Remarks");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(reportModel, "hidebreadcrumb", Search, Pagesize, false, "", "", "Home", "", "", "","datatable-total", true);
            ViewData["grid"] = grid;

            ViewBag.EmptyMessage = "False";
            ViewBag.GatewayList = ApplicationUtilities.SetDDLValue(LoadDropdownList("pmtGt"), "", "Select Gateway");
            ViewBag.Status = ApplicationUtilities.SetDDLValue(LoadDropdownList("status"), "", "Select Status");
            ViewBag.Product = ApplicationUtilities.SetDDLValue(LoadDropdownList("productlist"), "", "Select Product");
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult TransactionReport(DynamicReportFilter model)
        {
            ViewBag.EmptyMessage = "False";
            //ViewBag.GatewayList = ApplicationUtilities.SetDDLValue(LoadDropdownList("pmtGt"), "", "Select Gateway");
            ViewBag.Status = ApplicationUtilities.SetDDLValue(LoadDropdownList("status"), "", "Select Status");
            ViewBag.Product = ApplicationUtilities.SetDDLValue(LoadDropdownList("productlist"), "", "Select Product");
            // Start User Id from mobile number
            var list = _buss.GetSearchUserList(model.MobileNumber, "mobileno");
            if (!string.IsNullOrEmpty(model.MobileNumber))
            {
                var userinfo = list.FirstOrDefault();
                if (userinfo == null)
                {
                    ViewBag.EmptyMessage = "True";
                    return View();
                }
                model.AgentId = userinfo.AgentUserId.ToString();
            }
            //Ends


            List<DynamicReportCommon> dynamicReportCommons = _dynamicReport.GetTransactionReport(model);
            List<DynamicReportModel> reportModel = dynamicReportCommons.MapObjects<DynamicReportModel>();

            foreach (var item in reportModel)
            {
                item.Action = StaticData.GetActions("TransactionReport", item.AgentId.EncryptParameter(), this, "", "", item.TxnId);
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("TxnDate", "Txn Date");
            param.Add("TxnId", "Txn Id");
            param.Add("ProductName", "Product");
            //param.Add("AgentId", "Agent Id");
            param.Add("SubscriberNo", "Subscriber No.");
            param.Add("Amount", "Amount");
            param.Add("TxnStatus", "Txn Status");
            //param.Add("UserId", "User Id");
            param.Add("Remarks", "Remarks");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(reportModel, "hidebreadcrumb", "", 10, false, "", "", "Home", "", "", "", "datatable-total", true);
            ViewData["grid"] = grid;

            return View();
        }
        public ActionResult TransactionReportDetail(string ID = "", string TxnId = "")
        {
            DynamicReportModel dynamicReportModel = new DynamicReportModel();
            DynamicReportCommon dynamicReportCommons = new DynamicReportCommon();
            string id = ID.DecryptParameter();
            string txnId = TxnId;
            if (!String.IsNullOrEmpty(id))
            {
                dynamicReportCommons = _dynamicReport.GetTransactionReportDetail(txnId, id);
            }
            dynamicReportModel = dynamicReportCommons.MapObject<DynamicReportModel>();
            return View(dynamicReportModel);
        }
        #endregion

        #region Pending Transaction
        public ActionResult PendingTransaction()
        {
            DynamicReportFilter model = new DynamicReportFilter();
            List<DynamicReportCommon> dynamicReportCommons = _dynamicReport.GetPendingReport(model);
            List<DynamicReportModel> reportModel = dynamicReportCommons.MapObjects<DynamicReportModel>();

            foreach (var item in reportModel)
            {
                item.Action = StaticData.GetActions("PendingTransaction", item.AgentId.EncryptParameter(), this, "", "", item.TxnId);
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("TxnDate", "Txn Date");
            param.Add("TxnId", "Txn Id");
            param.Add("ProductName", "Product");
            //param.Add("AgentId", "Agent Id");
            param.Add("SubscriberNo", "Subscriber No.");
            param.Add("Amount", "Amount");
            param.Add("TxnStatus", "Txn Status");
            //param.Add("UserId", "User Id");
            param.Add("Remarks", "Remarks");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(reportModel, "hidebreadcrumb", "", 10, false, "", "", "Home", "", "", "", "datatable-total", true);
            ViewData["grid"] = grid;

            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult PendingTransaction(DynamicReportFilter model)
        {
            List<DynamicReportCommon> dynamicReportCommons = _dynamicReport.GetPendingReport(model);
            List<DynamicReportModel> reportModel = dynamicReportCommons.MapObjects<DynamicReportModel>();

            foreach (var item in reportModel)
            {
                item.Action = StaticData.GetActions("PendingTransaction", item.AgentId.EncryptParameter(), this, "", "", item.TxnId);
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("TxnDate", "Txn Date");
            param.Add("TxnId", "Txn Id");
            param.Add("ProductName", "Product");
            //param.Add("AgentId", "Agent Id");
            param.Add("SubscriberNo", "Subscriber No.");
            param.Add("Amount", "Amount");
            param.Add("TxnStatus", "Txn Status");
            //param.Add("UserId", "User Id");
            param.Add("Remarks", "Remarks");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(reportModel, "hidebreadcrumb", "", 10, false, "", "", "Home", "", "", "", "datatable-total", true);
            ViewData["grid"] = grid;

            return View();
        }
        public ActionResult PendingTransactionDetail(string ID = "", string TxnId = "")
        {
            DynamicReportModel dynamicReportModel = new DynamicReportModel();
            DynamicReportCommon dynamicReportCommons = new DynamicReportCommon();
            string id = ID.DecryptParameter();
            string txnId = TxnId;
            if (!String.IsNullOrEmpty(id))
            {
                dynamicReportCommons = _dynamicReport.GetTransactionReportDetail(txnId, id);
            }
            dynamicReportModel = dynamicReportCommons.MapObject<DynamicReportModel>();
            return View(dynamicReportModel);
        }
        #endregion

        #region Settlement Report

        public ActionResult SettlementReport()
        {
            ViewBag.EmptyMessage = "False";
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult SettlementReport(DynamicReportFilter model)
        {
            // Start User Id from mobile number
            var list = _buss.GetSearchUserList(model.MobileNumber, "mobileno");
            if (string.IsNullOrEmpty(model.MobileNumber))
            {
                list = null;
            }
            if (list != null)
            {
                var userinfo = list.FirstOrDefault();
                if (userinfo == null)
                {
                    ViewBag.EmptyMessage = "True";
                    return View();
                }
                model.UserId = userinfo.UserID.ToString();
            }
            else
            {
                ViewBag.EmptyMessage = "True";
                return View();
            }
            //Ends

            DynamicReportFilter models = new DynamicReportFilter();
            models = model.MapObject<DynamicReportFilter>();

            List<DynamicReportCommon> dynamicReportCommons = _dynamicReport.GetSettlementReport(models);
            List<DynamicReportModel> reportModel = dynamicReportCommons.MapObjects<DynamicReportModel>();

            foreach (var item in reportModel)
            {
                item.Action = StaticData.GetActions("PendingTransaction", item.AgentId.EncryptParameter(), this, "", "", item.TxnId);
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("TxnDate", "Txn Date");
            param.Add("TxnType", "Txn Type");
            param.Add("Remarks", "Remarks");
            param.Add("Debit", "Debit");
            param.Add("Credit", "Credit");
            param.Add("Amount", "Amount");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(reportModel, "hidebreadcrumb", "", 10, false, "", "", "", "", "", "", "datatable-total", true);
            ViewData["grid"] = grid;

            return View();
        }

        #endregion

        #region Manual Commission Report
        public ActionResult ManualCommissionReport()
        {
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManualCommissionReport(ManualCommissionReportCommon model)
        {
            // Start User Id from mobile number
            var list = _buss.GetSearchUserList(model.MobileNumber, "mobileno");
            if (string.IsNullOrEmpty(model.MobileNumber) )
            {
                list = null;
            }
            if (list != null)
            {
                var userinfo = list.FirstOrDefault();
                if (userinfo == null)
                {
                    ViewBag.EmptyMessage = "True";
                    return View();
                }
                model.UserId = userinfo.UserID.ToString();
            }
            else
            {
                ViewBag.EmptyMessage = "True";
                return View();
            }
            //Ends
            DynamicReportFilter models =new DynamicReportFilter();
            models = model.MapObject<DynamicReportFilter>();

            List<DynamicReportCommon> dynamicReportCommons = _dynamicReport.GetManualCommissionReport(models);
            List<DynamicReportModel> reportModel = dynamicReportCommons.MapObjects<DynamicReportModel>();
            Decimal Total_Commission = 0;
            foreach (var item in reportModel)
            {
                Total_Commission = Total_Commission + Convert.ToDecimal(item.CommissionEarned);
            }

            ViewBag.totalcommission = (float)Total_Commission;

            IDictionary<string, string> param = new Dictionary<string, string>();

            param.Add("SubscriberNo", "Mobile Number");
            param.Add("ProductName", "Product Name");
            param.Add("TxnType", "Txn Type");
            param.Add("Amount", "Amount");
            param.Add("CommissionEarned", "Commission Earned");
            param.Add("Remarks", "Remarks");
            param.Add("TxnDate", "Txn Date");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(reportModel, "hidebreadcrumb", "", 10, false, "", "", "", "", "", "", "datatable-total", true);
            ViewData["grid"] = grid;

            return View();
        }
        #endregion

        #region Payment Getway Transaction Report
        public ActionResult PaymentGatewayTransactionReport()
        {
            ViewBag.GatewayList = ApplicationUtilities.SetDDLValue(LoadDropdownList("pmtGt"), "", "Select Gateway");
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult PaymentGatewayTransactionReport(DynamicReportFilter model)
        {
            List<PaymentGatewayTransactionReport> paymentGatewayTransactionList = _dynamicReport.PaymentGatewayTransactionList(model);
            //List<DynamicReportModel> reportModel = dynamicReportCommons.MapObjects<DynamicReportModel>();
            foreach (var item in paymentGatewayTransactionList)
            {
                item.Action = StaticData.GetActions("paymentGatewayTransaction", item.GatewayTxnId.EncryptParameter(), this);
            }

            IDictionary<string, string> param = new Dictionary<string, string>();

            param.Add("TxnId", "Txn Id");
            //param.Add("ServiceCharge", "Service Charge");
            param.Add("GatewayName", "Gateway Name");
            param.Add("GatewayTxnId", "Gateway Txn Id");
            param.Add("AgentName", "Agent Name");
            param.Add("Status", "Status");
            param.Add("Amount", "Amount");
            param.Add("TotalAmount", "Total Amount");
            //param.Add("AgentId", "Agent Id");
            //param.Add("UserId", "User Id");
            //param.Add("TxnType", "Txn Type");
            param.Add("CreatedDate", "Created Date");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(paymentGatewayTransactionList, "hidebreadcrumb", "", 10, false, "", "", "", "", "", "", "datatable-total", true);
            ViewData["grid"] = grid;
            ViewBag.GatewayList = ApplicationUtilities.SetDDLValue(LoadDropdownList("pmtGt"), model.GatewayId, "Select Gateway");
            return View(model);
        }

        public ActionResult PaymentGatewayTransactionDetail(string txnid)
        {
            string TxnId = txnid.DecryptParameter();
            PaymentGatewayTransactionReport model = _dynamicReport.PaymentGatewayTransactionDetail(TxnId);
            return View(model);
        }

        #endregion

        #region Merchant Transaction Report
        public ActionResult MerchantTransactionReport()
        {
            var merchantList = _dynamicReport.MerchantDropdown();
            ViewBag.MerchantList = ApplicationUtilities.SetDDLValue(merchantList as Dictionary<string, string>, "", "All Merchant");
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult MerchantTransactionReport(DynamicReportFilter model)
        {
            var merchantList = _dynamicReport.MerchantDropdown();
            ViewBag.MerchantList = ApplicationUtilities.SetDDLValue(merchantList as Dictionary<string, string>, model.MerchantId, "All Merchant");

            List<MerchantTransactionCommon> reportModel = _dynamicReport.MerchantTransactionReport(model);

            IDictionary<string, string> param = new Dictionary<string, string>();

            //param.Add("TxnId", "Txn Id");
            //param.Add("MerchantId", "Merchant Id");
            param.Add("MerchantName", "Merchant Name");
            param.Add("MerchantCode", "Merchant Code");
            param.Add("UserId", "Mobile Number");
            param.Add("Amount", "Amount");
            param.Add("CommissionAmt", "Commission Amount");
            param.Add("CreatedDate", "Created Date");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(reportModel, "hidebreadcrumb", "", 10, false, "", "", "", "", "", "", "datatable-total", true);
            ViewData["grid"] = grid;

            return View();
        }
        #endregion

        public Dictionary<string, string> LoadDropdownList(string flag, string search1 = "")
        {
            Dictionary<string,string> status= new Dictionary<string, string>();
            status.Add("pending", "Pending");
            status.Add("success", "Success");
            status.Add("failed", "Failed");
            switch (flag)
            {
                case "pmtGt":
                    return _ICB.sproc_get_dropdown_list("041"); //pmt gateway dropdown
                //case "districtList":
                //    return _ICB.sproc_get_dropdown_list("007", search1);
                case "status":
                    return status;
                case "productlist":
                    return _ICB.sproc_get_dropdown_list("servicelist");
            }
            return null;
        }
    }
}
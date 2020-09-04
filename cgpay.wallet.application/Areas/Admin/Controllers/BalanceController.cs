using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.WebPages;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Balance;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Balance;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class BalanceController : Controller
    {
        private IBalanceBusiness _balance;
        string ControllerName = "Balance";
        public BalanceController(IBalanceBusiness balanceBusiness)
        {
            _balance = balanceBusiness;
        }

        #region Distributor

        [HttpGet]
        public ActionResult DistributorRT()
        {
            BalanceModel balanceModel = new BalanceModel();

            Dictionary<string, string> distributorName = new Dictionary<string, string>();
            distributorName = _balance.GetDistributorName();
            Dictionary<string, string> bankList = _balance.GetBankList();
            balanceModel.NameList = ApplicationUtilities.SetDDLValue(distributorName, "", "--Distributor--");
            balanceModel.BankAccountList = ApplicationUtilities.SetDDLValue(bankList, "", "--Bank--");

            return View(balanceModel);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult DistributorRT(BalanceModel balanceModel)
        {
            Dictionary<string, string> distributorName = _balance.GetDistributorName();
            Dictionary<string, string> bankList = _balance.GetBankList();
            balanceModel.NameList = ApplicationUtilities.SetDDLValue(distributorName, "", "--Distributor--");
            balanceModel.BankAccountList = ApplicationUtilities.SetDDLValue(bankList, "", "--Bank--");

            if (Convert.ToDecimal(balanceModel.Amount) > 500000 && balanceModel.Type == "T")
            {
                ModelState.AddModelError("Amount", "Amount Cannot Be Greater then 500000 (5 Lakhs)");
                return View(balanceModel);
            }

            if (balanceModel.Type == "R")
            {
                ModelState.Remove(("BankId"));
                if (Convert.ToDecimal(balanceModel.Amount) > 100000 && balanceModel.Type == "R")
                {
                    ModelState.AddModelError("Amount", "Amount Cannot Be Greater then 100000 (1 Lakh)");
                    return View(balanceModel);
                }
            }

            if (ModelState.IsValid)
            {
                balanceModel.CreatedBy = Session["UserName"].ToString();
                balanceModel.AgentId = distributorName.FirstOrDefault(x => x.Key == balanceModel.Name).Key.ToString();
                balanceModel.Name = distributorName.FirstOrDefault(x => x.Key == balanceModel.Name).Value.ToString();
                if (balanceModel.Type == "T")
                {
                    balanceModel.BankName = bankList.FirstOrDefault(x => x.Key == balanceModel.BankId).Value.ToString();
                }
                balanceModel.CreatedIp = ApplicationUtilities.GetIP();

                BalanceCommon balanceCommon = balanceModel.MapObject<BalanceCommon>();
                CommonDbResponse dbResponse = _balance.DistributorTR(balanceCommon);
                if (dbResponse.Code == 0)
                {
                    dbResponse.SetMessageInTempData(this, "DistributorRT");
                    return RedirectToAction("DistributorRT", ControllerName);
                }
            }
            else
            {
                return View(balanceModel);
            }

            return RedirectToAction("DistributorRT", ControllerName);
        }

        [HttpGet]
        public ActionResult Report(string Search = "", int Pagesize = 10)
        {
            List<BalanceCommon> balanceCommons = _balance.GetDistributorReport();
            List<BalanceModel> balanceModels = balanceCommons.MapObjects<BalanceModel>();

            foreach (var item in balanceModels)
            {
                item.Action = StaticData.GetActions("ReportList", item.AgentId.EncryptParameter(), this, "", "", item.BalanceId);
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("CreatedDate", "Date");
            param.Add("Name", "Name");
            param.Add("Amount", "Added/Retrieved balance");
            param.Add("CreatedBy", "Created By");
            param.Add("TxnMode", "Mode");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(balanceModels, ControllerName, Search, Pagesize, false, "", "", "Home", "", "", "");
            ViewData["grid"] = grid;

            return View();
            //return View(balanceModels);
        }
        public ActionResult ReportDetail(string Id = "", string ExtraId1 = "")
        {
            BalanceModel balanceModel = new BalanceModel();
            List<BalanceCommon> balanceCommons = new List<BalanceCommon>();
            BalanceCommon balanceCommon = new BalanceCommon();
            string ID = Id.DecryptParameter();
            string BalanceId = ExtraId1;

            if (!String.IsNullOrEmpty(ID))
            {
                balanceCommons = _balance.GetDistributorReport(ID, BalanceId);
            }

            balanceCommon = balanceCommons.FirstOrDefault();
            //balanceCommon = balanceCommons.FirstOrDefault(x => x.AgentId == ID);
            balanceModel = balanceCommon.MapObject<BalanceModel>();
            balanceModel.Type = balanceModel.Type == "T" ? "Transfer" : "Retrieve";

            return View(balanceModel);
        }

        #endregion

        #region Agent 
        [HttpGet]
        public ActionResult AgentRT()
        {
            BalanceModel balanceModel = new BalanceModel();
            List<BalanceCommon> balanceCommons = _balance.GetAgentName();
            Dictionary<string, string> agentName = new Dictionary<string, string>();
            Dictionary<string, string> bankList = _balance.GetBankList();
            foreach (BalanceCommon bcommon in balanceCommons)
            {
                agentName.Add(bcommon.AgentId, bcommon.Name);
            }
            balanceModel.NameList = ApplicationUtilities.SetDDLValue(agentName, "", "--Agent--");
            balanceModel.BankAccountList = ApplicationUtilities.SetDDLValue(bankList, "", "--Bank--");

            return View(balanceModel);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AgentRT(BalanceModel balanceModel)
        {
            //BalanceModel balanceModel = new BalanceModel();
            List<BalanceCommon> balanceCommons = _balance.GetAgentName();
            Dictionary<string, string> agentName = new Dictionary<string, string>();
            Dictionary<string, string> bankList = _balance.GetBankList();
            foreach (BalanceCommon bcommon in balanceCommons)
            {
                agentName.Add(bcommon.AgentId, bcommon.Name);
            }
            balanceModel.NameList = ApplicationUtilities.SetDDLValue(agentName, "", "--Agent--");
            balanceModel.BankAccountList = ApplicationUtilities.SetDDLValue(bankList, "", "--Bank--");

            if (Convert.ToDecimal(balanceModel.Amount) > 500000 && balanceModel.Type == "T")
            {
                ModelState.AddModelError("Amount", "Amount Cannot Be Greater then 500000 (5 Lakhs)");
                return View(balanceModel);
            }

            if (balanceModel.Type == "R")
            {
                ModelState.Remove(("BankId"));
                if (Convert.ToDecimal(balanceModel.Amount) > 100000 && balanceModel.Type == "R")
                {
                    ModelState.AddModelError("Amount", "Amount Cannot Be Greater then 100000 (1 Lakh)");
                    return View(balanceModel);
                }
            }

            if (ModelState.IsValid)
            {
                balanceModel.CreatedBy = Session["UserName"].ToString();
                balanceModel.AgentId = agentName.FirstOrDefault(x => x.Key == balanceModel.Name).Key.ToString();
                balanceModel.Name = agentName.FirstOrDefault(x => x.Key == balanceModel.Name).Value.ToString();
                if (balanceModel.Type == "T")
                {
                    balanceModel.BankName = bankList.FirstOrDefault(x => x.Key == balanceModel.BankId).Value.ToString();
                }
                balanceModel.CreatedIp = ApplicationUtilities.GetIP();

                BalanceCommon balanceCommon = balanceModel.MapObject<BalanceCommon>();
                CommonDbResponse dbResponse = _balance.AgentTR(balanceCommon);
                if (dbResponse.Code == 0)
                {
                    dbResponse.SetMessageInTempData(this);
                    return RedirectToAction("AgentRT", ControllerName);
                }
            }
            else
            {
                return View(balanceModel);
            }

            return RedirectToAction("AgentRT", ControllerName);
        }

        [HttpGet]
        public ActionResult AgentReport(string Search = "", int Pagesize = 10)
        {
            List<BalanceCommon> balanceCommons = _balance.GetAgentReport();
            List<BalanceModel> balanceModels = balanceCommons.MapObjects<BalanceModel>();

            foreach (var item in balanceModels)
            {
                item.Action = StaticData.GetActions("AgentReportList", item.AgentId.EncryptParameter(), this, "", "", item.BalanceId.EncryptParameter());
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("Name", "Agent Name");
            param.Add("Amount", "Added/Retrieved balance");
            param.Add("CreatedBy", "Created By");
            param.Add("TxnMode", "Mode");
            param.Add("Type", "Transaction Type");
            param.Add("CreatedDate", "Date");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(balanceModels, "", Search, Pagesize, false, "", "", "Home", "Agent Balance Transfer Report", "", "");
            ViewData["grid"] = grid;

            return View();
            //return View(balanceModels);
        }
        public ActionResult AgentReportDetail(string Id = "", string ExtraId1 = "")
        {
            BalanceModel balanceModel = new BalanceModel();
            List<BalanceCommon> balanceCommons = new List<BalanceCommon>();
            BalanceCommon balanceCommon = new BalanceCommon();
            string ID = Id.DecryptParameter();
            string BalanceId = ExtraId1.DecryptParameter();

            if (!String.IsNullOrEmpty(ID))
            {
                balanceCommons = _balance.GetAgentReport(ID, BalanceId);
            }

            balanceCommon = balanceCommons.FirstOrDefault();
            //balanceCommon = balanceCommons.FirstOrDefault(x => x.AgentId == ID);
            balanceModel = balanceCommon.MapObject<BalanceModel>();
            //balanceModel.Type = balanceModel.Type.ToUpper() == "DIG" ? "Transfer" : "Retrieve";
            return View(balanceModel);
        }

        [HttpPost,OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> Getparent(string AgentId)
        {
            List<BalanceCommon> balanceCommons = _balance.GetAgentName(AgentId);
            Dictionary<string, string> parentDetail = new Dictionary<string, string>();
            string parentId = string.IsNullOrEmpty(balanceCommons.FirstOrDefault().ParentId) ? "" : balanceCommons.FirstOrDefault().ParentId;
            string parentName = string.IsNullOrEmpty(balanceCommons.FirstOrDefault().ParentName) ? "" : balanceCommons.FirstOrDefault().ParentName;
            parentDetail.Add(parentId, parentName);
            return Json(new Dictionary<string, string>(parentDetail), JsonRequestBehavior.AllowGet);
        }
        #endregion




    }
}
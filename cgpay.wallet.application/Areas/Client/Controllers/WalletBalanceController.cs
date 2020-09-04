using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.KYC;
using cgpay.wallet.business.User;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class WalletBalanceController : Controller
    {
        IWalletUserBusiness _walletUser;
        string ControllerName = "WalletBalance";
        public WalletBalanceController(IWalletUserBusiness walletUser)
        {
            _walletUser = walletUser;
        }
        // GET: Client/WalletBalance
        public ActionResult balanceTransfer()
        {
            WalletBalanceModel walletBalance = new WalletBalanceModel();
            Dictionary<string, string> PurposeList = _walletUser.GetProposeList();
            walletBalance.PurposeList = ApplicationUtilities.SetDDLValue(PurposeList, "", "--Purpose--");
            return View(walletBalance);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult balanceTransfer(WalletBalanceModel walletBalance)
        {
            Dictionary<string, string> PurposeList = _walletUser.GetProposeList();
            walletBalance.PurposeList = ApplicationUtilities.SetDDLValue(PurposeList, "", "--Purpose--");

            if ((Convert.ToDecimal(walletBalance.Amount) > 1000 || Convert.ToDecimal(walletBalance.Amount) < 10) && walletBalance.Type == "T")
            {
                ModelState.AddModelError("Amount", "Amount should be between 10-1000");
                return View(walletBalance);
            }

            if (walletBalance.Type == "R")
            {
                ModelState.Remove(("Purpose"));
                if ((Convert.ToDecimal(walletBalance.Amount) > 1000 || Convert.ToDecimal(walletBalance.Amount) < 10))
                {
                    ModelState.AddModelError("Amount", "Amount should be between 10-1000");
                    return View(walletBalance);
                }
            }
            string usertype = Session["UserType"].ToString();
            string agentid = Session["AgentId"].ToString();
            CommonDbResponse response = _walletUser.CheckMobileNumber(agentid,walletBalance.ReceiverAgentId, usertype, "tb");
            if (response.Code != 0)
            {
                ModelState.AddModelError("ReceiverAgentId", "Invalid User Detail");
                return View(walletBalance);
            }
            else
            {
                ModelState.Remove("ReceiverAgentId");
            }
            if (ModelState.IsValid)
            {
                //walletBalance.AgentId = Session["AgentId"].ToString();
                walletBalance.ActionUser = Session["UserName"].ToString();
                walletBalance.IpAddress = ApplicationUtilities.GetIP();
                WalletBalanceCommon walletBalanceCommon = walletBalance.MapObject<WalletBalanceCommon>();
                CommonDbResponse dbResponse = _walletUser.WalletBalanceRT(walletBalanceCommon);
                if (dbResponse.Code == 0)
                {
                    dbResponse.SetMessageInTempData(this, "balanceTransfer");
                    return RedirectToAction("balanceTransfer", ControllerName);
                }
                dbResponse.SetMessageInTempData(this, "balanceTransfer");
                return RedirectToAction("balanceTransfer");
            }
            else
            {
                return View(walletBalance);
            }

            return RedirectToAction("balanceTransfer");

        }
        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> CheckMobileNumber(string MobileNo)
        {
            string usertype = Session["UserType"].ToString();
            string agentid = Session["AgentId"].ToString();
            CommonDbResponse response = _walletUser.CheckMobileNumber(agentid,MobileNo, usertype, "tb");
            int Code = (int)response.Code;
            return Json(new { Code }, JsonRequestBehavior.AllowGet);

        }
    }
}
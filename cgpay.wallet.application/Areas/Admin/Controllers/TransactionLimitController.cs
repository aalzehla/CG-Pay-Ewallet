using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.TransactionLimit;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.TransactionLimit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class TransactionLimitController : Controller
    {
        ICommonBusiness ICB;
        ITransactionLimitBusiness tbuss;
        public TransactionLimitController(ITransactionLimitBusiness _tbuss, ICommonBusiness _ICB)
        {
            ICB = _ICB;
            tbuss = _tbuss;
        }
        // GET: Admin/TransactionLimit
        public ActionResult Index(string Search = "", int Pagesize = 10)
        {
            var list = tbuss.GetTransactionLimitList();
            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("TransactionLimit", item.transacation_id.ToString().EncryptParameter(), this, "", "", item.transacation_id);
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            // param.Add("transacation_id", "Transaction Id");
            param.Add("transacation_type", "Transaction Type");
            param.Add("transaction_limit_maximum", "Transaction Maximum Limit");
            param.Add("daily_maximum_limit", "Daily Maximum Limit");
            param.Add("monthly_maximum_limit", "Monthly Maximum Limit");
            param.Add("kyc_status", "Status");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "hidebreadcrumb", Search, Pagesize, true, "", "", "Home", "TransactionLimit", "#", "#");
            ViewData["grid"] = grid;
            return View();
        }

        public ActionResult ManageTransaction(string transactionId = "")
        {

            TransactionLimitModel TLM = new TransactionLimitModel();
            string tId = transactionId.DecryptParameter();
            if (!string.IsNullOrEmpty(tId))
            {
                var tl = tbuss.GetTransactionLimitById(tId);
                if (tl != null)
                {
                    TLM.transacation_id = tl.transacation_id.EncryptParameter();
                    TLM.transacation_type = tl.transacation_type;
                    TLM.kyc_status = tl.kyc_status;
                    TLM.transaction_limit_maximum = tl.transaction_limit_maximum;
                    TLM.daily_maximum_limit = tl.daily_maximum_limit;
                    TLM.monthly_maximum_limit = tl.monthly_maximum_limit;

                }
            }
            return View(TLM);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageTransaction(TransactionLimitModel TLC)
        {
            if (TLC.transacation_type == "Cash In" && TLC.kyc_status == "not verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 5000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 5000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 20000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 20000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }
            if (TLC.transacation_type == "Cash In" && TLC.kyc_status == "verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 25000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 25000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 25000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 25000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 100000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 100000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }

            if (TLC.transacation_type == "Card Fund Load" && TLC.kyc_status == "not verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 5000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 5000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 30000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 30000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }
            if (TLC.transacation_type == "Card Fund Load" && TLC.kyc_status == "verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 16000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 16000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 50000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 50000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 300000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 300000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }

            if (TLC.transacation_type == "Transfer" && TLC.kyc_status == "not verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 5000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 5000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 10000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 10000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }
            if (TLC.transacation_type == "Transfer" && TLC.kyc_status == "verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 25000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 25000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 100000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 100000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 500000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 500000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }

            if (TLC.transacation_type == "Withdraw" && TLC.kyc_status == "not verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 5000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 5000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 20000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 20000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }
            if (TLC.transacation_type == "Withdraw" && TLC.kyc_status == "verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 25000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 25000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 100000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 100000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 500000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 500000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }

            if (TLC.transacation_type == "Card Fund Load(SCT)" && TLC.kyc_status == "not verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 5000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 5000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 30000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 30000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }
            if (TLC.transacation_type == "Card Fund Load(SCT)" && TLC.kyc_status == "verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 500000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 500000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 100000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 100000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 500000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 500000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }

            if (TLC.transacation_type == "Wallet Payment" && TLC.kyc_status == "not verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 5000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 5000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 20000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 20000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }
            if (TLC.transacation_type == "Wallet Payment" && TLC.kyc_status == "verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 1000000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 1000000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 1000000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 1000000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 5000000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 5000000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }

            if (TLC.transacation_type == "Load" && TLC.kyc_status == "not verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 5000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 5000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 5000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 30000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 30000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }
            if (TLC.transacation_type == "Load" && TLC.kyc_status == "verified")
            {
                int flag = 0;
                if (/*Convert.ToDouble( TLC.transaction_limit_maximum) <= 0 && */Convert.ToDouble(TLC.transaction_limit_maximum) > 100000)
                {
                    ModelState.AddModelError("transaction_limit_maximum", "Transaction limit should be less than 100000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.daily_maximum_limit) > 1000000)
                {
                    ModelState.AddModelError("daily_maximum_limit", "Daily Transaction limit should be less than 1000000");
                    flag = 1;
                }
                if (Convert.ToDouble(TLC.monthly_maximum_limit) > 1000000)
                {
                    ModelState.AddModelError("monthly_maximum_limit", "Monthly Transaction limit should be less than 1000000");
                    flag = 1;
                }
                if (flag == 1)
                {
                    return View(TLC);
                }
            }

            if (ModelState.IsValid)
            {
                TransactionLimitCommon tl = new TransactionLimitCommon();
                tl.transacation_id = TLC.transacation_id.DecryptParameter();
                tl.transaction_limit_maximum = TLC.transaction_limit_maximum;
                tl.daily_maximum_limit = TLC.daily_maximum_limit;
                tl.monthly_maximum_limit = TLC.monthly_maximum_limit;

                tl.ActionUser = Session["username"].ToString();
                CommonDbResponse dbresp = tbuss.ManageTransactionlimit(tl);

                if (dbresp.Code == 0)
                {
                    this.ShowPopup((int)dbresp.Code, dbresp.Message);
                    return RedirectToAction("Index");
                }
            }
            this.ShowPopup(1, "Error");
            return View();
        }

    }
}
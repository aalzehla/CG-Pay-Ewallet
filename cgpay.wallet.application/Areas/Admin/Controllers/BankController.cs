using cgpay.wallet.application.Library;
using cgpay.wallet.business.Bank;
using cgpay.wallet.business.Common;
using cgpay.wallet.shared.Models.Bank;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class BankController : Controller
    {

        IBankBusiness _bank;
        ICommonBusiness _ic;
        public BankController(IBankBusiness bank, ICommonBusiness ic)
        {
            this._bank = bank;
            this._ic = ic;
        }
        // GET: Admin/Bank
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public ActionResult Detail(string Search = "", int Pagesize = 10)
        {
            var bankList = _bank.GetBankList();
            foreach (var item in bankList)
            {
                item.Action = StaticData.GetActions("Bank", item.BankID.EncryptParameter(), this, "/Admin/Bank/Detail", "/Admin/Bank/Detail?BankID=" + item.BankID.EncryptParameter(), item.BankStatus, item.BankName.EncryptParameter());
                //item.IsActive = "<span class='badge badge-" + (item.IsActive.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.IsActive.Trim().ToUpper() == "Y" ? "Enable" : "Disable") + "</span>";
                string s = item.BankStatus.Trim().ToUpper();
                item.BankStatus = "<span class='badge badge-" + (item.BankStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.BankStatus.Trim().ToUpper() == "Y" ? "Enable" : "Disable") + "</span>";

            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("BankID", "Bank ID");
            param.Add("BankName", "Bank Name");
            param.Add("BankAccountNo", "Bank Account No");
            param.Add("BankBranch", "Bank Branch");
            param.Add("BankStatus", "Bank Status");
            param.Add("BankCreatedBy", "Created By");
            param.Add("CreatedDate", "Created Date");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(bankList, "Bank Setup", Search, Pagesize, true, "", "", "Home", "Bank", "/Admin/Bank", "/Admin/Bank/AddBank");
            ViewData["grid"] = grid;
            return View();
        }
        [HttpGet]
        public ActionResult AddBank(string bankID)
        {
            BankCommon bankDetail = new BankCommon();
            string hostname = Dns.GetHostName();
            string myIP = Dns.GetHostByName(hostname).AddressList[0].ToString();
            var bankList = _bank.GetBankList();
            if (bankID != null)
            {
                string bID = bankID.DecryptParameter();
                bankDetail = bankList.FirstOrDefault(id => id.BankID == bID);
            }
            return View(bankDetail);
        }

        [HttpPost]
        [Obsolete]
        public ActionResult AddBank(BankCommon bc)
        {
            if (ModelState.IsValid)
            {
                if (bc.BankID == null)
                {
                    string username= Session["Username"].ToString();
                    bc.ActionUser = username;
                    string hostname = Dns.GetHostName();
                    bc.IpAddress = Dns.GetHostByName(hostname).AddressList[0].ToString();
                    _bank.AddBank(bc);
                }
                else
                {
                    string bid = bc.BankID;
                    bc.BankID = bid.DecryptParameter();
                    string username = Session["Username"].ToString();
                    bc.ActionUser = username;
                    string hostname = Dns.GetHostName();
                    bc.IpAddress = Dns.GetHostByName(hostname).AddressList[0].ToString();
                    
                    _bank.UpdateBank(bc);
                }
               
            }
            return RedirectToAction("Detail");
        }


      
        public ActionResult EnableBank(string bankId)
        {
            if (bankId != null)
            {
                var bankList = _bank.GetBankList();
                var bank = bankList.FirstOrDefault(bid => bid.BankID == bankId.DecryptParameter());
                bank.BankStatus = "Y";
                _bank.UpdateBank(bank);
            }
            return RedirectToAction("Detail");
        }

        public ActionResult DisableBank(string bankId)
        {
            if (bankId != null)
            {
                var bankList = _bank.GetBankList();
                var bank = bankList.FirstOrDefault(bid => bid.BankID == bankId.DecryptParameter());
                bank.BankStatus = "N";
                _bank.UpdateBank(bank);
            }
            return RedirectToAction("Detail");
        }
    }
}
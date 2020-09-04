using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Client;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;
using Newtonsoft.Json;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class CustomerManagementController : Controller
    {
        string ControllerName = "CustomerManagement";
        IClientManagementBusiness _CustomerManagement;
        public CustomerManagementController(IClientManagementBusiness CustomerManagement)
        {
            _CustomerManagement = CustomerManagement;
        }
        // GET: Admin/CustomerManagement
        public ActionResult Index(string ParentId = "", string Search = "", int Pagesize = 20)
        {
            if (!string.IsNullOrEmpty(ParentId))
            {
                ParentId = ParentId.DecryptParameter();
            }
            else
            {
                ParentId = ApplicationUtilities.GetSessionValue("AgentId").ToString();
            }
            List<WalletUserInfoModel> lst = _CustomerManagement.WalletUserList("WalletUser", ParentId: ParentId).MapObjects<WalletUserInfoModel>();
            foreach (var item in lst)
            {
                item.Action = StaticData.GetActions(ControllerName, item.AgentId.ToString().EncryptParameter(), this, "", "", item.AgentStatus, item.UserId.EncryptParameter());
                item.AgentStatus = "<span class='badge badge-" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
                #region kycStatus
                if (item.KycStatus.ToUpper().Equals("PENDING"))
                    item.KycStatus = "<span class='badge badge-warning'>Pending</span>";
                else if (item.KycStatus.ToUpper().Equals("APPROVED"))
                    item.KycStatus = "<span class='badge badge-success'>Approved</span>";
                else if (item.KycStatus.ToUpper().Equals("REJECTED"))
                    item.KycStatus = "<span class='badge badge-danger'>Rejected</span>";
                else
                    item.KycStatus = "<span class='badge badge-info'>Not Filled</span>";
                #endregion
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("MobileNo", "Mobile No");
            param.Add("Email", "Email");
            param.Add("FullName", "Name");
            //param.Add("AgentId", "Agent Id");
            //param.Add("ParentId", "Parent Id");
            param.Add("Balance", "Balance");
            param.Add("KycStatus", "Kyc Status");
            param.Add("AgentStatus", "Status");
            param.Add("CreatedLocalDate", "Registered Date");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(lst, "", Search, Pagesize, true, "", "", "Home", "Customer", "/Admin/CustomerManagement", "/Admin/CustomerManagement/AddCustomer?parentid=" + ParentId.EncryptParameter());
            ViewData["grid"] = grid;
            return View();
        }

        [HttpGet]
        public ActionResult AddCustomer(string parentid = "")
        {
            WalletUserInfoModel wum = new WalletUserInfoModel();
            wum.ParentId = parentid;
            return View(wum);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AddCustomer(WalletUserInfoModel walletUserModel)
        {
            ModelState.Remove("BalanceToAdd");
            ModelState.Remove("Remarks");
            if (string.IsNullOrEmpty(walletUserModel.FullName))
            {
                ModelState.AddModelError("FullName", "Full Name is Required");
            }
            if (string.IsNullOrEmpty(walletUserModel.Email))
            {
                ModelState.AddModelError("Email", "Email is Required");
            }
            if (string.IsNullOrEmpty(walletUserModel.MobileNo))
            {
                ModelState.AddModelError("MobileNo", "Mobile Number is Required");
            }
            if (ModelState.IsValid)
            {
                WalletUserInfo walletUser = new WalletUserInfo();
                walletUser.ParentId = walletUserModel.ParentId.DecryptParameter();
                walletUser.MobileNo = walletUserModel.MobileNo;
                walletUser.Email = walletUserModel.Email;
                walletUser.FullName = walletUserModel.FullName;
                walletUser.ActionUser = Session["UserName"].ToString();
                walletUser.ActionIP = ApplicationUtilities.GetIP();
                HttpContext httpCtx = System.Web.HttpContext.Current;
                walletUser.ActionBrowser = httpCtx.Request.Headers["User-Agent"];
                CommonDbResponse dbresp = _CustomerManagement.AddUser(walletUser);
                if (dbresp.ErrorCode == 0)
                {
                    dbresp.SetMessageInTempData(this);

                    //this.ShowPopup(0, "Succesfully Added amount: " + walletUser.BalanceToAdd);
                    return RedirectToAction("Index", new { ParentId = walletUserModel.ParentId });
                }
                dbresp.SetMessageInTempData(this);
            }

            return View(walletUserModel);

        }
        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult UserStatusChange(string agentid, string userid, string status)
        {
            var data = new CommonDbResponse();
            bool valid = true;
            string userId = userid.DecryptParameter();
            string agentId = agentid.DecryptParameter();
            if (String.IsNullOrEmpty(userId) || String.IsNullOrEmpty(agentId))
            {
                data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid User." };
                valid = false;
            }

            if (valid)
            {
                WalletUserInfo walletUser = new WalletUserInfo();
                walletUser.UserId = userId;
                if (status.ToLower() == "y")
                {
                    walletUser.AgentStatus = "n";
                }
                if (status.ToLower() == "n")
                {
                    walletUser.AgentStatus = "y";
                }
                walletUser.AgentId = agentId;
                data = _CustomerManagement.UserStatusChange(walletUser.UserId, walletUser.AgentId, walletUser.AgentStatus);
                //if (data.ErrorCode == 0)
                //{
                //    data.Message = "Successfully Changed User";
                //}
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }

        [HttpGet]

        public JsonResult AddBalance(string agentid)
        {
            string agentId = agentid.DecryptParameter();
            if (!string.IsNullOrEmpty(agentId))
            {
                List<WalletUserInfoModel> lst = _CustomerManagement.WalletUserList("WalletUser").MapObjects<WalletUserInfoModel>();
                WalletUserInfoModel walletUser = lst.FirstOrDefault(x => x.AgentId == agentId);
                Session["AddAgentId"] = walletUser.AgentId;
                Session["AddFullName"] = walletUser.FullName;
                string value = string.Empty;
                value = JsonConvert.SerializeObject(walletUser, Formatting.Indented, new JsonSerializerSettings
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                });
                return Json(value, JsonRequestBehavior.AllowGet);
            }
            this.ShowPopup(1, "Error");
            return null;
        }

        [HttpPost, ValidateAntiForgeryToken]
        public void AddBalance(WalletUserInfoModel walletUserModel)
        {
            ModelState.Remove("FullName");
            ModelState.Remove("Email");
            ModelState.Remove("MobileNo");
            if (ModelState.IsValid)
            {
                WalletUserInfo walletUser = new WalletUserInfo();
                walletUser.AgentId = Session["AddAgentId"].ToString();
                //walletUser.FullName = Session["AddFullName"].ToString();
                Session.Remove("AddAgentId");
                walletUser.BalanceToAdd = walletUserModel.BalanceToAdd;
                walletUser.Remarks = walletUserModel.Remarks;
                walletUser.ActionUser = Session["UserName"].ToString();
                walletUser.ActionIP = ApplicationUtilities.GetIP();
                //HttpContext httpCtx = HttpContext.Current;
                //walletUser.ActionBrowser = httpCtx.Request.Headers["User-Agent"];
                CommonDbResponse dbresp = _CustomerManagement.InsertBalance(walletUser);
                if (dbresp.ErrorCode == 0)
                {
                    this.ShowPopup(0, "Succesfully Added amount: " + walletUser.BalanceToAdd);
                    return;
                }
                dbresp.SetMessageInTempData(this, "Index");
            }
            else
                this.ShowPopup(1, "Amount Not Added");
        }

        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult ResetPassword(string userid, string agentid)
        {
            var data = new CommonDbResponse();
            bool valid = true;
            string userId = userid.DecryptParameter();
            string AgentId = agentid.DecryptParameter();
            if (String.IsNullOrEmpty(userId))
            {
                data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Failed to Reset Password" };
                valid = false;
            }
            WalletUserInfo walletUser=new WalletUserInfo();
            walletUser.AgentId = AgentId;
            walletUser.UserId = userId;
            if (valid)
            {
                data = _CustomerManagement.ResetPassword(walletUser);
                //if (data.ErrorCode == 0)
                //{
                //    data.Message = "Successfully Changed User";
                //}
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }
    }
}
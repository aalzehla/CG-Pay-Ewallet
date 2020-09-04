using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.Merchant;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Merchant;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class MerchantController : Controller
    {

        private IMerchantBusiness _merchant;
        private string ControllerName = "MerchantManagement";
        ICommonBusiness _ICB;
        public MerchantController(IMerchantBusiness merchant, ICommonBusiness ICB)
        {
            _merchant = merchant;
            _ICB = ICB;
        }

        // GET: Client/Merchant
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ViewMerchantUser()
        {
            string merchantid = Session["UserId"].ToString();
            var UserType = Session["UserType"].ToString();
            string username = ApplicationUtilities.GetSessionValue("username").ToString();
            string id = Session["AgentId"].ToString(), IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString().Trim();

            if (string.IsNullOrEmpty(id))
            {
                return RedirectToAction("Index");
            }
           
            var merchantuser = _merchant.GetUserList(id, username);
            //Actions
            foreach (var item in merchantuser)
            {
                item.Action = StaticData.GetActions("Merchantusers", item.UserId.EncryptParameter(), this, "", "", item.MerchantId.EncryptParameter(), item.UserStatus, item.IsPrimary, DisableAddEdit: Session["UserId"].ToString() == item.UserId);
                item.UserStatus = "<span class='badge badge-" + (item.UserStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.UserStatus.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("DistributorId", "Agent Id");
            param.Add("FullName", "Fullname");
            param.Add("UserName", "Username");
            param.Add("UserEmail", "Email");
            param.Add("UserMobileNumber", "Mobile No");
            // param.Add("UserType", "User Type");
            param.Add("IsPrimary", "Is primary");
            param.Add("UserStatus", "Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            //Add New
            var grid = ProjectGrid.MakeGrid(merchantuser, "Merchant Users", "", 0, true, "", "", "Home", "Merchant", "/Client/Merchant/ManagemerchantUsers", "/Client/Merchant/ManagemerchantUsers?merchantid=" + id.EncryptParameter());
            ViewData["grid"] = grid;
            return View();
        }

        // GET: Admin/Distributor/User/Id
        public ActionResult ManagemerchantUsers(string merchantid, string UserId = "")
        {
            var UserType = Session["UserType"].ToString();
            string merchant_id = "";
            merchant_id = merchantid.DecryptParameter();
            MerchantUserCommon DMC = new MerchantUserCommon();
            var user_id = UserId.DecryptParameter();
            if (string.IsNullOrEmpty(merchant_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewMerchantUser", new { merchantid = merchantid.EncryptParameter() });
                }
                string username = ApplicationUtilities.GetSessionValue("username").ToString();
                DMC = _merchant.GetUserById(merchant_id, user_id, username);
                DMC.UserId = user_id.EncryptParameter();
            }
            DMC.MerchantId = merchant_id.EncryptParameter();
            MerchantUserModel DMM = DMC.MapObject<MerchantUserModel>();
            //LoadDropDownList(DMM);
            return View(DMM);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManagemerchantUsers(MerchantUserModel DMM)
        {


            MerchantUserCommon DMC = new MerchantUserCommon();
            DMC = DMM.MapObject<MerchantUserCommon>();
            if (!string.IsNullOrEmpty(DMC.UserId))
            {
                ModelState.Remove("Password");
                ModelState.Remove("ConfirmPassword");
                ModelState.Remove("username");
            }
            if (ModelState.IsValid)
            {
                if (!string.IsNullOrEmpty(DMC.UserId))
                {

                    DMC.UserId = DMC.UserId.DecryptParameter();
                }
                if (!string.IsNullOrEmpty(DMC.MerchantId))
                {
                    DMC.MerchantId = DMC.MerchantId.DecryptParameter();
                }
                DMC.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                DMC.IpAddress = ApplicationUtilities.GetIP();
                CommonDbResponse dbresp = _merchant.ManageUser(DMC);
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    this.ShowPopup(0, "Save Succesfully");
                    return RedirectToAction("ViewMerchantUser", new { merchantid = DMC.MerchantId.EncryptParameter() });
                }
                DMC.Msg = dbresp.Message;
            }
            this.ShowPopup(1, "Save unsuccessful!" + DMC.Msg);
            return View(DMM);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult BlockUser(string userid, string merchantid)
        {
            var data = new CommonDbResponse();
            bool valid = true;
            if (!String.IsNullOrEmpty(userid))
            {
                userid = userid.DecryptParameter();
                if (string.IsNullOrEmpty(userid))
                {
                    data = new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." };
                    valid = false;
                }
            }

            if (!String.IsNullOrEmpty(merchantid))
            {
                merchantid = merchantid.DecryptParameter();
                if (string.IsNullOrEmpty(merchantid))
                {
                    data = new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." };
                    valid = false;
                }
            }
            if (valid)
            {
                MerchantUserCommon DMC = new MerchantUserCommon()
                {
                    UserId = userid,
                    MerchantId = merchantid,
                    UserStatus = "N",
                    ActionUser = ApplicationUtilities.GetSessionValue("username").ToString(),
                    IpAddress = ApplicationUtilities.GetIP()

                };
                data = _merchant.Disable_EnableMerchantUser(DMC);
                if (data.ErrorCode == 0)
                {
                    data.Message = "Successfully Blocked User";
                }
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult UnBlockUser(string userid, string merchantid)
        {
            var data = new CommonDbResponse();
            bool valid = true;
            if (!String.IsNullOrEmpty(userid))
            {
                userid = userid.DecryptParameter();
                if (string.IsNullOrEmpty(userid))
                {
                    data = new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." };
                    valid = false;
                }
            }

            if (!String.IsNullOrEmpty(merchantid))
            {
                merchantid = merchantid.DecryptParameter();
                if (string.IsNullOrEmpty(merchantid))
                {
                    data = new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." };
                    valid = false;
                }
            }
            if (valid)
            {
                MerchantUserCommon DMC = new MerchantUserCommon()
                {
                    UserId = userid,
                    MerchantId = merchantid,
                    UserStatus = "Y",
                    ActionUser = ApplicationUtilities.GetSessionValue("username").ToString(),
                    IpAddress = ApplicationUtilities.GetIP()

                };
                data = _merchant.Disable_EnableMerchantUser(DMC);
                if (data.ErrorCode == 0)
                {
                    data.Message = "Successfully Blocked User";
                }
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }

        public ActionResult ViewTransactionReport()
        {
            string merchantid = Session["AgentId"].ToString();

            var TxnReport = _merchant.GetTransactionReport(merchantid);

            IDictionary<string, string> param = new Dictionary<string, string>();
           // param.Add("MerchantID", "Merchant ID");
           // param.Add("MerchantCode", "Merchant Code");
            param.Add("TransactionId", "Transaction No");
            param.Add("Amount", "Amount");
            param.Add("CommissionAmount", "Commission Amount");
            param.Add("UserID", "Created By");
            param.Add("CreateDate", "Created Date");
            ProjectGrid.column = param;
           
            var grid = ProjectGrid.MakeGrid(TxnReport, "Transaction Report", "", 0, false, "", "", "Home", "Merchant", "/Client/Merchant/ViewTransactionReport", "/Client/Merchant/ViewTransactionReport");
            ViewData["grid"] = grid;

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult GetDailyTransactionChart()
        {

            string UserId = Session["UserId"].ToString();

            var TxnReport = _merchant.GetDailyTransactionChart(UserId);
            var jsonResponse = JsonConvert.SerializeObject(TxnReport);
         
            return Json(jsonResponse);
        }

        public ActionResult Profile()
        {
            #region FileLocation

            string FileLocation;
            string username = Session["UserName"].ToString();
            string merchantid = Session["AgentId"].ToString();

            FileLocation = "/Content/userupload/Merchant/kyc/";
            
            #endregion
            string UserId = Session["UserId"].ToString();
            MerchantUserCommon walletUser = _merchant.GetUserById(merchantid,UserId,username);
            walletUser.MerchantId = merchantid.EncryptParameter();
            return View(walletUser);
        }
        [HttpGet, OverrideActionFilters]
        public ActionResult PrintQR(string merchantId)
        {
            MerchantModel merchantModel = new MerchantModel();

            if (!string.IsNullOrEmpty(merchantId))
            {
                merchantModel.MerchantID = merchantId.DecryptParameter();
                if (!string.IsNullOrEmpty(merchantModel.MerchantID))
                {
                    merchantModel = _merchant.GetMerchantById(merchantModel.MerchantID).MapObject<MerchantModel>();
                    merchantModel.MerchantID = merchantModel.MerchantID.EncryptParameter();
                    merchantModel.UserID = merchantModel.UserID.EncryptParameter();
                    return View(merchantModel);

                }
            }
            this.ShowPopup(1, "Error");
            return RedirectToAction("Index");
        }
    }


}
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.KYC;
using cgpay.wallet.business.User;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.KYC;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class ClientUserController : Controller
    {

        IUserBusiness _userBusiness;
        IWalletUserBusiness _walletUserBusiness;
        IKycBusiness _kyc;
        IClientManagementBusiness _CLientManagement;
        string ControllerName = "ClientUser";
        public ClientUserController(IUserBusiness user, IWalletUserBusiness walletUser, IKycBusiness kyc, IClientManagementBusiness clientManagement)
        {
            _userBusiness = user;
            _walletUserBusiness = walletUser;
            _kyc = kyc;
            _CLientManagement = clientManagement;
        }

        #region User Info
        public ActionResult Profile()
        {
            #region FileLocation

            string FileLocation;
            string usertype = Session["UserType"].ToString();
            if (usertype.ToLower() == "distributor")
            {
                FileLocation = "/Content/userupload/Distributor/kyc/";
            }
            else if (usertype.ToLower() == "sub-distributor")
            {
                FileLocation = "/Content/userupload/SubDistributor/kyc/";
            }
            else if (usertype.ToLower() == "walletuser")
            {
                FileLocation = "/Content/userupload/Walletuser/kyc/";
            }
            else if (usertype.ToLower() == "merchant")
            {
                FileLocation = "/Content/userupload/Merchant/kyc/";
            }
            else if (usertype.ToLower() == "agent")
            {
                FileLocation = "/Content/userupload/Agent/kyc/";
            }
            else if (usertype.ToLower() == "sub-agent")
            {
                FileLocation = "/Content/userupload/SubAgent/kyc/";
            }
            else
            {
                FileLocation = "/Content/userupload/";
            }
            #endregion
            string UserId = Session["UserName"].ToString();
            WalletUserInfo walletUser = _walletUserBusiness.UserInfo(UserId);
            return View(walletUser);
        }
        #endregion

        #region Change Password TPin
        public ActionResult ChangePassword()
        {
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ChangePassword(UserModel userModel)
        {
            string dbmessage = string.Empty;
            ModelState.Remove("UserPin");
            ModelState.Remove("ConfirmUserPin");
            userModel.UserName = Session["username"].ToString();
            if (ModelState.IsValid)
            {
                string oldpwd = userModel.OldPassword;
                string newpwd = userModel.UserPwd;
                string username = userModel.UserName;
                UserCommon user = new UserCommon
                {
                    OldPassword = oldpwd,
                    UserName = username,
                    UserPwd = newpwd,
                    Session=Session.SessionID
                };
                CommonDbResponse dbresp = _userBusiness.ChangePassword(user);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("Index", "Home");
                }
                dbmessage = dbresp.Message;

            }
            this.ShowPopup(1, string.IsNullOrEmpty(dbmessage) ? "Invalid Current Password" : dbmessage);
            return View(userModel);

        }

        public ActionResult ChangePin()
        {
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ChangePin(UserModel userModel)
        {
            string dbmessage = string.Empty;
            ModelState.Remove("UserPwd");
            userModel.UserID = Session["UserId"].ToString();
            userModel.UserName = Session["UserName"].ToString();
            ModelState.Remove("ConfirmUserPwd");
            if (ModelState.IsValid)
            {
                string password = userModel.OldPassword;
                string newpin = userModel.UserPin;
                string userId = userModel.UserID;
                string username = userModel.UserName;
                UserCommon user = new UserCommon
                {
                    UserPwd = password,
                    UserPin = newpin,
                    UserID = userId,
                    UserName = username

                };
                CommonDbResponse dbresp = _userBusiness.ChangePin(user);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("Index", "Home");
                }
                dbmessage = dbresp.Message;

            }
            this.ShowPopup(1, string.IsNullOrEmpty(dbmessage) ? "Invalid Current Password" : dbmessage);
            return View(userModel);

        }
        #endregion

        #region User Kyc
        [HttpGet]
        public ActionResult Kyc()
        {
            string UserId = Session["UserName"].ToString();
            string AgentID = _walletUserBusiness.UserInfo(UserId).AgentId.ToString();
            KYCCommon kycCommon = new KYCCommon();

            KYCModel kycModel = new KYCModel();
            if (!String.IsNullOrEmpty(AgentID))
                kycCommon = _kyc.AgentKycInfo(AgentID);
            //kycCommon.AgentId = ID.ToString();
            kycModel = kycCommon.MapObject<KYCModel>();
            kycModel.Country = string.IsNullOrEmpty(kycModel.Country) ? "Nepal" : kycModel.Country;
            kycModel.Nationality = string.IsNullOrEmpty(kycModel.Nationality) ? "Nepali" : kycModel.Nationality;
            LoadDropDownList(kycModel);
            #region FileLocation

            string FileLocation;
            string usertype = Session["UserType"].ToString();
            if (usertype.ToLower() == "distributor")
            {
                FileLocation = "/Content/userupload/Distributor/kyc/";
            }
            else if (usertype.ToLower() == "sub-distributor")
            {
                FileLocation = "/Content/userupload/SubDistributor/kyc/";
            }
            else if (usertype.ToLower() == "walletuser")
            {
                FileLocation = "/Content/userupload/Walletuser/kyc/";
            }
            else if (usertype.ToLower() == "merchant")
            {
                FileLocation = "/Content/userupload/Merchant/kyc/";
            }
            else if (usertype.ToLower() == "agent")
            {
                FileLocation = "/Content/userupload/Agent/kyc/";
            }
            else if (usertype.ToLower() == "sub-agent")
            {
                FileLocation = "/Content/userupload/SubAgent/kyc/";
            }
            else
            {
                FileLocation = "/Content/userupload/";
            }

            #endregion
            return View(kycModel);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Kyc(KYCModel clientkyc, HttpPostedFileBase PPImageFile, HttpPostedFileBase Id_DocumentFrontFile, HttpPostedFileBase Id_DocumentBackFile)
        {
            LoadDropDownList(clientkyc);
            string status = "u";
            ModelState.Remove(("Remarks"));
            #region FileLocation

            string FileLocation;
            string usertype = Session["UserType"].ToString();
            if (usertype.ToLower() == "distributor")
            {
                FileLocation = "/Content/userupload/Distributor/kyc/";
            }
            else if (usertype.ToLower() == "sub-distributor")
            {
                FileLocation = "/Content/userupload/SubDistributor/kyc/";
            }
            else if (usertype.ToLower() == "walletuser")
            {
                FileLocation = "/Content/userupload/Walletuser/kyc/";
            }
            else if (usertype.ToLower() == "merchant")
            {
                FileLocation = "/Content/userupload/Merchant/kyc/";
            }
            else if (usertype.ToLower() == "agent")
            {
                FileLocation = "/Content/userupload/Agent/kyc/";
            }
            else if (usertype.ToLower() == "sub-agent")
            {
                FileLocation = "/Content/userupload/SubAgent/kyc/";
            }
            else
            {
                FileLocation = "/Content/userupload/";
            }

            ViewBag.FileLocation = FileLocation;
            #endregion

            if ((Id_DocumentFrontFile == null && string.IsNullOrEmpty(clientkyc.Id_DocumentFront)) 
                || (PPImageFile == null && string.IsNullOrEmpty(clientkyc.PPImage)) 
                || (Id_DocumentBackFile == null && string.IsNullOrEmpty(clientkyc.Id_DocumentBack) && clientkyc.Id_type.ToUpper() == "CITIZENSHIP"))
            {
                if (Id_DocumentFrontFile == null && string.IsNullOrEmpty(clientkyc.Id_DocumentFront))
                    ModelState.AddModelError("Id_DocumentFront", "Document Front Image is Required");
                if (PPImageFile == null && string.IsNullOrEmpty(clientkyc.PPImage))
                    ModelState.AddModelError("PPImage", "Profile Image is Required");
                if ((Id_DocumentBackFile == null && string.IsNullOrEmpty(clientkyc.Id_DocumentBack) && clientkyc.Id_type.ToUpper() == "CITIZENSHIP"))
                {
                    ModelState.AddModelError("Id_DocumentBack", "Document Front Image is Required");
                }
                return View(clientkyc);
            }

            if (clientkyc.Id_type.ToUpper() == "CITIZENSHIP")
            {
                //if (Id_DocumentBackFile == null && string.IsNullOrEmpty(clientkyc.Id_DocumentBack))
                //{
                //    ModelState.AddModelError("Id_DocumentBack", "Document Front Image is Required");
                //    return View(clientkyc);
                //}
                ModelState.Remove(("Id_ExpiryDateAD"));
                ModelState.Remove(("Id_ExpiryDateBS"));
            }

            var PPImagePath = "";
            var Id_DocumentFrontPath = "";
            var Id_DocumentBackPath = "";

            string temp_address = clientkyc.SameAsPermanentAddress.ToString();
            if (temp_address == "True")
            {
                clientkyc.TProvince = clientkyc.PProvince;
                clientkyc.TDistrict = clientkyc.PDistrict;
                clientkyc.TLocalBody = clientkyc.PLocalBody;
                clientkyc.TWardNo = clientkyc.PWardNo;
                clientkyc.TAddress = clientkyc.PAddress;
            }

            if (ModelState.IsValid)
            {
                //clientkyc.Remarks = String.IsNullOrEmpty(clientkyc.Remarks) ? "" :
                //  clientkyc.Remarks.ToUpper().Equals("OTHERS") ? OthersRemarks : clientkyc.Remarks;

                clientkyc.ActionUser = Session["UserName"].ToString();

                #region "PPImage"
                if (PPImageFile != null && status.ToUpper() == "U")
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(PPImageFile.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(PPImageFile.FileName);
                    if (PPImageFile.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        return RedirectToAction("Kyc", ControllerName);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = timeStamp.Replace('/', '-').Replace(':', '-');
                        string myfilename = clientkyc.MobileNo + "-PPImage-" + datet + ext;
                        PPImagePath = Path.Combine(Server.MapPath(FileLocation), myfilename);
                        clientkyc.PPImage = FileLocation + myfilename;
                        //PPImageFile.SaveAs(PPImagePath);
                    }
                    else
                    {
                        return RedirectToAction("Kyc", ControllerName);
                    }
                }
                #endregion
                #region "Id_DocumentFront"
                if (Id_DocumentFrontFile != null && status.ToUpper() == "U")
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Id_DocumentFrontFile.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Id_DocumentFrontFile.FileName);
                    if (Id_DocumentFrontFile.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        return RedirectToAction("Kyc", ControllerName);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = timeStamp.Replace('/', '-').Replace(':', '-');
                        string myfilename = clientkyc.MobileNo + "-Id_DocumentFront-" + datet + ext;
                        Id_DocumentFrontPath = Path.Combine(Server.MapPath(FileLocation), myfilename);
                        clientkyc.Id_DocumentFront = FileLocation + myfilename;
                        //Id_DocumentFrontFile.SaveAs(Id_DocumentFrontPath);
                    }
                    else
                    {
                        return RedirectToAction("Kyc", ControllerName);
                    }
                }
                #endregion
                #region "Id_DocumentBack"
                if (Id_DocumentBackFile != null && status.ToUpper() == "U")
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Id_DocumentBackFile.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Id_DocumentBackFile.FileName);
                    if (Id_DocumentBackFile.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        return RedirectToAction("Kyc", ControllerName);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = timeStamp.Replace('/', '-').Replace(':', '-');
                        string myfilename = clientkyc.MobileNo + "-Id_DocumentBack-" + datet + ext;
                        Id_DocumentBackPath = Path.Combine(Server.MapPath(FileLocation), myfilename);
                        clientkyc.Id_DocumentBack = FileLocation + myfilename;
                        //Id_DocumentBackFile.SaveAs(Id_DocumentBackPath);
                    }
                    else
                    {
                        return RedirectToAction("Kyc", ControllerName);
                    }
                }
                #endregion
                KYCCommon kycCommon = clientkyc.MapObject<KYCCommon>();
                CommonDbResponse dbResponse = _kyc.UpadateKycDetails(kycCommon, status);
                if (dbResponse.Code == 0)
                {
                    //SaveImages On Success
                    if (PPImagePath != "")
                        PPImageFile.SaveAs(PPImagePath);
                    if (Id_DocumentFrontPath != "")
                        Id_DocumentFrontFile.SaveAs(Id_DocumentFrontPath);
                    if (Id_DocumentBackPath != "")
                        Id_DocumentBackFile.SaveAs(Id_DocumentBackPath);
                    //Ends SaveImages
                }
                dbResponse.SetMessageInTempData(this);
                return RedirectToAction("Profile");
            }
            return View(clientkyc);
        }
        public void LoadDropDownList(KYCModel kycModel)
        {
            kycModel.CountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country") as Dictionary<string, string>, kycModel.Country, "--Country--");
            kycModel.GenderList = ApplicationUtilities.SetDDLValue(LoadDropdownList("gender") as Dictionary<string, string>, kycModel.Gender, "--Gender--");
            kycModel.OccupationList = ApplicationUtilities.SetDDLValue(LoadDropdownList("occupation") as Dictionary<string, string>, kycModel.Occupation, "--Occupation--");
            kycModel.MaritalStatusList = ApplicationUtilities.SetDDLValue(LoadDropdownList("maritalstatus") as Dictionary<string, string>, kycModel.MaritalStatus, "--Marital Status--");
            kycModel.RemarksList = ApplicationUtilities.SetDDLValue(LoadDropdownList("remarks") as Dictionary<string, string>, kycModel.Remarks, "--Remarks--");
            kycModel.DocTypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype") as Dictionary<string, string>, kycModel.Id_type, "--Document Type--");
            kycModel.PProvinceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province") as Dictionary<string, string>, kycModel.PProvince, "--Permanent Province--");
            kycModel.TProvinceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province") as Dictionary<string, string>, kycModel.TProvince, "--Temporary Province--");
            kycModel.PDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", kycModel.PProvince) as Dictionary<string, string>, kycModel.PDistrict, "--Permanent District--");
            kycModel.TDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", kycModel.TProvince) as Dictionary<string, string>, kycModel.TDistrict, "--Temporary District--");
            kycModel.PMunicipalityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("localbodyList", (String.IsNullOrEmpty(kycModel.PDistrict) ? "" : kycModel.PDistrict)) as Dictionary<string, string>, kycModel.PLocalBody, "--Permanent Municipality--");
            kycModel.TMunicipalityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("localbodyList", (String.IsNullOrEmpty(kycModel.TDistrict) ? "" : kycModel.TDistrict)) as Dictionary<string, string>, kycModel.TLocalBody, "--Temporary Municipality--");
            kycModel.NationalityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("nationality") as Dictionary<string, string>, kycModel.Nationality, "--Nationality--");
            kycModel.Id_IssuedPlaceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList") as Dictionary<string, string>, kycModel.Id_IssuedPlace, "--Issue Place--");
            kycModel.OtherRemarks = !String.IsNullOrEmpty(kycModel.Remarks) ? (kycModel.Remarks.Contains("Others::") ? kycModel.Remarks.Replace("Others::", "") : "") : "";

        }

        public object LoadDropdownList(string flag, string search1 = "")
        {
            switch (flag)
            {
                case "country":
                    return _kyc.Dropdown("004");
                case "gender":
                    return _kyc.Dropdown("005");
                case "occupation":
                    return _kyc.Dropdown("024");
                case "maritalstatus":
                    return _kyc.Dropdown("025");
                case "remarks":
                    return _kyc.Dropdown("029");
                case "doctype":
                    return _kyc.Dropdown("014");
                case "province":
                    return _kyc.Dropdown("002");
                case "district":
                    return _kyc.Dropdown("007");
                case "districtList":
                    return _kyc.Dropdown("007", search1);
                case "localbody":
                    return _kyc.Dropdown("008");
                case "localbodyList":
                    return _kyc.Dropdown("008", search1);
                case "nationality":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("Nepali", "Nepali");
                        dict.Add("Indian", "Indian");
                        dict.Add("Chinese", "Chinese");
                        dict.Add("Others", "Others");
                        return dict;
                    };
            }
            return null;
        }

        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> GetDistrictsByProvince(string provinceId)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", provinceId) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }
        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> GetLocalbodyByDistrict(string DistrictId)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("localbodyList", DistrictId) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }
        #endregion

        #region AddUser

        public ActionResult UserList(string Search = "", int Pagesize = 20)
        {
            string ParentId = Session["UserId"].ToString();
            List<WalletUserInfoModel> lst = _CLientManagement.WalletUserList("WalletUser", ParentId: ParentId).MapObjects<WalletUserInfoModel>();
            foreach (var item in lst)
            {
                item.Action = StaticData.GetActions("ClientUserList", item.AgentId.ToString().EncryptParameter(), this, "", "", item.AgentStatus, item.UserId.EncryptParameter());
                item.AgentStatus = "<span class='badge badge-" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("MobileNo", "Mobile No.");
            param.Add("Email", "Email");
            param.Add("FullName", "Name");
            param.Add("KycStatus", "Kyc Status");
            param.Add("AgentStatus", "Status");
            //param.Add("Balance", "Balance");
            param.Add("CreatedLocalDate", "Registered Date");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(lst, "", Search, Pagesize, true, "", "", "Home", "User", "/Client/ClientUser/UserList", "/Client/ClientUser/AddClient");
            ViewData["grid"] = grid;
            return View();
        }
        [HttpGet]
        public ActionResult AddClient()
        {
            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AddClient(WalletUserInfoModel walletUserModel)
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
                walletUser.MobileNo = walletUserModel.MobileNo;
                walletUser.Email = walletUserModel.Email;
                walletUser.FullName = walletUserModel.FullName;
                walletUser.ActionUser = Session["UserName"].ToString();
                walletUser.ParentId = Session["UserId"].ToString();
                walletUser.ActionIP = ApplicationUtilities.GetIP();
                HttpContext httpCtx = System.Web.HttpContext.Current;
                walletUser.ActionBrowser = httpCtx.Request.Headers["User-Agent"];
                CommonDbResponse dbresp = _CLientManagement.AddUser(walletUser);
                if (dbresp.ErrorCode == 0)
                {
                    dbresp.SetMessageInTempData(this);

                    //this.ShowPopup(0, "Succesfully Added amount: " + walletUser.BalanceToAdd);
                    return RedirectToAction("UserList");
                }
                dbresp.SetMessageInTempData(this);
            }

            return View(walletUserModel);
        }

        [HttpPost, ValidateAntiForgeryToken, OverrideActionFilters]
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
                data = _CLientManagement.UserStatusChange(walletUser.UserId, walletUser.AgentId, walletUser.AgentStatus);
                //if (data.ErrorCode == 0)
                //{
                //    data.Message = "Successfully Changed User";
                //}
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }

        #endregion



    }
}
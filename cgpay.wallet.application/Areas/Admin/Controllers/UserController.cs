using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.User;
using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class UserController : Controller
    {
        string ControllerName = "User";

        IUserBusiness buss;
        ICommonBusiness ICB;

        public UserController(IUserBusiness _buss, ICommonBusiness _ICB)
        {
            buss = _buss;
            ICB = _ICB;
        }


        public ActionResult Index(string Search = "", int Pagesize = 10)
        {
            string usertype = Session["UserType"].ToString();
            var list = buss.GetAllList(StaticData.GetUser(), usertype, Pagesize);

            if (!Session["UserName"].ToString().Equals("superadmin"))
                list.Remove(list.Select(c => { c.UserName = "superadmin"; return c; }).FirstOrDefault());
            
            var RolesList = LoadDropdownList("ManageUser") as Dictionary<string, string>;

            ViewBag.Roles = ApplicationUtilities.SetDDLValue(RolesList, "select", "--Select Role--");
            foreach (var item in list)
            {
                item.RoleName = RolesList.First(m => m.Key == item.RoleId).Value;
                item.Action = StaticData.GetActions("User", item.UserID.EncryptParameter(), this, "", "", item.IsActive, Session["UserName"].ToString(), item.UserName,item.RoleName);
                item.ActivityStatus = item.IsActive;
                item.ActivityStatus = "<span class='badge badge-" + (item.IsActive.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.IsActive.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
            }

            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("UserName", "User Name");
            param.Add("FullName", "Full Name");
            param.Add("Email", "Email");
            param.Add("PhoneNo", "Phone No");
            param.Add("RoleName", "Role");
            param.Add("ActivityStatus", "Status");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "User", Search, Pagesize, true, "", "", "Home", "User", "/Admin/User", "/Admin/User/ManageUser");
            ViewData["grid"] = grid;
            return View();

        }
        public object LoadDropdownList(string forMethod)
        {
            switch (forMethod)
            {
                case "ManageUser":
                    return ICB.sproc_get_dropdown_list("001");
                case "searchfilter":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("MobileNo", "Mobile No");
                        dict.Add("Email", "Email");
                        dict.Add("Username", "User Name");
                        dict.Add("Fullname", "Full Name");

                        return dict;
                    };
            }
            return null;
        }
        public void ModelStateValidation(string validateMode = "Insert")
        {
            switch (validateMode)
            {
                case "Update":
                    ModelState.Remove("UserName");
                    ModelState.Remove("UserPwd");
                    ModelState.Remove("IsActive");
                    ModelState.Remove("ConfirmUserPwd");
                    ModelState.Remove("RoleId");
                    break;
                case "Insert":
                    break;
                default: break;
            }
        }
        public ActionResult ManageUser(string UserId = "")
        {
            UserCommon commonModel = new UserCommon();
            if (!String.IsNullOrEmpty(UserId))
            {
                var id = UserId.DecryptParameter();
                if (string.IsNullOrEmpty(id))
                    return RedirectToAction("Index");
                commonModel = buss.GetUserById(id);
                commonModel.UserID = commonModel.UserID.EncryptParameter();
            }
            var rol = LoadDropdownList("ManageUser");
            ViewBag.Roles = ApplicationUtilities.SetDDLValue(LoadDropdownList("ManageUser") as Dictionary<string, string>, commonModel.RoleId, "--Select Role--");

            //ViewBag.Roles = LoadDropdownList("ManageUser");
            return View(commonModel);
        }
        [ValidateAntiForgeryToken, HttpPost]
        public ActionResult ManageUser(UserCommon model)
        {
            ViewBag.Roles = ApplicationUtilities.SetDDLValue(LoadDropdownList("ManageUser") as Dictionary<string, string>, model.RoleId, "--Select Role--");

            //model.Roles = LoadDropdownList("ManageUser") as List<SelectListItem>;
            string userId = "";
            userId = model.UserID;
            if (!string.IsNullOrEmpty(model.UserID))
            {
                if (string.IsNullOrEmpty(model.UserID.DecryptParameter()))
                {
                    return RedirectToAction("Index");
                }

                model.UserID = userId.DecryptParameter();
            }
            ModelStateValidation(String.IsNullOrEmpty(userId) ? "Insert" : "Update");
            if (ModelState.IsValid)
            {
                model.ActionUser = Session["username"].ToString();
                model.IpAddress = ApplicationUtilities.GetIP();
                //model.CreatedPlatform = ApplicationUtilities.
                CommonDbResponse resp = buss.ManageUser(model);
                resp.SetMessageInTempData(this);
                if (resp.Code == 0)
                {
                    return RedirectToAction("Index");
                }
            }
            model.UserID = userId;
            return View(model);
        }

        public ActionResult ViewDetail(string UserId)
        {
            Profile commonModel = new Profile();
            if (!String.IsNullOrEmpty(UserId))
            {
                var id = UserId.DecryptParameter();
                if (string.IsNullOrEmpty(id))
                    return RedirectToAction("Index");
                commonModel = buss.UserInfo(id);
                commonModel.UserID = commonModel.UserID.EncryptParameter();
                ModelState.Remove("UserName");
                return View(commonModel);

            }
            return RedirectToAction("Index");

            //ViewBag.Roles = LoadDropdownList("ManageUser");
        }

        #region Search User
        public ActionResult SearchUser()
        {
            ViewBag.SearchFilter = ApplicationUtilities.SetDDLValue(LoadDropdownList("searchfilter") as Dictionary<string, string>, "", "--Select--");

            return View();
        }
        [ValidateAntiForgeryToken, HttpPost]
        public ActionResult SearchUser(UserSearchFilter USF)
        {
            ViewBag.SearchFilter = ApplicationUtilities.SetDDLValue(LoadDropdownList("searchfilter") as Dictionary<string, string>, USF.SearchFilter, "--Select--");

            if (!string.IsNullOrEmpty(USF.SearchField) && !string.IsNullOrEmpty(USF.SearchFilter))
            {
                string username = Session["username"].ToString();
                var lst = buss.GetSearchUserList(USF.SearchField, USF.SearchFilter, username);

                foreach (var item in lst)
                {
                    item.Action = StaticData.GetActions("SearchUser", item.UserID.EncryptParameter(), this, "", "", item.IsActive, Session["UserName"].ToString(), item.AgentUserId.EncryptParameter(), item.IsPrimary);
                    item.Status = "<span class='badge badge-" + (item.IsActive.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.IsActive.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
                }
                IDictionary<string, string> param = new Dictionary<string, string>();

                //param.Add("AgentUserId", "Agent Id");
                param.Add("FullName", "Full Name");
                param.Add("UserName", "User Name");
                param.Add("Email", "Email");
                param.Add("Status", "Status");
                param.Add("PhoneNo", "Mobile Number");
                param.Add("CreatedBy", "Created By");
                param.Add("CreateDate", "Created On");
                param.Add("Action", "Action");
                ProjectGrid.column = param;
                //Ends
                var grid = ProjectGrid.MakeGrid(lst, "hidebreadcrumb", "", 10, false, "", "", "", "", "", "");
                ViewData["grid"] = grid;
            }
            else
                this.ShowPopup(1, "Please Fill the fields");
            return View(USF);
        }

        public ActionResult EditSearchUser(string UserId = "")
        {
            UserCommon commonModel = new UserCommon();
            if (!string.IsNullOrEmpty(UserId))
            {
                var id = UserId.DecryptParameter();
                if (string.IsNullOrEmpty(id))
                    return RedirectToAction("SearchUser");
                string username = Session["username"].ToString();
                commonModel = buss.GetSearchUserList(id, "userid", username).FirstOrDefault();
                //commonModel = buss.GetUserById(id);
                commonModel.UserID = commonModel.UserID.EncryptParameter();
                var rol = LoadDropdownList("ManageUser");
                ViewBag.Roles = ApplicationUtilities.SetDDLValue(LoadDropdownList("ManageUser") as Dictionary<string, string>, commonModel.RoleId, "--Select Role--");
                return View(commonModel);

            }
            else
            {
                ApplicationUtilities.ShowPopup(this,1,"Something Went Wrong! ");
                return RedirectToAction("SearchUser");
            }

            //ViewBag.Roles = LoadDropdownList("ManageUser");
        }
        [ValidateAntiForgeryToken, HttpPost]
        public ActionResult EditSearchUser(UserCommon model)
        {
            ViewBag.Roles = ApplicationUtilities.SetDDLValue(LoadDropdownList("ManageUser") as Dictionary<string, string>, model.RoleId, "--Select Role--");

            //model.Roles = LoadDropdownList("ManageUser") as List<SelectListItem>;
            string userId = "";
            userId = model.UserID;
            if (!string.IsNullOrEmpty(model.UserID))
            {
                if (string.IsNullOrEmpty(model.UserID.DecryptParameter()))
                {
                    return RedirectToAction("SearchUser");
                }

                model.UserID = userId.DecryptParameter();
            }
            ModelStateValidation(String.IsNullOrEmpty(userId) ? "Insert" : "Update");
            if (ModelState.IsValid)
            {
                model.ActionUser = Session["username"].ToString();
                model.IpAddress = ApplicationUtilities.GetIP();
                //model.CreatedPlatform = ApplicationUtilities.
                CommonDbResponse resp = buss.ManageUser(model);
                resp.SetMessageInTempData(this);
                if (resp.Code == 0)
                {
                    return RedirectToAction("SearchUser");
                }
            }
            model.UserID = userId;
            return View(model);
        }

        public ActionResult ViewSearchUserDetail(string UserId)
        {
            Profile commonModel = new Profile();
            if (!String.IsNullOrEmpty(UserId))
            {
                var id = UserId.DecryptParameter();
                if (string.IsNullOrEmpty(id))
                    return RedirectToAction("Index");
                commonModel = buss.UserInfo(id);
                commonModel.UserID = commonModel.UserID.EncryptParameter();
                ModelState.Remove("UserName");
                return View(commonModel);

            }
            return RedirectToAction("SearchUser");

            //ViewBag.Roles = LoadDropdownList("ManageUser");
        }

        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult BlockSearchUser(string userid)
        {
            if (!String.IsNullOrEmpty(userid))
            {
                userid = userid.DecryptParameter();
                if (string.IsNullOrEmpty(userid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = buss.block_unblockuser(userid, "N");
                if (DbResponse.ErrorCode == 0)
                {
                    DbResponse.Message = "Successfully Blocked User";
                    DbResponse.SetMessageInTempData(this);

                }
                return Json(DbResponse);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
        }
        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult UnBlockSearchUser(string userid)
        {
            if (!String.IsNullOrEmpty(userid))
            {
                userid = userid.DecryptParameter();
                if (string.IsNullOrEmpty(userid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = buss.block_unblockuser(userid, "Y");
                if (DbResponse.ErrorCode == 0)
                {
                    DbResponse.Message = "Successfully Un-Blocked User";
                    DbResponse.SetMessageInTempData(this);

                }
                return Json(DbResponse);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
        }

        #endregion


        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Changeuserpassword(ChangePasswordModel model)
        {
            ModelState.Remove("RoleId");
            if (ModelState.IsValid)
            {
                model.UserName = model.UserNamePassword.DecryptParameter();
                model.ActionUser = Session["UserName"].ToString();
                model.IpAddress = ApplicationUtilities.GetIP();
                //model.BrowserInfo = ApplicationUtilities.GetBrowserInfo();
                var common = model.MapObject<shared.Models.User.ChangePasswordCommon>();
                CommonDbResponse resp = buss.ChangeUserPassword(common);//.SetMessageInTempData(this);
                if (resp.Code == ResponseCode.Success)
                {
                    this.ShowPopup(0, "Password Changed Successfully!!");
                    //resp.SetMessageInTempData(this);
                    return RedirectToAction("Index");
                }

            }
            this.ShowPopup(1, "Something went wrong!!");
            return RedirectToAction("Index");

        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Changeuserpassword(UserSearchFilter model)
        {
            ModelState.Remove("RoleId");
            ModelState.Remove("SearchFilter");
            if (ModelState.IsValid)
            {
                model.UserName = model.UserNamePassword.DecryptParameter();
                model.ActionUser = Session["UserName"].ToString();
                model.IpAddress = ApplicationUtilities.GetIP();
                //model.BrowserInfo = ApplicationUtilities.GetBrowserInfo();
                var common = model.MapObject<shared.Models.User.ChangePasswordCommon>();
                CommonDbResponse resp = buss.ChangeUserPassword(common);//.SetMessageInTempData(this);
                if (resp.Code == ResponseCode.Success)
                {
                    this.ShowPopup(0, "Password Changed Successfully!!");
                    //resp.SetMessageInTempData(this);
                    return RedirectToAction("Index");
                }

            }
            this.ShowPopup(1, "Something went wrong!!");
            return RedirectToAction("SearchUser",model);

        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AssignRole(ChangePasswordModel model)
        {

            ModelState.Remove("Password");
            ModelState.Remove("ConfirmPassword");
            if (ModelState.IsValid)
            {
                model.UserName = model.UserNameRole.DecryptParameter();
                model.ActionUser = Session["UserName"].ToString();
                model.IpAddress = ApplicationUtilities.GetIP();
                //model.BrowserInfo = ApplicationUtilities.GetBrowserInfo();
                var common = model.MapObject<shared.Models.User.ChangePasswordCommon>();
                CommonDbResponse resp = buss.AssignRole(common);//.SetMessageInTempData(this);
                if (resp.Code == ResponseCode.Success)
                {
                    this.ShowPopup(0, "Role Changed Successfully!!");
                    //resp.SetMessageInTempData(this);
                    return RedirectToAction("Index");
                }

            }
            this.ShowPopup(1, "Something went wrong!!");
            return RedirectToAction("Index");
            //return View(model);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult DeleteUser(string UserName)
        {
            if (!String.IsNullOrEmpty(UserName))
            {
                UserName = UserName.DecryptParameter();
                if (string.IsNullOrEmpty(UserName))
                {
                    return Json(new CommonDbResponse { Code = shared.Models.ResponseCode.Failed, Message = "Invalid User." });
                }
                string ActionUser = Session["UserName"].ToString();
                string IpAddress = ApplicationUtilities.GetIP();
                //string BrowserInfo = ApplicationUtilities.GetBrowserInfo();
                var DbResponse = buss.DeleteAdminUser(new shared.Models.UserCommon { UserName = UserName, ActionUser = ActionUser, IpAddress = IpAddress});

                if (DbResponse.Code == ResponseCode.Success)
                {
                    DbResponse.Message = "Successfully deleted User";
                    //this.ShowPopup(0, "Successfully deleted User");
                    //return Json(DbResponse);

                }
                DbResponse.SetMessageInTempData(this);
                return Json(new CommonDbResponse() { Code = DbResponse.Code, Message = DbResponse.Message });
            }
            return Json(new CommonDbResponse { Code = shared.Models.ResponseCode.Failed, Message = "Invalid User." });
        }

        public ActionResult changepassword()
        {

            return View();
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult changepassword(UserCommon uc)
        {
            string dbmessage = string.Empty;
            ModelState.Remove("RoleId");
            ModelState.Remove("IsActive");
            ModelState.Remove("PhoneNo");
            ModelState.Remove("Email");
            ModelState.Remove("FullName");
            ModelState.Remove("UserName");
            if (string.IsNullOrEmpty(uc.OldPassword))
            {
                ModelState.AddModelError("OldPassword", "Current Password is Required");

            }
            if (ModelState.IsValid)
            {
                string oldpwd = uc.OldPassword;
                string newpwd = uc.UserPwd;
                string username = Session["username"].ToString();
                UserCommon user = new UserCommon
                {
                    OldPassword = oldpwd,
                    UserName = username,
                    UserPwd = newpwd,
                    Session = Session.SessionID
                };



                CommonDbResponse dbresp = buss.ChangePassword(user);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("Index", "home");
                }
                dbmessage = dbresp.Message;

            }
            this.ShowPopup(1, string.IsNullOrEmpty(dbmessage) ? "Error" : dbmessage);
            return View(uc);

        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult BlockUser(string userid)
        {
            if (!String.IsNullOrEmpty(userid))
            {
                userid = userid.DecryptParameter();
                if (string.IsNullOrEmpty(userid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = buss.block_unblockuser(userid, "N");
                if (DbResponse.ErrorCode == 0)
                {
                    DbResponse.Message = "Successfully Blocked User";
                    DbResponse.SetMessageInTempData(this);

                }
                return Json(DbResponse);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult UnBlockUser(string userid)
        {
            if (!String.IsNullOrEmpty(userid))
            {
                userid = userid.DecryptParameter();
                if (string.IsNullOrEmpty(userid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = buss.block_unblockuser(userid, "Y");
                if (DbResponse.ErrorCode == 0)
                {
                    DbResponse.Message = "Successfully Un-Blocked User";
                    DbResponse.SetMessageInTempData(this);

                }
                return Json(DbResponse);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
        }

        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult BlockSearchUser(string userid, string agentid)
        {
            if (!string.IsNullOrEmpty(userid) && !string.IsNullOrEmpty(agentid))
            {
                userid = userid.DecryptParameter();
                agentid = agentid.DecryptParameter();
                if (string.IsNullOrEmpty(userid) || string.IsNullOrEmpty(agentid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = buss.Block_UnblockSearchUser(userid, agentid, "N");
                if (DbResponse.ErrorCode == 0)
                {
                    DbResponse.Message = "Successfully Blocked User";
                    DbResponse.SetMessageInTempData(this);

                }
                return Json(DbResponse);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
        }
        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult UnBlockSearchUser(string userid, string agentid)
        {
            if (!string.IsNullOrEmpty(userid) && !string.IsNullOrEmpty(agentid))
            {
                userid = userid.DecryptParameter();
                agentid = agentid.DecryptParameter();
                if (string.IsNullOrEmpty(userid) || string.IsNullOrEmpty(agentid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = buss.Block_UnblockSearchUser(userid, agentid, "Y");
                if (DbResponse.ErrorCode == 0)
                {
                    DbResponse.Message = "Successfully Un-Blocked User";
                    DbResponse.SetMessageInTempData(this);

                }
                return Json(DbResponse);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
        }
        public ActionResult Profile()
        {
            string UserId = Session["UserName"].ToString();
            Profile walletUser = buss.UserInfo(UserId);
            return View(walletUser);
        }

    }
}
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.SubDistributorManagement;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubDistributorManagement;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class SubDistributorManagementController : Controller
    {
        
        ISubDistributorManagementBusiness buss;
        ICommonBusiness ICB;
        public SubDistributorManagementController(ISubDistributorManagementBusiness _buss, ICommonBusiness _ICB)
        {
            buss = _buss;
            ICB = _ICB;

        }

        public ActionResult Index(string ParentId = "")
        {
            var UserType = Session["UserType"].ToString();
            string AgentId="",  IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();           
            string username = ApplicationUtilities.GetSessionValue("UserName").ToString();
            if(UserType.ToUpper()=="SUB-DISTRIBUTOR")
            {
                AgentId = Session["agentid"].ToString();
            }            
            ParentId = ParentId.DecryptParameter();
            var DistributorCommon = buss.GetSubDistributorList(ParentId, username,AgentId);
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("AgentName", "Agent Name");
            param.Add("AgentOperationType", "Operation Type");
            param.Add("AgentMobileNumber", "Contact Number");
            param.Add("AgentCreditLimit", "Credit Limit");
            param.Add("AgentStatus", "Agent Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            foreach (var item in DistributorCommon)
            {
                item.Action = StaticData.GetActions("SubDistributorManagement", item.AgentID.EncryptParameter(), this, "", "", username.EncryptParameter(), item.AgentStatus);
                item.AgentStatus = "<span class='badge badge-" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
            }
            var grid = ProjectGrid.MakeGrid(DistributorCommon, "Sub-Distributor List ", "", 0, true, "", "", "Home", "Sub-Distributor", "/Admin/SubDistributorManagement", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ? "/Admin/SubDistributorManagement/ManageSubDistributor?parent_id=" + ParentId.EncryptParameter() : "");
            ViewData["grid"] = grid;
            return View();
        }

        public ActionResult ManageSubDistributor(string parent_id="", string agent_Id = "")
        {
            

            SubDistributorManagementModel DMM = new SubDistributorManagementModel();
            DMM.ParentID = parent_id;
            if (!string.IsNullOrEmpty(agent_Id))
            {
                
                if (!string.IsNullOrEmpty(agent_Id.DecryptParameter()))
                {
                    string UserName = ApplicationUtilities.GetSessionValue("username").ToString();
                    SubDistributorManagementCommon DC = buss.GetSubDistributorById(agent_Id.DecryptParameter(), UserName);
                    DMM = DC.MapObject<SubDistributorManagementModel>();
                    DMM.AgentID = DMM.AgentID.EncryptParameter();
                    DMM.UserID = DMM.UserID.EncryptParameter();
                    DMM.ParentID = DMM.ParentID.EncryptParameter();
                }
            }
            LoadDropDownList(DMM);
            return View(DMM);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ManageSubDistributor(SubDistributorManagementModel DistModel, HttpPostedFileBase Agent_Logo, HttpPostedFileBase Pan_Certiticate, HttpPostedFileBase Registration_Certificate, string changepassword)
        {
            var Agent_LogoPath = "";
            var Pan_CertiticatePath = "";
            var Registration_CertificatePath = "";
            ModelState.Remove("AgentContractDate_BS");
            LoadDropDownList(DistModel);
            if (!string.IsNullOrEmpty(DistModel.AgentID.DecryptParameter()))
            {
                             
                    RemoveupdateValidation(DistModel);
                
            }
            if (DistModel.AgentOperationType.ToUpper() != "BUSINESS")
            {
                DistModel.AgentEmail = DistModel.UserEmail;
                DistModel.AgentMobileNumber = DistModel.UserMobileNumber;
                RemoveBusinessValidation(DistModel);
            }
            if (ModelState.IsValid)
            {
                SubDistributorManagementCommon DMC = new SubDistributorManagementCommon();
                DMC = DistModel.MapObject<SubDistributorManagementCommon>();
                if (!string.IsNullOrEmpty(DMC.AgentID))
                {
                    if (string.IsNullOrEmpty(DMC.AgentID.DecryptParameter()))
                    {
                        return View(DistModel);
                    }
                    if (string.IsNullOrEmpty(changepassword))
                    {
                        DMC.Password = "";
                        DMC.ConfirmPassword = "";
                    }
                    DMC.AgentID = DMC.AgentID.DecryptParameter();
                    DMC.UserID = DMC.UserID.DecryptParameter();
                }
                if (!string.IsNullOrEmpty(DMC.ParentID))
                {
                    if (string.IsNullOrEmpty(DMC.ParentID.DecryptParameter()))
                    {
                        return View(DistModel);
                    }
                    DMC.ParentID = DMC.ParentID.DecryptParameter();

                }

                DMC.ActionUser = ApplicationUtilities.GetSessionValue("UserName").ToString();
                DMC.IpAddress = ApplicationUtilities.GetIP();

                if (Agent_Logo != null)
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Agent_Logo.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Agent_Logo.FileName);
                    if (Agent_Logo.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(DistModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + ext.ToLower();
                        Agent_LogoPath = Path.Combine(Server.MapPath("~/Content/userupload/subdistributor"), myfilename);
                        DMC.AgentLogo = "/content/userupload/subdistributor/" + myfilename;
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(DistModel);
                    }
                }
                if (DMC.AgentOperationType.ToUpper() == "BUSINESS")
                {
                    if (Pan_Certiticate != null)
                    {
                        var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                        var fileName = Path.GetFileName(Pan_Certiticate.FileName);
                        String timeStamp = DateTime.Now.ToString();
                        var ext = Path.GetExtension(Pan_Certiticate.FileName);
                        if (Pan_Certiticate.ContentLength > 1 * 1024 * 1024)//1 MB
                        {
                            this.ShowPopup(1, "Image Size must be less than 1MB");
                            return View(DistModel);
                        }
                        if (allowedExtensions.Contains(ext.ToLower()))
                        {
                            string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                            string myfilename = "pan " + datet + ext.ToLower();
                            Pan_CertiticatePath = Path.Combine(Server.MapPath("~/Content/userupload/subdistributor"), myfilename);
                            DMC.AgentPanCertificate = "/content/userupload/subdistributor/" + myfilename;
                        }
                        else
                        {
                            this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                            return View(DistModel);
                        }
                    }

                    if (Registration_Certificate != null)
                    {
                        var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                        var fileName = Path.GetFileName(Registration_Certificate.FileName);
                        String timeStamp = DateTime.Now.ToString();
                        var ext = Path.GetExtension(Registration_Certificate.FileName);
                        if (Registration_Certificate.ContentLength > 1 * 1024 * 1024)//1 MB
                        {
                            this.ShowPopup(1, "Image Size must be less than 1MB");
                            return View(DistModel);
                        }
                        if (allowedExtensions.Contains(ext.ToLower()))
                        {
                            string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                            string myfilename = "reg " + datet+ext.ToLower();
                            Registration_CertificatePath = Path.Combine(Server.MapPath("~/Content/userupload/subdistributor"), myfilename);
                            DMC.AgentRegistrationCertificate = "/content/userupload/subdistributor/"+myfilename;
                            //Registration_Certificate.SaveAs(path);
                        }
                        else
                        {
                            this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                            return View(DistModel);
                        }
                    }
                }
                CommonDbResponse dbresp = buss.ManageSubDistributor(DMC);
                if (dbresp.Code == 0)
                {
                    if (DMC.AgentOperationType.ToUpper() == "BUSINESS")
                    {
                        if (Pan_Certiticate != null)
                        {
                            Pan_Certiticate.SaveAs(Pan_CertiticatePath);
                        }
                        if (Registration_Certificate != null)
                        {
                            Registration_Certificate.SaveAs(Registration_CertificatePath);
                        }
                    }
                    if (Agent_Logo != null)
                    {
                        Agent_Logo.SaveAs(Agent_LogoPath);
                    }

                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("Index",new { ParentId = DistModel.ParentID});
                }
                DistModel.Msg = dbresp.Message;

            }
            this.ShowPopup(1, "Error " + DistModel.Msg);
            return View(DistModel);

        }

        public JsonResult ExtendCreditLimit(string agentid)
        {
            SubDistributorManagementCommon amc = new SubDistributorManagementCommon();
            SubDistributorCreditLimitModel aclm = new SubDistributorCreditLimitModel();
            if (!string.IsNullOrEmpty(agentid))
            {
                string agent_id = agentid.DecryptParameter();
                if (!string.IsNullOrEmpty(agent_id))
                {
                    string username = ApplicationUtilities.GetSessionValue("UserName").ToString();
                    amc = buss.GetSubDistributorById(agent_id, username);
                    aclm.AgentId = amc.AgentID.EncryptParameter();
                    aclm.AgentName = amc.AgentName;
                    aclm.AgentCurrentCreditLimit = amc.AgentCreditLimit;

                    string value = string.Empty;
                    value = JsonConvert.SerializeObject(aclm, Formatting.Indented, new JsonSerializerSettings
                    {
                        ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                    });
                    return Json(value, JsonRequestBehavior.AllowGet);
                }
            }
            this.ShowPopup(1, "Error");
            return null;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public void ExtendCreditLimit(SubDistributorCreditLimitModel model)
        {
            if (ModelState.IsValid)
            {
                SubDistributorCreditLimitCommon clc = new SubDistributorCreditLimitCommon();
                clc = model.MapObject<SubDistributorCreditLimitCommon>();
                clc.AgentId = clc.AgentId.DecryptParameter();
                clc.ActionUser = ApplicationUtilities.GetSessionValue("UserName").ToString();
                clc.IpAddress = ApplicationUtilities.GetIP();
                CommonDbResponse dbresp = buss.ExtendCreditLimit(clc);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return;
                }
                this.ShowPopup(1, dbresp.Message);
                return;
            }
            this.ShowPopup(1, "Credit Limit Not Changed");
            return;
        }


        public JsonResult EnableSubDistributor(string AgentId)
        {
            if (!string.IsNullOrEmpty(AgentId))
            {
                if (!string.IsNullOrEmpty(AgentId.DecryptParameter()))
                {
                    SubDistributorManagementCommon DMC = new SubDistributorManagementCommon();
                    DMC.AgentID = AgentId.DecryptParameter();
                    DMC.IpAddress = ApplicationUtilities.GetIP();
                    DMC.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                    DMC.UserStatus = "Y";
                    CommonDbResponse dbresp = buss.Disable_EnableSubDistributor(DMC);
                    if (dbresp.ErrorCode == 0)
                    {
                        dbresp.Message = "Successfully Un-Blocked Agent";
                        dbresp.SetMessageInTempData(this);

                    }
                    return Json(dbresp);
                }

            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Agent." });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult DisableSubDistributor(string AgentId)
        {
            if (!string.IsNullOrEmpty(AgentId))
            {
                if (!string.IsNullOrEmpty(AgentId.DecryptParameter()))
                {
                    SubDistributorManagementCommon DMC = new SubDistributorManagementCommon();
                    DMC.AgentID = AgentId.DecryptParameter();
                    DMC.IpAddress = ApplicationUtilities.GetIP();
                    DMC.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                    DMC.UserStatus = "N";
                    CommonDbResponse dbresp = buss.Disable_EnableSubDistributor(DMC);
                    if (dbresp.ErrorCode == 0)
                    {
                        dbresp.Message = "Successfully Blocked Agent";
                        dbresp.SetMessageInTempData(this);

                    }
                    return Json(dbresp);
                }

            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Agent." });
        }




        #region login user
        public ActionResult ViewSubDistributorUser(string DistId = "")
        {
            var UserType = Session["UserType"].ToString();
            string username = ApplicationUtilities.GetSessionValue("username").ToString();
            string id = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString().Trim();
            /*if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                return RedirectToAction("Index", "SubDistributorManagement", new { DistId = Session["AgentId"].ToString() });
            }
            else if (UserType.ToUpper() == "DISTRIBUTOR")
            {
                id = Session["AgentId"].ToString();
            }
            else
            {
                id = DistId.DecryptParameter();
            }*/

            if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                id = Session["AgentId"].ToString();
            }
            else
            {
                id = DistId.DecryptParameter();
            }

            if (string.IsNullOrEmpty(id))
            {
                return RedirectToAction("Index");
            }
            var userId = "";
            if (String.IsNullOrEmpty(IsPrimary) == false && (IsPrimary.ToUpper().Trim() == "N" || IsPrimary.ToUpper().Trim() == ""))
            {
                userId = Session["UserId"].ToString();
            }
            var subDistributorCommons = buss.GetUserList(id, username, userId);
            //Actions
            foreach (var item in subDistributorCommons)
            {
                item.Action = StaticData.GetActions("SubDistributorManagementUser", item.UserID.EncryptParameter(), this, "", "", item.AgentID.EncryptParameter(), item.UserStatus, item.IsPrimary, DisableAddEdit: Session["UserId"].ToString() == item.UserID);
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
            var grid = ProjectGrid.MakeGrid(subDistributorCommons, "Sub-Distributor Users", "", 0, true, "", "", "Home", "Sub-Distributor", "/Admin/SubDistributorManagement", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ? "/Admin/SubDistributorManagement/ManageSubDistributorUsers?distid=" + id.EncryptParameter() : "");
            ViewData["grid"] = grid;
            return View();
        }

        // GET: Admin/Distributor/User/Id
        public ActionResult ManageSubDistributorUsers(string distid, string UserId = "")
        {
            var UserType = Session["UserType"].ToString();
            string distributor_id = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();
            //if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            //{
            //    return RedirectToAction("Index", "SubDistributor");
            //}
            //else if (UserType.ToUpper() == "DISTRIBUTOR")
            //{
            //    distributor_id = Session["AgentId"].ToString();
            //}
            //else
            //{
                distributor_id = distid.DecryptParameter();
            //}
            SubDistributorManagementCommon DMC = new SubDistributorManagementCommon();
            var user_id = UserId.DecryptParameter();
            if (string.IsNullOrEmpty(distributor_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewSubDistributorUser", new { DistId = distributor_id.EncryptParameter() });
                }
                string username = ApplicationUtilities.GetSessionValue("username").ToString();
                DMC = buss.GetUserById(distributor_id, user_id, username);
                DMC.UserID = user_id.EncryptParameter();
            }
            DMC.AgentID = distributor_id.EncryptParameter();
            SubDistributorManagementModel DMM = DMC.MapObject<SubDistributorManagementModel>();
            LoadDropDownList(DMM);
            return View(DMM);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageSubDistributorUsers(SubDistributorManagementModel DMM)
        {
            //RemoveAgentValidation(dcommon);
            //RemoveContactPersonValidation(dcommon);
            LoadDropDownList(DMM);
            RemoveAgentValidation(DMM);
            SubDistributorManagementCommon DMC = new SubDistributorManagementCommon();
            DMC = DMM.MapObject<SubDistributorManagementCommon>();
            if (!string.IsNullOrEmpty(DMC.UserID))
            {
                ModelState.Remove("Password");
                ModelState.Remove("ConfirmPassword");
                ModelState.Remove("username");
            }
            if (ModelState.IsValid)
            {
                if (!string.IsNullOrEmpty(DMC.UserID))
                {

                    DMC.UserID = DMC.UserID.DecryptParameter();
                }
                if (!string.IsNullOrEmpty(DMC.AgentID))
                {
                    DMC.AgentID = DMC.AgentID.DecryptParameter();
                }
                DMC.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                DMC.IpAddress = ApplicationUtilities.GetIP();
                CommonDbResponse dbresp = buss.ManageUser(DMC);
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    this.ShowPopup(0, "Save Succesfully");
                    return RedirectToAction("ViewSubDistributorUser", new { DistId = DMC.AgentID.EncryptParameter() });
                }
                DMC.Msg = dbresp.Message;
            }
            this.ShowPopup(1, "Save unsuccessful!"+ DMC.Msg);
            return View(DMM);
        }

        [HttpGet]
        public ActionResult AssignRole(string distid, string UserId = "")
        {
            SubDistributorManagementRolesModel distributormodel = new SubDistributorManagementRolesModel();
            var distributor_id = distid.DecryptParameter();
            var user_id = UserId.DecryptParameter();
            if (string.IsNullOrEmpty(distributor_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewSubDistributorUser", new { DistId = distributor_id.EncryptParameter() });
                }
            }
            string username = ApplicationUtilities.GetSessionValue("username").ToString();
            var dist = buss.getSubDistributorRoleAssigned(distributor_id, user_id, username);
            if (dist.UserId != null)
            {
                LoadUserDropdownlist(distributormodel);

                distributormodel.AgentId = dist.AgentId.EncryptParameter();
                distributormodel.UserId = dist.UserId.EncryptParameter();
                distributormodel.RoleId = dist.RoleId;
                distributormodel.IsPrimary = dist.IsPrimary;
                return View(distributormodel);
            }
            return RedirectToAction("ViewSubDistributorUser", new { DistId = distributor_id.DecryptParameter() });
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AssignRole(SubDistributorManagementRolesModel dcommon)
        {
            var distributor_id = dcommon.AgentId.DecryptParameter();
            var user_id = dcommon.UserId.DecryptParameter();
            if (string.IsNullOrEmpty(distributor_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(dcommon.UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewSubDistributorUser", new { DistId = distributor_id.EncryptParameter() });
                }
            }
            if (ModelState.IsValid)
            {
                var isPrimary = "n";
                if (dcommon.IsPrimary == "on")
                {
                    isPrimary = "y";
                }
                CommonDbResponse dbresp = buss.AssignSubDistributorRole(distributor_id, user_id, dcommon.RoleId, isPrimary);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, "Role Assigned Successfully.");
                    return RedirectToAction("ViewSubDistributorUser", new { DistId = distributor_id.EncryptParameter() });
                }
            }
            this.ShowPopup(1, "Failed to assign role to user!");
            return View(dcommon);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult BlockUser(string userid, string agentid)
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

            if (!String.IsNullOrEmpty(agentid))
            {
                agentid = agentid.DecryptParameter();
                if (string.IsNullOrEmpty(agentid))
                {
                    data = new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." };
                    valid = false;
                }
            }
            if (valid)
            {
                SubDistributorManagementCommon DMC = new SubDistributorManagementCommon()
                {
                    UserID = userid,
                    AgentID = agentid,
                    UserStatus = "N",
                    ActionUser = ApplicationUtilities.GetSessionValue("username").ToString(),
                    IpAddress = ApplicationUtilities.GetIP()

                };
                data = buss.Disable_EnableSubDistributorUser(DMC);
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
        public JsonResult UnBlockUser(string userid, string agentid)
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

            if (!String.IsNullOrEmpty(agentid))
            {
                agentid = agentid.DecryptParameter();
                if (string.IsNullOrEmpty(agentid))
                {
                    data = new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." };
                    valid = false;
                }
            }
            if (valid)
            {
                SubDistributorManagementCommon DMC = new SubDistributorManagementCommon()
                {
                    UserID = userid,
                    AgentID = agentid,
                    UserStatus = "Y",
                    ActionUser = ApplicationUtilities.GetSessionValue("username").ToString(),
                    IpAddress = ApplicationUtilities.GetIP()

                };
                data = buss.Disable_EnableSubDistributorUser(DMC);
                if (data.ErrorCode == 0)
                {
                    data.Message = "Successfully Un Blocked User";
                }
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }

        #endregion





        public void RemoveAgentValidation(SubDistributorManagementModel AMM)
        {
            ModelState.Remove("AgentType");

            ModelState.Remove("ParentID");
            ModelState.Remove("AgentOperationType");
            ModelState.Remove("AgentCommissionType");
            ModelState.Remove("AgentStatus");
            ModelState.Remove("AgentName");
            ModelState.Remove("AgentPhoneNumber");
            ModelState.Remove("AgentMobileNumber");
            ModelState.Remove("AgentEmail");
            ModelState.Remove("AgentWebUrl");
            ModelState.Remove("AgentRegistrationNumber");
            ModelState.Remove("AgentPanNumber");
            ModelState.Remove("AgentContractDate");
            ModelState.Remove("AgentContractDate_BS");
            ModelState.Remove("AgentCountry");
            ModelState.Remove("AgentCountryCode");
            ModelState.Remove("AgentProvince");
            ModelState.Remove("AgentDistrict");
            ModelState.Remove("AgentVDC_Muncipality");
            ModelState.Remove("AgentWardNo");
            ModelState.Remove("AgentStreet");
            ModelState.Remove("AgentCreditLimit");
            ModelState.Remove("AgentBalance");
            ModelState.Remove("AgentLogo");
            ModelState.Remove("AgentRegistrationCertificate");
            ModelState.Remove("AgentPanCertificate");
            ModelState.Remove("FirstName");
            ModelState.Remove("MiddleName");
            ModelState.Remove("LastName");
            ModelState.Remove("ContactPersonName");
            ModelState.Remove("ContactPersonMobileNumber");
            ModelState.Remove("ContactPersonIdType");
            ModelState.Remove("ContactPersonIdNumber");
            ModelState.Remove("ContactPersonIdIssueCountry");
            ModelState.Remove("ContactPersonIdIssueDistrict");
            ModelState.Remove("ContactPersonIdIssueDate");
            ModelState.Remove("ContactPersonIdIssueDate_BS");
            ModelState.Remove("ContactPersonIdExpiryDate");
            ModelState.Remove("ContactPersonIdExpiryDate_BS");
        }




        public void RemoveBusinessValidation(SubDistributorManagementModel AMM)
        {
            ModelState.Remove("AgentPhoneNumber");
            ModelState.Remove("AgentMobileNumber");
            ModelState.Remove("AgentEmail");
            ModelState.Remove("AgentWebUrl");
            ModelState.Remove("AgentRegistrationNumber");
            ModelState.Remove("AgentPanNumber");
            ModelState.Remove("AgentContractDate");
            ModelState.Remove("AgentContractDate_BS");
            ModelState.Remove("AgentRegistrationCertificate");
            ModelState.Remove("AgentPanCertificate");
            ModelState.Remove("ContactPersonName");
            ModelState.Remove("ContactPersonMobileNumber");
            ModelState.Remove("ContactPersonIdType");
            ModelState.Remove("ContactPersonIdNumber");
            ModelState.Remove("ContactPersonIdIssueCountry");
            ModelState.Remove("ContactPersonIdIssueDistrict");
            ModelState.Remove("ContactPersonIdIssueDate");
            ModelState.Remove("ContactPersonIdIssueDate_BS");
            ModelState.Remove("ContactPersonIdExpiryDate");
            ModelState.Remove("ContactPersonIdExpiryDate_BS");
            AMM.AgentPhoneNumber = "";
            AMM.AgentMobileNumber = "";
            AMM.AgentEmail = "";
            AMM.AgentWebUrl = "";
            AMM.AgentRegistrationNumber = "";
            AMM.AgentPanNumber = "";
            AMM.AgentContractDate = "";
            AMM.AgentContractDate_BS = "";
            AMM.ContactPersonName = "";
            AMM.ContactPersonMobileNumber = "";
            AMM.ContactPersonIdType = "";
            AMM.ContactPersonIdNumber = "";
            AMM.ContactPersonIdIssueCountry = "";
            AMM.ContactPersonIdIssueDistrict = "";
            AMM.ContactPersonIdIssueDate = "";
            AMM.ContactPersonIdIssueDate_BS = "";
            AMM.ContactPersonIdExpiryDate = "";
            AMM.ContactPersonIdExpiryDate_BS = "";
        }
        public void RemoveupdateValidation(SubDistributorManagementModel AMM)
        {
            ModelState.Remove("FirstName");
            ModelState.Remove("MiddleName");
            ModelState.Remove("LastName");
            ModelState.Remove("Username");
            ModelState.Remove("Password");
            ModelState.Remove("confirmPassword");
            ModelState.Remove("UserMobileNumber");
            ModelState.Remove("UserEmail");
        }

        public void LoadDropDownList(SubDistributorManagementModel DMM)
        {

            //Manage Distributor
            ViewBag.AgentCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), DMM.AgentCountry, "--select Country--");
            ViewBag.AgentProvinceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", DMM.AgentCountry), DMM.AgentProvince, "--select Provience--");
            ViewBag.AgentDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", DMM.AgentProvince) as Dictionary<string, string>, DMM.AgentDistrict, "--select District--");
            ViewBag.AgentVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", DMM.AgentDistrict), DMM.AgentVDC_Muncipality, "--select VDC Muncipality--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), DMM.ContactPersonIdIssueDistrict, "--Select District--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), DMM.ContactPersonIdType, "--Select Document Type--");
        }
        public void LoadUserDropdownlist(SubDistributorManagementRolesModel DMR)
        {
            ViewBag.usertype = ApplicationUtilities.SetDDLValue(LoadDropdownList("usertype"), DMR.RoleId, "--Select User Type--");
            ViewBag.Primary = ApplicationUtilities.SetDDLValue(LoadDropdownList("isprimary"), DMR.IsPrimary, "--Select Primary--");
        }
        public Dictionary<string, string> LoadDropdownList(string flag, string search1 = "")
        {
            switch (flag)
            {

                case "country":
                    return ICB.sproc_get_dropdown_list("004");
                case "gender":
                    return ICB.sproc_get_dropdown_list("005");
                case "occupation":
                    return ICB.sproc_get_dropdown_list("024");
                case "doctype":
                    return ICB.sproc_get_dropdown_list("014");
                case "province":
                    return ICB.sproc_get_dropdown_list("002");
                case "issuedistrict":
                    return ICB.sproc_get_dropdown_list("007");
                case "userRole":
                    return ICB.sproc_get_dropdown_list("035");
                case "districtList":
                    return ICB.sproc_get_dropdown_list("007", search1);
                case "vdc_muncipality":
                    return ICB.sproc_get_dropdown_list("008", search1);
                case "usertype":

                    Dictionary<string, string> dict1 = new Dictionary<string, string>();
                    dict1.Add("1", "Manager");
                    dict1.Add("2", "User");

                    return dict1;

                case "isprimary":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("Y", "Yes");
                        dict.Add("N", "No");
                        return dict;
                    };

            }
            return null;
        }
        [HttpPost]
        [OverrideActionFilters]
        public JsonResult GetDistrictsByProvince(string provinceId)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", provinceId) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }
        [HttpPost]
        [OverrideActionFilters]
        public JsonResult GetMuncipalityByDistrict(string district)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", district) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }
    }
}
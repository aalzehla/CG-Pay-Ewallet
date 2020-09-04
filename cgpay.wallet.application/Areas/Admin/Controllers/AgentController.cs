using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.Agent;
using cgpay.wallet.shared.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class AgentController : Controller
    {
        IAgentBusiness _Agent;
        ICommonBusiness ICB;
        public AgentController(IAgentBusiness Agent, ICommonBusiness _ICB)
        {
            _Agent = Agent;
            ICB = _ICB;
        }
        // GET: Admin/Agent
        public ActionResult Index(string ParentId = "")
        {
            var parentId = "";
            if (!string.IsNullOrEmpty(ParentId))
                parentId = ParentId.DecryptParameter();
            if (string.IsNullOrEmpty(parentId))
            {
                return RedirectToAction("Index", "Distributor");
            }
            var AgentCommon = _Agent.GetAgentList(parentId);
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("AgentName", "Agent Name");
            param.Add("AgentOperationType", "Operation Type");
            param.Add("AgentMobileNumber", "Contact Number");
            param.Add("AgentStatus", "Agent Status");
            param.Add("kycstatus", "Kyc Status");

            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            foreach (var item in AgentCommon)
            {
                // item.Action = StaticData.GetActions("Agent", item.AgentId.EncryptParameter(), this, "", "", "");
                item.Action = StaticData.GetActions("Agent", item.AgentID.EncryptParameter(), this, "", "", item.UserName.EncryptParameter(), item.ParentId.EncryptParameter());
            }
            var grid = ProjectGrid.MakeGrid(AgentCommon, "Agent List ", "", 0, true, "", "", "Home", "Agent", "/Admin/Agent", "/Admin/Agent/Manage?ParentId=" + parentId.EncryptParameter());
            ViewData["grid"] = grid;
            return View();
        }

        // GET: Admin/Agent/Manage/Id
        [HttpGet]
        public ActionResult Manage(string ParentId = "", string AgentId = "", string UserName = "")
        {
            shared.Models.AgentCommon Agentmodel = new shared.Models.AgentCommon();

            Agentmodel.ParentId = ParentId.DecryptParameter();
           
                Agentmodel.AgentID = AgentId.DecryptParameter();
                     
            if (!string.IsNullOrEmpty(ParentId))
                if (string.IsNullOrEmpty(Agentmodel.ParentId))
                    return RedirectToAction("Index", "Distributor");
            if (string.IsNullOrEmpty(AgentId) == false)
                if (string.IsNullOrEmpty(Agentmodel.AgentID))
                    return RedirectToAction("Index", new { ParentId = Agentmodel.ParentId.EncryptParameter() });
            // Agentmodel.UserName = UserName;
            if (!String.IsNullOrEmpty(Agentmodel.AgentID))
            {

                Agentmodel = _Agent.GetAgentById(Agentmodel.AgentID, Agentmodel.ParentId, Session["Username"].ToString());
                //Agentmodel.AgentId = Agentmodel.AgentId.EncryptParameter();
                Agentmodel.AgentID = Agentmodel.AgentID.EncryptParameter();
            }
            LoadDropDownList(Agentmodel);
            return View(Agentmodel);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Manage(AgentCommon DModel, HttpPostedFileBase Agent_Logo, HttpPostedFileBase Pan_Certiticate, HttpPostedFileBase Registration_Certificate)
        {
            var Agent_LogoPath = "";
            var Pan_CertiticatePath = "";
            var Registration_CertificatePath = "";
            string op_type = DModel.AgentOperationType;
            //string temp_address = DModel..ToString();
            var ParentId = DModel.ParentId.DecryptParameter();
    if (DModel.AgentID != null)
    {
        var AgentId = DModel.AgentID.DecryptParameter();
            }
            if (!string.IsNullOrEmpty(DModel.ParentId))
                if (string.IsNullOrEmpty(ParentId))
                    return RedirectToAction("Index", "Distributor");
            if (string.IsNullOrEmpty(DModel.AgentID) == false)
                if (string.IsNullOrEmpty(DModel.AgentID))
                    return RedirectToAction("Index", new { ParentId = ParentId.EncryptParameter() });
            if (!string.IsNullOrEmpty(DModel.AgentID))
            {
                RemoveUpdateValidation(DModel);
            }
            if (string.IsNullOrEmpty(DModel.AgentID))
            {
                RemoveUpdateValidation(DModel);
            }
            if (DModel.AgentOperationType == "Individual")
            {
                RemoveContactPersonValidation(DModel);
            }
            DModel.ParentId = ParentId;
            DModel.AgentID = DModel.AgentID ?? "";
            LoadDropDownList(DModel);
            if (ModelState.IsValid)
            {
                string username = Session["UserName"].ToString();
                if (string.IsNullOrEmpty(DModel.AgentID))
                {
                    if (!string.IsNullOrEmpty(DModel.AgentID.DecryptParameter()))
                    {
                        return View("Manage", DModel);
                    }
                    DModel.AgentID = DModel.AgentID.DecryptParameter();
                }
                if (DModel.AgentID == null)
                {
                    DModel.AgentID = "''";
                }
                DModel.ActionUser = Session["username"].ToString();
                DModel.IpAddress = ApplicationUtilities.GetIP();


                if (Pan_Certiticate != null)
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Pan_Certiticate.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Pan_Certiticate.FileName);
                    if (Pan_Certiticate.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(DModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + "." + Pan_Certiticate.FileName;
                        Pan_CertiticatePath = Path.Combine(Server.MapPath("~/Content/assets/images/Agent_image"), myfilename);
                        DModel.AgentPanCertificate = myfilename;
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(DModel);
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
                        return View(DModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + "." + Registration_Certificate.FileName;
                        Registration_CertificatePath = Path.Combine(Server.MapPath("~/Content/assets/images/Agent_image"), myfilename);
                        DModel.AgentRegistrationCertificate = myfilename;
                        //Registration_Certificate.SaveAs(path);
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(DModel);
                    }
                }


                if (Agent_Logo != null)
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Agent_Logo.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Agent_Logo.FileName);
                    if (Agent_Logo.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(DModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + "." + Agent_Logo.FileName;
                        Agent_LogoPath = Path.Combine(Server.MapPath("~/Content/assets/images/Agent_image"), myfilename);
                        DModel.AgentLogo = myfilename;
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(DModel);
                    }
                }
                //DModel.AgentId = DModel.AgentId.DecryptParameter();
                CommonDbResponse dbresp = _Agent.ManageAgent(DModel, username);

                //if (dbresp.Code == 0)
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    if (!string.IsNullOrEmpty(Agent_LogoPath))
                    {
                        Agent_Logo.SaveAs(Agent_LogoPath);
                    }
                    if (!string.IsNullOrEmpty(Registration_CertificatePath))
                    {
                        Registration_Certificate.SaveAs(Registration_CertificatePath);
                    }
                    if (!string.IsNullOrEmpty(Pan_CertiticatePath))
                    {
                        Pan_Certiticate.SaveAs(Pan_CertiticatePath);
                    }
                    //SaveImages On Success
                    //Ends SaveImages
                    this.ShowPopup(0, "Saved Succesfully");
                    return RedirectToAction("Index", new { ParentId = ParentId.EncryptParameter() });
                }
            }
            this.ShowPopup(1, "Please fill out all the field stating * (Mandatory)");
            return View(DModel);
        }

        // GET: Admin/Agent/ViewUser
        public ActionResult ViewAgentUser(string AgentId = "", string ParentId = "")
        {
            var _ParentID = ParentId.DecryptParameter();
            var _AgentID = AgentId.DecryptParameter();
            if (!string.IsNullOrEmpty(ParentId))
                if (string.IsNullOrEmpty(_ParentID))
                    return RedirectToAction("Index", new { ParentId = _ParentID.EncryptParameter() });
            if (string.IsNullOrEmpty(AgentId) == false)
                if (string.IsNullOrEmpty(_AgentID))
                    return RedirectToAction("Index", new { ParentId = _ParentID.EncryptParameter(), AgentId = _AgentID.EncryptParameter() });

            var AgentCommon = _Agent.GetUserList(_AgentID);
            //Actions
            foreach (var item in AgentCommon)
            {
                item.Action = StaticData.GetActions("ViewAgentUser", item.UserId.EncryptParameter(), this, "", "", item.AgentID.EncryptParameter(), item.UserStatus,_ParentID.EncryptParameter());
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("AgentId", "Agent Id");
            param.Add("UserFullName", "Fullname");
            param.Add("UserName", "Username");
            param.Add("UserEmail", "Email");
            param.Add("UserMobileNo", "Mobile No");
            param.Add("UserType", "User Type");
            param.Add("isPrimary", "Is primary");
            param.Add("UserStatus", "Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            //Add New
            var grid = ProjectGrid.MakeGrid(AgentCommon, "Agent Users", "", 0, true, "", "", "Home", "Agent", "/Admin/Agent", "/Admin/Agent/ManageAgentUsers?AgentId=" + _AgentID.EncryptParameter());
            ViewData["grid"] = grid;
            return View();
        }

        // GET: Admin/Agent/User/Id
        public ActionResult ManageAgentUsers(string AgentId, string UserId = "")
        {
            shared.Models.AgentCommon Agentmodel = new shared.Models.AgentCommon();
            var Agent_id = AgentId.DecryptParameter();
            var user_id = UserId.DecryptParameter();
            if (string.IsNullOrEmpty(Agent_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewAgentUser", new { AgentId = Agent_id.EncryptParameter() });
                }
                Agentmodel = _Agent.GetUserById(Agent_id, user_id);
                Agentmodel.UserId = user_id.EncryptParameter();
            }
            Agentmodel.AgentID = Agent_id.EncryptParameter();
            LoadDropDownList(Agentmodel);
            return View(Agentmodel);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageAgentUsers(AgentCommon dcommon)
        {
            RemoveAgentValidation(dcommon);
            RemoveContactPersonValidation(dcommon);
            if (!string.IsNullOrEmpty(dcommon.UserId))
            {
                ModelState.Remove("Password");
                ModelState.Remove("ConfirmPassword");
            }
            if (ModelState.IsValid)
            {
                if (!string.IsNullOrEmpty(dcommon.UserId))
                {

                    dcommon.UserId = dcommon.UserId.DecryptParameter();
                }
                if (!string.IsNullOrEmpty(dcommon.AgentID))
                {
                    dcommon.AgentID = dcommon.AgentID.DecryptParameter();
                }
                LoadDropDownList(dcommon);
                CommonDbResponse dbresp = _Agent.ManageUser(dcommon);
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    this.ShowPopup(0, "Save Succesfully");
                    return RedirectToAction("ViewAgentUser", new { AgentId = dcommon.AgentID.EncryptParameter() });
                }
            }
            this.ShowPopup(1, "Save unsuccessful.Please try again!");
            return View(dcommon);
        }

        [HttpGet]
        public ActionResult AssignRole(string AgentId, string UserId = "")
        {
            AgentRoles Agentmodel = new AgentRoles();
            var Agent_id = AgentId.DecryptParameter();
            var user_id = UserId.DecryptParameter();
            if (string.IsNullOrEmpty(Agent_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewAgentUser", new { AgentId = Agent_id.EncryptParameter() });
                }
            }
            var dist = _Agent.getAgentRoleAssigned(Agent_id, user_id);
            LoadRolesDropdownList(Agentmodel);
            Agentmodel.AgentId = Agent_id.EncryptParameter();
            Agentmodel.UserId = user_id.EncryptParameter();
            Agentmodel.RoleId = dist.Extra2;
            Agentmodel.IsPrimary = dist.Extra1;
            return View(Agentmodel);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AssignRole(AgentRoles dcommon)
        {
            var Agent_id = dcommon.AgentId.DecryptParameter();
            var user_id = dcommon.UserId.DecryptParameter();
            LoadRolesDropdownList(dcommon);
            if (string.IsNullOrEmpty(Agent_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(dcommon.UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewAgentUser", new { AgentId = Agent_id.EncryptParameter() });
                }
            }
            if (ModelState.IsValid)
            {
                var isPrimary = "n";
                if (dcommon.IsPrimary == "on")
                {
                    isPrimary = "y";
                }
                CommonDbResponse dbresp = _Agent.AssignAgentRole(Agent_id, user_id, dcommon.RoleId, isPrimary);
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    this.ShowPopup(0, "Role Assigned Successfully.");
                    return RedirectToAction("ViewAgentUser", new { AgentId = Agent_id.EncryptParameter() });
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

                data = _Agent.block_unblockuser(userid, "N", agentid);
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

                data = _Agent.block_unblockuser(userid, "Y", agentid);
                if (data.ErrorCode == 0)
                {
                    data.Message = "Successfully Un Blocked User";
                }
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }
        public void RemoveContactPersonValidation(AgentCommon SDM)
        {
            ModelState.Remove("ContactPersonName");
            ModelState.Remove("ContactPersonAddress");
            ModelState.Remove("ContactPersonNumber");
            ModelState.Remove("ContactPersonIDtype");
            ModelState.Remove("ContactPersonIDNumber");
            ModelState.Remove("ContactPersonIDIssueDate");
            ModelState.Remove("ContactPersonIDIssueDate_BS");
            ModelState.Remove("ContactPersonIDExpiryDate");
            ModelState.Remove("ContactPersonIDExpiryDate_BS");
            ModelState.Remove("ContactPersonIDIssueDistrict");
        }
        public void RemoveAgentValidation(AgentCommon SDM)
        {
            ModelState.Remove("AgentType");
            ModelState.Remove("AgentID");
            ModelState.Remove("AgentOperationType");
            ModelState.Remove("isautocommission");
            ModelState.Remove("AgentName");
            ModelState.Remove("AgentMobileNumber");
            ModelState.Remove("AgentEmail");
            ModelState.Remove("AgentWebUrl");
            ModelState.Remove("AgentRegistrationNumber");
            ModelState.Remove("AgentPanNo");
            ModelState.Remove("AgentContractDate");
            ModelState.Remove("AgentAddress");
            ModelState.Remove("AgentLatitude");
            ModelState.Remove("AgentLongitude");
            ModelState.Remove("AgentCreditLimit");
            ModelState.Remove("AgentBalance");
            ModelState.Remove("AgentLogo");
            ModelState.Remove("AgentRegistrationCertificate");
            ModelState.Remove("AgentPanCertificate");
            ModelState.Remove("FirstName");
            ModelState.Remove("MiddleName");
            ModelState.Remove("LastName");
            ModelState.Remove("DOB_AD");
            ModelState.Remove("DOB_BS");
            ModelState.Remove("Gender");
            ModelState.Remove("Occupation");
            ModelState.Remove("Nationality");
            ModelState.Remove("PermanentCountry");
            ModelState.Remove("PermanentProvince");
            ModelState.Remove("PermanentDistrict");
            ModelState.Remove("PermanentVDC_Muncipality");
            ModelState.Remove("PermanentWardNo");
            ModelState.Remove("PermanentStreet");
            ModelState.Remove("TemporaryCountry");
            ModelState.Remove("TemporaryProvince");
            ModelState.Remove("TemporaryDistrict");
            ModelState.Remove("TemporaryVDC_Muncipality");
            ModelState.Remove("TemporaryWardNo");
            ModelState.Remove("TemporaryStreet");
        }

        public void RemoveUpdateValidation(AgentCommon SDM)
        {
            ModelState.Remove("AgentOperationType");
            ModelState.Remove("UserId");
            ModelState.Remove("UserName");
            ModelState.Remove("UserFullName");
            ModelState.Remove("UserEmail");
            ModelState.Remove("UserMobileNo");
            ModelState.Remove("UserType");
            ModelState.Remove("UserTypeId");
            ModelState.Remove("Password");
            ModelState.Remove("ConfirmPassword");
        }
        public void LoadDropDownList(AgentCommon Agentmodel)
        {

            //Manage Agent
            ViewBag.PermanentCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), Agentmodel.PermanentCountry, "--Permanent Country--");
            ViewBag.PermanentProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", Agentmodel.PermanentCountry), Agentmodel.PermanentProvince, "--Permanent Provience--");
            ViewBag.PermanentDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", Agentmodel.PermanentProvince) as Dictionary<string, string>, Agentmodel.PermanentDistrict, "--Permanent District--");
            ViewBag.PermanentVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", Agentmodel.PermanentDistrict), Agentmodel.PermanentVDC_Muncipality, "--Permanent VDC Muncipality--");

            ViewBag.TemporarytCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), Agentmodel.TemporaryCountry, "--Temporary Country--");
            ViewBag.TemporaryProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", Agentmodel.TemporaryCountry), Agentmodel.TemporaryProvince, "--Temporary Provience--");
            ViewBag.TemporaryDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", Agentmodel.TemporaryProvince), Agentmodel.TemporaryDistrict, "--Temporary District--");
            ViewBag.TemporaryVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", Agentmodel.TemporaryDistrict), Agentmodel.TemporaryVDC_Muncipality, "--Temporary VDC Muncipality--");

            ViewBag.GenderList = ApplicationUtilities.SetDDLValue(LoadDropdownList("gender"), Agentmodel.Gender, "--Select Gender--");
            ViewBag.OccupationList = ApplicationUtilities.SetDDLValue(LoadDropdownList("occupation"), Agentmodel.Occupation, "--Select Occupation--");
            ViewBag.Nationalitylist = ApplicationUtilities.SetDDLValue(LoadDropdownList("nationality"), Agentmodel.Nationality, "--Select Nationality--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), Agentmodel.Nationality, "--Select Document Type--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), Agentmodel.Nationality, "--Select District--");
        }
        public void LoadRolesDropdownList(AgentRoles model)
        {
            model.RolesList = ApplicationUtilities.SetDDLValue(LoadDropdownList("userRole"), model.RoleId, "--Select Role--");
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
                    return ICB.sproc_get_dropdown_list("037");
                case "districtList":
                    return ICB.sproc_get_dropdown_list("007", search1);
                case "vdc_muncipality":
                    return ICB.sproc_get_dropdown_list("008", search1);
                case "nationality":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("Nepali", "Nepali");
                        dict.Add("Indian", "Indian");
                        dict.Add("Chinese", "Chinese");
                        dict.Add("Others", "Others");
                        return dict;
                    };
                case "usertype":

                    Dictionary<string, string> dict1 = new Dictionary<string, string>();
                    dict1.Add("1|Manager", "Manager");
                    dict1.Add("2|User", "User");

                    return dict1;

                case "isprimary":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("Yes", "Yes");
                        dict.Add("No", "No");
                        return dict;
                    };
                case "status":
                    Dictionary<string, string> dict2 = new Dictionary<string, string>();
                    dict2.Add("Y", "Enable");
                    dict2.Add("N", "Disable");

                    return dict2;
            }
            return null;
        }
        [OverrideActionFilters]
        [HttpPost]
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

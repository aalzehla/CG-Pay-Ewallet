using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.Distributor;
using cgpay.wallet.shared.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Mvc;


namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class DistributorController : Controller
    {
        IDistributorBusiness _distributor;
        ICommonBusiness ICB;
        public DistributorController(IDistributorBusiness distributor, ICommonBusiness _ICB)
        {
            _distributor = distributor;
            ICB = _ICB;
        }
        // GET: Admin/Distributor
        public ActionResult Index()
        {
            var UserType = Session["UserType"].ToString();
            string AgentId = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();
            if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                return RedirectToAction("Index", "SubDistributor");
            }
            else if (UserType.ToUpper() == "DISTRIBUTOR")
            {
                AgentId = Session["AgentId"].ToString();
            }
            var DistributorCommon = _distributor.GetDistributorList(AgentId);
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
            foreach (var item in DistributorCommon)
            {
                
                // item.Action = StaticData.GetActions("Distributor", item.DistributorId.EncryptParameter(), this, "", "", "");
                item.Action = StaticData.GetActions("Distributor", item.AgentID.EncryptParameter(), this, "", "", item.UserName.EncryptParameter());
				item.kycstatus = "<span class='badge badge-" + (item.kycstatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.kycstatus.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
            }
            var grid = ProjectGrid.MakeGrid(DistributorCommon, "Distributor List ", "", 0, true, "", "", "Home", "Distributor", "/Admin/Distributor", String.IsNullOrEmpty(IsPrimary)==false&&IsPrimary.ToUpper().Trim()=="Y"?"/Admin/Distributor/Manage":"");
            ViewData["grid"] = grid;
            return View();
        }

        // GET: Admin/Distributor/Manage/Id
        [HttpGet]
        public ActionResult Manage(string DistId = "", string UserName = "")
        {
            shared.Models.DistributorCommon distributormodel = new shared.Models.DistributorCommon();

            distributormodel.AgentID = DistId.DecryptParameter();
            if (!string.IsNullOrEmpty(DistId))
                if (string.IsNullOrEmpty(distributormodel.AgentID))
                    return RedirectToAction("Index");
            // distributormodel.UserName = UserName;
            if (!String.IsNullOrEmpty(distributormodel.AgentID))
            {

                distributormodel = _distributor.GetDistributorById(distributormodel.AgentID, Session["Username"].ToString());
                //distributormodel.DistributorId = distributormodel.DistributorId.EncryptParameter();
                distributormodel.AgentID = distributormodel.AgentID.EncryptParameter();
            }
            LoadDropDownList(distributormodel);
            return View(distributormodel);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Manage(DistributorCommon DModel, HttpPostedFileBase Agent_Logo, HttpPostedFileBase Pan_Certiticate, HttpPostedFileBase Registration_Certificate)
        {
            string DistId = "";
            var Agent_LogoPath = "";
            var Pan_CertiticatePath = "";
            var Registration_CertificatePath = "";
            string op_type = DModel.AgentOperationType;
            //string temp_address = DModel..ToString();
            DistId = DModel.AgentID;
            if (!string.IsNullOrEmpty(DModel.AgentID))
            {
                RemoveUpdateValidation(DModel);
                ModelState.Remove("ContactPersonIDExpiryDate");
                ModelState.Remove("ContactPersonIDExpiryDate_BS");
            }
            if (DModel.AgentOperationType == "Individual")
            {
                RemoveContactPersonValidation(DModel);
            }
            LoadDropDownList(DModel);
            if (ModelState.IsValid)
            {
                string username = Session["UserName"].ToString();
                if (!string.IsNullOrEmpty(DModel.AgentID))
                {
                    if (string.IsNullOrEmpty(DModel.AgentID.DecryptParameter()))
                    {
                        return View("Manage", DModel);
                    }
                    DModel.AgentID = DModel.AgentID.DecryptParameter();
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
                        Pan_CertiticatePath = Path.Combine(Server.MapPath("~/Content/assets/images/distributor_image"), myfilename);
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
                        Registration_CertificatePath = Path.Combine(Server.MapPath("~/Content/assets/images/distributor_image"), myfilename);
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
                        Agent_LogoPath = Path.Combine(Server.MapPath("~/Content/assets/images/distributor_image"), myfilename);
                        DModel.AgentLogo = myfilename;
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(DModel);
                    }
                }
                //DModel.DistributorId = DModel.DistributorId.DecryptParameter();
                CommonDbResponse dbresp = _distributor.ManageDistributor(DModel, username);

                if (dbresp.Code == 0)
                // if (dbresp.Code == shared.Models.ResponseCode.Success)
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
                    return RedirectToAction("Index");
                }
            }
            this.ShowPopup(1, "Please fill out all the field stating * (Mandatory)");
            return View(DModel);
        }

        // GET: Admin/Distributor/ViewUser
        public ActionResult ViewDistributorUser(string DistId = "")
        {
            var UserType = Session["UserType"].ToString();
            string id = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString().Trim();
            if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                return RedirectToAction("Index", "SubDistributor",new { DistId = Session["AgentId"].ToString() });
            }
            else if (UserType.ToUpper() == "DISTRIBUTOR")
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
            if (String.IsNullOrEmpty(IsPrimary) == false && (IsPrimary.ToUpper().Trim() == "N"|| IsPrimary.ToUpper().Trim() == ""))
            {
                userId = Session["UserId"].ToString();
            }
            var DistributorCommon = _distributor.GetUserList(id,userId);
            //Actions
            foreach (var item in DistributorCommon)
            {
                item.Action = StaticData.GetActions("ViewDistributorUser", item.UserId.EncryptParameter(), this, "", "", item.AgentID.EncryptParameter(), item.UserStatus, item.isPrimary,DisableAddEdit:Session["UserId"].ToString()==item.UserId);
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("DistributorId", "Agent Id");
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
            var grid = ProjectGrid.MakeGrid(DistributorCommon, "Distributor Users", "", 0, true, "", "", "Home", "Distributor", "/Admin/Distributor", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ? "/Admin/Distributor/ManageDistributorUsers?distid=" + id.EncryptParameter():"");
            ViewData["grid"] = grid;
            return View();
        }

        // GET: Admin/Distributor/User/Id
        public ActionResult ManageDistributorUsers(string distid, string UserId = "")
        {
            var UserType = Session["UserType"].ToString();
            string distributor_id="", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();
            if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                return RedirectToAction("Index", "SubDistributor");
            }
            else if (UserType.ToUpper() == "DISTRIBUTOR")
            {
                distributor_id = Session["AgentId"].ToString();
            }
            else
            {
                distributor_id = distid.DecryptParameter();
            }
            shared.Models.DistributorCommon distributormodel = new shared.Models.DistributorCommon();
            var user_id = UserId.DecryptParameter();
            if (string.IsNullOrEmpty(distributor_id))
            {
                return RedirectToAction("Index");
            }
            if (!string.IsNullOrEmpty(UserId))
            {
                if (string.IsNullOrEmpty(user_id))
                {
                    return RedirectToAction("ViewDistributorUser", new { DistId = distributor_id.EncryptParameter() });
                }
                distributormodel = _distributor.GetUserById(distributor_id, user_id);
                distributormodel.UserId = user_id.EncryptParameter();
            }
            distributormodel.AgentID = distributor_id.EncryptParameter();
            LoadDropDownList(distributormodel);
            return View(distributormodel);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageDistributorUsers(DistributorCommon dcommon)
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
                CommonDbResponse dbresp = _distributor.ManageUser(dcommon);
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    this.ShowPopup(0, "Save Succesfully");
                    return RedirectToAction("ViewDistributorUser", new { DistId = dcommon.AgentID.EncryptParameter() });
                }
            }
            this.ShowPopup(1, "Save unsuccessful.Please try again!");
            return View(dcommon);
        }

        [HttpGet]
        public ActionResult AssignRole(string distid, string UserId = "")
        {
            DistributorRoles distributormodel = new DistributorRoles();
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
                    return RedirectToAction("ViewDistributorUser", new { DistId = distributor_id.EncryptParameter() });
                }
            }
            var dist = _distributor.getDistributorRoleAssigned(distributor_id, user_id);
            LoadRolesDropdownList(distributormodel);
            distributormodel.AgentId = distributor_id.EncryptParameter();
            distributormodel.UserId = user_id.EncryptParameter();
            distributormodel.RoleId = dist.Extra2;
            distributormodel.IsPrimary = dist.Extra1;
            return View(distributormodel);
        }
        //Post
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AssignRole(DistributorRoles dcommon)
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
                    return RedirectToAction("ViewDistributorUser", new { DistId = distributor_id.EncryptParameter() });
                }
            }
            if (ModelState.IsValid)
            {
                var isPrimary = "n";
                if (dcommon.IsPrimary == "on")
                {
                    isPrimary = "y";
                }
                CommonDbResponse dbresp = _distributor.AssignDistributorRole(distributor_id, user_id, dcommon.RoleId, isPrimary);
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    this.ShowPopup(0, "Role Assigned Successfully.");
                    return RedirectToAction("ViewDistributorUser", new { DistId = distributor_id.EncryptParameter() });
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

                data = _distributor.block_unblockuser(userid, "N", agentid);
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

                data = _distributor.block_unblockuser(userid, "Y", agentid);
                if (data.ErrorCode == 0)
                {
                    data.Message = "Successfully Un Blocked User";
                }
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }
        public void RemoveContactPersonValidation(DistributorCommon SDM)
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
            ModelState.Remove("ContactPersonIDIssueCountry");
        }
        public void RemoveAgentValidation(DistributorCommon SDM)
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

        public void RemoveUpdateValidation(DistributorCommon SDM)
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
        public void LoadDropDownList(DistributorCommon distributormodel)
        {

            //Manage Distributor
            ViewBag.PermanentCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), distributormodel.PermanentCountry, "--Permanent Country--");
            ViewBag.PermanentProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", distributormodel.PermanentCountry), distributormodel.PermanentProvince, "--Permanent Provience--");
            ViewBag.PermanentDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", distributormodel.PermanentProvince) as Dictionary<string, string>, distributormodel.PermanentDistrict, "--Permanent District--");
            ViewBag.PermanentVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", distributormodel.PermanentDistrict), distributormodel.PermanentVDC_Muncipality, "--Permanent VDC Muncipality--");

            ViewBag.TemporarytCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), distributormodel.TemporaryCountry, "--Temporary Country--");
            ViewBag.TemporaryProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", distributormodel.TemporaryCountry), distributormodel.TemporaryProvince, "--Temporary Provience--");
            ViewBag.TemporaryDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", distributormodel.TemporaryProvince), distributormodel.TemporaryDistrict, "--Temporary District--");
            ViewBag.TemporaryVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", distributormodel.TemporaryDistrict), distributormodel.TemporaryVDC_Muncipality, "--Temporary VDC Muncipality--");

            ViewBag.GenderList = ApplicationUtilities.SetDDLValue(LoadDropdownList("gender"), distributormodel.Gender, "--Select Gender--");
            ViewBag.OccupationList = ApplicationUtilities.SetDDLValue(LoadDropdownList("occupation"), distributormodel.Occupation, "--Select Occupation--");
            ViewBag.Nationalitylist = ApplicationUtilities.SetDDLValue(LoadDropdownList("nationality"), distributormodel.Nationality, "--Select Nationality--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), distributormodel.Nationality, "--Select Document Type--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), distributormodel.Nationality, "--Select District--");
        }
        public void LoadRolesDropdownList(DistributorRoles model)
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
                    return ICB.sproc_get_dropdown_list("035");
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

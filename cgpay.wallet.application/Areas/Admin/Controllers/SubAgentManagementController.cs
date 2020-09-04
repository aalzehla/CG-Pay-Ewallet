using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.SubAgentManagement;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubAgentManagement;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class SubAgentManagementController : Controller
    {

        ICommonBusiness ICB;      
        ISubAgentManagementBusiness buss;
        public SubAgentManagementController(ICommonBusiness _ICB, ISubAgentManagementBusiness _ISA)
        {
            ICB = _ICB;
            buss = _ISA;
        }
        // GET: Admin/SubAgentManagement
        public ActionResult Index(string agentId = "", string UserName = "", string Search = "", int Pagesize = 10)
        {
            string username = ApplicationUtilities.GetSessionValue("username").ToString();
            var UserType = Session["UserType"].ToString();
            string AgentId = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();
            //if (UserType.ToUpper() == "SUB-AGENT")
            //{
            //    return RedirectToAction("Index", "SubAgentManagement");
            //}
            //else if (UserType.ToUpper() == "AGENT")
            //{
            //    AgentId = Session["AgentId"].ToString();
            //}
            if(!string.IsNullOrEmpty(agentId))
            {
                AgentId = agentId.DecryptParameter();
            }
            
            //string username = ApplicationUtilities.GetSessionValue("UserName").ToString();

            var SubAgentCommon = buss.GetSubAgentList(AgentId, username);
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("AgentName", "Agent Name");
            param.Add("AgentOperationType", "Operation Type");
            param.Add("AgentCreditLimit", "Credit Limit");
            param.Add("AgentMobileNumber", "Contact Number");
            param.Add("AgentStatus", "Agent Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            foreach (var item in SubAgentCommon)
            {
                item.Action = StaticData.GetActions("SubAgentManagement", item.AgentID.EncryptParameter(), this, "", "", username.EncryptParameter(),item.AgentStatus);
            }
            var grid = ProjectGrid.MakeGrid(SubAgentCommon, "Sub Agent List ", "", 0, true, "", "", "Home", "Agent", "/Admin/SubAgentManagement/Index", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ? "/Admin/SubAgentManagement/ManageSubAgent?parentid="+AgentId.EncryptParameter() : "");
            ViewData["grid"] = grid;
            SubAgentCreditLimitModel sam = new SubAgentCreditLimitModel();
            sam.ParentId = agentId;
            return View(sam);

        }

        public ActionResult ManageSubAgent(string UserName,string parentid="", string agentId = "")
        {
            SubAgentManagementModel SAM = new SubAgentManagementModel();
            SAM.ParentID = parentid;

            if (!string.IsNullOrEmpty(agentId))
            {
                SAM.AgentID = agentId.DecryptParameter();
                if (!string.IsNullOrEmpty(SAM.AgentID))
                {
                    SubAgentManagementCommon SAC = buss.GetSubAgentById(SAM.AgentID, UserName.DecryptParameter());
                    SAM = SAC.MapObject<SubAgentManagementModel>();
                    SAM.AgentID = SAM.AgentID.EncryptParameter();
                    SAM.UserID = SAM.UserID.EncryptParameter();
                    SAM.ParentID = SAM.ParentID.EncryptParameter();
                }
            }
           
                
            LoadDropDownList(SAM);
            return View(SAM);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ManageSubAgent(SubAgentManagementModel subagentModel, HttpPostedFileBase Agent_Logo, HttpPostedFileBase Pan_Certiticate, HttpPostedFileBase Registration_Certificate,string changepassword="")
        {

            var Agent_LogoPath = "";
            var Pan_CertiticatePath = "";
            var Registration_CertificatePath = "";
            ModelState.Remove("AgentContractDate_BS");
            ModelState.Remove("Action");
            LoadDropDownList(subagentModel);
            
            if (!string.IsNullOrEmpty(subagentModel.AgentID.DecryptParameter()))
            {
                ModelState.Remove("userName");
                if (changepassword.ToUpper() != "ON")
                {
                    RemoveupdateValidation(subagentModel);
                    subagentModel.Password = "";
                    subagentModel.ConfirmPassword = "";
                }
            }
            if (subagentModel.AgentOperationType.ToUpper() != "BUSINESS")
            {
                subagentModel.AgentMobileNumber = subagentModel.UserMobileNumber;
                subagentModel.AgentEmail = subagentModel.UserEmail;
                RemoveBusinessValidation(subagentModel);
            }
            if (ModelState.IsValid)
            {
                SubAgentManagementCommon AC = new SubAgentManagementCommon();
                AC = subagentModel.MapObject<SubAgentManagementCommon>();
                if (!string.IsNullOrEmpty(AC.AgentID))
                {
                    if (string.IsNullOrEmpty(AC.AgentID.DecryptParameter()))
                    {
                        return View(subagentModel);
                    }
                    //if (changepassword.ToUpper() != "ON")
                    //{
                    //    AC.Password = "";
                    //    AC.ConfirmPassword = "";
                    //}
                    AC.AgentID = AC.AgentID.DecryptParameter();
                    AC.UserID = AC.UserID.DecryptParameter();
                }
                if (!string.IsNullOrEmpty(AC.ParentID))
                {
                    if (string.IsNullOrEmpty(AC.ParentID.DecryptParameter()))
                    {
                        return View(subagentModel);
                    }
                    AC.ParentID = AC.ParentID.DecryptParameter();

                }
              

                AC.ActionUser = ApplicationUtilities.GetSessionValue("UserName").ToString();
                AC.IpAddress = ApplicationUtilities.GetIP();

                if (Agent_Logo != null)
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Agent_Logo.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Agent_Logo.FileName);
                    if (Agent_Logo.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(subagentModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet +ext.ToLower();
                        Agent_LogoPath = Path.Combine(Server.MapPath("~/Content/userupload/subagent"), myfilename);
                        AC.AgentLogo = "/Content/userupload/subagent/" + myfilename;
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(subagentModel);
                    }
                }
                if (AC.AgentOperationType.ToUpper() == "BUSINESS")
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
                            return View(subagentModel);
                        }
                        if (allowedExtensions.Contains(ext.ToLower()))
                        {
                            string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                            string myfilename = "pan " + datet + ext.ToLower();
                            Pan_CertiticatePath = Path.Combine(Server.MapPath("~/Content/userupload/subagent"), myfilename);
                            AC.AgentPanCertificate = "/Content/userupload/subagent/" + myfilename;
                        }
                        else
                        {
                            this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                            return View(subagentModel);
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
                            return View(subagentModel);
                        }
                        if (allowedExtensions.Contains(ext.ToLower()))
                        {
                            string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                            string myfilename = "reg " + datet + ext.ToLower();
                            Registration_CertificatePath = Path.Combine(Server.MapPath("~/Content/userupload/subagent"), myfilename);
                            AC.AgentRegistrationCertificate = "/Content/userupload/subagent/" + myfilename;
                            //Registration_Certificate.SaveAs(path);
                        }
                        else
                        {
                            this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                            return View(subagentModel);
                        }
                    }
                }
                CommonDbResponse dbresp = buss.ManageSubAgent(AC);
                if (dbresp.Code == 0)
                {
                    if (AC.AgentOperationType.ToUpper() == "BUSINESS")
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
                    return RedirectToAction("Index",new { agentId = subagentModel.ParentID});
                }
                subagentModel.Msg = dbresp.Message;

            }
            this.ShowPopup(1, "Error " + subagentModel.Msg);
            return View(subagentModel);

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


        public JsonResult ExtendCreditLimit(string agentid)
        {
            SubAgentManagementCommon amc = new SubAgentManagementCommon();
            SubAgentCreditLimitModel aclm = new SubAgentCreditLimitModel();
            if (!string.IsNullOrEmpty(agentid))
            {
                string agent_id = agentid.DecryptParameter();
                if (!string.IsNullOrEmpty(agent_id))
                {
                    string username = ApplicationUtilities.GetSessionValue("UserName").ToString();
                    amc = buss.GetSubAgentById(agent_id, username);
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
        public void ExtendCreditLimit(AgentCreditLimitModel model)
        {
            if (ModelState.IsValid)
            {
                SubAgentCreditLimitCommon clc = new SubAgentCreditLimitCommon();
                clc = model.MapObject<SubAgentCreditLimitCommon>();
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
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult EnableSubAgent(string AgentId)
        {
            if (!string.IsNullOrEmpty(AgentId))
            {
                if (!string.IsNullOrEmpty(AgentId.DecryptParameter()))
                {
                    SubAgentManagementCommon amc = new SubAgentManagementCommon();
                    amc.AgentID = AgentId.DecryptParameter();
                    amc.IpAddress = ApplicationUtilities.GetIP();
                    amc.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                    amc.UserStatus = "Y";
                    CommonDbResponse dbresp = buss.Disable_EnableSubAgent(amc);
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
        public JsonResult DisableSubAgent(string AgentId)
        {
            if (!string.IsNullOrEmpty(AgentId))
            {
                if (!string.IsNullOrEmpty(AgentId.DecryptParameter()))
                {
                    SubAgentManagementCommon amc = new SubAgentManagementCommon();
                    amc.AgentID = AgentId.DecryptParameter();
                    amc.IpAddress = ApplicationUtilities.GetIP();
                    amc.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
                    amc.UserStatus = "N";
                    CommonDbResponse dbresp = buss.Disable_EnableSubAgent(amc);
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








        public void LoadDropDownList(SubAgentManagementModel subagentmodel)
        {

            //Manage Distributor
            ViewBag.AgentCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), subagentmodel.AgentCountry, "--select Country--");
            ViewBag.AgentProvinceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", subagentmodel.AgentCountry), subagentmodel.AgentProvince, "--select Province--");
            ViewBag.AgentDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", subagentmodel.AgentProvince) as Dictionary<string, string>, subagentmodel.AgentDistrict, "--select District--");
            ViewBag.AgentVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", subagentmodel.AgentDistrict), subagentmodel.AgentVDC_Muncipality, "--select VDC Muncipality--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), subagentmodel.ContactPersonIdIssueDistrict, "--Select District--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), subagentmodel.ContactPersonIdType, "--Select Document Type--");

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

            }
            return null;
        }

        public void RemoveBusinessValidation(SubAgentManagementModel AMM)
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
        public void RemoveupdateValidation(SubAgentManagementModel AMM)
        {
            ModelState.Remove("Password");
            ModelState.Remove("confirmPassword");
        }
    }
}
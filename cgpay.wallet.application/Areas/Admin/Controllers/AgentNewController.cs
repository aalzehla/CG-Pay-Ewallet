using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.NewAgent;
using cgpay.wallet.business.Common;
using cgpay.wallet.application.Library;
using cgpay.wallet.shared.Models.SubDistributor;
using System.IO;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class AgentNewController : Controller
    {
        IAgentBusiness buss;
        ICommonBusiness ICB;
        public AgentNewController(IAgentBusiness _buss, ICommonBusiness _ICB)
        {
            buss = _buss;
            ICB = _ICB;

        }
        // GET: Admin/AgentNew
        public ActionResult Index()
        {
            var UserType = Session["UserType"].ToString();
            string AgentId = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();
            if (UserType.ToUpper() == "SUB-AGENT")
            {
                return RedirectToAction("Index", "SUBAGENT");
            }
            else if (UserType.ToUpper() == "AGENT")
            {
                AgentId = Session["AgentId"].ToString();
            }
            string username = ApplicationUtilities.GetSessionValue("UserName").ToString();

            var AgentCommon = buss.GetAgentList(AgentId, username);
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("AgentName", "Agent Name");
            param.Add("AgentOperationType", "Operation Type");
            param.Add("AgentMobileNumber", "Contact Number");
            param.Add("AgentStatus", "Agent Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            foreach (var item in AgentCommon)
            {
                // item.Action = StaticData.GetActions("Distributor", item.DistributorId.EncryptParameter(), this, "", "", "");
                item.Action = StaticData.GetActions("AgentNew", item.AgentID.EncryptParameter(), this, "", "", username.EncryptParameter());
            }
            var grid = ProjectGrid.MakeGrid(AgentCommon, "Agent List ", "", 0, true, "", "", "Home", "Agent", "/Admin/AgentNew", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ? "/Admin/AgentNew/ManageAgent" : "");
            ViewData["grid"] = grid;
            return View();
        }

        public ActionResult ManageAgent(string UserName, string agentId = "")
        {
            AgentNewModel AM = new AgentNewModel();

            if (!string.IsNullOrEmpty(agentId))
            {
                AM.AgentID = agentId.DecryptParameter();
                if (!string.IsNullOrEmpty(AM.AgentID))
                {
                    AgentNewCommon AC = buss.GetAgentById(AM.AgentID, UserName.DecryptParameter());
                    AM = AC.MapObject<AgentNewModel>();
                    AM.AgentID = AM.AgentID.EncryptParameter();
                }
            }
            LoadDropDownList(AM);
            return View(AM);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ManageAgent(AgentNewModel agentModel, HttpPostedFileBase Agent_Logo, HttpPostedFileBase Pan_Certiticate, HttpPostedFileBase Registration_Certificate)
        {
            var Agent_LogoPath = "";
            var Pan_CertiticatePath = "";
            var Registration_CertificatePath = "";
            LoadDropDownList(agentModel);
            if (ModelState.IsValid)
            {
                AgentNewCommon AC = new AgentNewCommon();
                AC = agentModel.MapObject<AgentNewCommon>();
                if (!string.IsNullOrEmpty(AC.AgentID))
                {
                    if (string.IsNullOrEmpty(AC.AgentID.DecryptParameter()))
                    {
                        return View(agentModel);
                    }
                }
                if (!string.IsNullOrEmpty(AC.ParentID))
                {
                    if (string.IsNullOrEmpty(AC.ParentID.DecryptParameter()))
                    {
                        return View(agentModel);
                    }
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
                        return View(agentModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + "." + Agent_Logo.FileName;
                        Agent_LogoPath = Path.Combine(Server.MapPath("~/Content/assets/images/distributor_image"), myfilename);
                        AC.AgentLogo = myfilename;
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(agentModel);
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
                            return View(agentModel);
                        }
                        if (allowedExtensions.Contains(ext.ToLower()))
                        {
                            string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                            string myfilename = "logo " + datet + "." + Pan_Certiticate.FileName;
                            Pan_CertiticatePath = Path.Combine(Server.MapPath("~/Content/assets/images/distributor_image"), myfilename);
                            AC.AgentPanCertificate = myfilename;
                        }
                        else
                        {
                            this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                            return View(agentModel);
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
                            return View(agentModel);
                        }
                        if (allowedExtensions.Contains(ext.ToLower()))
                        {
                            string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                            string myfilename = "logo " + datet + "." + Registration_Certificate.FileName;
                            Registration_CertificatePath = Path.Combine(Server.MapPath("~/Content/assets/images/distributor_image"), myfilename);
                            AC.AgentRegistrationCertificate = myfilename;
                            //Registration_Certificate.SaveAs(path);
                        }
                        else
                        {
                            this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                            return View(agentModel);
                        }
                    }
                }
                CommonDbResponse dbresp = buss.ManageAgent(AC);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("Index");
                }
                agentModel.Msg = dbresp.Message;

            }
            this.ShowPopup(1, "Error " + agentModel.Msg);
            return View(agentModel);

        }

        public ActionResult ViewAgentWalletUser(string AgentId = "")
        {
            var UserType = Session["UserType"].ToString();
            string id = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString().Trim();
            if (UserType.ToUpper() == "SUB-DISTRIBUTOR")
            {
                return RedirectToAction("Index", "SubDistributor", new { DistId = Session["AgentId"].ToString() });
            }
            else if (UserType.ToUpper() == "DISTRIBUTOR")
            {
                id = Session["AgentId"].ToString();
            }
            else
            {
                id = AgentId.DecryptParameter();
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
            //var WalletUser = buss.GetWalletUserList(id, userId);
            dynamic WalletUser = null;

            //Actions
            foreach (var item in WalletUser)
            {
                item.Action = StaticData.GetActions("ViewDistributorUser", item.UserId.EncryptParameter(), this, "", "", item.AgentID.EncryptParameter(), item.UserStatus, item.isPrimary, DisableAddEdit: Session["UserId"].ToString() == item.UserId);
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
            var grid = ProjectGrid.MakeGrid(WalletUser, "Distributor Users", "", 0, true, "", "", "Home", "Distributor", "/Admin/Distributor", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ? "/Admin/Distributor/ManageDistributorUsers?distid=" + id.EncryptParameter() : "");
            ViewData["grid"] = grid;
            return View();
        }

        public void LoadDropDownList(AgentNewModel agentmodel)
        {

            //Manage Distributor
            ViewBag.AgentCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), agentmodel.AgentCountry, "--select Country--");
            ViewBag.AgentProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", agentmodel.AgentCountry), agentmodel.AgentProvince, "--select Provience--");
            ViewBag.AgentDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", agentmodel.AgentProvince) as Dictionary<string, string>, agentmodel.AgentDistrict, "--select District--");
            ViewBag.AgentVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", agentmodel.AgentDistrict), agentmodel.AgentVDC_Muncipality, "--select VDC Muncipality--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), agentmodel.ContactPersonIdIssueDistrict, "--Select District--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), agentmodel.ContactPersonIdType, "--Select Document Type--");

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
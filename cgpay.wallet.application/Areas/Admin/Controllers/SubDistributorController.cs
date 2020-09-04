using cgpay.wallet.application.Library;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.SubDistributor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Models;
using cgpay.wallet.shared.Models.SubDistributor;
using cgpay.wallet.application.Filters;
using cgpay.wallet.shared.Models;
using System.IO;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
  
    public class SubDistributorController : Controller
    {
        // GET: Admin/Agent
        ICommonBusiness ICB;
        ISubDistributorBusiness ISD;
        public SubDistributorController(ICommonBusiness _ICB,ISubDistributorBusiness _ISD)
        {
            ICB = _ICB;
            ISD = _ISD;
        }
        public ActionResult Index(string DistId="", string username="",string Search="",int Pagesize=10)
        {
            var UserType = ApplicationUtilities.GetSessionValue("UserType").ToString();
            string SubDistId = "";
            if(UserType.ToUpper()=="SUB-DISTRIBUTOR")
            {
                DistId = Session["ParentId"].ToString();
                SubDistId= Session["AgentId"].ToString();
            }
            else
            {

                DistId = DistId.DecryptParameter();
                if(string.IsNullOrEmpty(DistId))
                {
                    return RedirectToAction("Index","Distributor");
                }

            }            

            if (string.IsNullOrEmpty(username))
                username = Session["UserName"].ToString();
            string IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();
            var lst = ISD.GetSubDistributorsList(username, DistId,SubDistId);
            foreach (var item in lst)
            {
                item.Action = StaticData.GetActions("Subdistributor", item.AgentID.ToString().EncryptParameter(), this, "", "", "");
                //item.kycstatus = "<img src='/Content/assets/images/service logos/" + item.ProductLogo + "' height='50' width='50' />";
                item.AgentStatus = "<span class='badge badge-" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.AgentStatus.Trim().ToUpper() == "Y" ? "Enable" : "Disable") + "</span>";

                if (item.kycstatus.ToUpper().Equals("PENDING"))
                    item.kycstatus = "<span class='badge badge-warning'>Pending</span>";
                else if (item.kycstatus.ToUpper().Equals("APPROVED"))
                    item.kycstatus = "<span class='badge badge-success'>Approved</span>";
                else
                    item.kycstatus = "<span class='badge badge-danger'>Rejected</span>";
            }

            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("ProductId", "Product Id");
           // param.Add("ProductLogo", "Product Logo");
            param.Add("AgentName", "Agent Name");
            param.Add("AgentOperationType", "Operation Type");
            param.Add("AgentMobileNumber", "Contact Number");
            param.Add("AgentStatus", "Agent Status");
            param.Add("kycstatus", "Kyc Status");
     
            param.Add("Action", "Action");


            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(lst, "Sub-Distributor", Search, Pagesize, true, "", "", "Home", "Sub-Distributor", "/Admin/subdistributor", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ?"/Admin/subdistributor/Manage?parentid=" +DistId.EncryptParameter():"");
            ViewData["grid"] = grid;
            return View();
            
        }



        public ActionResult Manage(string parentid="", string agentid="")
        {
            SubDistributorModel SDM = new SubDistributorModel();
            string username = Session["username"].ToString();
            SDM.ParentId = parentid;
            if(!string.IsNullOrEmpty(agentid.DecryptParameter()))
            {
                SubDistributorCommon SDC = ISD.GetSubDistributorById(agentid.DecryptParameter(),  username);
                 SDM = SDC.MapObject<SubDistributorModel>();
            }

            ViewBag.PermanentCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), SDM.PermanentCountry, "--Permanent Country--");
            ViewBag.PermanentProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", SDM.PermanentCountry), SDM.PermanentProvince, "--Permanent Provience--");
            ViewBag.PermanentDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", SDM.PermanentProvince) as Dictionary<string, string>, SDM.PermanentDistrict, "--Permanent District--");
            ViewBag.PermanentVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", SDM.PermanentDistrict), SDM.PermanentVDC_Muncipality, "--Permanent VDC Muncipality--");



            ViewBag.TemporarytCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), SDM.TemporaryCountry, "--Temporary Country--");
            ViewBag.TemporaryProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", SDM.TemporaryCountry), SDM.TemporaryProvince, "--Temporary Provience--");
            ViewBag.TemporaryDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", SDM.TemporaryProvince), SDM.TemporaryDistrict, "--Temporary District--");
            ViewBag.TemporaryVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", SDM.TemporaryDistrict), SDM.TemporaryVDC_Muncipality, "--Temporary VDC Muncipality--");

            ViewBag.GenderList = ApplicationUtilities.SetDDLValue(LoadDropdownList("gender"), SDM.Gender, "--Select Gender--");
            ViewBag.OccupationList = ApplicationUtilities.SetDDLValue(LoadDropdownList("occupation"), SDM.Occupation, "--Select Occupation--");
            ViewBag.Nationalitylist = ApplicationUtilities.SetDDLValue(LoadDropdownList("nationality"), SDM.Nationality, "--Select Nationality--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), SDM.Nationality, "--Select Document Type--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), SDM.Nationality, "--Select District--");


            return View(SDM);
        }
        [HttpPost,ValidateAntiForgeryToken]
        public ActionResult Manage(SubDistributorModel SDM, HttpPostedFileBase Agent_Logo, HttpPostedFileBase Pan_Certiticate, HttpPostedFileBase Registration_Certificate)
        {
            ViewBag.PermanentCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), SDM.PermanentCountry, "--Permanent Country--");
            ViewBag.PermanentProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", SDM.PermanentCountry), SDM.PermanentProvince, "--Permanent Provience--");
            ViewBag.PermanentDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", SDM.PermanentProvince) as Dictionary<string, string>, SDM.PermanentDistrict, "--Permanent District--");
            ViewBag.PermanentVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", SDM.PermanentDistrict), SDM.PermanentVDC_Muncipality, "--Permanent VDC Muncipality--");



            ViewBag.TemporarytCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), SDM.TemporaryCountry, "--Temporary Country--");
            ViewBag.TemporaryProvienceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", SDM.TemporaryCountry), SDM.TemporaryProvince, "--Temporary Provience--");
            ViewBag.TemporaryDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", SDM.TemporaryProvince), SDM.TemporaryDistrict, "--Temporary District--");
            ViewBag.TemporaryVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", SDM.TemporaryDistrict), SDM.TemporaryVDC_Muncipality, "--Temporary VDC Muncipality--");

            ViewBag.GenderList = ApplicationUtilities.SetDDLValue(LoadDropdownList("gender"), SDM.Gender, "--Select Gender--");
            ViewBag.OccupationList = ApplicationUtilities.SetDDLValue(LoadDropdownList("occupation"), SDM.Occupation, "--Select Occupation--");
            ViewBag.Nationalitylist = ApplicationUtilities.SetDDLValue(LoadDropdownList("nationality"), SDM.Nationality, "--Select Nationality--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), SDM.Nationality, "--Select Document Type--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), SDM.Nationality, "--Select District--");
            if(!string.IsNullOrEmpty(SDM.AgentID))
            {
                RemoveUserValidation(SDM);
            }
            if (SDM.AgentOperationType.ToUpper()=="INDIVIDUAL")
            {
                RemoveContactPersonValidation(SDM);
            }
            if (ModelState.IsValid)
            {
                SubDistributorCommon SDC = SDM.MapObject<SubDistributorCommon>();

                if (!string.IsNullOrEmpty(SDC.AgentID))
                {
                    if (string.IsNullOrEmpty(SDC.AgentID.DecryptParameter()))
                    {
                        return View("Manage", SDM);
                    }
                    SDC.AgentID = SDC.AgentID.DecryptParameter();
                }
                if (!string.IsNullOrEmpty(SDC.UserId))
                {
                    if (string.IsNullOrEmpty(SDC.UserId.DecryptParameter()))
                    {
                        return View("Manage", SDM);
                    }
                    SDC.UserId = SDC.UserId.DecryptParameter();
                }


                if (!string.IsNullOrEmpty(SDC.ParentId))
                {
                   
                    SDC.ParentId = SDC.ParentId.DecryptParameter();
                }



                SDC.ActionUser = Session["username"].ToString();
                SDC.IpAddress = ApplicationUtilities.GetIP();
                
             
                if (Pan_Certiticate != null)
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Pan_Certiticate.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Pan_Certiticate.FileName);
                    if (Pan_Certiticate.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(SDM);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo "+datet + "." + Pan_Certiticate.FileName;
                        var path = Path.Combine(Server.MapPath("~/Content/assets/images/Sub_Distributor"), myfilename);
                        SDC.AgentPanCertificate = myfilename;
                        Pan_Certiticate.SaveAs(path);
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(SDM);
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
                        return View(SDM);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + "." + Registration_Certificate.FileName;
                        var path = Path.Combine(Server.MapPath("~/Content/assets/images/Sub_Distributor"), myfilename);
                        SDC.AgentRegistrationCertificate = myfilename;
                        Registration_Certificate.SaveAs(path);
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(SDM);
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
                        return View(SDM);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + "." + Agent_Logo.FileName;
                        var path = Path.Combine(Server.MapPath("~/Content/assets/images/Sub_Distributor"), myfilename);
                        SDC.AgentLogo = myfilename;
                        Agent_Logo.SaveAs(path);
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(SDM);
                    }
                }

                var dbresp = ISD.Manage(SDC);
                if(dbresp.Code==0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("Index",new{DistId=SDM.ParentId} );
                }
                SDM.Msg = dbresp.Message;
            }
            this.ShowPopup(1, "Error "+SDM.Msg);

            return View(SDM);
        }

        #region user list

        public ActionResult ViewUser(string agentid = "")
        {
            var id = agentid.DecryptParameter();
            var UserType = Session["UserType"].ToString();
          var IsPrimary= ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString();
            if (string.IsNullOrEmpty(id))
            {
                return RedirectToAction("Index");
            }
            var userId = "";
            if (String.IsNullOrEmpty(IsPrimary) == false && (IsPrimary.ToUpper().Trim() == "N" || IsPrimary.ToUpper().Trim() == ""))
            {
                userId = Session["UserId"].ToString();
            }
         //   var DistributorCommon = _distributor.GetUserList(id, userId);

            var subDistributorCommon = ISD.GetUserList(id,userId);
   
            foreach (var item in subDistributorCommon)
            {
                item.Action = StaticData.GetActions("subdistributoruser", item.AgentID.EncryptParameter(), this, "", "", item.UserId.EncryptParameter(), item.UserStatus, ExtraId5:IsPrimary,DisableAddEdit: Session["UserId"].ToString() == item.UserId);
                item.UserStatus = "<span class='badge badge-" + (item.UserStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.UserStatus.Trim().ToUpper() == "Y" ? "Enable" : "Disable") + "</span>";

            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("AgentID", "Agent Id");
            param.Add("UserId", "User Id");
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
            var grid = ProjectGrid.MakeGrid(subDistributorCommon, "SubDistibutor-User", "", 0, true, "", "", "Home", "Distributor", "/Admin/SubDistributor", String.IsNullOrEmpty(IsPrimary) == false && IsPrimary.ToUpper().Trim() == "Y" ? "/Admin/SubDistributor/addUsers?agentid=" + agentid:"");
            ViewData["grid"] = grid;
            return View();
        }
        
        
        public ActionResult addUsers(string agentid, string UserId = "")
        {
            SubDistributorCommon SDC = new SubDistributorCommon();
            if(!string.IsNullOrEmpty(agentid.DecryptParameter()))
            {
                if(!string.IsNullOrEmpty(UserId.DecryptParameter()))
                SDC = ISD.GetUserById(agentid.DecryptParameter(), UserId.DecryptParameter());

                SDC.UserId = SDC.UserId.EncryptParameter();
                SDC.AgentID = SDC.AgentID.EncryptParameter();
                SDC.UserStatus = string.IsNullOrEmpty(SDC.UserStatus)?"": SDC.UserStatus.Trim();
                SDC.UserType = SDC.UserTypeId + '|' + SDC.UserType;

            }
            ViewBag.UserTypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("usertype"), SDC.UserType, "--Select User Type--");
            ViewBag.UserStatusList = ApplicationUtilities.SetDDLValue(LoadDropdownList("status"), SDC.UserStatus, "--Select Status--");

            ViewBag.UserIsPrimaryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("isprimary") as Dictionary<string, string>, SDC.isPrimary, "--Is Primary--");
            SubDistributorModel SDM = SDC.MapObject<SubDistributorModel>();

           
            return View(SDM);
        }
        
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult addUsers(SubDistributorModel SDM,string changepassword)
        {

            ViewBag.UserTypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("usertype"), SDM.UserType, "--Select User Type--");
            ViewBag.UserStatusList = ApplicationUtilities.SetDDLValue(LoadDropdownList("status"), SDM.UserStatus, "--Select Status--");

            ViewBag.UserIsPrimaryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("isprimary") as Dictionary<string, string>, SDM.isPrimary, "--Is Primary--");
            RemoveAgentValidation(SDM);
            RemoveContactPersonValidation(SDM);
            if(changepassword.ToUpper()!="ON")
            {
                ModelState.Remove("Password");
                ModelState.Remove("ConfirmPassword");
            }
            if (ModelState.IsValid)
            {
               if(string.IsNullOrEmpty(SDM.AgentID.DecryptParameter()))
                {
                    this.ShowPopup(1, "Error. Please try again!");
                    return View(SDM);
                }

               if(!string.IsNullOrEmpty(SDM.UserId))
                {
                    if (string.IsNullOrEmpty(SDM.UserId.DecryptParameter()))
                    {
                        this.ShowPopup(1, "Error. Please try again!");
                        return View(SDM);
                    }


                }

                SDM.UserId = SDM.UserId.DecryptParameter();

                SDM.AgentID = SDM.AgentID.DecryptParameter();
                string[] usertype_id = SDM.UserType.Split('|');
                SDM.UserType = usertype_id[1];
                SDM.UserTypeId = usertype_id[0];

               
                SubDistributorCommon SDC = SDM.MapObject<SubDistributorCommon>();

                CommonDbResponse dbresp = ISD.ManageUser(SDC,changepassword);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("ViewUser",new { agentid=SDM.AgentID.EncryptParameter()});
                }
            }
            this.ShowPopup(1, "Save unsuccessful.Please try again!");
            return View(SDM);
        }

        #endregion


        #region Disable/Enable user
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult BlockUser(string userid, string agentid)
        {
            if (!String.IsNullOrEmpty(userid) && !String.IsNullOrEmpty(agentid))
            {
                userid = userid.DecryptParameter();
                agentid = agentid.DecryptParameter();
                if (string.IsNullOrEmpty(userid) || string.IsNullOrEmpty(agentid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = ISD.block_unblockuser(userid, "N",agentid);
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
        public JsonResult UnBlockUser(string userid, string agentid)
        {
            if (!String.IsNullOrEmpty(userid))
            {
                userid = userid.DecryptParameter();
                if (string.IsNullOrEmpty(userid))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid User." });
                }
                var DbResponse = ISD.block_unblockuser(userid, "Y",agentid);
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



        public Dictionary<string,string> LoadDropdownList(string flag, string search1 = "")
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
        public async System.Threading.Tasks.Task<JsonResult> GetDistrictsByProvince(string provinceId)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", provinceId) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }
        [HttpPost]
        [OverrideActionFilters]

        public async System.Threading.Tasks.Task<JsonResult> GetMuncipalityByDistrict(string district)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", district) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }

        public void RemoveContactPersonValidation(SubDistributorModel SDM)
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
        public void RemoveAgentValidation(SubDistributorModel SDM)
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

        public void RemoveUserValidation(SubDistributorModel SDM)
        {
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
    }
}
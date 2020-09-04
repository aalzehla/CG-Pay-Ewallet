using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.KYC;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.KYC;
using WebGrease.Css.Extensions;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class KYCController : Controller
    {
        IKycBusiness _kyc;
        string ControllerName = "KYC";
        public KYCController(IKycBusiness kyc)
        {
            _kyc = kyc;
        }
        [HttpGet]
        public ActionResult Index(string Search = "", int Pagesize = 10)
        {
            KycFilterModel model = new KycFilterModel();
            model.KycStatusList = ApplicationUtilities.SetDDLValue(LoadDropdownList("kycstatus") as Dictionary<string, string>, model.KycStatus, "--Status--");
            KycFilterCommon filterCommon = new KycFilterCommon();
            filterCommon = model.MapObject<KycFilterCommon>();
            List<KYCCommon> kycCommon = _kyc.GetAgentList(filterCommon);
            List<KYCModel> kycModel = kycCommon.MapObjects<KYCModel>();
            foreach (var item in kycModel)
            {
                item.Action = StaticData.GetActions(ControllerName, item.AgentId.EncryptParameter(), this, "", "", item.KycStatus);

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
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("AgentId", "Agent Id");
            param.Add("MobileNo", "Mobile No");
            param.Add("EmailAddress", "Email");
            param.Add("SubmittedDate", "Submitted Date");
            param.Add("KycStatus", "Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(kycModel, "hidebreadcrumb", Search, Pagesize, false, "", "", "", "KYC", "", "KYC");
            ViewData["grid"] = grid;


            ViewBag.EmptyMessage = "False";
            return View(model);
            //return View(kycModel);
        }
        [HttpPost]
        public ActionResult Index(KycFilterModel model)
        {
            model.KycStatusList = ApplicationUtilities.SetDDLValue(LoadDropdownList("kycstatus") as Dictionary<string, string>, model.KycStatus, "--Status--");
            KycFilterCommon filterCommon = new KycFilterCommon();
            filterCommon = model.MapObject<KycFilterCommon>();
            List<KYCCommon> kycCommon = _kyc.GetAgentList(filterCommon);
            if (kycCommon == null || kycCommon.Count == 0)
            {
                ViewBag.EmptyMessage = "True";
                return View(model);
            }
            List<KYCModel> kycModel = kycCommon.MapObjects<KYCModel>();
            foreach (var item in kycModel)
            {
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
                item.Action = StaticData.GetActions(ControllerName, item.AgentId.EncryptParameter(), this, "", "", "");
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("AgentId", "Agent Id");
            param.Add("MobileNo", "Mobile No");
            param.Add("EmailAddress", "Email");
            param.Add("SubmittedDate", "Submitted Date");
            param.Add("KycStatus", "Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(kycModel, "hidebreadcrumb", "", 10, false, "", "", "", "KYC", "", "KYC");
            ViewData["grid"] = grid;
            ViewBag.EmptyMessage = "False";
            return View(model);
            //return View(kycModel);
        }
        // GET: KYC/Details/id="1003"
        public ActionResult Details(string agentid = "")
        {
            KYCCommon kycCommon = new KYCCommon();

            KYCModelDetail kycModel = new KYCModelDetail();
            var ID = agentid.DecryptParameter();
            if (String.IsNullOrEmpty(ID))
            {
                return RedirectToAction("Index", ControllerName);
            }

            if (!String.IsNullOrEmpty(ID))
                kycCommon = _kyc.AgentKycInfo(ID);
            //kycCommon.AgentId = ID.ToString();
            kycModel = kycCommon.MapObject<KYCModelDetail>();
            kycModel.Country = string.IsNullOrEmpty(kycModel.Country) ? "Nepal" : kycModel.Country;
            kycModel.Nationality = string.IsNullOrEmpty(kycModel.Nationality) ? "Nepali" : kycModel.Nationality;
            var pprovince = LoadDropdownList("province") as Dictionary<string, string>;
            kycModel.PProvince = pprovince.ContainsKey(kycModel.PProvince)
                ? pprovince.FirstOrDefault(x => x.Key == kycModel.PProvince).Value : kycModel.PProvince;
            kycModel.TProvince = pprovince.ContainsKey(kycModel.TProvince)
                ? pprovince.FirstOrDefault(x => x.Key == kycModel.TProvince).Value : kycModel.TProvince;
            ViewBag.AgentId = ID;
            KYCModel kyc = new KYCModel();
            kyc = kycModel.MapObject<KYCModel>();
            ViewBag.RemarksList = ApplicationUtilities.SetDDLValue(LoadDropdownList("remarks") as Dictionary<string, string>, kycModel.Remarks, "--Remarks--");

            //LoadDropDownList(kyc);
            #region FileLocation

            string FileLocation;
            string usertype = kycModel.AgentType;
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
            return View(kycModel);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Details(KYCModelDetail kycModel, string submitbutton, string OthersRemarks = "")
        {
            if (submitbutton.ToUpper() == "GOBACK")
            {
                return RedirectToAction("Index", ControllerName);
            }
            KYCModel kyc = new KYCModel();
            kyc = kycModel.MapObject<KYCModel>();
            LoadDropDownList(kyc);
            #region FileLocation

            string FileLocation;
            string usertype = kycModel.AgentType;
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
            if (String.IsNullOrEmpty(kycModel.AgentId))
                return RedirectToAction("Index", ControllerName);
            string status = "";
            if (submitbutton.ToUpper() == "REJECT")
            {
                status = "r";
                if (kycModel.Remarks.ToUpper().Equals("OTHERS"))
                {
                    if (OthersRemarks == "")
                    {
                        ModelState.AddModelError("OtherRemarks", "Other Remarks is Required");
                        return View(kycModel);
                    }
                    else
                    {
                        kycModel.Remarks = "Others::" + OthersRemarks;
                    }
                }
                RejectValidation();

            }
            else if (submitbutton.ToUpper() == "APPROVE")
            {
                status = "a";
                ModelState.Remove(("Remarks"));
            }

            else
                return RedirectToAction("Index", ControllerName);

            kycModel.ActionUser = Session["UserName"].ToString();
            kycModel.AgentId = kycModel.AgentId.DecryptParameter();
            KYCCommon kycCommon = kycModel.MapObject<KYCCommon>();
            CommonDbResponse dbResponse = _kyc.UpadateKycDetails(kycCommon, status);
            dbResponse.SetMessageInTempData(this);
            return RedirectToAction("Index");
        }

        public ActionResult EditDetails(string agentid = "")
        {
            KYCCommon kycCommon = new KYCCommon();

            KYCModel kycModel = new KYCModel();
            var ID = agentid.DecryptParameter();

            //if (Session["UserName"] == null)
            //{
            //    return RedirectToAction("LogOff", "Home");
            //}
            if (String.IsNullOrEmpty(ID))
            {
                return RedirectToAction("Index", ControllerName);
            }

            if (!String.IsNullOrEmpty(ID))
                kycCommon = _kyc.AgentKycInfo(ID);
            //kycCommon.AgentId = ID.ToString();
            kycModel = kycCommon.MapObject<KYCModel>();
            kycModel.Country = string.IsNullOrEmpty(kycModel.Country) ? "Nepal" : kycModel.Country;
            kycModel.Nationality = string.IsNullOrEmpty(kycModel.Nationality) ? "Nepali" : kycModel.Nationality;
            ViewBag.AgentId = ID;
            LoadDropDownList(kycModel);
            #region FileLocation

            string FileLocation;
            string usertype = kycModel.AgentType;
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
            return View(kycModel);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult EditDetails(KYCModel kycModel, HttpPostedFileBase PPImageFile, HttpPostedFileBase Id_DocumentFrontFile, HttpPostedFileBase Id_DocumentBackFile, string submitbutton, string OthersRemarks = "")
        {
            if (submitbutton.ToUpper() == "GOBACK")
            {
                return RedirectToAction("Index", ControllerName);
            }
            LoadDropDownList(kycModel);
            #region FileLocation

            string FileLocation;
            string usertype = kycModel.AgentType;
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
            if (String.IsNullOrEmpty(kycModel.AgentId))
                return RedirectToAction("Index", ControllerName);
            string status = "";
            if (submitbutton.ToUpper() == "REJECT")
            {
                status = "r";
                if (kycModel.Remarks.ToUpper().Equals("OTHERS"))
                {
                    if (OthersRemarks == "")
                    {
                        ModelState.AddModelError("OtherRemarks", "Other Remarks is Required");
                        return View(kycModel);
                    }
                    else
                    {
                        kycModel.Remarks = "Others::" + OthersRemarks;
                    }
                }
                RejectValidation();

            }
            else if (submitbutton.ToUpper() == "APPROVE")
            {
                status = "a";
                ModelState.Remove(("Remarks"));
            }
            else if (submitbutton.ToUpper() == "UPDATE")
            {
                status = "u";
                ModelState.Remove(("Remarks"));
            }
            else
                return RedirectToAction("Index", ControllerName);

            if (submitbutton.ToUpper() != "REJECT")
            {
                if ((Id_DocumentFrontFile == null && string.IsNullOrEmpty(kycModel.Id_DocumentFront))
                    || (PPImageFile == null && string.IsNullOrEmpty(kycModel.PPImage))
                    || (Id_DocumentBackFile == null && string.IsNullOrEmpty(kycModel.Id_DocumentBack) && kycModel.Id_type.ToUpper() == "CITIZENSHIP"))
                {
                    if (Id_DocumentFrontFile == null && string.IsNullOrEmpty(kycModel.Id_DocumentFront))
                        ModelState.AddModelError("Id_DocumentFront", "Document Front Image is Required");
                    if (PPImageFile == null && string.IsNullOrEmpty(kycModel.PPImage))
                        ModelState.AddModelError("PPImage", "Profile Image is Required");
                    if ((Id_DocumentBackFile == null && string.IsNullOrEmpty(kycModel.Id_DocumentBack) && kycModel.Id_type.ToUpper() == "CITIZENSHIP"))
                    {
                        ModelState.AddModelError("Id_DocumentBack", "Document Front Image is Required");
                    }
                    return View(kycModel);
                }

                if (kycModel.Id_type.ToUpper() == "CITIZENSHIP")
                {
                    ModelState.Remove(("Id_ExpiryDateAD"));
                    ModelState.Remove(("Id_ExpiryDateBS"));
                }
                string temp_address = kycModel.SameAsPermanentAddress.ToString();
                if (temp_address == "True")
                {
                    kycModel.TProvince = kycModel.PProvince;
                    kycModel.TDistrict = kycModel.PDistrict;
                    kycModel.TLocalBody = kycModel.PLocalBody;
                    kycModel.TWardNo = kycModel.PWardNo;
                    kycModel.TAddress = kycModel.PAddress;
                }
            }

            string ID = "";
            var PPImagePath = "";
            var Id_DocumentFrontPath = "";
            var Id_DocumentBackPath = "";

            if (ModelState.IsValid)
            {
                //kycModel.Remarks = String.IsNullOrEmpty(kycModel.Remarks) ? "" :
                //  kycModel.Remarks.ToUpper().Equals("OTHERS") ? OthersRemarks : kycModel.Remarks;

                kycModel.ActionUser = Session["UserName"].ToString();

                ID = kycModel.AgentId.DecryptParameter();
                kycModel.AgentId = ID;

                #region "PPImage"
                if (PPImageFile != null && (status.ToUpper() == "A" || status.ToUpper() == "U"))
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(PPImageFile.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(PPImageFile.FileName);
                    if (PPImageFile.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        return RedirectToAction("Details", ControllerName, ID);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = timeStamp.Replace('/', ' ').Replace(':', ' ');
                        string myfilename = kycModel.MobileNo + "-PPImage-" + datet + ext;
                        PPImagePath = Path.Combine(Server.MapPath(FileLocation), myfilename);
                        kycModel.PPImage = FileLocation + myfilename;
                        //PPImageFile.SaveAs(PPImagePath);
                    }
                    else
                    {
                        return RedirectToAction("Details", ControllerName, ID);
                    }
                }
                #endregion
                #region "Id_DocumentFront"
                if (Id_DocumentFrontFile != null && (status.ToUpper() == "A" || status.ToUpper() == "U"))
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Id_DocumentFrontFile.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Id_DocumentFrontFile.FileName);
                    if (Id_DocumentFrontFile.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        return RedirectToAction("Details", ControllerName, ID);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = timeStamp.Replace('/', ' ').Replace(':', ' ');
                        string myfilename = kycModel.MobileNo + "-Id_DocumentFront-" + datet + ext;
                        Id_DocumentFrontPath = Path.Combine(Server.MapPath(FileLocation), myfilename);
                        kycModel.Id_DocumentFront = FileLocation + myfilename;
                        //Id_DocumentFrontFile.SaveAs(Id_DocumentFrontPath);
                    }
                    else
                    {
                        return RedirectToAction("Details", ControllerName, ID);
                    }
                }
                #endregion
                #region "Id_DocumentBack"
                if (Id_DocumentBackFile != null && (status.ToUpper() == "A" || status.ToUpper() == "U"))
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Id_DocumentBackFile.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Id_DocumentBackFile.FileName);
                    if (Id_DocumentBackFile.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        return RedirectToAction("Details", ControllerName, ID);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = timeStamp.Replace('/', ' ').Replace(':', ' ');
                        string myfilename = kycModel.MobileNo + "-Id_DocumentBack-" + datet + ext;
                        Id_DocumentBackPath = Path.Combine(Server.MapPath(FileLocation), myfilename);
                        kycModel.Id_DocumentBack = FileLocation + myfilename;
                        //Id_DocumentBackFile.SaveAs(Id_DocumentBackPath);
                    }
                    else
                    {
                        return RedirectToAction("Details", ControllerName, ID);
                    }
                }
                #endregion
                KYCCommon kycCommon = kycModel.MapObject<KYCCommon>();
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
                return RedirectToAction("Index");

            }

            return View(kycModel);
            //return RedirectToAction("Index");
        }

        public void LoadDropDownList(KYCModel kycModel)
        {
            switch (kycModel.PProvince != null ? kycModel.PProvince.ToLower() : "")
            {
                case "province no. 1":
                    kycModel.PProvince = "1";
                    break;
                case "province no. 2":
                    kycModel.PProvince = "2";
                    break;
                case "bagmati pradesh":
                    kycModel.PProvince = "3";
                    break;
                case "gandaki pradesh":
                    kycModel.PProvince = "4";
                    break;
            }
            switch (kycModel.TProvince != null ? kycModel.TProvince.ToLower() : "")
            {
                case "province no. 1":
                    kycModel.TProvince = "1";
                    break;
                case "province no. 2":
                    kycModel.TProvince = "2";
                    break;
                case "bagmati pradesh":
                    kycModel.TProvince = "3";
                    break;
                case "gandaki pradesh":
                    kycModel.TProvince = "4";
                    break;
            }
            ViewBag.CountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country") as Dictionary<string, string>, kycModel.Country, "--Country--");
            ViewBag.GenderList = ApplicationUtilities.SetDDLValue(LoadDropdownList("gender") as Dictionary<string, string>, kycModel.Gender, "--Gender--");
            ViewBag.OccupationList = ApplicationUtilities.SetDDLValue(LoadDropdownList("occupation") as Dictionary<string, string>, kycModel.Occupation, "--Occupation--");
            ViewBag.MaritalStatusList = ApplicationUtilities.SetDDLValue(LoadDropdownList("maritalstatus") as Dictionary<string, string>, kycModel.MaritalStatus, "--Marital Status--");
            ViewBag.RemarksList = ApplicationUtilities.SetDDLValue(LoadDropdownList("remarks") as Dictionary<string, string>, kycModel.Remarks, "--Remarks--");
            ViewBag.DocTypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype") as Dictionary<string, string>, kycModel.Id_type, "--Document Type--");
            ViewBag.PProvinceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province") as Dictionary<string, string>, kycModel.PProvince, "--Permanent Province--");
            ViewBag.TProvinceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province") as Dictionary<string, string>, kycModel.TProvince, "--Temporary Province--");
            ViewBag.PDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", kycModel.PProvince) as Dictionary<string, string>, kycModel.PDistrict, "--Permanent District--");
            ViewBag.TDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", kycModel.TProvince) as Dictionary<string, string>, kycModel.TDistrict, "--Temporary District--");
            ViewBag.PMunicipalityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("localbodyList", (String.IsNullOrEmpty(kycModel.PDistrict) ? "" : kycModel.PDistrict)) as Dictionary<string, string>, kycModel.PLocalBody, "--Permanent Municipality--");
            ViewBag.TMunicipalityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("localbodyList", (String.IsNullOrEmpty(kycModel.TDistrict) ? "" : kycModel.TDistrict)) as Dictionary<string, string>, kycModel.TLocalBody, "--Temporary Municipality--");
            ViewBag.NationalityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("nationality") as Dictionary<string, string>, kycModel.Nationality, "--Nationality--");
            ViewBag.OtherRemarks = !String.IsNullOrEmpty(kycModel.Remarks) ? (kycModel.Remarks.Contains("Others::") ? kycModel.Remarks.Replace("Others::", "") : "") : "";
            ViewBag.Id_IssuedPlaceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList") as Dictionary<string, string>, kycModel.Id_IssuedPlace, "--Issue Place--");
            ViewBag.SpouseName = kycModel.SpouseName;
            ViewBag.ExpireDateAD = kycModel.Id_ExpiryDateAD;
            ViewBag.ExpireDateBS = kycModel.Id_ExpiryDateBS;

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
                case "kycstatus":
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        dict.Add("Approved", "Approved");
                        dict.Add("Pending", "Pending");
                        dict.Add("Rejected", "Failed");
                        dict.Add("N", "Not Filled");
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

        public void RejectValidation()
        {
            ModelState.Remove(("FirstName"));
            ModelState.Remove(("LastName"));
            ModelState.Remove(("DOB_Eng"));
            ModelState.Remove(("DOB_Nep"));
            ModelState.Remove(("Gender"));
            ModelState.Remove(("Occupation"));
            ModelState.Remove(("MaritalStatus"));
            ModelState.Remove(("FatherName"));
            ModelState.Remove(("MotherName"));
            ModelState.Remove(("GrandFatherName"));
            ModelState.Remove(("Nationality"));
            ModelState.Remove(("Country"));
            ModelState.Remove(("PProvince"));
            ModelState.Remove(("PDistrict"));
            ModelState.Remove(("PLocalBody"));
            ModelState.Remove(("PWardNo"));
            ModelState.Remove(("PAddress"));
            ModelState.Remove(("Id_type"));
            ModelState.Remove(("Id_No"));
            ModelState.Remove(("Id_IssuedDateAD"));
            ModelState.Remove(("Id_IssuedDateBS"));
            ModelState.Remove(("Id_IssuedPlace"));
            ModelState.Remove(("Id_ExpiryDateAD"));
            ModelState.Remove(("Id_ExpiryDateBS"));
        }

    }
}

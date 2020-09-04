using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.Merchant;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Merchant;
using QRCoder;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class MerchantManagementController : Controller
    {
        private IMerchantBusiness _merchant;
        private string ControllerName = "MerchantManagement";
        ICommonBusiness _ICB;
        public MerchantManagementController(IMerchantBusiness merchant, ICommonBusiness ICB)
        {
            _merchant = merchant;
            _ICB = ICB;
        }
        // GET: Admin/MerchantManagement
        public ActionResult Index()
        {
            List<MerchantModel> lst = _merchant.GetMerchantList().MapObjects<MerchantModel>();
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("MerchantName", "Merchant Name");
            //param.Add("MerchantOperationType", "Operation Type");
            //param.Add("MerchantMobileNumber", "Contact Number");
            param.Add("MerchantCode", "Merchant Code");
            param.Add("MerchantStatus", "Merchant Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            foreach (var item in lst)
            {
                // item.Action = StaticData.GetActions("Distributor", item.DistributorId.EncryptParameter(), this, "", "", "");
                item.Action = StaticData.GetActions(ControllerName, item.MerchantID.EncryptParameter(), this, "", "", item.MerchantStatus);
                item.MerchantStatus = "<span class='badge badge-" + (item.MerchantStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.MerchantStatus.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
            }
            var grid = ProjectGrid.MakeGrid(lst, "Merchant List ", "", 0, true, "", "", "Home", "Merchant", "/Admin/MerchantManagement", "/Admin/MerchantManagement/ManageMerchant");
            ViewData["grid"] = grid;
            return View();
        }
        public ActionResult ManageMerchant(string merchantId = "")
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

                }
            }
            if(string.IsNullOrEmpty(merchantId))
            {
             merchantModel.MerchantCountry = "Nepal";
            }
            LoadDropDownList(merchantModel);
            return View(merchantModel);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageMerchant(MerchantModel merchantModel, HttpPostedFileBase Merchant_Logo, HttpPostedFileBase Pan_Certiticate, HttpPostedFileBase Registration_Certificate, string changepassword)
        {
            var Merchant_LogoPath = "";
            var Pan_CertiticatePath = "";
            var Registration_CertificatePath = "";
            LoadDropDownList(merchantModel);
            if (!string.IsNullOrEmpty(merchantModel.MerchantID.DecryptParameter()))
            {
                ModelState.Remove("UserName");
                ModelState.Remove("Password");
                ModelState.Remove("ConfirmPassword");
                ModelState.Remove("FullName");
                ModelState.Remove("UserMobileNumber");
                ModelState.Remove("UserEmail");
                ModelState.Remove("FirstName");
                ModelState.Remove("LastName");

                if (string.IsNullOrEmpty(changepassword))
                {
                    ModelState.Remove("UserName");
                    ModelState.Remove("Password");
                    ModelState.Remove("ConfirmPassword");
                }
            }
            if (ModelState.IsValid)
            {
                MerchantCommon merchantCommon = new MerchantCommon();
                merchantCommon = merchantModel.MapObject<MerchantCommon>();
                if (!string.IsNullOrEmpty(merchantCommon.MerchantID))
                {
                    if (string.IsNullOrEmpty(merchantCommon.MerchantID.DecryptParameter()))
                    {
                        return View(merchantModel);
                    }
                    if (string.IsNullOrEmpty(changepassword))
                    {
                        merchantCommon.Password = "";
                        merchantCommon.ConfirmPassword = "";
                        merchantCommon.MerchantEmail = "";
                        merchantCommon.MerchantMobileNumber = "";
                    }
                    merchantCommon.MerchantID = merchantCommon.MerchantID.DecryptParameter();
                    merchantCommon.UserID = merchantCommon.UserID.DecryptParameter();
                }
                if (!string.IsNullOrEmpty(merchantCommon.ParentID))
                {
                    if (string.IsNullOrEmpty(merchantCommon.ParentID.DecryptParameter()))
                    {
                        return View(merchantModel);
                    }
                    merchantCommon.ParentID = merchantCommon.ParentID.DecryptParameter();

                }
                merchantCommon.ActionUser = ApplicationUtilities.GetSessionValue("UserName").ToString();
                merchantCommon.IpAddress = ApplicationUtilities.GetIP();

                if (Merchant_Logo != null)
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Merchant_Logo.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Merchant_Logo.FileName);
                    if (Merchant_Logo.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(merchantModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "logo " + datet + "." + Merchant_Logo.FileName;
                        Merchant_LogoPath = Path.Combine(Server.MapPath("~/Content/userupload/merchant"), myfilename);
                        merchantCommon.MerchantLogo = "/Content/userupload/merchant/" + myfilename;

                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(merchantModel);
                    }
                }

                if (Pan_Certiticate != null)
                {
                    var allowedExtensions = new[] { ".jpg", ".png", ".jpeg" };
                    var fileName = Path.GetFileName(Pan_Certiticate.FileName);
                    String timeStamp = DateTime.Now.ToString();
                    var ext = Path.GetExtension(Pan_Certiticate.FileName);
                    if (Pan_Certiticate.ContentLength > 1 * 1024 * 1024)//1 MB
                    {
                        this.ShowPopup(1, "Image Size must be less than 1MB");
                        return View(merchantModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "pan " + datet + "." + Pan_Certiticate.FileName;
                        Pan_CertiticatePath = Path.Combine(Server.MapPath("~/Content/userupload/merchant"), myfilename);
                        merchantCommon.MerchantPanCertificate = "/Content/userupload/merchant/" + myfilename;

                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(merchantModel);
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
                        return View(merchantModel);
                    }
                    if (allowedExtensions.Contains(ext.ToLower()))
                    {
                        string datet = DateTime.Now.ToString().Replace('/', ' ').Replace(':', ' ');
                        string myfilename = "reg " + datet + "." + Registration_Certificate.FileName;
                        Registration_CertificatePath = Path.Combine(Server.MapPath("~/Content/userupload/merchant"), myfilename);
                        merchantCommon.MerchantRegistrationCertificate = "/Content/userupload/merchant/" + myfilename;

                        //Registration_Certificate.SaveAs(path);
                    }
                    else
                    {
                        this.ShowPopup(1, "File Must be .jpg,.png,.jpeg");
                        return View(merchantModel);
                    }
                }

                CommonDbResponse dbresp = _merchant.ManageMerchant(merchantCommon);
                if (dbresp.Code == 0)
                {

                    if (Pan_Certiticate != null)
                    {
                        Pan_Certiticate.SaveAs(Pan_CertiticatePath);
                    }
                    if (Registration_Certificate != null)
                    {
                        Registration_Certificate.SaveAs(Registration_CertificatePath);
                    }

                    if (Merchant_Logo != null)
                    {
                        Merchant_Logo.SaveAs(Merchant_LogoPath);
                    }

                    string userId = dbresp.Extra1;
                    string agentId = dbresp.Extra2;
                    string AgentCode = dbresp.Extra3;

                    QRCoder.QRCodeGenerator qrGenerator = new QRCodeGenerator();
                    var encData = AgentCode.EncryptParameterForQr();
                    QRCodeData qrCodeData = qrGenerator.CreateQrCode(encData, QRCodeGenerator.ECCLevel.Q);
                    QRCode qrCode = new QRCode(qrCodeData);
                    Bitmap qrCodeImage = qrCode.GetGraphic(20);
                    string ImageUrl = "";
                    using (MemoryStream stream = new MemoryStream())
                    {
                        qrCodeImage.Save(stream, System.Drawing.Imaging.ImageFormat.Png);
                        byte[] byteImage = stream.ToArray();
                        ImageUrl = string.Format(Convert.ToBase64String(byteImage));
                       
                    }
                    string qrFilePath = Server.MapPath("~/Content/userupload/Merchant/");
                    string qrImageName = "qrImage" + "_" + userId + "_" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss").Replace("-", "_").Replace(" ", "_").Replace(":", "_") + ".png";
                    qrCodeImage.Save(qrFilePath + qrImageName, ImageFormat.Png);
                    CommonDbResponse qrInsert = _merchant.AddCardQr(userId, agentId, ImageUrl, "/Content/userupload/Merchant/" + qrImageName);


                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("Index");
                }
                merchantModel.Msg = dbresp.Message;

            }
            this.ShowPopup(1, "Error " + merchantModel.Msg);
            return View(merchantModel);

        }

        public ActionResult MerchantDetail(string merchantId)
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
                    var pprovince = LoadDropdownList("province") as Dictionary<string, string>;
                    merchantModel.MerchantProvince = pprovince.ContainsKey(merchantModel.MerchantProvince)
                        ? pprovince.FirstOrDefault(x => x.Key == merchantModel.MerchantProvince).Value : merchantModel.MerchantProvince;
                    return View(merchantModel);

                }
            }
            this.ShowPopup(1, "Error");
            return RedirectToAction("Index");
        }
        [HttpGet,OverrideActionFilters]
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

        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult EnableMerchant(string merchantid, string status)
        {
            var data = new CommonDbResponse();
            MerchantCommon merchantCommon = new MerchantCommon();
            bool valid = true;
            //string userId = userid.DecryptParameter();
            string agentId = merchantid.DecryptParameter();
            if (String.IsNullOrEmpty(agentId))
            {
                data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid User." };
                valid = false;
            }

            if (valid)
            {
                merchantCommon.MerchantStatus = "y";
                merchantCommon.MerchantID = agentId;
                //merchantCommon.UserID = userId;
                merchantCommon.ActionUser = Session["UserName"].ToString();
                data = _merchant.Disable_EnableMerchant(merchantCommon);
                //if (data.ErrorCode == 0)
                //{
                //    data.Message = "Successfully Changed User";
                //}
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult DisableMerchant(string merchantid, string status)
        {
            var data = new CommonDbResponse();
            MerchantCommon merchantCommon = new MerchantCommon();
            bool valid = true;
            //string userId = userid.DecryptParameter();
            string agentId = merchantid.DecryptParameter();
            if ( String.IsNullOrEmpty(agentId))
            {
                data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid User." };
                valid = false;
            }

            if (valid)
            {
                merchantCommon.MerchantStatus = "n";
                merchantCommon.MerchantID = agentId;
                //merchantCommon.UserID = userId;
                merchantCommon.ActionUser = Session["UserName"].ToString();
                data = _merchant.Disable_EnableMerchant(merchantCommon);
                //if (data.ErrorCode == 0)
                //{
                //    data.Message = "Successfully Changed User";
                //}
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }

        #region login user
        public ActionResult ViewMerchantUser(string merchantid = "")
        {
            var UserType = Session["UserType"].ToString();
            string username = ApplicationUtilities.GetSessionValue("username").ToString();
            string id = "", IsPrimary = ApplicationUtilities.GetSessionValue("IsPrimaryUser").ToString().Trim();
            
            if(!string.IsNullOrEmpty(merchantid))
            {
                id = merchantid.DecryptParameter();
            }
            
            if (string.IsNullOrEmpty(id))
            {
                return RedirectToAction("Index");
            }
            //var userId = "";
            //if (String.IsNullOrEmpty(IsPrimary) == false && (IsPrimary.ToUpper().Trim() == "N" || IsPrimary.ToUpper().Trim() == ""))
            //{
            //    userId = Session["UserId"].ToString();
            //}
            var merchantuser = _merchant.GetUserList(id, username);
            //Actions
            foreach (var item in merchantuser)
            {
                item.Action = StaticData.GetActions("Merchantuser", item.UserId.EncryptParameter(), this, "", "", item.MerchantId.EncryptParameter(), item.UserStatus, item.IsPrimary, DisableAddEdit: Session["UserId"].ToString() == item.UserId);
                item.UserStatus = "<span class='badge badge-" + (item.UserStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.UserStatus.Trim().ToUpper() == "Y" ? "Active" : "Blocked") + "</span>";
                item.IsPrimary = "<span class='badge badge-" + (item.IsPrimary.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.IsPrimary.Trim().ToUpper() == "Y" ? "Primary" : "Secondary") + "</span>";
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("DistributorId", "Agent Id");
            param.Add("FullName", "Full Name");
            param.Add("UserName", "User Name");
            param.Add("UserEmail", "Email");
            param.Add("UserMobileNumber", "Mobile Number");
            // param.Add("UserType", "User Type");
            param.Add("IsPrimary", "Is primary");
            param.Add("UserStatus", "Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            //Add New
            var grid = ProjectGrid.MakeGrid(merchantuser, "Merchant Users", "", 0, true, "", "", "Home", "Merchant", "/Admin/merchantmanagement/ManagemerchantUsers","/Admin/merchantmanagement/ManagemerchantUsers?merchantid=" + id.EncryptParameter());
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
       

        [HttpPost, ValidateAntiForgeryToken]
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
        [HttpPost, ValidateAntiForgeryToken]
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

        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult ResetPassword(string userid, string merchantid)
        {
            var data = new CommonDbResponse();
            bool valid = true;
            string userId = userid.DecryptParameter();
            string MerchantId = merchantid.DecryptParameter();
            if (String.IsNullOrEmpty(userId))
            {
                data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Failed to Reset Password" };
                valid = false;
            }
            MerchantCommon model = new MerchantCommon();
            model.MerchantID = MerchantId;
            model.UserID = userId;
            model.ActionUser = ApplicationUtilities.GetSessionValue("username").ToString();
            model.IpAddress = ApplicationUtilities.GetIP();
            if (valid)
            {
                data = _merchant.ResetPassword(model);
                //if (data.ErrorCode == 0)
                //{
                //    data.Message = "Successfully Changed User";
                //}
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }
        #endregion


        public void LoadDropDownList(MerchantModel merchantModel)
        {

            //Manage Distributor
            ViewBag.MerchantCountryList = ApplicationUtilities.SetDDLValue(LoadDropdownList("country"), merchantModel.MerchantCountry, "--Select Country--");
            ViewBag.MerchantProvinceList = ApplicationUtilities.SetDDLValue(LoadDropdownList("province", merchantModel.MerchantCountry), merchantModel.MerchantProvince, "--Select Province--");
            ViewBag.MerchantDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", merchantModel.MerchantProvince) as Dictionary<string, string>, merchantModel.MerchantDistrict, "--Select District--");
            ViewBag.MerchantVDC_MuncipilityList = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", merchantModel.MerchantDistrict), merchantModel.MerchantVDC_Muncipality, "--Select VDC Muncipality--");
            ViewBag.IssueDistrictList = ApplicationUtilities.SetDDLValue(LoadDropdownList("issuedistrict"), merchantModel.ContactPersonIdIssueDistrict, "--Select District--");
            ViewBag.DoctypeList = ApplicationUtilities.SetDDLValue(LoadDropdownList("doctype"), merchantModel.ContactPersonIdType, "--Select Document Type--");

        }
        public Dictionary<string, string> LoadDropdownList(string flag, string search1 = "")
        {
            switch (flag)
            {

                case "country":
                    return _ICB.sproc_get_dropdown_list("004");
                case "gender":
                    return _ICB.sproc_get_dropdown_list("005");
                case "occupation":
                    return _ICB.sproc_get_dropdown_list("024");
                case "doctype":
                    return _ICB.sproc_get_dropdown_list("014");
                case "province":
                    return _ICB.sproc_get_dropdown_list("002");
                case "issuedistrict":
                    return _ICB.sproc_get_dropdown_list("007");
                case "userRole":
                    return _ICB.sproc_get_dropdown_list("035");
                case "districtList":
                    return _ICB.sproc_get_dropdown_list("007", search1);
                case "vdc_muncipality":
                    return _ICB.sproc_get_dropdown_list("008", search1);

            }
            return null;
        }

        [OverrideActionFilters, HttpPost]
        public JsonResult GetDistrictsByProvince(string provinceId)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("districtList", provinceId) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }
        [HttpPost, OverrideActionFilters]
        public JsonResult GetMuncipalityByDistrict(string district)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            list = ApplicationUtilities.SetDDLValue(LoadDropdownList("vdc_muncipality", district) as Dictionary<string, string>, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }

    }
}
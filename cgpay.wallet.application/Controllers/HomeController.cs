using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Login;
using cgpay.wallet.shared.Models.Login;
using cgpay.wallet.application.Library;
using System.Web.UI.WebControls;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.KYC;
using System.Diagnostics;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.application.Controllers
{

    public class HomeController : Controller
    {
        ILoginUserBusiness _login;
        public HomeController(ILoginUserBusiness login)
        {
            _login = login;
        }
        [OverrideActionFilters]
        public ActionResult Index()
        {
            if (Session["UserName"] == null)
            {
                return View();
            }
            if (Session["UserType"].ToString().ToUpper() == "ADMIN" || Session["UserType"].ToString().ToUpper() == "DISTRIBUTOR" || Session["UserType"].ToString().ToUpper() == "SUBDISTRIBUTOR")
                return RedirectToAction("", "Home", new { area = "Admin" });
            else if (Session["UserType"].ToString().ToUpper() == "WALLETUSER" || Session["UserType"].ToString().ToUpper() == "MERCHANT" || Session["UserType"].ToString().ToUpper() == "AGENT" || Session["UserType"].ToString().ToUpper() == "SUB-AGENT")
                return RedirectToAction("", "Home", new { area = "Client" });
            return RedirectToAction("LogOff");
        }
        [OverrideActionFilters]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(LoginCommon model, string submit)
        {
            bool login = true;
            Session["SessionGuid"] = new Guid().ToString();
            if (submit == "SignIn")
            {
                ModelState.Remove("FullName");
                ModelState.Remove("Email");
                ModelState.Remove("MobileNo");
                ModelState.Remove("ConfirmPassword");
            }
            else if (submit == "SignUp")
            {
                ModelState.Remove("UserName");
                ModelState.Remove("Password");
                ModelState.Remove("ConfirmPassword");
                login = false;
            }
            else
            {
                return RedirectToAction("Index");
            }
            if (ModelState.IsValid)
            {
                if (login)
                {
                    var x = Login(model);
                    return RedirectToAction(x.Item1, x.Item2, new { area = x.Item3 });
                }
                else
                {
                    try
                    {
                        var dbres = _login.Signup(model);
                        int code = (int)dbres.Code;
                        TempData["msg"] = dbres.Message;
                        if (dbres.Code == shared.Models.ResponseCode.Success)
                        {
                            return RedirectToAction("verifyCode", model);
                        }
                        else
                        {
                            TempData["message"] = dbres.Message;
                        }
                    }
                    catch (Exception ex)
                    {
                        TempData["msg"] = "Something Went Wrong";
                    }

                }
            }
            return View();
        }
        [OverrideActionFilters]
        public ActionResult LogOff()
        {
            AbandonSession();
            return RedirectToAction("", "Home", new { area = "" });
        }
        [OverrideActionFilters]
        [HttpGet]
        public ActionResult VerifyCode(LoginCommon common)
        {
            // common.MobileNo = common.MobileNo.EncryptParameter();
            //  common.Email = common.Email.EncryptParameter();

            return View(common);
        }
        [OverrideActionFilters]
        [HttpPost, ActionName("VerifyCode")]
        [ValidateAntiForgeryToken]
        public ActionResult Verify_Code(LoginCommon common)
        {
            //common.MobileNo = common.MobileNo.DecryptParameter();
            //    common.Email = common.Email.DecryptParameter();
            var dbres = _login.verifycode(common);

            if (dbres.Code == shared.Models.ResponseCode.Success)
            {
                string aid = dbres.Extra1.EncryptParameter();
                return RedirectToAction("SetPassword", common);

            }
            TempData["msg"] = dbres.Message.ToString();
            return View();
        }
        [OverrideActionFilters]
        [HttpGet]
        public ActionResult SetPassword(LoginCommon common)
        {
            return View(common);
        }
        [OverrideActionFilters]
        [HttpPost, ActionName("SetPassword")]
        [ValidateAntiForgeryToken]
        public ActionResult Set_Password(LoginCommon common)
        {
            ModelState.Remove("UserName");
            string ErrorMessage = "";
            if (ModelState.IsValid)
            {
                var dbresp = _login.setpassword(common);
                if (dbresp.Code == shared.Models.ResponseCode.Success)
                {
                    /*
                    var requestVtoken =(StaticData.GetHtmlHelper(this)).AntiForgeryToken().ToHtmlString();
                    return Content("<html><body onload=\"document.getElementById('submit').click();\"><form action='/home/Index' id='frmTest' method='post'>" + requestVtoken+"<input type='hidden' name='UserName' value='" + common.MobileNo + "' /><input type='hidden' name='Password' value='" + common.Password + "' /><button type='submit' name='submit' value='SignIn' id='submit' ></button></form><script></script></body></html>");
                    */
                    ModelState.Clear();
                    common.UserName = "user" + common.MobileNo;
                    var x = Login(common);
                    return RedirectToAction(x.Item1, x.Item2, new { area = x.Item3 });

                    //return Index(common, "SignIn");
                    // return RedirectToAction("Index", new { model = common, submit = "SignIn" });
                }
                ErrorMessage = dbresp.Message;
            }
            TempData["msg"] = ErrorMessage;
            return View(common);
        }

        [OverrideActionFilters]
        [HttpGet]
        public ActionResult ForgotPassword()
        {
            LoginCommon common = new LoginCommon();
            return View(common);
        }
        //[OverrideActionFilters]
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult ForgotPassword(LoginCommon common)
        //{
        //    if(ModelState.IsValid)
        //    {
        //        var dbresp=_login.
        //    }
        //    return View();
        //}
        [OverrideActionFilters]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ForgotPassword(LoginCommon common)
        {
            ModelState.Remove("MobileNo");
            ModelState.Remove("Email");
            ModelState.Remove("Password");
            ModelState.Remove("ConfirmPassword");
            ModelState.Remove("FullName");
            if (ModelState.IsValid)
            {
                CommonDbResponse dbresp = _login.checkusername(common);
                if (dbresp.Code == 0)
                {
                    Session["forgotUsername"] = common.UserName;
                    return RedirectToAction("forgotpasswordverifycode");
                }
                else
                {
                    ModelState.Clear();
                    TempData["isValid"] = false;
                    common.UserName = "";
                    ModelState.AddModelError("UserName", "Invalid Email or Mobile Number");
                }
            }
            else
            {
                ModelState.Clear();
                TempData["isValid"] = false;
                common.UserName = "";
                ModelState.AddModelError("UserName", "Invalid Email or Mobile Number");
            }
            return View(common);

        }

        [OverrideActionFilters]
        [HttpGet]
        public ActionResult forgotpasswordverifycode()
        {
            LoginCommon common = new LoginCommon();
            if (Session["forgotUsername"] == null || Session["forgotUsername"].ToString() == "")
            {
                return RedirectToAction("ForgotPassword");
            }
            common.UserName = Session["forgotUsername"].ToString();
            return View(common);
        }
        [OverrideActionFilters]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult forgotpasswordverifycode(LoginCommon common)
        {

            if (string.IsNullOrEmpty(common.ActivationCode))
            {
                ModelState.Clear();
                TempData["isValid"] = false;
                common.UserName = Session["forgotUsername"].ToString();
                ModelState.AddModelError("ActivationCode", "Please enter verification code");
                return View(common);
            }

            ModelState.Remove("MobileNo");
            ModelState.Remove("Email");
            ModelState.Remove("Password");
            ModelState.Remove("ConfirmPassword");
            ModelState.Remove("FullName");
            common.UserName = Session["forgotUsername"].ToString();
            if (ModelState.IsValid)
            {
                CommonDbResponse dbresp = _login.Checkverifycode(common);
                if (dbresp.Code == 0)
                {
                    Session["uname"] = common.UserName;
                    Session["vcode"] = common.ActivationCode;
                    Session.Remove("forgotUsername");
                    return RedirectToAction("ChangePassword");
                }
                else
                {
                    ModelState.Clear();
                    TempData["isValid"] = false;
                    common.UserName = Session["forgotUsername"].ToString();
                    ModelState.AddModelError("ActivationCode", "Invalid OTP Code.");
                }
            }
            else
            {
                ModelState.Clear();
                TempData["isValid"] = false;
                common.UserName = Session["forgotUsername"].ToString();
                ModelState.AddModelError("ActivationCode", "Please enter verification code");

            }
            return View(common);
        }

        [OverrideActionFilters, HttpGet]
        public ActionResult ChangePassword(LoginCommon common)
        {
            ModelState.Remove("Password");
            if (Session["uname"] == null)
            {
                return RedirectToAction("LogOff");
            }

            return View();
        }

        [OverrideActionFilters]
        [HttpPost, ActionName("ChangePassword")]
        [ValidateAntiForgeryToken]
        public ActionResult Change_Password(LoginCommon common)
        {
            ModelState.Remove("MobileNo");
            ModelState.Remove("Email");
            //ModelState.Remove("Password");
            ModelState.Remove("FullName");
            ModelState.Remove("username");
            if (ModelState.IsValid)
            {
                common.ActivationCode = Session["vcode"].ToString();
                common.UserName = Session["uname"].ToString();
                CommonDbResponse dbresp = _login.changepassword(common);
                if (dbresp.Code == 0)
                {
                    return RedirectToAction("LogOff");
                }
            }
            return RedirectToAction("ChangePassword", common);
        }

        public Tuple<string, string, string> Login(LoginCommon common)
        {
            try
            {

                System.Web.HttpContext httpCtx = System.Web.HttpContext.Current;

                var browserDetails = httpCtx.Request.Headers["User-Agent"];
                string Ipaddress = ApplicationUtilities.GetIP();
                var dbres = _login.Login(new LoginCommon { UserName = common.UserName, Password = common.Password, IpAddress = Ipaddress, BrowserDetail = browserDetails });

                if (dbres.code == "0")
                {
                    Session["SessionGuid"] = Guid.NewGuid().ToString();
                    Session["UserId"] = dbres.UserId;
                    Session["RoleId"] = dbres.RoleId;
                    Session["AgentId"] = dbres.AgentId;
                    Session["ParentId"] = dbres.ParentId;
                    Session["UserName"] = dbres.UserName;
                    Session["FullName"] = dbres.FullName;
                    Session["UserType"] = dbres.UserType;
                    Session["KycStatus"] = dbres.KycStatus;
                    Session["FirstTimeLogin"] = dbres.FirstTimeLogin;
                    Session["IsPrimaryUser"] = dbres.IsPrimaryUser;


                    var menus = _login.GetMenus(common.UserName);
                    string areaName = "", dashboard_name = "Index";
                    if (dbres.UserType == "Admin" || dbres.UserType == "Distributor" || dbres.UserType == "Sub-Distributor")
                    {
                        areaName = "Admin";
                        if (dbres.UserType == "Distributor")
                        {
                            dashboard_name = "Dashboard2";
                        }
                        else if (dbres.UserType == "Sub-Distributor")
                        {
                            dashboard_name = "Dashboard3";
                        }

                    }
                    else if (dbres.UserType != null && (dbres.UserType.ToLower() == "walletuser" || dbres.UserType.ToLower() == "merchant" || dbres.UserType.ToLower() == "agent" || dbres.UserType.ToLower() == "sub-agent"))
                    {
                        areaName = "Client"; ;
                        if (dbres.KycStatus.ToUpper() == "APPROVED")
                        {
                            Session["KycStatus"] = "a";
                        }
                        else if (dbres.KycStatus.ToUpper() == "PENDING")
                        {
                            Session["KycStatus"] = "p";
                        }
                        else if (dbres.KycStatus.ToUpper() == "REJECTED")
                        {
                            Session["KycStatus"] = "r";
                        }
                        else
                        {
                            Session["KycStatus"] = "n";//N
                        }
                    }
                    var functions = _login.GetApplicatinFunction(dbres.RoleId, true);
                    _login.updateSessionId(Session["UserName"].ToString(), Session.SessionID);
                    Session["Menus"] = menus.menu;
                    Session["Functions"] = functions;
                    return new Tuple<string, string, string>(dashboard_name, "Home", areaName);
                }
                TempData["msg"] = dbres.message;
                return new Tuple<string, string, string>("Index", "Home", "");
            }
            catch (Exception)
            {
                TempData["msg"] = "Something Went Wrong";
                return new Tuple<string, string, string>("Index", "Home", "");

            }
        }
     
        public void AbandonSession()
        {
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }
        }


    }
}
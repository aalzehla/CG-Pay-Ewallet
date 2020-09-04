using cgpay.wallet.application.Library;
using cgpay.wallet.business.Role;
using cgpay.wallet.shared.Models.Role;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class RoleController : Controller
    {
        // GET: Admin/Role

        IRoleBusiness buss;
        public RoleController(IRoleBusiness _buss)
        {
            buss = _buss;
        }

        public ActionResult Index()
        {
            var model = buss.GetRoles();
            return View(model);
        }

        public ActionResult Manage()
        {
            var model = new RoleCommon();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Manage(RoleCommon model)
        {
            if(ModelState.IsValid)
            {
                model.CreatedBy = Session["UserName"].ToString();
                buss.Manage(model).SetMessageInTempData(this,"index");
                return RedirectToAction("Index");
            }
            return View(model);
        }

        public ActionResult privilege(string RoleId, string Name)
        {
            RoleId = RoleId.DecryptParameter();
            string name = Name.DecryptParameter();
            if (string.IsNullOrEmpty(RoleId) || string.IsNullOrEmpty(name))
            {
                return View("Error");
            }

            var dbres = buss.GetRoleList(RoleId);
            ViewData["RoleList"] = ApplicationUtilities.SetDDLValueMultiSelectWithGroup(dbres);
            ViewData["RoleId"] = RoleId.EncryptParameter();
            ViewBag.Name = name;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult privilege(string RoleId, string[] RoleList)
        {
            var data = RoleList != null ? string.Join(",", RoleList.ToArray()) : null;
            RoleId = RoleId.DecryptParameter();
            buss.AssignRoles(RoleId, data, Session["UserName"].ToString()).SetMessageInTempData(this, "index");
            return RedirectToAction("Index");
        }

        public ActionResult FunctionPrivilege(string RoleId, string Name)
        {
            RoleId = RoleId.DecryptParameter();
            string name = Name.DecryptParameter();
            if (string.IsNullOrEmpty(RoleId) || string.IsNullOrEmpty(name))
            {
                return View("Error");
            }

            var dbres = buss.GetFunctionList(RoleId);
            ViewData["FunctionList"] = ApplicationUtilities.SetDDLValueMultiSelectWithGroup(dbres);
            ViewData["RoleId"] = RoleId.EncryptParameter();
            ViewBag.Name = name;
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]

        public ActionResult FunctionPrivilege(string RoleId, string[] FunctionList)
        {
            var data =  FunctionList !=null ? string.Join(",", FunctionList.ToArray()) : null;
            RoleId = RoleId.DecryptParameter();
            buss.AssignFunctions(RoleId, data, Session["UserName"].ToString()).SetMessageInTempData(this, "index");
            return RedirectToAction("Index");
        }

    }
}
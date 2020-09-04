using cgpay.wallet.application.Library;
using cgpay.wallet.application.Filters;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Client.Commission;
using cgpay.wallet.business.Common;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.ClientCommission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    [SessionExpiryFilter]
    public class ClientCommissionController : Controller
    {
        // GET: Client/ClientCommission
        ICommonBusiness ICB;
        IClientCommissionBusiness comm;
        public ClientCommissionController(IClientCommissionBusiness _comm, ICommonBusiness _ICB)
        {
            ICB = _ICB;
            comm = _comm;
        }
        public ActionResult Category(string Search = "", int Pagesize = 10)
        {
            string agentid = ApplicationUtilities.GetSessionValue("agentid").ToString();
            var list = comm.GetCommissionCategoryList(agentid);
            foreach (var item in list)
            {
                item.IsActive = (item.IsActive.Trim().ToUpper() == "Y" ? "1" : "0");
                item.Action = StaticData.GetActions("ClientCommissionCategory", item.CategoryId.ToString().EncryptParameter(), this, "", "", item.IsActive);
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("CategoryName", "Category Name");
            param.Add("CreatedBy", "Created By");
            param.Add("CreateDate", "Created On");
            param.Add("IsActive", "Is Active");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "Commission Category", Search, Pagesize, true, "", "", "Home", "Commission", "/client/clientCommission/category", "/client/clientCommission/ManageCommissionCategory");
            ViewData["grid"] = grid;
            return View();

        }
        public ActionResult ManageCommissionCategory(string categoryid = "")
        {
            ClientCommissionCategoryModel CCM = new ClientCommissionCategoryModel();
            string Id = categoryid.DecryptParameter();
            if (!string.IsNullOrEmpty(Id))
            {
                var cc = comm.GetCommissionCategoryById(categoryid.DecryptParameter());
                if (cc != null)
                {
                    CCM.CategoryId = cc.CategoryId.EncryptParameter();
                    CCM.CategoryName = cc.CategoryName;
                }

            }

            return View(CCM);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageCommissionCategory(ClientCommissionCategoryModel CCM)
        {
            if (ModelState.IsValid)
            {
                ClientCommissionCategoryCommon CCC = new ClientCommissionCategoryCommon();
                CCC.CategoryId = CCM.CategoryId.DecryptParameter();
                CCC.CategoryName = CCM.CategoryName;
                CCC.IpAddress = ApplicationUtilities.GetIP();
                CCC.AgentId = ApplicationUtilities.GetSessionValue("agentid").ToString();

                CCC.ActionUser = Session["username"].ToString();
                CommonDbResponse dbresp = comm.ManageCommissionCategory(CCC);


                if (dbresp.Code == 0)
                {
                    this.ShowPopup((int)dbresp.Code, dbresp.Message);
                    return RedirectToAction("Category");
                }
            }
            this.ShowPopup(1, "Error");
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult DisableCommissionCategory(string ID)
        {
            if (!string.IsNullOrEmpty(ID))
            {
                ClientCommissionCategoryCommon CCC = new ClientCommissionCategoryCommon();
                CCC.CategoryId = ID.DecryptParameter();
                CCC.IpAddress = ApplicationUtilities.GetIP();
                CCC.ActionUser = Session["username"].ToString();
                if (string.IsNullOrEmpty(CCC.CategoryId))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Category." });
                }
                CommonDbResponse dbresp = comm.block_unblockCategory(CCC, "N");

                if (dbresp.ErrorCode == 0)
                {
                    dbresp.Message = "Successfully Blocked Category";
                    dbresp.SetMessageInTempData(this);

                }
                return Json(dbresp);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Category." });
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult EnableCommissionCategory(string ID)
        {
            if (!string.IsNullOrEmpty(ID))
            {
                ClientCommissionCategoryCommon CCC = new ClientCommissionCategoryCommon();
                CCC.CategoryId = ID.DecryptParameter();
                CCC.IpAddress = ApplicationUtilities.GetIP();
                CCC.ActionUser = Session["username"].ToString();
                if (string.IsNullOrEmpty(CCC.CategoryId))
                {
                    return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Category." });
                }
                CommonDbResponse dbresp = comm.block_unblockCategory(CCC, "Y");

                if (dbresp.ErrorCode == 0)
                {
                    dbresp.Message = "Successfully Un-Blocked Category";
                    dbresp.SetMessageInTempData(this);

                }
                return Json(dbresp);
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Category." });
        }



        public ActionResult CommissionProductList(string categoryid = "", string Search = "", int Pagesize = 10)
        {
            categoryid = categoryid.DecryptParameter();

            var list = comm.GetCommissionCategoryProductList(categoryid);
            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("ProductCommissionCategory", item.CommissionDetailId.ToString().EncryptParameter(), this, "/client/clientcommission/ManageCommissionCategoryProduct", "/client/clientcommission/ManageCommissionCategoryProduct?id=" + item.CommissionDetailId.EncryptParameter(), "");
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("ProductLabel", "Product Label");
            param.Add("CommissionType", "Commission Type");
            param.Add("CommissionValue", "Commission Value");
            param.Add("CommissionPercentType", "Commission Percent Type");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "Category Product", Search, Pagesize, false, "", "", "Home", "Commission", "", "");
            ViewData["grid"] = grid;
            return View();
        }
        public ActionResult ManageCommissionCategoryProduct(string id)
        {
            ClientCommissionCategoryDetailCommon CDC = comm.GetCommissioncategoryProductById(id.DecryptParameter());
            ClientCommissionCategoryDetailModel CMC = new ClientCommissionCategoryDetailModel();
            if (CDC != null)
            {

                CMC.CommissionDetailId = CDC.CommissionDetailId.EncryptParameter();
                CMC.ProductId = CDC.ProductId;
                CMC.CommissionCategoryId = CDC.CommissionCategoryId.EncryptParameter();
                CMC.CommissionType = CDC.CommissionType;
                CMC.CommissionValue = CDC.CommissionValue;
                CMC.CommissionPercentType = CDC.CommissionPercentType.Trim();

            }
            ViewBag.productlist = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("servicelist"), CMC.ProductId, "Select Product");

            ViewBag.CommissionPercentTypeList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("031"), CMC.CommissionPercentType, "Select Percent Type");
            ViewBag.CommissionTypeList = LoadDropdownList("commissiontype") as List<SelectListItem>;
            return View(CMC);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageCommissionCategoryProduct(ClientCommissionCategoryDetailModel CMC)
        {
            ViewBag.productlist = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("servicelist"), CMC.ProductId, "Select Product");
            // ViewBag.CommissionPercentType = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("031"), CMC.CommissionPercentType, "Select Percent Type");
            ViewBag.CommissionPercentTypeList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("031"), CMC.CommissionPercentType, "Select Percent Type");
            ViewBag.CommissionTypeList = LoadDropdownList("commissiontype") as List<SelectListItem>;
            if (ModelState.IsValid)
            {
                ClientCommissionCategoryDetailCommon CDC = new ClientCommissionCategoryDetailCommon();

                CDC.CommissionDetailId = CMC.CommissionDetailId.DecryptParameter();
                CDC.ProductId = CMC.ProductId;
                CDC.CommissionCategoryId = CMC.CommissionCategoryId.DecryptParameter();
                CDC.CommissionType = CMC.CommissionType;
                CDC.CommissionPercentType = CMC.CommissionPercentType;
                CDC.CommissionValue = CMC.CommissionValue;
                CDC.IpAddress = ApplicationUtilities.GetIP();
                CDC.ActionUser = Session["username"].ToString();
                if ((CDC.CommissionType != "F" && float.Parse(CDC.CommissionValue) > 100) || (float.Parse(CDC.CommissionValue) < 0))
                {
                    this.ShowPopup(1, "Commission Value Mismatch");
                    return View(CMC);
                }
                CommonDbResponse dbres = comm.ManageCommissionCategoryProduct(CDC);
                if (dbres.Code == 0)
                {
                    this.ShowPopup(0, dbres.Message);
                    return RedirectToAction("CommissionProductList", new { categoryid = CMC.CommissionCategoryId });
                }
                CMC.Msg = dbres.Message;

            }
            this.ShowPopup(1, "Error" + CMC.Msg);
            return View(CMC);
        }

        public ActionResult AssignCategory(string Search = "", int Pagesize = 10)
        {
            ClientAssignCommissionCommon ACC = new ClientAssignCommissionCommon();
            ACC.AgentType = Session["UserType"].ToString();
            ACC.AgentId = ApplicationUtilities.GetSessionValue("agentid").ToString();//Session["UserId"].ToString();

            var list = comm.GetAssignedCategoryList(ACC);
            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("AssignCommissionCategory", item.AgentId.ToString().EncryptParameter(), this, "", "/client/clientcommission/ManageAssignCategory?ID=" + item.AgentId.EncryptParameter(), "");
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("AgentName", "Agent Name");
            param.Add("AgentType", "Agent Type");
            param.Add("CommissionCategoryName", "Category Name");
            //  param.Add("CreateDate", "Created On");
            // param.Add("updatedby", "Updated By");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "Assign Category", Search, Pagesize, false, "", "", "Home", "Commission", "", "");
            ViewData["grid"] = grid;
            return View();
        }

        public ActionResult ManageAssignCategory(string ID)
        {
            ClientAssignCommissionCommon ACC = comm.GetAssignedCategoryById(ID.DecryptParameter());
            ClientAssignCommissionModel ACM = new ClientAssignCommissionModel();
            if (ACC != null)
            {
                ACM.AgentName = ACC.AgentName;
                ACM.AgentId = ACC.AgentId.EncryptParameter();
                ACM.CommissionCategoryId = ACC.CommissionCategoryId;

                ViewBag.CommissionCategoryList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("016",ApplicationUtilities.GetSessionValue("agentid").ToString()), ACM.CommissionCategoryId, "Select Commission Category");
                return View(ACM);

            }
            this.ShowPopup(1, "Error");
            return RedirectToAction("AssignCategory");

        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageAssignCategory(ClientAssignCommissionModel ACM)
        {
            if (ModelState.IsValid)
            {
                if (!string.IsNullOrEmpty(ACM.AgentId.DecryptParameter()))
                {
                    ClientAssignCommissionCommon ACC = new ClientAssignCommissionCommon();
                    ACC.CommissionCategoryId = ACM.CommissionCategoryId;
                    ACC.AgentId = ACM.AgentId.DecryptParameter();
                    ACC.ActionUser = Session["username"].ToString();
                    CommonDbResponse dbresp = comm.ManageAssignCategory(ACC);
                    if (dbresp.Code == 0)
                    {
                        this.ShowPopup(0, dbresp.Message);
                        return RedirectToAction("AssignCategory");
                    }
                    ACM.Msg = dbresp.Message;
                }

            }
            this.ShowPopup(1, "Error " + ACM.Msg);
            return View(ACM);
        }

        public object LoadDropdownList(string forMethod)
        {
            switch (forMethod)
            {

                case "commissiontype":
                    return new List<SelectListItem> { new SelectListItem { Text = "Select Commission Type", Value = "" }, new SelectListItem { Text = "Percentage", Value = "P" }, new SelectListItem { Text = "Flat", Value = "F" } };


            }
            return null;
        }
    }
}
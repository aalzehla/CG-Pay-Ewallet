using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Agent_Commission;
using cgpay.wallet.business.Common;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Commission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class AgentCommissionController : Controller
    {
        ICommonBusiness ICB;
        IAgentCommissionBusiness comm;
        public AgentCommissionController(IAgentCommissionBusiness _comm, ICommonBusiness _ICB)
        {
            ICB = _ICB;
            comm = _comm;
        }
        // GET: Admin/AgentCommission
        public ActionResult Category(string Search = "", int Pagesize = 10)
        {
            string agentid = ApplicationUtilities.GetSessionValue("agentid").ToString();

            var list = comm.GetAgentCommissionCategoryList(agentid);

            foreach (var item in list)
            {
                item.IsActive = (item.IsActive.Trim().ToUpper() == "Y" ? "1" : "0");
                item.Action = StaticData.GetActions("AgentCommissionCategory", item.CategoryId.ToString().EncryptParameter(), this, "", "", item.IsActive);


            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("CategoryName", "Category Name");
            param.Add("CreatedBy", "Created By");
            param.Add("CreateDate", "Created On");
            param.Add("IsActive", "Is Active");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "Agent Commission Category", Search, Pagesize, true, "", "", "Home", "AgentCommission", "/Admin/AgentCommission/Category", "/Admin/AgentCommission/ManageAgentCommissionCategory");
            ViewData["grid"] = grid;
            return View();
        }
        public ActionResult ManageAgentCommissionCategory(string categoryid = "")
        {
            CommissionCategoryModel CCM = new CommissionCategoryModel();
            string Id = categoryid.DecryptParameter();
            if (!string.IsNullOrEmpty(Id))
            {
                var cc = comm.GetAgentCommissionCategoryById(categoryid.DecryptParameter());
                if (cc != null)
                {
                    CCM.CategoryId = cc.CategoryId.EncryptParameter();
                    CCM.CategoryName = cc.CategoryName;
                }

            }

            return View(CCM);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageAgentCommissionCategory(CommissionCategoryModel CCM)
        {
            if (ModelState.IsValid)
            {
                CommissionCategoryCommon CCC = new CommissionCategoryCommon();

                if (!string.IsNullOrEmpty(CCM.CategoryId))
                {
                    CCC.CategoryId = CCM.CategoryId.DecryptParameter();
                    if (string.IsNullOrEmpty(CCC.CategoryId))
                    {
                        return RedirectToAction("Category");
                    }
                }
                CCC.CategoryId = CCM.CategoryId.DecryptParameter();
                CCC.CategoryName = CCM.CategoryName;
                CCC.IpAddress = ApplicationUtilities.GetIP();
                CCC.ActionUser = Session["username"].ToString();
                CCC.AgentId = ApplicationUtilities.GetSessionValue("agentid").ToString();
                CommonDbResponse dbresp = comm.ManageAgentCommissionCategory(CCC);


                if (dbresp.Code == 0)
                {
                    this.ShowPopup((int)dbresp.Code, dbresp.Message);
                    return RedirectToAction("Category");
                }
            }
            this.ShowPopup(1, "Error");
            return View();
        }
        public ActionResult AgentCommissionProductList(string categoryid = "", string Search = "", int Pagesize = 10)
        {
            categoryid = categoryid.DecryptParameter();
           
            var list = comm.GetAgentCommissionCategoryProductList(categoryid);
            

            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("AgentProductCommissionCategory", item.CommissionDetailId.ToString().EncryptParameter(), this, "/Admin/AgentCommission/ManageAgentCommissionCategoryProduct", "/Admin/AgentCommission/ManageAgentCommissionCategoryProduct?id=" + item.CommissionDetailId.EncryptParameter(), "");

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
        public ActionResult ManageAgentCommissionCategoryProduct(string id)
        {
            CommissionCategoryDetailCommon CDC = comm.GetAgentCommissioncategoryProductById(id.DecryptParameter());
            CommissionCategoryDetailModel CMC = new CommissionCategoryDetailModel();
            string agentid = Session["AgentId"].ToString();
            if (CDC != null)
            {

                CMC.CommissionDetailId = CDC.CommissionDetailId.EncryptParameter();
                CMC.ProductId = CDC.ProductId;
                CMC.CommissionCategoryId = CDC.CommissionCategoryId.EncryptParameter();
                CMC.CommissionType = CDC.CommissionType;
                CMC.CommissionValue = CDC.CommissionValue;
                string agentcommCat = comm.GetAdminCommCatagory(agentid).CommissionCategoryId;
                var admincomm = comm.GetAdminCommvalue(agentcommCat, CDC.ProductId);
                CMC.AdminCommissionType = admincomm.CommissionType;
                CMC.AdminCommissionValue = admincomm.CommissionValue;
                CMC.AdminProductId = admincomm.ProductId;
                //CMC.CommissionPercentType = CDC.CommissionPercentType.Trim();
               

            }
            ViewBag.productlist = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("servicelist"), CMC.ProductId, "Select Product");

            CMC.CommissionPercentTypeList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("031"), CMC.CommissionPercentType, "Select Percent Type");
            CMC.CommissionTypeList = LoadDropdownList("commissiontype") as List<SelectListItem>;
            return View(CMC);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageAgentCommissionCategoryProduct(CommissionCategoryDetailModel CMC)
        {
            ViewBag.productlist = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("servicelist"), CMC.ProductId, "Select Product");
            CMC.CommissionPercentTypeList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("031"), CMC.CommissionPercentType, "Select Percent Type");

            CMC.CommissionTypeList = LoadDropdownList("commissiontype") as List<SelectListItem>;
            ModelState.Remove("CommissionDetailId");
            ModelState.Remove("CommissionCategoryId");
            //ModelState.Remove("ProductId");
            //ModelState.Remove("CommissionType");
            //ModelState.Remove("ProductId");
            ModelState.Remove("CommissionPercentType");

            if (ModelState.IsValid)
            {
                CommissionCategoryDetailCommon CDC = new CommissionCategoryDetailCommon();

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
                if ((float.Parse(CDC.CommissionValue) > (float.Parse(CMC.AdminCommissionValue))) && (CMC.AdminCommissionType == CDC.CommissionType))            
                {
                    this.ShowPopup(1, "Commission value can not be greater than commission value assigned by admin to this distributor");
                    return View(CMC);
                }

                CommonDbResponse dbres = comm.ManageAgentCommissionCategoryProduct(CDC);
                if (dbres.Code == 0)
                {
                    this.ShowPopup(0, dbres.Message);
                    return RedirectToAction("AgentCommissionProductList", new { categoryid = CMC.CommissionCategoryId });
                }
                CMC.Msg = dbres.Message;

            }
            this.ShowPopup(1, "Error" + CMC.Msg);
            return View(CMC);
        }
        public ActionResult AssignCategory(string Search = "", int Pagesize = 10)
        {
            AssignCommissionCommon ACC = new AssignCommissionCommon();
            ACC.AgentType = Session["UserType"].ToString();
            ACC.AgentId = ApplicationUtilities.GetSessionValue("agentid").ToString();

            var list = comm.GetAssignedCategoryList(ACC);
            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("AssignCommissionCategory", item.AgentId.ToString().EncryptParameter(), this, "", "/admin/AgentCommission/ManageAssignCategory?ID=" + item.AgentId.EncryptParameter(), "");
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            //param.Add("AgentId", "Agent Id");
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
            AssignCommissionCommon ACC = comm.GetAssignedCategoryById(ID.DecryptParameter());
            AssignCommissionModel ACM = new AssignCommissionModel();
            if (ACC != null)
            {
                var agentid = ApplicationUtilities.GetSessionValue("agentid").ToString();
                ACM.AgentName = ACC.AgentName;
                ACM.AgentId = ACC.AgentId;
                ACM.CommissionCategoryId = ACC.CommissionCategoryId;

                ViewBag.CommissionCategoryList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("016",agentid), ACM.CommissionCategoryId, "Select Commission Category");
                return View(ACM);

            }
            this.ShowPopup(1, "Error");
            return RedirectToAction("AssignCategory");

        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageAssignCategory(AssignCommissionModel ACM)
        {
            if (ModelState.IsValid)
            {
                if (!string.IsNullOrEmpty(ACM.AgentId))
                {
                    AssignCommissionCommon ACC = new AssignCommissionCommon();
                    ACC.CommissionCategoryId = ACM.CommissionCategoryId;
                    ACC.AgentId = ACM.AgentId;
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult DisableCommissionCategory(string ID)
        {
            if (!string.IsNullOrEmpty(ID))
            {
                CommissionCategoryCommon CCC = new CommissionCategoryCommon();
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
                CommissionCategoryCommon CCC = new CommissionCategoryCommon();
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
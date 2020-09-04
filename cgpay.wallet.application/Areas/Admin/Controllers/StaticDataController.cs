using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.business.StaticData;
using cgpay.wallet.application.Models;
using cgpay.wallet.shared.Models;
using cgpay.wallet.application.Library;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class StaticDataController : Controller
    {
        // GET: Admin/StaticData
        IStaticDataBusiness buss;
        public StaticDataController(IStaticDataBusiness _buss)
        {
            buss = _buss;

        }
        public ActionResult Index(string Search="",int Pagesize=10)
        {
            List<StaticDataCommon> lst = buss.GetStaticDataTypeList();
            foreach (var item in lst)
            {
                item.Action = StaticData.GetActions("StaticDataType", item.StaticDataTypeId.ToString().EncryptParameter(), this, "", "", "");
            }

            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("StaticDataTypeName", "Static Data Type Name");
            param.Add("StaticDataTypeDescription", "Static Data Type Description");            
            param.Add("Action", "Action");


            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(lst, "hidebreadcrumb", Search, Pagesize, false, "", "", "Home", "Static Data Type", "", "");
            ViewData["grid"] = grid;
            return View();
        }
        public ActionResult StaticDataList(string SdatatypeID)
        {
            if (!string.IsNullOrEmpty(SdatatypeID))
            {
                SdatatypeID = SdatatypeID.DecryptParameter();
                if(string.IsNullOrEmpty(SdatatypeID))
                {
                    this.ShowPopup(1, "Error");
                    return RedirectToAction("Index");
                }
                List<StaticDataCommon> lst = buss.GetStaticDataList(SdatatypeID);
                foreach (var item in lst)
                {
                    item.IsDeleted = string.IsNullOrEmpty(item.IsDeleted) ? "n" : item.IsDeleted;
                    item.Action = StaticData.GetActions("StaticDataList", item.StaticDataId.ToString().EncryptParameter(), this, "", "", item.StaticDataTypeId.EncryptParameter(),item.IsDeleted);
                    item.IsDeleted = "<span class='badge badge-" + (item.IsDeleted.Trim().ToUpper() == "Y" ? "danger" : "success") + "'>" + (item.IsDeleted.Trim().ToUpper() == "Y" ? "Disabled" : "Enabled") + "</span>";
                }

                IDictionary<string, string> param = new Dictionary<string, string>();
                //param.Add("ProductId", "Product Id");
                param.Add("StaticDataLabel", "Static Data Label");
                param.Add("StaticDataValue", "Static Data Value");
                param.Add("StaticDataDescription", "Static Data Description");
                param.Add("IsDeleted", "Status");
                param.Add("Action", "Action");


                ProjectGrid.column = param;
                var grid = ProjectGrid.MakeGrid(lst, "", "", 10, true, "", "", "Home", "Static Data Type", "/Admin/StaticData/Index", "/Admin/Staticdata/Managestaticdata?sdatatypeid="+ SdatatypeID.EncryptParameter());
                ViewData["grid"] = grid;
                return View();
            }
            else
            {
                this.ShowPopup(1, "Error");
                return RedirectToAction("Index");
            }

        }
        public ActionResult ManageStaticData(string sdatatypeId,string sdataid="")
        {
            StaticDataCommon SDC = new StaticDataCommon();
            StaticDataModel SDM = new StaticDataModel();
            if(!string.IsNullOrEmpty(sdatatypeId))
            {
                SDM.StaticDataTypeId = sdatatypeId;
                sdatatypeId = sdatatypeId.DecryptParameter().ToString();
                if(!string.IsNullOrEmpty(sdatatypeId) && !string.IsNullOrEmpty(sdataid))
                {
                    sdataid = sdataid.DecryptParameter();
                    if(!string.IsNullOrEmpty(sdataid))
                    {
                        SDC = buss.GetStaticDataById(sdataid, sdatatypeId);
                        SDC.StaticDataTypeId = SDC.StaticDataTypeId.EncryptParameter();
                        SDC.StaticDataId = SDC.StaticDataId.EncryptParameter();
                         SDM = SDC.MapObject<StaticDataModel>();                       
                    }
                }
                return View(SDM);
            }
            return RedirectToAction("StaticDataList", new { SdatatypeID = SDM.StaticDataTypeId });
        }
        [HttpPost,ValidateAntiForgeryToken]
        public ActionResult ManageStaticData(StaticDataModel SDM)
        {
            StaticDataCommon SDC = new StaticDataCommon();
            if (ModelState.IsValid)
            {
                SDC = SDM.MapObject<StaticDataCommon>();
                SDC.StaticDataTypeId = SDC.StaticDataTypeId.DecryptParameter();

                if (!string.IsNullOrEmpty(SDC.StaticDataId))
                    SDC.StaticDataId = SDC.StaticDataId.DecryptParameter();
                SDC.ActionUser = Session["username"].ToString();
                CommonDbResponse dbresp = buss.ManageStaticData(SDC);
                if (dbresp.Code==0)
                {
                    this.ShowPopup(0, dbresp.Message);
                    return RedirectToAction("StaticDataList", new { SdatatypeID = SDM.StaticDataTypeId });
                }
            }
            this.ShowPopup(1, "Error");
            return View(SDM);            
        }
        public ActionResult StaticDataDetail(string sdatatypeId, string sdataid = "")
        {
            StaticDataCommon SDC = new StaticDataCommon();
            StaticDataModel SDM = new StaticDataModel();
            if (!string.IsNullOrEmpty(sdatatypeId))
            {
                SDM.StaticDataTypeId = sdatatypeId;
                sdatatypeId = sdatatypeId.DecryptParameter().ToString();
                if (!string.IsNullOrEmpty(sdatatypeId) && !string.IsNullOrEmpty(sdataid))
                {
                    sdataid = sdataid.DecryptParameter();
                    if (!string.IsNullOrEmpty(sdataid))
                    {
                        SDC = buss.GetStaticDataById(sdataid, sdatatypeId);
                        SDC.StaticDataTypeId = SDC.StaticDataTypeId.EncryptParameter();
                        SDC.StaticDataId = SDC.StaticDataId.EncryptParameter();
                        SDM = SDC.MapObject<StaticDataModel>();
                    }
                }
                return View(SDM);
            }
            return RedirectToAction("StaticDataList", new { SdatatypeID = SDM.StaticDataTypeId });
        }
        [HttpPost,ValidateAntiForgeryToken]
        public JsonResult DisableSData(string sdatatypeId, string sdataid)
        {
            if(!string.IsNullOrEmpty(sdataid) && !string.IsNullOrEmpty(sdatatypeId))
            {
                sdataid = sdataid.DecryptParameter();
                sdatatypeId = sdatatypeId.DecryptParameter();
                if (!string.IsNullOrEmpty(sdataid) && !string.IsNullOrEmpty(sdatatypeId))
                {
                    StaticDataCommon sdc = new StaticDataCommon();
                    sdc.StaticDataId = sdataid;
                    sdc.StaticDataTypeId = sdatatypeId;
                    sdc.ActionUser = Session["username"].ToString();
                    CommonDbResponse dbresp = buss.block_unblockStaticData(sdc, "y");
                    if (dbresp.Code == 0)
                    {
                        dbresp.Message = "Successfully Blocked Static Data";
                        dbresp.SetMessageInTempData(this);
                    }
                    return Json(dbresp);
                } 
            
            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Static Data" });
        }
        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult EnableSData(string sdatatypeId, string sdataid)
        {
            if (!string.IsNullOrEmpty(sdataid) && !string.IsNullOrEmpty(sdatatypeId))
            {
                sdataid = sdataid.DecryptParameter();
                sdatatypeId = sdatatypeId.DecryptParameter();
                if (!string.IsNullOrEmpty(sdataid) && !string.IsNullOrEmpty(sdatatypeId))
                {
                    StaticDataCommon sdc = new StaticDataCommon();
                    sdc.StaticDataId = sdataid;
                    sdc.StaticDataTypeId = sdatatypeId;
                    sdc.ActionUser = Session["username"].ToString();
                    CommonDbResponse dbresp = buss.block_unblockStaticData(sdc, "n");
                    if (dbresp.Code == 0)
                    {
                        dbresp.Message = "Successfully Un-Blocked Static Data";
                        dbresp.SetMessageInTempData(this);
                    }
                    return Json(dbresp);
                }

            }
            return Json(new CommonDbResponse { ErrorCode = 1, Message = "Invalid Static Data" });
        }
    }
}
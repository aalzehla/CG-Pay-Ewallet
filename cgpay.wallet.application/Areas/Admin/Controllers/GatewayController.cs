using cgpay.wallet.application.Library;
using cgpay.wallet.business.Gateway;
using cgpay.wallet.shared.Models;
using cgpay.wallet.application.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.business.Common;
using Newtonsoft.Json;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class GatewayController : Controller
    {
        // GET: Admin/Gateway
        string ControllerName = "Gateway";
        IGatewayBusiness buss;
        ICommonBusiness ICB;
        public GatewayController(IGatewayBusiness _buss, ICommonBusiness _ICB)
        {
            buss = _buss;
            ICB = _ICB;
        }
        public ActionResult Detail(string Search = "", int Pagesize = 10, string balanceadd = "")
        {
            var list = buss.GetGatewayList();
            //   dynamic list = null;
            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("Gateway", item.GatewayId.EncryptParameter(), this, "/Admin/Gateway/ManageGateway", "/Admin/Gateway/ManageGateway?GatewayID=" + item.GatewayId.EncryptParameter(), item.GatewayStatus, item.GatewayName.EncryptParameter());
                //  item.Action+= StaticData.GetActions("Gateway", item.GatewayId.EncryptParameter(), this, "/Admin/Gateway/ProductList", "/Admin/Gateway/ProductList?GatewayID=" + item.GatewayId.EncryptParameter(), item.GatewayStatus);
                item.GatewayStatus = "<span class='badge badge-" + (item.GatewayStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.GatewayStatus.Trim().ToUpper() == "Y" ? "Enable" : "Disable") + "</span>";
            }
            //  var list = buss.GetGatewayList(gateway_Id);
            IDictionary<string, string> param = new Dictionary<string, string>();
            //  param.Add("GatewayId", "Gateway ID");
            param.Add("GatewayName", "Gateway Name");
            param.Add("GatewayBalance", "Available Balance");
            //    param.Add("GatewayURL", "Gateway URL");
            param.Add("GatewayStatus", "Gateway Status");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "Gateway", Search, Pagesize, true, "", "", "Home", "Gateway", "/Admin/Gateway/Detail", "/Admin/Gateway/ManageGateway");
            ViewData["grid"] = grid;
            return View();
        }
        public ActionResult ManageGateway(string GatewayID = "")
        {
            GatewayCommon gatewaycommon = new GatewayCommon();
            GatewayModel gatewaymodel = new GatewayModel();
            if (!string.IsNullOrEmpty(GatewayID))
            {
                string gateway_id = GatewayID.DecryptParameter();
                if (!string.IsNullOrEmpty(gateway_id))
                {
                    gatewaycommon = buss.GetGatewayById(gateway_id);
                    gatewaymodel.GatewayId = gatewaycommon.GatewayId.EncryptParameter();
                    gatewaymodel.GatewayName = gatewaycommon.GatewayName;
                    gatewaymodel.GatewayUsername = gatewaycommon.GatewayUsername.DecryptParameter();
                    gatewaymodel.GatewayPwd = gatewaycommon.GatewayPwd.DecryptParameter();
                    gatewaymodel.GatewayBalance = gatewaycommon.GatewayBalance;
                    gatewaymodel.GatewayURL = gatewaycommon.GatewayURL.DecryptParameter();
                    gatewaymodel.GatewayAccessCode = gatewaycommon.GatewayAccessCode.DecryptParameter();
                    gatewaymodel.GatewaySecurityCode = gatewaycommon.GatewaySecurityCode.DecryptParameter();
                    gatewaymodel.GatewayApitoken = gatewaycommon.GatewayApitoken.DecryptParameter();
                    gatewaymodel.GatewayStatus = gatewaycommon.GatewayStatus;
                    gatewaymodel.IsDirectGateway = gatewaycommon.IsDirectGateway;
                    gatewaymodel.GatewayType = gatewaycommon.GatewayType;
                    gatewaymodel.GatewayCountry = gatewaycommon.GatewayCountry;
                    gatewaymodel.GatewayCurrency = "NPR";//gatewaycommon.GatewayCurrency;
                    gatewaymodel.GatewayContact = gatewaycommon.GatewayContact;
                }
            }
            gatewaymodel.GatewayCurrency = "NPR";
            gatewaymodel.IsDirectGatewayList = LoadDropdownList("directindirect") as List<SelectListItem>;
            gatewaymodel.GatewayTypeList = LoadDropdownList("gatewaytype") as List<SelectListItem>;
            // gatewaymodel.GatewayCurrencyList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("20"), gatewaymodel.GatewayCurrency, "Select Currency");
            gatewaymodel.GatewayCountryList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("030"), gatewaymodel.GatewayCurrency, "Select Country");
            return View(gatewaymodel);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageGateway(GatewayModel gm)
        {

            if (ModelState.IsValid)
            {
                string username = Session["UserName"].ToString();
                string ipaddress = ApplicationUtilities.GetIP();

                GatewayCommon gc = new GatewayCommon();
                gc.GatewayId = gm.GatewayId.DecryptParameter();
                if (!string.IsNullOrEmpty(gc.GatewayId))
                {
                    if (string.IsNullOrEmpty(gm.GatewayId))
                    {
                        this.ShowPopup(1, "Gateway Not found !");
                        return RedirectToAction("ManageGateway", gm);
                    }
                }
                gc.GatewayName = gm.GatewayName;
                gc.GatewayUsername = gm.GatewayUsername.EncryptParameter();
                gc.GatewayPwd = gm.GatewayPwd.EncryptParameter();
                // gc.GatewayBalance = gm.GatewayBalance;
                gc.GatewayURL = gm.GatewayURL.EncryptParameter();
                gc.GatewayAccessCode = gm.GatewayAccessCode.EncryptParameter();
                gc.GatewaySecurityCode = gm.GatewaySecurityCode.EncryptParameter();
                gc.GatewayApitoken = gm.GatewayApitoken.EncryptParameter();
                gc.GatewayStatus = gm.GatewayStatus;
                gc.IsDirectGateway = gm.IsDirectGateway;
                gc.GatewayType = gm.GatewayType.Trim();
                gc.GatewayCountry = gm.GatewayCountry;
                gc.GatewayCurrency = gm.GatewayCurrency;
                gc.GatewayContact = gm.GatewayContact;
                gc.ActionUser = username;
                gc.IpAddress = ipaddress;
                CommonDbResponse dbresp = buss.ManageGateway(gc);
                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, "Save Succesfully");
                    return RedirectToAction("Detail");
                }

            }
            this.ShowPopup(1, "Error");
            return RedirectToAction("ManageGateway", gm);
        }
        [HttpGet]
        public ActionResult GatewayDetail(string GatewayID = "")
        {
            GatewayCommon gatewaycommon = new GatewayCommon();
            GatewayDetailModel gatewaymodel = new GatewayDetailModel();
            if (!string.IsNullOrEmpty(GatewayID))
            {
                string gateway_id = GatewayID.DecryptParameter();
                if (!string.IsNullOrEmpty(gateway_id))
                {
                    gatewaycommon = buss.GetGatewayById(gateway_id);
                    gatewaymodel.GatewayId = gatewaycommon.GatewayId.EncryptParameter();
                    gatewaymodel.GatewayName = gatewaycommon.GatewayName;
                    gatewaymodel.GatewayUsername = gatewaycommon.GatewayUsername.DecryptParameter();
                    gatewaymodel.GatewayPwd = gatewaycommon.GatewayPwd.DecryptParameter();
                    gatewaymodel.GatewayBalance = gatewaycommon.GatewayBalance;
                    gatewaymodel.GatewayURL = gatewaycommon.GatewayURL.DecryptParameter();
                    gatewaymodel.GatewayAccessCode = gatewaycommon.GatewayAccessCode.DecryptParameter();
                    gatewaymodel.GatewaySecurityCode = gatewaycommon.GatewaySecurityCode.DecryptParameter();
                    gatewaymodel.GatewayApitoken = gatewaycommon.GatewayApitoken.DecryptParameter();
                    gatewaymodel.GatewayStatus = gatewaycommon.GatewayStatus;
                    gatewaymodel.IsDirectGateway = gatewaycommon.IsDirectGateway;
                    gatewaymodel.GatewayType = gatewaycommon.GatewayType;
                    gatewaymodel.GatewayCountry = gatewaycommon.GatewayCountry;
                    gatewaymodel.GatewayCurrency = "NPR";//gatewaycommon.GatewayCurrency;
                    gatewaymodel.GatewayContact = gatewaycommon.GatewayContact;
                }
            }
            gatewaymodel.GatewayCurrency = "NPR";
            //gatewaymodel.IsDirectGatewayList = LoadDropdownList("directindirect") as List<SelectListItem>;
            if (!string.IsNullOrEmpty(gatewaymodel.GatewayType))
            {
                if (gatewaymodel.GatewayType.ToUpper().Equals("P"))
                    gatewaymodel.GatewayType = "Payment";
                if (gatewaymodel.GatewayType.ToUpper().Equals("S"))
                    gatewaymodel.GatewayType = "SMS";
                if (gatewaymodel.GatewayType.ToUpper().Equals("T"))
                    gatewaymodel.GatewayType = "Transaction";
            }

            Dictionary<string, string> GatewayCountryList = new Dictionary<string, string>();
            if (GatewayCountryList.Count > 0)
            {
                gatewaymodel.GatewayCountry = GatewayCountryList.First(x => x.Key == gatewaymodel.GatewayCurrency).Value;
            }

            //gatewaymodel.GatewayTypeList = LoadDropdownList("gatewaytype") as List<SelectListItem>;
            // gatewaymodel.GatewayCurrencyList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("20"), gatewaymodel.GatewayCurrency, "Select Currency");
            //gatewaymodel.GatewayCountryList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("030"), gatewaymodel.GatewayCurrency, "Select Country");
            return View(gatewaymodel);
        }
        #region old balance add
        /*
        public ActionResult GatewayBalanceDetail(string Search = "", int Pagesize = 10)
        {

            var list = buss.GetGatewayList();

            //   dynamic list = null;

            foreach (var item in list)
            {
                item.Action = "<input type='button' value='Add Balance' onclick=showpopupmodel('" + item.GatewayId.EncryptParameter() + "')></input>"; // StaticData.GetActions("Gateway", item.GatewayId.EncryptParameter(), this, "/Admin/Gateway/ManageGatewayBalance", "showpopupmodel" + item.GatewayId.EncryptParameter(), item.GatewayStatus);
                item.GatewayStatus = "<span class='badge badge-" + (item.GatewayStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (item.GatewayStatus.Trim().ToUpper() == "Y" ? "Enable" : "Disable") + "</span>";
            }
            //  var list = buss.GetGatewayList(gateway_Id);

            IDictionary<string, string> param = new Dictionary<string, string>();
            //  param.Add("GatewayId", "Gateway ID");
            param.Add("GatewayName", "Gateway Name");
            param.Add("GatewayBalance", "Available Balance");
         //   param.Add("GatewayURL", "Gateway URL");
            param.Add("GatewayStatus", "Gateway Status");
            param.Add("Action", "Action");

            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "Gateway", Search, Pagesize, true, "", "", "Home", "Gateway", "/Admin/Gateway", "");
            ViewData["grid"] = grid;
            return View();
        }*/
        #endregion
        public JsonResult ManageGatewayBalance(string GatewayID = "")
        {
            GatewayCommon gatewaycommon = new GatewayCommon();
            GatewayBalanceModel balance = new GatewayBalanceModel();
            if (!string.IsNullOrEmpty(GatewayID))
            {
                string gateway_id = GatewayID.DecryptParameter();
                gatewaycommon = buss.GetGatewayById(gateway_id);
                balance.Gatewayid = gatewaycommon.GatewayId.EncryptParameter();
                balance.GatewayName = gatewaycommon.GatewayName;
                //gatewaymodel.GatewayUsername = gatewaycommon.GatewayUsername;//.DecryptParameter();
                //gatewaymodel.GatewayPwd = gatewaycommon.GatewayPwd;//.DecryptParameter();
                balance.AvaliableBalance = decimal.Parse(gatewaycommon.GatewayBalance);

                //gatewaymodel.GatewayURL = gatewaycommon.GatewayURL;//.DecryptParameter();
                //gatewaymodel.GatewayAccessCode = gatewaycommon.GatewayAccessCode;//.DecryptParameter();
                //gatewaymodel.GatewaySecurityCode = gatewaycommon.GatewaySecurityCode;//.DecryptParameter();
                //gatewaymodel.GatewayApitoken = gatewaycommon.GatewayApitoken;//.DecryptParameter();
                //balance.GatewayStatus = "<span class='badge badge-" + (gatewaycommon.GatewayStatus.Trim().ToUpper() == "Y" ? "success" : "danger") + "'>" + (gatewaycommon.GatewayStatus.Trim().ToUpper() == "Y" ? "Enable" : "Disable") + "</span>";
                //gatewaymodel.IsDirectGateway = gatewaycommon.IsDirectGateway;
                //gatewaymodel.GatewayType = gatewaycommon.GatewayType;
                //gatewaymodel.GatewayCountry = gatewaycommon.GatewayCountry;
                balance.GatewayCurrency = gatewaycommon.GatewayCurrency;

                //gatewaymodel.GatewayContact = gatewaycommon.GatewayContact;
                string value = string.Empty;
                value = JsonConvert.SerializeObject(balance, Formatting.Indented, new JsonSerializerSettings
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                });
                return Json(value, JsonRequestBehavior.AllowGet);
            }


            //gatewaymodel.IsDirectGatewayList = LoadDropdownList("directindirect") as List<SelectListItem>;
            //gatewaymodel.GatewayTypeList = LoadDropdownList("gatewaytype") as List<SelectListItem>;
            //// gatewaymodel.GatewayCurrencyList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("20"), gatewaymodel.GatewayCurrency, "Select Currency");
            //gatewaymodel.GatewayCountryList = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("030"), gatewaymodel.GatewayCurrency, "Select Country");

            this.ShowPopup(1, "Error");
            return null;




        }
        [HttpPost, ValidateAntiForgeryToken]
        public void ManageGatewayBalance(GatewayBalanceModel model)
        {
            if (ModelState.IsValid)
            {
                GatewayBalanceCommon common = new GatewayBalanceCommon();
                common.Gatewayid = model.Gatewayid.DecryptParameter();
                common.BalanceToBeAdd = Math.Abs(model.BalanceToBeAdd);
                common.ActionUser = Session["UserName"].ToString();
                common.IpAddress = ApplicationUtilities.GetIP();
                common.Remarks = model.Remarks;
                CommonDbResponse dbresp = buss.updatebalance(common);

                if (dbresp.Code == 0)
                {
                    this.ShowPopup(0, "Succesfully Added");
                    return;
                    //dbresp.SetMessageInTempData(this);
                    //return ("1");
                    //       return RedirectToAction("Detail");
                }
            }
            else

                this.ShowPopup(1, "Amount Not Added");

        }
        public ActionResult GatewayProductList(string GatewayID, string Search = "", int Pagesize = 10)
        {
            GatewayID = GatewayID.DecryptParameter();
            //string  GatewayName = name.DecryptParameter();
            var list = buss.GetGatewayProductList(GatewayID, "");
            foreach (var item in list)
            {
                item.Action = StaticData.GetActions("", item.GatewayProductId.ToString().EncryptParameter(), this, "/Admin/Gateway/ManageGatewayCommission", "/Admin/Gateway/ManageGatewayCommission?Id=" + item.GatewayId.ToString().EncryptParameter() + "&pid=" + item.ProductId.EncryptParameter(), "");
                item.CommissionType = string.IsNullOrEmpty(item.CommissionType.Trim()) ? "" :
                    item.CommissionType.Trim().Equals("F") ? "FLAT" : "PERCENTAGE";


                //item.Action = "<input type='button' value='Edit Commission' onclick=redirect('" + item.GatewayId.EncryptParameter() + "','" + item.ProductId.EncryptParameter() + "')></input>";
                //item.Action = "< button type = 'button' onclick =\"window.location.href='www.example.com/page.html?Id=" + GatewayID.EncryptParameter() + "&gwid=" + item.GatewayProductId.ToString().EncryptParameter() + "'\">";
            }
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("ProductLabel", "Product Label");
            param.Add("CommissionValue", "Commission");
            param.Add("CommissionType", "Commission Type");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            var grid = ProjectGrid.MakeGrid(list, "Gateway Services", Search, Pagesize, true, "", "", "Home", "Gateway", "/Admin/Gateway", "/Admin/Gateway/ManageGatewayCommission?Id=" + GatewayID.EncryptParameter());
            ViewData["grid"] = grid;
            return View();
        }
        public ActionResult ManageGatewayCommission(string Id, string pid = "")
        {
            string GatewayId = Id;
            GatewayProductModel GPM = new GatewayProductModel();
            GPM.GatewayId = GatewayId;
            GPM.ProductId = pid;//.DecryptParameter();
            string AvailableProduct = "N";
            GPM.IsProduct = AvailableProduct.EncryptParameter();
            if ((!string.IsNullOrEmpty(pid)) && (!string.IsNullOrEmpty(pid.DecryptParameter())))
            {
                var list = buss.GetGatewayProductList(GPM.GatewayId.DecryptParameter(), GPM.ProductId.DecryptParameter());
                if (list != null)
                {
                    AvailableProduct = "Y";
                    GPM.IsProduct = AvailableProduct.EncryptParameter();
                    GPM.ProductId = list[0].ProductId.ToString();
                    GPM.GatewayId = list[0].GatewayId.ToString().EncryptParameter();
                    GPM.CommissionType = list[0].CommissionType.ToString();
                    GPM.CommissionValue = (float)list[0].CommissionValue;
                }
            }
            ViewBag.servicelist = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("servicelist", GPM.GatewayId.DecryptParameter()), GPM.ProductId, "Select Service");
            GPM.CommissionTypeList = LoadDropdownList("commissiontype") as List<SelectListItem>;
            return View(GPM);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult ManageGatewayCommission(GatewayProductModel GaPM)
        {
            GatewayProductCommon gc = new GatewayProductCommon();
            ViewBag.servicelist = ApplicationUtilities.SetDDLValue(ICB.sproc_get_dropdown_list("servicelist", GaPM.GatewayId.DecryptParameter()), GaPM.ProductId, "Select Service");
            GaPM.CommissionTypeList = LoadDropdownList("commissiontype") as List<SelectListItem>;
            gc.ActionUser = Session["username"].ToString();
            gc.IpAddress = ApplicationUtilities.GetIP();
            ViewBag.CommissionType = LoadDropdownList("commissiontype") as List<SelectListItem>;

            gc.ProductId = GaPM.ProductId;
            gc.GatewayId = GaPM.GatewayId.DecryptParameter();
            gc.CommissionType = GaPM.CommissionType;
            gc.CommissionValue = GaPM.CommissionValue;
            gc.IsProduct = GaPM.IsProduct.DecryptParameter();
            if (gc.CommissionType.ToUpper() == "P" && (gc.CommissionValue > 100 || gc.CommissionValue < 0))
            {
                this.ShowPopup(1, "Error");
                return View(GaPM);
            }
            CommonDbResponse dbresp = buss.ManageGatewayProductCommission(gc);
            if (dbresp.Code == 0)
            {
                this.ShowPopup(0, dbresp.Message);
                return RedirectToAction("GatewayProductList", new { GatewayID = GaPM.GatewayId });
            }
            this.ShowPopup(1, dbresp.Message);
            return View(GaPM);
        }
        public object LoadDropdownList(string forMethod)
        {
            switch (forMethod)
            {
                case "directindirect":
                    return new List<SelectListItem> { new SelectListItem { Text = "Select Direct-Indirect Type", Value = "" }, new SelectListItem { Text = "Direct Gateway", Value = "Y" }, new SelectListItem { Text = "Indirect Gateway", Value = "N" } };
                case "gatewaytype":
                    return new List<SelectListItem> { new SelectListItem { Text = "Select Gateway Type", Value = "" }, new SelectListItem { Text = "Payment", Value = "P" }, new SelectListItem { Text = "SMS", Value = "S" }, new SelectListItem { Text = "Transaction", Value = "T" } };
                case "commissiontype":
                    return new List<SelectListItem> { new SelectListItem { Text = "Select Commission Type", Value = "" }, new SelectListItem { Text = "Percentage", Value = "P" }, new SelectListItem { Text = "Flat", Value = "F" } };


            }
            return null;
        }

        // public void ModelStateValidation(string validateMode = "Insert")
        // {
        //     switch (validateMode)
        //     {
        //         case "Update":
        //             ModelState.Remove("GatewayName");
        //             ModelState.Remove("GatewayAmount");
        //             ModelState.Remove("GatewayUrl");
        //             ModelState.Remove("GatewayUserName");
        //             ModelState.Remove("GatewayPassword");
        //             ModelState.Remove("GatewaySecurityCode");
        //             ModelState.Remove("GatewayAccessCode");
        //             ModelState.Remove("GatewayType");
        //             break;
        //         case "Insert":
        //             break;
        //         default: break;
        //     }
        // }

        // //public ActionResult ManageGateway(string GatewayId = "")
        // //{
        // //    GatewayCommon commonModel = new GatewayCommon();
        // //    if (!String.IsNullOrEmpty(GatewayId))
        // //    {
        // //        var id = GatewayId.DecryptParameter();
        // //        if (string.IsNullOrEmpty(id))
        // //            return RedirectToAction("Index");
        // //        commonModel = buss.GetGatewayById(id);
        // //        commonModel.GatewayId = commonModel.GatewayId.EncryptParameter();
        // //    }
        // //    //commonModel.Roles = LoadDropdownList("ManageGateway") as List<SelectListItem>;
        // //    return View(commonModel);
        // //}

        //// [ValidateAntiForgeryToken]
        // //public ActionResult ManageGateway(GatewayCommon model)
        // //{

        // //    string gatewayId = "";
        // //    gatewayId = model.GatewayId;
        // //    if (!string.IsNullOrEmpty(model.GatewayId))
        // //    {
        // //        if (string.IsNullOrEmpty(model.GatewayId.DecryptParameter()))
        // //        {
        // //            return RedirectToAction("Index");
        // //        }

        // //        model.GatewayId = gatewayId.DecryptParameter();
        // //    }
        // //    ModelStateValidation(String.IsNullOrEmpty(gatewayId) ? "Insert" : "Update");
        // //    if (ModelState.IsValid)
        // //    {
        // //        buss.ManageGateway(model).SetMessageInTempData(this);
        // //        return RedirectToAction("Index");
        // //    }
        // //    model.GatewayId = gatewayId;
        // //    return View(model);
        // //}

        public ActionResult BalanceReport(string Search = "", int Pagesize = 10)
        {
            List<GatewayBalanceCommon> gatewayBalanceCommons = buss.GetGatewayReportList();
            List<GatewayBalanceModel> gatewayBalanceModels = gatewayBalanceCommons.MapObjects<GatewayBalanceModel>();
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("GatewayName", "Gateway Name");
            param.Add("GatewayStatus", "Balance Type");
            param.Add("AvaliableBalance", "Amount");
            param.Add("BalanceToBeAdd", "New Balance");
            param.Add("GatewayCurrency", "Currency Code");
            param.Add("CreatedBy", "Created By");
            param.Add("Remarks", "Remarks");
            ProjectGrid.column = param;
            //Ends
            var grid = ProjectGrid.MakeGrid(gatewayBalanceModels, "", Search, Pagesize, false, "", "", "Home", "", "", "");
            ViewData["grid"] = grid;

            return View();
        }
    }
}
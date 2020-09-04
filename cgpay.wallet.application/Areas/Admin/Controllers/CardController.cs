using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Card;
using cgpay.wallet.business.Client;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.application.Areas.Admin.Controllers
{
    public class CardController : Controller
    {
        string ControllerName = "Card";

        ICardBusiness _card;
        IWalletUserBusiness _walletUserBusiness;
        public CardController(ICardBusiness cardBusiness, IWalletUserBusiness walletUser)
        {
            _card = cardBusiness;
            _walletUserBusiness = walletUser;
        }
        // GET: Admin/Card
        public ActionResult Index(string UserId = "", string AgentId = "")
        {
            var userID = UserId.DecryptParameter();
            if (string.IsNullOrEmpty(UserId))
            {
                return RedirectToAction("", "Home", new { area = "Admin" });
            }
            var cardCommonList = _card.GetCardList(userID);
            var UserInfo = _walletUserBusiness.UserInfo(userID);
            ViewBag.UserName = UserInfo.UserName;
            ViewBag.FullName = UserInfo.FullName;
            Session["CardForUser"] = UserInfo.UserName;

            //Actions
            foreach (var item in cardCommonList)
            {
                item.Action = StaticData.GetActions("UserCard", item.UserId.EncryptParameter(), this, "", "", item.CardNo.EncryptParameter(), item.Status, item.AgentId.EncryptParameter(), item.CardType);
                #region Status
                if (item.Status.ToUpper().Equals("YES") || item.Status.ToUpper().Equals("Y"))
                    item.Status = "<span class='badge badge-success'>Enabled</span>";
                if (item.Status.ToUpper().Equals("NO") || item.Status.ToUpper().Equals("N"))
                    item.Status = "<span class='badge badge-danger'>Disabled</span>";
                #endregion
                #region CardType
                if (item.CardType.Equals("1"))
                    item.CardType = "<span class='badge badge-success'>Virtual</span>";
                else if (item.CardType.Equals("2"))
                    item.CardType = "<span class='badge badge-success'>Gift</span>";
                else if (item.CardType.Equals("3"))
                    item.CardType = "<span class='badge badge-success'>Discount</span>";
                else if (item.CardType.Equals("4"))
                    item.CardType = "<span class='badge badge-success'>Prepaid</span>";
                else
                    item.CardType = "<span class='badge badge-success'>Others</span>";
                #endregion
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("FullName", "Name");
            param.Add("MobileNo", "Mobile Number");
            param.Add("Email", "Email");
            param.Add("CardType", "Card type");
            param.Add("CardNo", "Card No.");
            param.Add("IssueDate", "Issue Date");
            param.Add("ExpiryDate", "Expiry Date");
            param.Add("Status", "Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            //Add New
            var grid = ProjectGrid.MakeGrid(cardCommonList, "", "", 0, true, "", "", "Home", "Card", "/Admin/Card", "/Admin/Card/AddCard?UserId=" + UserId + "&AgentId=" + AgentId);
            ViewData["grid"] = grid;
            if (cardCommonList.Count() == 0)
            {
                ViewBag.EmptyMessage = "True";
            }
            return View();
        }
        [HttpGet]
        public ActionResult AddCard(string UserId, string AgentId)
        {
            CardModel cardModel = new CardModel();
            cardModel.UserId = UserId.DecryptParameter();
            cardModel.AgentId = AgentId.DecryptParameter();
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            cardModel.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, "", "--Card Type--");
            return View(cardModel);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult AddCard(CardModel cardModel)
        {
            ModelState.Remove("Amount");
            ModelState.Remove("CardNo");
            if (ModelState.IsValid)
            {
                cardModel.ActionUser = Session["UserName"].ToString();
                cardModel.UserId = cardModel.UserId.DecryptParameter();
                cardModel.AgentId = cardModel.AgentId.DecryptParameter();
                cardModel.UserName = Session["CardForUser"].ToString();
                CardCommon cardCommon = cardModel.MapObject<CardCommon>();
                CommonDbResponse dbResponse = _card.InsertCard(cardCommon);
                if (dbResponse.Code == 0)
                {
                    dbResponse.SetMessageInTempData(this);
                    return RedirectToAction("Index", new { UserId = cardModel.UserId.EncryptParameter(), AgentId = cardModel.AgentId.EncryptParameter() });
                }
            }
            return View(cardModel);

        }

        [HttpGet]
        public ActionResult CardUpdate(string UserId, string CardNo, string CardType, string AgentId)
        {
            CardModel cardModel = new CardModel();
            cardModel.UserId = UserId.DecryptParameter();
            cardModel.CardNo = CardNo.DecryptParameter();
            ViewBag.CardNo = CardNo.DecryptParameter();
            cardModel.AgentId = AgentId.DecryptParameter();
            cardModel.CardType = CardType;
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            cardModel.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, cardModel.CardType, "--Card Type--");
            return View(cardModel);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult CardUpdate(CardModel cardModel)
        {
            ModelState.Remove("Email");
            ModelState.Remove("MobileNo");
            ModelState.Remove("IssueDate");
            ModelState.Remove("Amount");
            CommonDbResponse dbResponse = new CommonDbResponse();
            if (ModelState.IsValid)
            {
                //cardModel.ActionUser = Session["UserName"].ToString();
                CardModel card = new CardModel();
                card.UserId = cardModel.UserId.DecryptParameter();
                card.AgentId = cardModel.AgentId.DecryptParameter();
                card.CardNo = cardModel.CardNo.DecryptParameter();
                card.CardType = cardModel.CardType;
                //cardModel.UserName = Session["CardForUser"].ToString();
                CardCommon cardCommon = card.MapObject<CardCommon>();
                dbResponse = _card.UpdateCard(cardCommon);
                //if (dbResponse.Code == 0)
                //{
                //    dbResponse.SetMessageInTempData(this);
                //    return RedirectToAction("Index", new { UserId = cardModel.UserId, AgentId = cardModel.AgentId });
                //}
                dbResponse.SetMessageInTempData(this);
                return RedirectToAction("Index", new { UserId = cardModel.UserId, AgentId = cardModel.AgentId });
            }
            dbResponse = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid Card Info" };
            dbResponse.SetMessageInTempData(this);
            return RedirectToAction("Index", new { UserId = cardModel.UserId, AgentId = cardModel.AgentId });

        }

        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult CardDisable(string userid, string agentid, string cardno)
        {
            var data = new CommonDbResponse();
            bool valid = true;
            if (!String.IsNullOrEmpty(userid) || !String.IsNullOrEmpty(agentid))
            {
                userid = userid.DecryptParameter();
                agentid = agentid.DecryptParameter();
                if (string.IsNullOrEmpty(userid) || string.IsNullOrEmpty(agentid))
                {
                    data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid User." };
                    valid = false;
                }
            }

            if (!String.IsNullOrEmpty(cardno))
            {
                cardno = cardno.DecryptParameter();
                if (string.IsNullOrEmpty(cardno))
                {
                    data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid Card" };
                    valid = false;
                }
            }
            if (valid)
            {
                CardCommon cardCommon = new CardCommon();
                cardCommon.UserId = userid;
                cardCommon.AgentId = agentid;
                cardCommon.CardNo = cardno;
                data = _card.EnableDisableCard(cardCommon);
                if (data.ErrorCode == 0)
                {
                    data.Message = "Successfully Disabled Card";
                }
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public JsonResult CardEnable(string userid, string agentid, string cardno)
        {
            var data = new CommonDbResponse();
            bool valid = true;
            if (!String.IsNullOrEmpty(userid) || !String.IsNullOrEmpty(agentid))
            {
                userid = userid.DecryptParameter();
                agentid = agentid.DecryptParameter();
                if (string.IsNullOrEmpty(userid) || string.IsNullOrEmpty(agentid))
                {
                    data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid User." };
                    valid = false;
                }
            }

            if (!String.IsNullOrEmpty(cardno))
            {
                cardno = cardno.DecryptParameter();
                if (string.IsNullOrEmpty(cardno))
                {
                    data = new CommonDbResponse { Code = ResponseCode.Failed, Message = "Invalid Card" };
                    valid = false;
                }
            }
            if (valid)
            {
                CardCommon cardCommon = new CardCommon();
                cardCommon.UserId = userid;
                cardCommon.AgentId = agentid;
                cardCommon.CardNo = cardno;
                data = _card.EnableDisableCard(cardCommon);
                if (data.ErrorCode == 0)
                {
                    data.Message = "Successfully Enabled Card";
                }
            }

            data.SetMessageInTempData(this);
            return Json(data);
        }


        #region Card Approve Reject

        public ActionResult CardApprovalList()
        {
            var cardCommonList = _card.GetApprovalList();
            //Actions
            var cardType = _card.GetCardType();//.FirstOrDefault(x => x.Key == item.CardType);
            foreach (var item in cardCommonList)
            {
                item.Action = StaticData.GetActions("CardApproval", item.RequestId.EncryptParameter(), this, "", "", item.CardType);
                item.CardType = cardType.FirstOrDefault(x => x.Key == item.CardType).Value; ;
            }
            //Column Creator
            IDictionary<string, string> param = new Dictionary<string, string>();
            param.Add("UserName", "Name");
            param.Add("MobileNo", "Mobile Number");
            param.Add("Email", "Email");
            param.Add("CardType", "Card type");
            //param.Add("CardType", "Card No.");
            param.Add("CreatedLocalDate", "Issue Date");
            //param.Add("ExpiryDate", "Expiry Date");
            param.Add("RequestStatus", "Status");
            param.Add("Action", "Action");
            ProjectGrid.column = param;
            //Ends
            //Add New
            var grid = ProjectGrid.MakeGrid(cardCommonList, "", "", 0, false, "", "", "Home", "Card");
            ViewData["grid"] = grid;
            if (cardCommonList.Count() == 0)
            {
                ViewBag.EmptyMessage = "True";
            }
            return View();
        }
        [HttpGet]
        public ActionResult CardApprovalDetail(string reqid)
        {
            CardModel cardModel = new CardModel();
            if (string.IsNullOrEmpty(reqid.DecryptParameter()))
            {
                return RedirectToAction("CardApprovalList");
            }
            cardModel.RequestId = reqid.DecryptParameter();
            var cardDetail = _card.GetApprovalList().FirstOrDefault(x => x.RequestId == cardModel.RequestId);
            cardModel.CardType = cardDetail.CardType;
            cardModel.UserName = cardDetail.UserName;
            cardModel.MobileNo = cardDetail.MobileNo;
            cardModel.CreatedLocalDate = cardDetail.CreatedLocalDate;
            cardModel.Email = cardDetail.Email;
            cardModel.Amount = cardDetail.Amount;
            cardModel.CardType = _card.GetCardType().FirstOrDefault(x => x.Key == cardModel.CardType).Value;
            return View(cardModel);
        }
        [HttpPost]
        public ActionResult CardApprovalDetail(CardModel cardModel, string btnApprove)
        {
            if (btnApprove.ToUpper() == "REJECT")
            {
                cardModel.RequestStatus = "Rejected";
            }
            if (btnApprove.ToUpper() == "APPROVE")
            {
                cardModel.RequestStatus = "Approved";
            }
            //Get user info from userName
            WalletUserInfo walletUser = _walletUserBusiness.UserInfo(cardModel.UserName);
            cardModel.UserId = walletUser.UserId;
            cardModel.AgentId = walletUser.AgentId;
            cardModel.ActionUser = Session["UserId"].ToString();
            cardModel.CreatedIp = ApplicationUtilities.GetIP();
            cardModel.CardType = _card.GetCardType().FirstOrDefault(x => x.Value == cardModel.CardType).Key;
            CardCommon cardCommon = cardModel.MapObject<CardCommon>();
            CommonDbResponse dbResponse = _card.CardApproval(cardCommon);
            dbResponse.SetMessageInTempData(this);
            return RedirectToAction("CardApprovalList");
        }
        #endregion
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models;
using cgpay.wallet.business.Card;
using cgpay.wallet.business.Client;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.WalletUser;

namespace cgpay.wallet.application.Areas.Client.Controllers
{
    public class CardsController : Controller
    {
        string ControllerName = "Cards";

        ICardBusiness _card;
        IWalletUserBusiness _walletUserBusiness;
        public CardsController(ICardBusiness cardBusiness, IWalletUserBusiness walletUser)
        {
            _card = cardBusiness;
            _walletUserBusiness = walletUser;
        }
        // GET: Client/Cards
        [HttpGet]
        public ActionResult Index()
        {
            string userid = Session["UserId"].ToString();
            var cardCommonList = _card.GetCardList(userid).MapObjects<CardModel>();
            List<CardModel> cardModels = new List<CardModel>();
            var cardType = _card.GetCardType();
            foreach (var item in cardCommonList)
            {
                CardModel model = new CardModel();
                model.FullName = item.FullName;
                model.UserId = item.UserId;
                model.Amount = item.Amount;
                model.CardId = item.CardId;
                model.CardNo = item.CardNo;
                model.CardType = item.CardType;
                model.CardTypeName = cardType.FirstOrDefault(x => x.Key == item.CardType).Value; ;
                model.ExpiryDate = item.ExpiryDate;
                model.Status = item.Status.Trim();//== "Y" ? "checked" : "";
                model.IsReceived = item.IsReceived.Trim();
                model.ReceivedFrom = item.ReceivedFrom;
                cardModels.Add(model);
            }
            Dictionary<string, string> cardoptions = new Dictionary<string, string>()
            {
                {"0","--Select Card Options--"},
                {"1","Add New Card"},
                {"2", "Card Balance Add/Retrieve"},
                {"3","Card Transfer/Retrieve"}
            };
            ViewBag.CardOptions = ApplicationUtilities.SetDDLValue(cardoptions, "", "");

            return View(cardModels);
        }
        [HttpGet]
        public ActionResult RequestCard()
        {
            //string userid = Session["UserId"].ToString();
            //var cardCommonList = _card.GetCardList(userid);

            CardModel cardModel = new CardModel();
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            cardModel.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, "", "--Card Type--");
            return View(cardModel);
        }
        [HttpPost,ValidateAntiForgeryToken]
        public ActionResult RequestCard(CardModel cardModels)
        {
            int ReqAmount = 0;
            float AvaBalnce = 0;
            cardModels.Balance = Session["Balance"].ToString();
            //CardModel cardModel = new CardModel();
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            cardModels.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, "", "--Card Type--");
            
            if (int.TryParse(cardModels.Amount,out ReqAmount))
            {
                if (ReqAmount < 100) //|| ReqAmount>1000
                {
                    ModelState.AddModelError("Amount", "Amount should be at least RS. 100");
                    return View(cardModels);
                }
            }
            else
            {
                ModelState.AddModelError("Amount", "Invalid Requested amount.");
                return View(cardModels);
            }
            if (float.TryParse(cardModels.Balance, out AvaBalnce))
            {
                if (ReqAmount > AvaBalnce)
                {
                    ModelState.AddModelError("Amount", "Requested amount greater then balance");
                    return View(cardModels);
                }

            }
            cardModels.UserId = Session["UserId"].ToString();
            cardModels.AgentId = Session["AgentId"].ToString();
            cardModels.UserName = Session["UserName"].ToString();
            //cardModels.UserName = Session["FullName"].ToString();
            WalletUserInfo walletUser = _walletUserBusiness.UserInfo(cardModels.UserId);
            cardModels.Email = walletUser.Email;
            cardModels.MobileNo = walletUser.MobileNo;
            cardModels.ActionUser = cardModels.UserName;
            cardModels.CreatedIp = ApplicationUtilities.GetIP();
            CardCommon cardCommon = cardModels.MapObject<CardCommon>();
            //CommonDbResponse dbResponse = _card.CardApproval(cardCommon);
            CommonDbResponse dbResponse = _card.RequestCard(cardCommon);
            if (dbResponse.Code == 0)
            {
                //dbResponse.SetMessageInTempData(this, "Index");
                return RedirectToAction("Index");
            }
            dbResponse.SetMessageInTempData(this, "Index");
            return View(cardModels);
        }

        public ActionResult CardBalance()
        {
            CardModel cardModel = new CardModel();
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD" || kvp.Value.ToUpper() == "GIFT CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            //Dictionary<string, string> cardNo = new Dictionary<string, string>();
            //cardModel.CardNoList = ApplicationUtilities.SetDDLValue(cardNo as Dictionary<string, string>, cardModel.CardNo, "--Card Number--");
            cardModel.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, "", "--Card Type--");
            return View(cardModel);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult CardBalance(CardModel cardModel)
        {
            int ReqAmount = 0;
            float AvaBalnce = 0;
            cardModel.Balance = Session["Balance"].ToString();
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD" || kvp.Value.ToUpper() == "GIFT CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            cardModel.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, "", "--Card Type--");
            if (string.IsNullOrEmpty(cardModel.CardNo))
            {
                ModelState.AddModelError("CardNo", "Card Number Required!");
                //return RedirectToAction("CardBalance");
                return View("CardBalance", cardModel);
            }
            if (int.TryParse(cardModel.Amount, out ReqAmount) && float.TryParse(cardModel.Balance, out AvaBalnce))
            {
                if (ReqAmount > AvaBalnce && cardModel.Type.ToLower() == "ad")
                {
                    ModelState.AddModelError("Amount", "Requested amount greater then balance");
                    return View("CardBalance", cardModel);
                }
                string userid = Session["UserId"].ToString();
                if (string.IsNullOrEmpty(userid))
                {
                    return RedirectToAction("Index", "Home");
                }
                var cardCommonList = _card.GetCardList(userid).Where(x => x.CardId == cardModel.CardNo);//MapObjects<CardModel>();
                float AvailableCardBalance = 0;
                if (float.TryParse(cardCommonList.FirstOrDefault().Amount, out AvailableCardBalance))
                {
                    if (ReqAmount > AvailableCardBalance && cardModel.Type.ToLower() == "rb")
                    {
                        ModelState.AddModelError("Amount", "Requested amount greater then balance");
                        return View("CardBalance", cardModel);
                    }

                }

            }
            CardCommon cardCommon = cardModel.MapObject<CardCommon>();
            //CommonDbResponse dbResponse = _card.CardApproval(cardCommon);
            CommonDbResponse dbResponse = _card.CardBalance(cardCommon);
            dbResponse.SetMessageInTempData(this, "Index");
            return RedirectToAction("Index");
        }

        public ActionResult CardUser()
        {
            CardModel cardModel = new CardModel();
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD" || kvp.Value.ToUpper() == "PREPAID CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            cardModel.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, cardModel.CardType, "--Card Type--");
            //Dictionary<string,string> cardNo=new Dictionary<string, string>();
            //cardModel.CardNoList = ApplicationUtilities.SetDDLValue(cardNo as Dictionary<string, string>, cardModel.CardNo, "--Card Number--");
            return View(cardModel);
        }
        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult CardUser(CardModel cardModel)
        {
            cardModel.Balance = Session["Balance"].ToString();
            var cardType = _card.GetCardType();
            foreach (var item in cardType.Where(kvp => kvp.Value.ToUpper() == "VIRTUAL CARD" || kvp.Value.ToUpper() == "PREPAID CARD").ToList())
            {
                cardType.Remove(item.Key);
            }
            cardModel.CardTypeList = ApplicationUtilities.SetDDLValue(cardType as Dictionary<string, string>, cardModel.CardType, "--Card Type--");

            if (cardModel.Type == "re")
            {
                ModelState.Remove("MobileNo");
            }

            if (string.IsNullOrEmpty(cardModel.CardNo))
            {
                ModelState.AddModelError("CardNo", "Card Number Required!");
                return View("CardUser", cardModel);
            }
            
            else
            {
                IWalletUserBusiness _walletUserBusiness = new WalletUserBusiness();
                var userinfo = _walletUserBusiness.UserInfo(cardModel.MobileNo);
                if (string.IsNullOrEmpty(userinfo.UserId))
                {
                    ModelState.AddModelError("MobileNo", "Invalid Mobile Number");
                    return View("CardUser", cardModel);
                }
            }

            cardModel.ActionUser = Session["UserId"].ToString();
            CardCommon cardCommon = cardModel.MapObject<CardCommon>();
            //CommonDbResponse dbResponse = _card.CardApproval(cardCommon);
            CommonDbResponse dbResponse = _card.CardUser(cardCommon);
            dbResponse.SetMessageInTempData(this, "Index");
            return RedirectToAction("Index");
        }

        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> GetCards(string cardType)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            string userid = Session["UserId"].ToString();
            var cardsList = _card.GetCardList(userid).MapObjects<CardModel>();
            //var cardType = _card.GetCardType();
            Dictionary<string, string> cardNo = new Dictionary<string, string>();
            foreach (var item in cardsList.Where(x => x.CardType == cardType).Where(x => x.Status.ToUpper() == "Y" && x.ReceivedFrom != userid))
            {
                string cardlastfour = "************"+ item.CardNo.Substring(12, 4);
                cardNo.Add(item.CardId, cardlastfour);
            }
            list = ApplicationUtilities.SetDDLValue(cardNo, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }

        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> GetTRCards(string cardType, string checkboxtype)
        {
            List<SelectListItem> list = new List<SelectListItem>();
            string userid = Session["UserId"].ToString();
            var cardsList = _card.GetCardList(userid).MapObjects<CardModel>();
            //var cardType = _card.GetCardType();
            Dictionary<string, string> cardNo = new Dictionary<string, string>();
            if (checkboxtype.ToLower() == "tr")
            {
                foreach (var item in cardsList.Where(x => x.CardType == cardType).Where(x => x.Status.ToUpper() == "Y").Where(x => x.IsReceived.ToUpper() != "Y"))
                {
                    string trcardlastfour = "************" + item.CardNo.Substring(12, 4);
                    cardNo.Add(item.CardId, trcardlastfour);
                }
            }
            if (checkboxtype.ToLower() == "re")
            {
                foreach (var item in cardsList.Where(x => x.CardType == cardType).Where(x => x.Status.ToUpper() == "Y").Where(x => x.IsReceived.ToUpper() == "Y"))
                {
                    string recardlastfour = "************" + item.CardNo.Substring(12, 4);
                    cardNo.Add(item.CardId, recardlastfour);
                }
            }
            list = ApplicationUtilities.SetDDLValue(cardNo, "");
            return Json(new SelectList(list, "Value", "Text", JsonRequestBehavior.AllowGet));
        }

        [HttpPost, OverrideActionFilters]
        public async System.Threading.Tasks.Task<JsonResult> ValidMobileNo(string mobileNum)
        {
            IWalletUserBusiness _walletUserBusiness = new WalletUserBusiness();
            var userinfo = _walletUserBusiness.UserInfo(mobileNum);
            int Code = 0;
            if (string.IsNullOrEmpty(userinfo.UserId))
            {
                Code = 1;
            }

            return Json(new { Code }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost, OverrideActionFilters]
        public ActionResult Go(string CardOption)
        {
            if (CardOption.Trim() != null)
            {
                if (CardOption == "1")
                {
                    return RedirectToAction("RequestCard");
                }
                if (CardOption == "2")
                {
                    return RedirectToAction("CardBalance");
                }
                if (CardOption == "3")
                {
                    return RedirectToAction("CardUser");
                }
            }
            return RedirectToAction("Index");
        }
    }
}
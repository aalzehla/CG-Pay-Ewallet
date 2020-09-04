using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Card
{
    public interface ICardBusiness
    {
        List<CardCommon> GetCardList(string UserId);
        Dictionary<string, string> GetCardType();
        CommonDbResponse InsertCard(CardCommon cardCommon);
        CommonDbResponse UpdateCard(CardCommon cardCommon);
        CommonDbResponse EnableDisableCard(CardCommon cardCommon);
        CommonDbResponse RequestCard(CardCommon cardCommon);
        List<CardCommon> GetApprovalList();
        CommonDbResponse CardApproval(CardCommon cardCommon);
        CommonDbResponse CardBalance(CardCommon cardCommon);
        CommonDbResponse CardUser(CardCommon cardCommon);
    }
}

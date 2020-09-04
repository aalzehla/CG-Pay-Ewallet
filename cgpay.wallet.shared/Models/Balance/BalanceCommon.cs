using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Balance
{
    public class BalanceCommon
    {
        public string AgentId { get; set; }
        public string BalanceId { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public string TxnMode { get; set; }
        public string BankId { get; set; }
        public string BankName { get; set; }
        public string BankBranch { get; set; }
        public string BankAcccountNo { get; set; }
        public List<System.Web.Mvc.SelectListItem> BankAccountList { get; set; }
        public string Amount { get; set; }
        public string OldBalance { get; set; }
        public string NewBalance { get; set; }
        public string Remarks { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedIp { get; set; }
        public string CreatedDate { get; set; }
        public string CreatedNepaliDate { get; set; }
        public string CreatedPlatform { get; set; }
        public string ActionUser { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string ServiceCharge { get; set; }
        public string BonusAmt { get; set; }
        public string SenderId { get; set; }
        public string RecieverId { get; set; }
        public string GrandParentId { get; set; }
        public string ParentId { get; set; }
        public string ParentName { get; set; }
        public string Subscriber { get; set; }
        public string Action { get; set; }

    }
}

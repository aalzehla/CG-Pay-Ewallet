using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace cgpay.wallet.shared.Models
{
    public class CardCommon
    {
        public string AgentId { get; set; }
        public string AgentName { get; set; }
        public string UserName { get; set; }
        public string UserId { get; set; }
        public string CardNo { get; set; }
        public string CardId { get; set; }
        public string CardType { get; set; }
        public List<SelectListItem> CardTypeList { get; set; }
        public string CardTxnType { get; set; }
        public string Status { get; set; }
        public string ActionUser { get; set; }
        public string IssueDate { get; set; }
        public string ExpiryDate { get; set; }  
        public string MobileNo { get; set; }
        public string Email { get; set; }
        public string Action { get; set; }
        public string CreatedIp { get; set; }
        //For Approval
        public string RequestId { get; set; }
        public string RequestStatus { get; set; }
        public string CreatedLocalDate { get; set; }
        public string CreatedUTCDate { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedLocalDate { get; set; }
        public string UpdatedUTCDate { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedIp { get; set; }
        public string Amount { get; set; }
        public string FullName { get; set; }
        public string Type { get; set; }
        public string IsReceived { get; set; }
        public string ReceivedFrom { get; set; }

    }
}

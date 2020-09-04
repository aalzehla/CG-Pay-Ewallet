using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.WalletUser
{
    public class WalletBalanceCommon:Common
    {
        public string UserId { get; set; }
        public string AgentId { get; set; }
        public string ReceiverUserId { get; set; }
        public string ReceiverAgentId { get; set; }
        public string Amount { get; set; }
        public string Type { get; set; }
        public string TxnId { get; set; }
        public string Remarks { get; set; }
        public string Propose { get; set; }
        public List<System.Web.Mvc.SelectListItem> ProposeList { get; set; }
        public string MobileNumber { get; set; }
        public string ReceiverName { get; set; }
    }
}

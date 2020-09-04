using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.SubAgentManagement
{
    public class SubAgentCreditLimitCommon:Common
    {
        public string ParentId { get; set; }

        public string AgentId { get; set; }
        public string AgentName { get; set; }
        public string AgentCreditLimit { get; set; }
        public string AgentCurrentCreditLimit { get; set; }
        public string Remarks { get; set; }
    }
}

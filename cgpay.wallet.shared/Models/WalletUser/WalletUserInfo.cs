using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.WalletUser
{
    public class WalletUserInfo
    {
        [Display(Name = "User Id")]
        public string UserId { get; set; }
        [Display(Name = "Agent Id")]
        public string AgentId { get; set; }
        public string ParentId { get; set; }
        [Display(Name = "Name")]
        public string FullName { get; set; }
        public string Email { get; set; }
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Display(Name = "User Id")]
        public string UserName { get; set; }
        [Display(Name = "Member From")]
        public string CreatedLocalDate { get; set; }
        public string Balance { get; set; }
        public string PPImage { get; set; }
        public string AgentStatus { get; set; }
        public string KycStatus { get; set; }
        public string Action { get; set; }
        [Display(Name = "Amount To Add")]
        public string BalanceToAdd { get; set; }
        public string Remarks { get; set; }
        public string ActionUser { get; set; }
        public string ActionIP { get; set; }
        public string ActionBrowser { get; set; }

    }
}

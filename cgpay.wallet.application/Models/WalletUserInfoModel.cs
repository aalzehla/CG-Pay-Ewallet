using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class WalletUserInfoModel
    {
        [Display(Name = "User Id")]
        public string UserId { get; set; }
        [Display(Name = "Agent Id")]
        public string AgentId { get; set; }
        public string ParentId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Name is required")]
        [Display(Name = "Name ")]
        [RegularExpression(@"[A-Za-z\s_]+$", ErrorMessage = "Name is Invalid")]
        public string FullName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Email Id is required")]
        [Display(Name = "Email Id ")]
        [RegularExpression(@"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$", ErrorMessage = "Email Id Invalid")]
        public string Email { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Mobile Number is required")]
        [Display(Name = "Mobile Number ")]
        [RegularExpression(@"^\+?\d{0,3}\-?\d{4,5}\-?\d{4,5}", ErrorMessage = "Mobile Number Invalid")]
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
        [Required]
        public string BalanceToAdd { get; set; }
        [Required]
        public string Remarks { get; set; }
        public string ActionUser { get; set; }
        public string ActionIP { get; set; }
        public string ActionBrowser { get; set; }

    }
}
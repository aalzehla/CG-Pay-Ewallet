using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using cgpay.wallet.shared.Models;

namespace cgpay.wallet.application.Models
{
    public class WalletBalanceModel:Common
    {
        public string UserId { get; set; }
        public string AgentId { get; set; }
        public string ReceiverUserId { get; set; }
        [Display(Name = "Mobile Number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Mobile Number is Required")]
        [RegularExpression(@"^((980)|(981)|(982)|(984)|(985)|(986)|(974)|(976)|(975)|(988)|(961)|(962)|(972))([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        [StringLength(10, ErrorMessage = "Mobile Number Not Valid")]
        public string ReceiverAgentId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Amount is Required")]
        [Range(10,Int32.MaxValue,ErrorMessage = "Invalid Amount")]
        public string Amount { get; set; }
        public string Type { get; set; }
        public string TxnId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Remarks is Required")]
        public string Remarks { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Purpose is Required")]
        public string Purpose { get; set; }
        public List<System.Web.Mvc.SelectListItem> PurposeList { get; set; }
        [Display(Name = "Receiver Mobile No.")]
        public string MobileNumber { get; set; }
        [Display(Name = "Receiver Name")]
        public string ReceiverName { get; set; }
    }
}
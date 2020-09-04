using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Models
{
    public class CardModel
    {
        public string AgentId { get; set; }
        public string AgentName { get; set; }
        [Display(Name = "Name")]
        public string UserName { get; set; }
        public string UserId { get; set; }
        [Display(Name = "Card Number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Card Number is required")]
        public string CardNo { get; set; }
        public List<SelectListItem> CardNoList { get; set; }
        public string CardId { get; set; }
        [Display(Name = "Card Type")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Card Type is required")]
        public string CardType { get; set; }
        public string CardTypeName { get; set; }
        public List<SelectListItem> CardTypeList { get; set; }
        public string CardTxnType { get; set; }
        public string Status { get; set; }
        public string ActionUser { get; set; }
        [Display(Name = "Issue Date")]
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        public string IssueDate { get; set; }
        public string ExpiryDate { get; set; }
        [Display(Name = "Mobile No.")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [RegularExpression("^[9][0-9]*$", ErrorMessage = "Mobile Number Start With 9")]
        [MaxLength(10, ErrorMessage = "Mobile Number Max Length is Invalid"), MinLength(10, ErrorMessage = "Mobile Number Minimum Length is Invalid")]
        public string MobileNo { get; set; }
        [Display(Name = "Email Address")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [EmailAddress]
        public string Email { get; set; }
        public string Action { get; set; }
        public string CreatedIp { get; set; }
        //For Approval
        public string RequestId { get; set; }
        public string RequestStatus { get; set; }
        [Display(Name = "Created lDate")]
        public string CreatedLocalDate { get; set; }
        public string CreatedUTCDate { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedLocalDate { get; set; }
        public string UpdatedUTCDate { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedIp { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Required")]
        [Range(100, Int32.MaxValue ,ErrorMessage = "Amount should be at least RS. 100")]//Int32.MaxValue
        public string Amount { get; set; }
        public string Balance { get; set; }
        public string FullName { get; set; }
        public string Type { get; set; }
        public string IsReceived { get; set; }
        public string ReceivedFrom { get; set; }
        public string CardOption { get; set; }

    }
}
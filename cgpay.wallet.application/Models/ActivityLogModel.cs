using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class ActivityLogModel
    {
        public string page_url { get; set; }
        public string page_name { get; set; }
        public string log_type { get; set; }
        public string ipaddress { get; set; }
        public string browser_detail { get; set; }
        public string user_name { get; set; }
        public string CreatedLocalDate { get; set; }
        [Display(Name = "Email Address")]
        [EmailAddress]
        public string Email { get; set; }
        [Display(Name = "Mobile Number")]
        //[RegularExpression(@"^((980)|(981)|(982)|(984)|(985)|(986)|(974)|(976)|(975)|(988)|(961)|(962)|(972))([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        [MaxLength(10, ErrorMessage = "Mobile Number Max Length is Invalid"), MinLength(10, ErrorMessage = "Mobile Number Minimum Length is Invalid")]
        public string MobileNumber { get; set; }
        [Display(Name = "From Date")]
        public string FromDate { get; set; }
        [Display(Name = "To Date")]
        public string ToDate { get; set; }
        public string CreatedBy { get; set; }
        public string ActionUser { get; set; }
    }
}
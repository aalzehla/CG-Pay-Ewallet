using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class SubAgentCreditLimitModel:Common
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Parent Id is required")]
        public string ParentId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Id is required")]
        [Display(Name = "Agent Id")]
        public string AgentId { get; set; }
        [Display(Name = "Agent Name")]
        public string AgentName { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Agent Credit Limit is required")]
        [Display(Name = "Agent's Credit Limit")]
        [Range(0, float.MaxValue, ErrorMessage = "Credit Limit Invalid")]
        public string AgentCreditLimit { get; set; }

        [Display(Name = "Agent's Current Credit Limit")]
        public string AgentCurrentCreditLimit { get; set; }
        public string Remarks { get; set; }
    }
}
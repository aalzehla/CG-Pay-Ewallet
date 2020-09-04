using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class AssignCommissionModel:Common
    {
        [Required(ErrorMessage = "Commission Category is Required")]
        [Display(Name = "Commission Category")]
        public string CommissionCategoryId { get; set; }
        public string CommissionCategoryName { get; set; }

        public string AgentId { get; set; }
        
        [Display(Name = "Agent Name")]
        public string AgentName { get; set; }
        public string AgentType { get; set; }

    }
}
using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class ClientCommissionCategoryModel : Common
    {
        public string AgentId { get; set; }

        public string CategoryId { get; set; }
        [Required(ErrorMessage = "Category Name is Required")]
        [Display(Name = "Category Name")]
        public string CategoryName { get; set; }
        public string IsActive { get; set; }
        [Display(Name = "Updated By")]

        public string UpdatedBy { get; set; }
        [Display(Name = "Updated on")]

        public string UpdatedDate { get; set; }


    }
}
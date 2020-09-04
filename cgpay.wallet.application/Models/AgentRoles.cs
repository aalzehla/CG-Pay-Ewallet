using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Models
{
    public class AgentRoles
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Role is required")]
        [Display(Name = "Role")]
        public string RoleId { get; set; }
        public List<SelectListItem> RolesList { get; set; }
        [Display(Name = "Is Primary")]
        public string IsPrimary { get; set; }
        public string AgentId { get; set; }
        public string UserId { get; set; }
    }
}
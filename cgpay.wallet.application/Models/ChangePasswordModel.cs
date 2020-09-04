using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class ChangePasswordModel
    {
        public string UserName { get; set; }
        public string UserNameRole { get; set; }
        public string UserNamePassword { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Password is required")]
        [Display(Name = "Password")]
        [RegularExpression(@"^.*(?=.{8,16})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$", ErrorMessage = "Must be 8 to 16 Length and must contain a-z,A-Z,0-9,@#$%^&+=")]
        public string Password { get; set; }
        [Display(Name = "Confirm Password")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Confirm Password is required")]
        [Compare("Password", ErrorMessage = "Password Mismatch")]
        public string ConfirmPassword { get; set; }
        [Display(Name = "Role")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Role is Required")]
        public string RoleId { get; set; }
        [Display(Name = "Current Role")]
        public string RoleName { get; set; }
        public string IpAddress { get; set; }
        public string BrowserInfo { get; set; }
        public string ActionUser { get; set; }
    }
}
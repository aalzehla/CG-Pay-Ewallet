using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Login
{
    public class LoginCommon
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Email Id/ Mobile Number is required")]
        public string UserName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Password is required")]
        public string Password { get; set; }
        [Compare("Password", ErrorMessage = "Confirm New Password doesn't match")]
        public string ConfirmPassword { get; set; }
        public bool RememberMe { get; set; }
        public string IpAddress { get; set; }
        public string BrowserDetail { get; set; }
        public string Session { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Full Name is Required")]
        public string FullName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Email is Required")]
        [EmailAddress(ErrorMessage = "Email is Invalid")]
        [DataType(DataType.EmailAddress)]
        [RegularExpression(@"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage ="Invalid Email")]
        public string Email { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Mobile Number is Required")]
        //[RegularExpression(@"^\d{10}$", ErrorMessage = "Invalid Mobile Number.")]
        [RegularExpression(@"^((980)|(981)|(982)|(984)|(985)|(986)|(974)|(976)|(975)|(988)|(961)|(962)|(972))([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        //[RegularExpression(@"^([9]{1})([678]{1})([012]{1})([0-9]{7})$", ErrorMessage = "Mobile Number Not Valid")]
        public string MobileNo { get; set; }
        public bool IsEmailVerified { get; set; }

        public string ActivationCode { get; set; }
    }
    public class LoginResponse
    {
        public string code { get; set; }
        public string message { get; set; }
        public string UserId { get; set; }
        public string RoleId { get; set; }
        public string AgentId { get; set; }
        public string ParentId { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public string UserType { get; set; }
        public string KycStatus { get; set; }
        public string FirstTimeLogin { get; set; }
        public string IsPrimaryUser { get; set; }
        
    }
}

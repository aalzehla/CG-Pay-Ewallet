using cgpay.wallet.shared.Models.User;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using CompareAttribute = System.ComponentModel.DataAnnotations.CompareAttribute;

namespace cgpay.wallet.shared.Models
{
    public class UserCommon : Common
    {
        public string UserID { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "User Name is required")]
        [Display(Name = "User Name")]
        public string UserName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Full Name is required")]
        [Display(Name = " Full Name")]
        public string FullName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Email is required")]
        [Display(Name = " Email")]
        //[EmailAddress]
        //RegularExpression(@"^([a-zA-Z0-9\.-]+)@([a-zA-Z0-9\.-]+)\.([a-z]{2,3})$", ErrorMessage = "The Email field is not a valid e-mail address.")]
        [RegularExpression(@"^([a-zA-Z0-9\._-]+)@([a-zA-Z0-9-]+)\.([a-z]{2,3})(.[a-z]{2,3})?$", ErrorMessage = "The Email field is not a valid e-mail address.")]
        public string Email { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Phone Number is required")]
        [Display(Name = " Phone Number")]
        public string PhoneNo { get; set; }

        [Required(ErrorMessage = "User Password is required")]
        [Display(Name = "User New Password")]
        [RegularExpression(@"^.*(?=.{8,16})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$", ErrorMessage = "Must be 8 to 16 Length and must contain a-z,A-Z,0-9,@#$%^&+=")]
        public string UserPwd { get; set; }

        [Compare("UserPwd", ErrorMessage = "Confirm Password doesn't match")]
        [Display(Name = "Confirm Password")]
        public string ConfirmUserPwd { get; set; }
        public string UserPin { get; set; }
        public string ConfirmUserPin { get; set; }
        public string OldPin { get; set; }
        [Required]
        [Display(Name = "Is Active")]
        public string IsActive { get; set; }
        public string ActivityStatus { get; set; }
        [Required(ErrorMessage = "Role is required")]
        [Display(Name = "Role")]
        public string RoleId { get; set; }
        public List<SelectListItem> Roles { get; set; }
        public string AgentType { get; set; }
        public string AgentUserId { get; set; }
        public string ParentId { get; set; }
        public string GrandParentId { get; set; }
        public string DistributorId { get; set; }
        public string DistributorName { get; set; }
        public string SubDistributorId { get; set; }
        public string SubDistributorName { get; set; }
        public string MerchantName { get; set; }
        public string MerchantId { get; set; }
        public string GatewayName { get; set; }
        public string GatewayId { get; set; }
        [Display(Name = "Old Password")]
        public string OldPassword { get; set; }

        //user search
        [Display(Name = "Search Field")]
        public string SearchField { get; set; }
        [Display(Name = "Search Filter")]
        public string SearchFilter { get; set; }
        public string Status { get; set; }
        [Display(Name = "Allow Multiple Login")]
        public string Allow_Multiple_Login { get; set; }
        public string Session { get; set; }
        public string RoleName { get; set; }
        public string IsPrimary { get; set; }


    }
    public class Profile
    {
        public string UserID { get; set; }      
        [Display(Name = "User Name")]
        public string UserName { get; set; }
        public string AgentUserId { get; set; }
        [Display(Name = "Full Name")]
        public string FullName { get; set; }
        [Display(Name = "Email Address")]
        public string Email { get; set; }
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        public string PPImage { get; set; }
        [Display(Name = "Member From")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public string CreateDate { get; set; }
        public string Balance { get; set; }
        [Display(Name = "Role Name")] 
        public string RoleName { get; set; }


    }

    public class UserSearchFilter
    {
        [Display(Name = "Search Field")]
        public string SearchField { get; set; }
        [Display(Name = "Search Filter")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Search Filter is required!")]
        public string SearchFilter { get; set; }
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
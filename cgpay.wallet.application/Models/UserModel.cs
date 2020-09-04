using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class UserModel
    {
        public string UserID { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
        public string PPImaage { get; set; }
        [Required(ErrorMessage = "New Password is required")]
        [Display(Name = "New Password")]
        public string UserPwd { get; set; }
        [Compare("UserPwd", ErrorMessage = "Confirm New Password doesn't match")]

        [Required(ErrorMessage = "Confirm New Password is required")]

        [Display(Name = "Confirm New Password")]
        public string ConfirmUserPwd { get; set; }

        [Required(ErrorMessage = "Current Password is required")]
        [Display(Name = "Current Password")]
        public string OldPassword { get; set; }

        [Required(ErrorMessage = "New mPIN is required")]
        [Display(Name = "New mPIN")]
        [MaxLength(6, ErrorMessage = "Pin Max Length is Invalid"), MinLength(6, ErrorMessage = "Pin Minimum Length is Invalid")]
        public string UserPin { get; set; }

        [Required(ErrorMessage = "Confirm mPIN is required")]
        [Compare("UserPin", ErrorMessage = "Confirm mPin doesn't match")]
        [Display(Name = "Confirm new mPin")]
        [MaxLength(6, ErrorMessage = "Pin Max Length is Invalid"), MinLength(6, ErrorMessage = "Pin Minimum Length is Invalid")]
        public string ConfirmUserPin { get; set; }
        [Display(Name = "Old Pin")]
        public string OldPin { get; set; }
        public string Status { get; set; }

    }
}
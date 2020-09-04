using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class AppVersionControlModel:Common
    {
        public string VersionId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Platform Subject is required")]
        [Display(Name = "Platform")]
        public string AppPlatform { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Version is required")]
        [Display(Name = "Version")]
        public string AppVersion { get; set; }
        
        [Display(Name = "Major Update")]
        public string IsMajorUpdate { get; set; }
     
        [Display(Name = "Minor Update")]
        public string IsMinorUpdate { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Update Information is required")]
        [Display(Name = "Update Information")]
        public string AppUpdateInfo { get; set; }
    }
}
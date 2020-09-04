using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class MobileNotificationModel:Common
    {
        public string NotificationId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Notification Subject is required")]
        [Display(Name = "Subject")]
        public string NotificationSubject { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Sub-Title is required")]
        [Display(Name = "Sub-Title")]
        public string NotificationSubtitle { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Notification content is required")]
        [Display(Name = "Content")]
        public string NotificationBody { get; set; }
        public string NotificationImageUrl { get; set; }
        public string ActionId { get; set; }
        public string NotificationType { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Importance Level is required")]
        [Display(Name = "Importance Level")]
        public string NotificationImportanceLevel { get; set; }
        public string NotificationStatus { get; set; }
        public string IsBackground { get; set; }
        public string NotificationTo { get; set; }
        public string AgentId { get; set; }
        public string UserId { get; set; }
        public string TxnId { get; set; }
        public string ReadStatus { get; set; }
        public string TxnStatusId { get; set; }
        public string TxnStatus { get; set; }

        public string ImageUpload { get; set; }
    }
}
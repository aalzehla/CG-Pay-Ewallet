using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.MobileNotification
{
    public class MobileNotificationCommon:Common
    {
        public string NotificationId { get; set; }
        public string NotificationSubject { get; set; }
        public string NotificationSubtitle { get; set; }
        public string NotificationBody { get; set; }
        public string NotificationImageUrl { get; set; }
        public string ActionId { get; set; }
        public string NotificationType { get; set; }
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

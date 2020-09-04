using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.User
{
    public class ChangePasswordCommon
    {
        public string UserName { get; set; }
        public string UserNameRole { get; set; }
        public string UserNamePassword { get; set; }      
        public string Password { get; set; }       
        public string ConfirmPassword { get; set; }      
        public string RoleId { get; set; }       
        public string RoleName { get; set; }
        public string IpAddress { get; set; }
        public string BrowserInfo { get; set; }
        public string ActionUser { get; set; }
    }
}

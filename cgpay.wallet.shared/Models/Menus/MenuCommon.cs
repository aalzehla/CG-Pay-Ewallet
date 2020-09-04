using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Menus
{
    public class UserMenuFunctions
    {
        public List<MenuCommon> menu { get; set; }
        public List<UserFunctionId> function { get; set; }
    }
    public class MenuCommon
    {
        public string MenuName { get; set; }
        public string linkPage { get; set; }
        public string MenuGroup { get; set; }
        public string ParentGroup { get; set; }
        public string Class { get; set; }
    }
    public class UserFunctionId
    {
        public string FunctionId { get; set; }
    }
}

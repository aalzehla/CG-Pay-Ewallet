using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Login;
using cgpay.wallet.shared.Models.Menus;

namespace cgpay.wallet.business.Login
{
    public interface ILoginUserBusiness
    {
        LoginResponse Login(LoginCommon request);
        UserMenuFunctions GetMenus(string UserLoginId);
        Dictionary<string, string> UserList();
        List<string> GetApplicatinFunction(string UserLoginId, bool loggedin = false);
        CommonDbResponse Signup(LoginCommon customer);
        CommonDbResponse setpassword(LoginCommon common);
        CommonDbResponse verifycode(LoginCommon verify);
        CommonDbResponse checkusername(LoginCommon common);
        CommonDbResponse Checkverifycode(LoginCommon Verify);
        CommonDbResponse changepassword(LoginCommon common);
        void updateSessionId(string user_name,string session);
        SessionIdMapping getUserSessionId(string user_name);
    }
}

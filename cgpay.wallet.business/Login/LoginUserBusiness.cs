using System.Collections.Generic;
using System.Data;
using cgpay.wallet.repository.Login;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Login;
using cgpay.wallet.shared.Models.Menus;

namespace cgpay.wallet.business.Login
{
    public class LoginUserBusiness : ILoginUserBusiness
    {
        ILoginUserRepository _repo;
        public LoginUserBusiness()
        {
            _repo = new LoginUserRepository();
        }

        public List<string> GetApplicatinFunction(string UserLoginId, bool loggedin = false)
        {
            return _repo.GetApplicationFunction(UserLoginId, loggedin);
        }

        public UserMenuFunctions GetMenus(string UserLoginId)
        {
            return _repo.GetMenus(UserLoginId);
        }

        public LoginResponse Login(LoginCommon request)
        {
            return _repo.Login(request);
        }

        public Dictionary<string, string> UserList()
        {
            return _repo.UserList();
        }
        public CommonDbResponse Signup(LoginCommon customer)
        {
            return _repo.Signup(customer);
        }
        public CommonDbResponse verifycode(LoginCommon verify)
        {
            return _repo.verifycode(verify);
        }
        public CommonDbResponse setpassword(LoginCommon common)
        {
            return _repo.setpassword(common);
        }
        public CommonDbResponse checkusername(LoginCommon common)
        {
            return _repo.checkusername(common);
        }
        public CommonDbResponse Checkverifycode(LoginCommon Verify)
        {
            return _repo.Checkverifycode(Verify);
        }
        public CommonDbResponse changepassword(LoginCommon common)
        {
            return _repo.changepassword(common);
        }

        public void updateSessionId(string user_name, string session)
        {
            _repo.updateSessionId(user_name, session);
        }

        public SessionIdMapping getUserSessionId(string user_name)
        {
            SessionIdMapping map = new SessionIdMapping();
            var dbres = _repo.getSessionId(user_name);
            map.Session = dbres["session"].ToString();
            map.Allowd_Multiple_Login = dbres["allow_multiple_login"].ToString().Trim();
            return map;
        }
    }
}

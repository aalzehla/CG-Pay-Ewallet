using cgpay.wallet.repository.User;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.User
{
    public class UserBusiness : IUserBusiness
    {
        IUserRepository repo;
        public UserBusiness(UserRepository _repo)
        {
            repo = _repo;
        }

        public List<UserCommon> GetAllList(string User, string usertype, int Pagesize)
        {
            return repo.GetAllList(User, usertype, Pagesize);
        }
        public UserCommon GetUserById(string UserId)
        {
            return repo.GetUserById(UserId);
        }
        public CommonDbResponse ManageUser(UserCommon setup)
        {
            return repo.ManageUser(setup);
        }
        public CommonDbResponse ChangePassword(UserCommon user)
        {
            return repo.ChangePassword(user);
        }

        public CommonDbResponse ChangePin(UserCommon user)
        {
            return repo.ChangePin(user);
        }
        public CommonDbResponse block_unblockuser(string userid, string status)
        {
            return repo.block_unblockuser(userid, status);
        }
        public List<UserCommon> GetSearchUserList(string SearchField, string SearchFilter, string username = "")
        {
            return repo.GetSearchUserList(SearchField, SearchFilter, username);
        }
        public Profile UserInfo(string UserId = "")
        {
            return repo.UserInfo(UserId);
        }
        public CommonDbResponse AssignRole(ChangePasswordCommon model)
        {
            return repo.AssignRole(model);

        }
        public CommonDbResponse ChangeUserPassword(ChangePasswordCommon model)
        {
            return repo.ChangeUserPassword(model);

        }
        public CommonDbResponse DeleteAdminUser(UserCommon model)
        {
            return repo.DeleteAdminUser(model);

        }

        public CommonDbResponse Block_UnblockSearchUser(string userid, string agentid, string status)
        {
            return repo.Block_UnblockSearchUser(userid, agentid, status);
        }
    }
}

using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.User;
using System.Collections.Generic;

namespace cgpay.wallet.business.User
{
    public interface IUserBusiness
    {
        List<UserCommon> GetAllList(string User, string usertype, int Pagesize);
        UserCommon GetUserById(string UserId);
        CommonDbResponse ManageUser(UserCommon setup);
        CommonDbResponse ChangePassword(UserCommon user);
        CommonDbResponse ChangePin(UserCommon user);
        CommonDbResponse block_unblockuser(string userid, string status);
        List<UserCommon> GetSearchUserList(string SearchField, string SearchFilter, string username = "");
        Profile UserInfo(string UserId = "");
        CommonDbResponse AssignRole(ChangePasswordCommon model);
        CommonDbResponse ChangeUserPassword(ChangePasswordCommon model);
        CommonDbResponse DeleteAdminUser(UserCommon model);
        CommonDbResponse Block_UnblockSearchUser(string userid, string agentid, string status);
    }
}
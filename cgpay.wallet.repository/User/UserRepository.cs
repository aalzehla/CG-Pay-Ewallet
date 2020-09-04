using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.User;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.User
{
    public class UserRepository : IUserRepository
    {
        RepositoryDao dao;

        public UserRepository()
        {
            dao = new RepositoryDao();
        }

        public List<UserCommon> GetAllList(string User, string usertype, int Pagesize)
        {
            var sql = "Exec sproc_user_detail ";
            sql += "@flag = 'lglst' ";
            sql += ",@user_name = " + dao.FilterString(User);
            sql += ",@usr_type = " + dao.FilterString(usertype);

            //sql += ",@Search = " + dao.FilterString(Search);
            //sql += ",@Page_size = " + dao.FilterString(Pagesize.ToString());
            var dt = dao.ExecuteDataTable(sql);
            var list = new List<UserCommon>();
            if (null != dt)
            {
                int sn = 1;
                foreach (DataRow item in dt.Rows)
                {
                    var common = new UserCommon
                    {
                        UserID = item["User_ID"].ToString(),
                        FullName = item["Full_Name"].ToString(),
                        Email = item["user_email"].ToString(),
                        PhoneNo = item["user_mobile_no"].ToString(),
                        CreateDate = item["created_local_date"].ToString(),
                        CreatedBy = item["created_by"].ToString(),
                        IsActive = item["status"].ToString(),
                        UserName = item["user_name"].ToString(),
                        RoleId=item["role_id"].ToString()
                    };
                    sn++;
                    list.Add(common);
                }
            }
            return list;

        }
        public UserCommon GetUserById(string UserId)
        {
            var sql = "Exec sproc_user_detail ";
            sql += "@flag = 'v' ";
            sql += ",@user_id = " + dao.FilterString(UserId);
            var dt = dao.ExecuteDataTable(sql);
            var item = new UserCommon();
            if (null != dt)
            {
                int sn = 1;
                foreach (DataRow dr in dt.Rows)
                {
                    item = new UserCommon
                    {
                        UserID = dr["User_ID"].ToString(),
                        FullName = dr["Full_Name"].ToString(),
                        Email = dr["user_email"].ToString(),
                        PhoneNo = dr["user_mobile_no"].ToString(),
                        CreateDate = dr["created_local_date"].ToString(),
                        CreatedBy = dr["created_by"].ToString(),
                        IsActive = dr["status"].ToString(),
                        UserName = dr["user_name"].ToString(),
                        RoleId=dr["usr_type_id"].ToString(),
                        Allow_Multiple_Login=dr["allow_multiple_login"].ToString().Trim()
                    };
                    return item;
                }
            }
            return item;

        }

        public CommonDbResponse ManageUser(UserCommon setup)
        {
            var sql = "Exec sproc_user_detail ";
            sql += "@flag = '" + (string.IsNullOrEmpty(setup.UserID) ? "i" : "u") + "' ";
            sql += ",@full_name = " + dao.FilterString(setup.FullName);
            sql += ",@email = " + dao.FilterString(setup.Email);
            sql += ",@mobile = " + dao.FilterString(setup.PhoneNo);
            sql += "," + (string.IsNullOrEmpty(setup.UserID) ? "@created_by" : "@updated_by") + " = " + dao.FilterString(setup.ActionUser);
            sql += ",@usr_type_id = '1'";
            sql += ",@role_id = " + dao.FilterString(setup.RoleId);
            sql += ",@allow_multiple_login = " + dao.FilterString(setup.Allow_Multiple_Login);
            if (string.IsNullOrEmpty(setup.UserID))
            {
                sql += ",@user_name = " + dao.FilterString(setup.UserName);
                sql += ",@password = " + dao.FilterString(setup.UserPwd);
                sql += ",@created_ip = " + dao.FilterString(setup.IpAddress);
                sql += ",@created_platform = " + dao.FilterString(setup.CreatedPlatform);
                sql += ",@status = " + dao.FilterString(setup.IsActive);
               
            }
            else
            {
                sql += ",@user_id = " + dao.FilterString(setup.UserID);
                sql += ",@created_ip = " + dao.FilterString(setup.IpAddress);
            }
            return dao.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse ChangePassword(UserCommon user)
        {

            var sql = "Exec sproc_user_detail ";
            sql += " @flag='changepwd'";
            sql += ", @password=" + dao.FilterString(user.OldPassword);
            sql += ", @new_password=" + dao.FilterString(user.UserPwd);
            sql += ", @user_name=" + dao.FilterString(user.UserName);
            sql += ", @session=" + dao.FilterString(user.Session);
            return dao.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse ChangePin(UserCommon user)
        {

            var sql = "Exec sproc_user_detail ";
            sql += " @flag='wmp', @mode='r'"; //mode u for update s for first time change
            sql += ", @old_mpin=" + dao.FilterString(user.UserPin);
            sql += ", @mpin=" + dao.FilterString(user.UserPin);
            sql += ", @password=" + dao.FilterString(user.UserPwd);
            sql += ", @user_id=" + dao.FilterString(user.UserID);
            sql += ", @action_user=" + dao.FilterString(user.UserName);
            return dao.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse block_unblockuser(string userid,string status )
        {
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='e'";
            sql += ", @status=" + dao.FilterString(status);
            sql += ", @user_id=" + dao.FilterString(userid);
            return dao.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse Block_UnblockSearchUser(string userid,string agentid, string status)
        {
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='uu'";
            sql += ", @status=" + dao.FilterString(status);
            sql += ", @user_id=" + dao.FilterString(userid);
            sql += ", @agent_id=" + dao.FilterString(agentid);
            return dao.ParseCommonDbResponse(sql);
        }

        public Profile UserInfo(string UserId = "")
        {
            Profile User = new Profile();
            string sql = "sproc_user_detail @flag = 'selectuser',@search= " + dao.FilterString(UserId);
            var dr = dao.ExecuteDataRow(sql);
            if (dr != null)
            {
                User.UserID = dr["user_id"].ToString();
                User.Email = dr["user_email"].ToString();
                User.FullName = dr["full_name"].ToString();
                User.MobileNo = dr["user_mobile_no"].ToString();
                User.UserName = dr["user_name"].ToString();
                User.AgentUserId = dr["agent_id"].ToString();
                User.Balance = dr["available_balance"].ToString();
                User.CreateDate = dr["created_local_date"].ToString();
                User.RoleName = dr["role_name"].ToString();
                //User.PPImage = dr["identification_photo_logo"].ToString();
            }
            return User;
        }
        public List<UserCommon> GetSearchUserList(string SearchField,string SearchFilter,string username="")
        {
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='searchfilteruser'";
            sql += ", @action_user="+dao.FilterString(username);
            if(SearchFilter.ToLower()=="email")
                sql += " ,@email=" + dao.FilterString(SearchField);
            if(SearchFilter.ToLower()== "mobileno")
                sql += " ,@mobile=" + dao.FilterString(SearchField); 
            if(SearchFilter.ToLower()=="username")
                sql += " ,@user_name=" + dao.FilterString(SearchField);
            if (SearchFilter.ToLower() == "fullname")
                sql += " ,@full_name=" + dao.FilterString(SearchField);
            if (SearchFilter.ToLower() == "userid")
                sql += " ,@search=" + dao.FilterString(SearchField);
            var dt = dao.ExecuteDataTable(sql);
            var list = new List<UserCommon>();
            if (null != dt)
            {
                int sn = 1;
                foreach (DataRow item in dt.Rows)
                {
                    var common = new UserCommon
                    {
                        UserID = item["User_ID"].ToString(),
                        AgentUserId = item["Agent_id"].ToString(),
                        FullName = item["Full_Name"].ToString(),
                        UserName = item["user_name"].ToString(),
                        Email = item["user_email"].ToString(),
                        PhoneNo = item["user_mobile_no"].ToString(),
                        CreateDate = item["created_local_date"].ToString(),
                        CreatedBy = item["created_by"].ToString(),
                        IsActive = item["status"].ToString(),
                        IsPrimary = item["is_primary"].ToString(),
                        Allow_Multiple_Login = item["allow_multiple_login"].ToString().Trim()

                        //identification photo logo
                    };
                    sn++;
                    list.Add(common);
                }
            }
            return list;
        }


        public CommonDbResponse ChangeUserPassword(ChangePasswordCommon model)
        {
            CommonDbResponse r = new CommonDbResponse();
            // initialize api feature
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='changeuserpwd'";
            sql += ", @password=" + dao.FilterString(model.Password);
            sql += ", @confirm_password=" + dao.FilterString(model.ConfirmPassword);
            sql += ", @user_id=" + dao.FilterString(model.UserName);
            sql += ", @action_user = " + dao.FilterString(model.ActionUser);
            sql += ", @updated_ip=" + dao.FilterString(model.IpAddress);
            //sql += ", @actionbrowser=" + dao.FilterString(model.BrowserInfo);
            r = dao.ParseCommonDbResponse(sql);
            return r;
        }
        public CommonDbResponse DeleteAdminUser(UserCommon model)
        {
            CommonDbResponse r = new CommonDbResponse();
            // initialize api feature
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='d'";
            sql += ", @user_id=" + dao.FilterString(model.UserName);
            sql += ", @action_user = " + dao.FilterString(model.ActionUser);
            sql += ", @updated_ip=" + dao.FilterString(model.IpAddress);
            //sql += ", @actionbrowser=" + dao.FilterString(model.BrowserInfo);
            r = dao.ParseCommonDbResponse(sql);
            return r;
        }

        public CommonDbResponse AssignRole(ChangePasswordCommon model)
        {
            CommonDbResponse r = new CommonDbResponse();
            // initialize api feature
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='r'";
            sql += ", @user_id=" + dao.FilterString(model.UserName);
            sql += ", @role_id=" + dao.FilterString(model.RoleId);
            sql += ", @action_user = " + dao.FilterString(model.ActionUser);
            sql += ", @updated_ip=" + dao.FilterString(model.IpAddress);
            //sql += ", @actionbrowser=" + dao.FilterString(model.BrowserInfo);
            r = dao.ParseCommonDbResponse(sql);
            return r;
        }
    }
}



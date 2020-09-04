using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Role;
using System;
using System.Collections.Generic;

namespace cgpay.wallet.business.Role
{
    public interface IRoleBusiness
    {
        List<RoleCommon> GetRoles();
        CommonDbResponse Manage(RoleCommon setup);
        List<Tuple<string, string, string, bool>> GetRoleList(string RoleId);
        CommonDbResponse AssignRoles(string RoleId, string RoleList, string user);
        List<Tuple<string, string, string, bool>> GetFunctionList(string RoleId);
        CommonDbResponse AssignFunctions(string RoleId, string FunctionList, string user);
    }
}
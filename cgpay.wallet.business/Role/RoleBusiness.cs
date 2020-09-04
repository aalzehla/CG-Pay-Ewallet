using cgpay.wallet.repository.Role;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Role;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Role
{
    public class RoleBusiness : IRoleBusiness
    {

        IRoleRepository IRR;
        public RoleBusiness(RoleRepository _IRR)
        {
            IRR = _IRR;
        }
        public List<RoleCommon> GetRoles()
        {
            return IRR.GetRoles();
        }

        public CommonDbResponse Manage(RoleCommon setup)
        {
            return IRR.Manage(setup);
        }

        public List<Tuple<string, string, string, bool>> GetRoleList(string RoleId)
        {
            return IRR.GetRoleList(RoleId);

        }

        public CommonDbResponse AssignRoles(string RoleId, string RoleList, string user)
        {
            return IRR.AssignRoles(RoleId, RoleList, user);
        }

        public List<Tuple<string, string, string, bool>>GetFunctionList(string RoleId)
        {
            return IRR.GetFunctionList(RoleId);
        }

        public CommonDbResponse AssignFunctions(string RoleId, string FunctionList, string user)
        {
            return IRR.AssignFunctions(RoleId, FunctionList, user);
        }
    }
}

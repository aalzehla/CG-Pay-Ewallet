using cgpay.wallet.repository.SubDistributor;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubDistributor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.SubDistributor
{
    public class SubDistributorBusiness:ISubDistributorBusiness
    {
        ISubDistributorRepository _repo;
        public SubDistributorBusiness()
        {
            _repo = new SubDistributorRepository();
        }
        public List<SubDistributorCommon> GetSubDistributorsList(string username, string Distid, string SubDistId = "")
        {
            return _repo.GetSubDistributorsList(username, Distid,  SubDistId );
        }
        public CommonDbResponse Manage(SubDistributorCommon sdc)
        {
            return _repo.Manage(sdc);
        }
        public SubDistributorCommon GetSubDistributorById(string agentid, string username)
        {
            return _repo.GetSubDistributorById(agentid, username);
        }
        public List<SubDistributorCommon> GetUserList(string agentid,string userId)
        {
            return _repo.GetUserList(agentid, userId);
        }
        public SubDistributorCommon GetUserById(string agentid, string UserId = "")
        {
            return _repo.GetUserById(agentid, UserId);
        }
        public CommonDbResponse ManageUser(SubDistributorCommon SDC, string changepassword)
        {
            return _repo.ManageUser( SDC, changepassword);
        }
        public CommonDbResponse block_unblockuser(string userid, string status, string agentid)
        {
            return _repo.block_unblockuser( userid,  status,  agentid);
        }
    }
}

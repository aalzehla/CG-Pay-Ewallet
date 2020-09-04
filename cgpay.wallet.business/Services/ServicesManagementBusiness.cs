using cgpay.wallet.repository.Services;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Services
{
    public class ServicesManagementBusiness:IServicesManagementBusiness
    {
        IServicesManagementRepository _repo;
        public ServicesManagementBusiness()
        {
            _repo = new ServicesManagementRepository();
        }
        public List<ServicesCommon> GetServicesList(string UserId = "")
        {
            return _repo.GetServicesList(UserId);
        }
        public ServicesCommon GetServicesByProductId(int ProductId)
        {
            return _repo.GetServicesByProductId(ProductId);
        }
        //public CommonDbResponse UpdateServicesByProductId(ServicesCommon SC, string username)
        //{
        //    return _repo.UpdateServicesByProductId( SC, username);
        //}
        public CommonDbResponse ManageServices(ServicesCommon SC, string username)
        {
            return _repo.ManageServices(SC, username);
        }
        public Dictionary<string, string> Dropdown(string flag)
        {
            return _repo.Dropdown( flag);
        }
        public void ServicesStatus(string[] services, string username, string ipaddress)
        {
             _repo.ServicesStatus(services, username, ipaddress);
        }

    }
}

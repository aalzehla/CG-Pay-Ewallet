using System.Web.Mvc;
using cgpay.wallet.business.Balance;
using cgpay.wallet.business.KYC;
using Unity;
using Unity.AspNet.Mvc;
using cgpay.wallet.business.Login;
using cgpay.wallet.business.User;
using cgpay.wallet.business.Services;
using cgpay.wallet.business.Distributor;
using cgpay.wallet.business.Gateway;
using cgpay.wallet.business.Role;
using cgpay.wallet.business.Common;
using cgpay.wallet.business.Commission;
using cgpay.wallet.business.Bank;
using cgpay.wallet.business.Card;
using cgpay.wallet.business.Client;
using cgpay.wallet.business.DynamicReport;
using cgpay.wallet.business.Log;
using cgpay.wallet.business.SubDistributor;
using cgpay.wallet.business.Mobile;
using cgpay.wallet.business.StaticData;
using cgpay.wallet.business.AgentManagement;
using cgpay.wallet.business.SubAgentManagement;
using cgpay.wallet.business.Dashboard;
using cgpay.wallet.business.TransactionLimit;
using cgpay.wallet.business.DistributorManagement;
using cgpay.wallet.business.Client.MobileTopup;
using cgpay.wallet.business.Merchant;
using cgpay.wallet.business.Notification;
using cgpay.wallet.business.SubDistributorManagement;
using cgpay.wallet.business.MobileNotification;
using cgpay.wallet.business.AppVersionControl;
using cgpay.wallet.business.Client.Commission;
using cgpay.wallet.business.Agent_Commission;
using cgpay.wallet.business.LoadBalance;
using cgpay.wallet.business.LandLine;
using cgpay.wallet.business.Utilities;
using cgpay.wallet.business.BulkUpload;
using cgpay.wallet.business.AdminCommission;

namespace cgpay.wallet.application
{
    public class Bootstrapper
    {
        public static void Initialise()
        {
            var container = BuildUnityContainer();

            DependencyResolver.SetResolver(new UnityDependencyResolver(container));
        }
        private static IUnityContainer BuildUnityContainer()
        {
            var container = new UnityContainer();

            // register all your components with the container here
            // it is NOT necessary to register your controllers
            container.RegisterType<ILoginUserBusiness, LoginUserBusiness>();
            container.RegisterType<IDistributorBusiness, DistributorBusiness>();
            container.RegisterType<IUserBusiness, UserBusiness>();
            container.RegisterType<IKycBusiness, KycBusiness>();
            container.RegisterType<IServicesManagementBusiness, ServicesManagementBusiness>();
            container.RegisterType<IRoleBusiness, RoleBusiness>();
            container.RegisterType<IGatewayBusiness, GatewayBusiness>();
            container.RegisterType<ICommonBusiness, CommonBusiness>();
            container.RegisterType<IBalanceBusiness, BalanceBusiness>();
            container.RegisterType<ICommissionBusiness, CommissionBusiness>();
            container.RegisterType<IBankBusiness, BankBusiness>();
            container.RegisterType<IWalletUserBusiness, WalletUserBusiness>();
            container.RegisterType<ISubDistributorBusiness, SubDistributorBusiness>();
            container.RegisterType<ICardBusiness, CardBusiness>();
            container.RegisterType<IMobileTopUpPaymentBusiness, MobileTopUpPaymentBusiness>();
            container.RegisterType<IDynamicReportBusiness, DynamicReportBusiness>();
            container.RegisterType<business.Agent.IAgentBusiness, business.Agent.AgentBusiness>();
            //container.RegisterType<business.NewAgent.IAgentBusiness, business.NewAgent.AgentBusiness>();
            container.RegisterType<IStaticDataBusiness, StaticDataBusiness>();
            container.RegisterType<IActivityLogBusiness, ActivityLogBusiness>();
            container.RegisterType<IMobilePaymentBusiness, MobilePaymentBusiness>();
            container.RegisterType<IClientManagementBusiness, ClientManagementBusiness>();
            container.RegisterType<IAgentManagementBusiness, AgentManagementBusiness>();
            container.RegisterType<ISubAgentManagementBusiness, SubAgentManagementBusiness>();
            container.RegisterType<IDashboardBusiness, DashboardBusiness>();
            container.RegisterType<ITransactionLimitBusiness, TransactionLimitBusiness>();
            container.RegisterType<IAccessLogBusiness, AccessLogBusiness>();
            container.RegisterType<IErrorLogBusiness, ErrorLogBusiness>();
            container.RegisterType<IApiLogBusiness, ApiLogBusiness>();
            container.RegisterType<IDistributorManagementBusiness, DistributorManagementBusiness>();
            container.RegisterType<ISubDistributorManagementBusiness, SubDistributorManagementBusiness>();
            container.RegisterType<IMerchantBusiness, MerchantBusiness>();
            container.RegisterType<INotificationBusiness, NotificationBusiness>();
            container.RegisterType<IMobileNotificationBusiness, MobileNotificationBusiness>();
            container.RegisterType<IAppVersionControlBusiness, AppVersionControlBusiness>();
            container.RegisterType<IClientCommissionBusiness, ClientCommissionBusiness>();
            container.RegisterType<IAgentCommissionBusiness, AgentCommissionBusiness>();
            container.RegisterType<ILoadBalanceBusiness, LoadBalanceBusiness>();
            container.RegisterType<ILandLinePaymentBusiness, LandLinePaymentBusiness>();
            container.RegisterType<INeaBillPaymentBusiness, NeaBillPaymentBusinsess>();
            container.RegisterType<IBulkUploadBusiness, BulkUploadBusiness>();
            container.RegisterType<IAdminCommissionBusiness, AdminCommissionBusiness>();
            container.RegisterType<INwscBillPaymentBusiness, NwscBillPaymentBusiness>();
            container.RegisterType<IWorldLinkBillPaymentBusiness, WorldLinkBillPaymentBusiness>();
            container.RegisterType<IVianetBillPaymentBusiness, VianetBillPaymentBusiness>();





            return container;
        }
    }
}


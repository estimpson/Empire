using System.Collections.Generic;
using System.Reflection;
using System.Web.Mvc;
using Autofac;
using Autofac.Integration.Mvc;
using EmpirePortal.Domain.Sql;
using FxWeb.Domain.Core;
using FxWeb.Domain.Core.Logging;
using FxWeb.Mvc.Infrastructure.DataServices;
using FxWeb.Mvc.Infrastructure.EventTasks;
using FxWeb.Mvc.Infrastructure.Security.Identity;

namespace EmpirePortal.Mvc.App_Start
{
    public class DependencyInjectionConfig
    {
        public static void RegisterTypes()
        {
            var builder = new ContainerBuilder();

            //  Register MVC controllers.
            builder.RegisterControllers(typeof(MvcApplication).Assembly);

            // OPTIONAL: Register model binders that require DI.
            //builder.RegisterModelBinders(typeof(MvcApplication).Assembly);
            //builder.RegisterModelBinderProvider();

            // OPTIONAL: Register web abstractions like HttpContextBase.
            builder.RegisterModule<AutofacWebTypesModule>();

            // OPTIONAL: Enable property injection in view pages.
            //builder.RegisterSource(new ViewRegistrationSource());

            // OPTIONAL: Enable property injection into action filters.
            builder.RegisterFilterProvider();

            //  Register EF Db.
            builder.RegisterType<CorePortalEntities>().As<ICoreDataSource>().InstancePerRequest();
            builder.RegisterType<CorePortalEntities>().As<CorePortalEntities>().InstancePerRequest();
            //builder.RegisterType<FxEntities>().As<IFxDataSource>().InstancePerRequest();

            //  Register Current User.
            builder.RegisterType<CurrentUser>().As<ICurrentUser>().InstancePerRequest();

            //  Register Log Action.
            //builder.RegisterType<LogAction>().As<ILogAction>().InstancePerRequest();

            //  Register Event Tasks.
            var rootAssembly = Assembly.GetExecutingAssembly();
            builder.RegisterAssemblyTypes(rootAssembly)
                .As<IRunAfterEachRequest>();
            builder.RegisterAssemblyTypes(rootAssembly)
                .As<IRunAtInit>();
            builder.RegisterAssemblyTypes(rootAssembly)
                .As<IRunAtStartup>();
            builder.RegisterAssemblyTypes(rootAssembly)
                .As<IRunOnEachRequest>();
            builder.RegisterAssemblyTypes(rootAssembly)
                .As<IRunOnError>();

            // Set the dependency resolver to be Autofac.
            var container = builder.Build();

            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));

            // Run all IRunAtInit, IRunAtStartup tasks.
            foreach (var task in container.Resolve<IEnumerable<IRunAtInit>>())
            {
                task.Execute();
            }
            foreach (var task in container.Resolve<IEnumerable<IRunAtStartup>>())
            {
                task.Execute();
            }

            // Refactor.  I still don't know how to do this properly.
            CoreDbContextService.Db = new CorePortalEntities();
        }
    }
}
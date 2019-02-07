using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using AutoMapper;
using FxWeb.Mvc.Infrastructure.EventTasks;
using FxWeb.Mvc.Infrastructure.Mapping;

namespace EmpirePortal.Mvc
{
    public class AutoMapperConfig : IRunAtInit
    {
        public void Execute()
        {
            //Mapper.Initialize(cfg => cfg.CreateMap<MenuItemNode, MenuItemNodeViewModel>().ReverseMap());
            var types = Assembly.GetExecutingAssembly().GetExportedTypes();

            LoadStandardMappings(types);
            LoadCustomMappings(types);
        }

        private static void LoadStandardMappings(IEnumerable<Type> types)
        {
            var maps = (types.SelectMany(t => t.GetInterfaces(), (t, i) => new { t, i })
                    .Where(@t1 =>
                        @t1.i.IsGenericType &&
                        @t1.i.GetGenericTypeDefinition() == typeof(IMapsFrom<>) &&
                        !@t1.t.IsAbstract &&
                        !@t1.t.IsInterface)
                    .Select(@t1 => new { Source = @t1.i.GetGenericArguments()[0], Destination = @t1.t, }))
                .ToArray();

            foreach (var map in maps)
            {
                Mapper.Initialize(cfg => cfg.CreateMap(map.Source, map.Destination));
            }
        }
        private static void LoadCustomMappings(IEnumerable<Type> types)
        {
            var maps = (types.SelectMany(t => t.GetInterfaces(), (t, i) => new { t, i })
                    .Where(@t1 =>
                        typeof(ICustomMapping).IsAssignableFrom(@t1.t) &&
                        !@t1.t.IsAbstract &&
                        !@t1.t.IsInterface)
                    .Select(@t1 => (ICustomMapping)Activator.CreateInstance(@t1.t)))
                .ToArray();

            foreach (var map in maps)
            {
                map.CreateMapping(Mapper.Configuration);
            }
        }
    }
}
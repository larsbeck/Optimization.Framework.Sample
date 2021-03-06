﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class ProductionmixSample
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        private static Model BuildModel()
        {
            #region Data

            var productionmixModel = new ProductionmixModel();

            var d1 = new Desk { Name = "d1" };
            var d2 = new Desk { Name = "d2" };
            var d3 = new Desk { Name = "d3" };
            var d4 = new Desk { Name = "d4" };

            var carpentry = new Shop { Name = "carpentry" };
            var finishing = new Shop { Name = "finishing" };

            d1.Price = 12;
            d2.Price = 20;
            d3.Price = 18;
            d4.Price = 40;

            carpentry.Capacity = 6000;
            finishing.Capacity = 4000;

            carpentry.ManHours.Add(d1, 4);
            carpentry.ManHours.Add(d2, 9);
            carpentry.ManHours.Add(d3, 7);
            carpentry.ManHours.Add(d4, 10);

            finishing.ManHours.Add(d1, 1);
            finishing.ManHours.Add(d2, 1);
            finishing.ManHours.Add(d3, 3);
            finishing.ManHours.Add(d4, 40);
            
            var desks = new List<Desk> {d1, d2, d3, d4};
            var shops = new List<Shop> {carpentry, finishing};

            productionmixModel.Desks = desks;
            productionmixModel.Shops = shops;

            #endregion

            #region MathModel
            
            var mathModel = new Model();

            var mix = new VariableCollection<Desk>("deskmix", 0, Double.PositiveInfinity, VariableType.Integer, productionmixModel.Desks);

            mathModel.AddObjective(Expression.Sum(productionmixModel.Desks.Select(desk => desk.Price*mix[desk])), "profit", ObjectiveSense.Maximize);

            foreach (var shop in productionmixModel.Shops)
            {
                mathModel.AddConstraint(Expression.Sum(productionmixModel.Desks.Select(desk => shop.ManHours[desk]*mix[desk])) <= shop.Capacity, new StringBuilder("CapacityLimit_").Append(shop.Name).ToString());
            }

            return mathModel;

            #endregion
        }

        private static Solution SolveModel(Model mathModel)
        {
            ISolver solver = new GLPKSolver(Console.WriteLine);
            Solution solution = solver.Solve(mathModel);

            return solution;
        }

        /*
         * Classes used for the definition of the data
         */

        public class Desk
        {
            public string Name { get; set; }

            public double Price { get; set; }
        }

        public class Shop
        {
            public string Name { get; set; }

            public double Capacity { get; set; }

            public ManHoursDictionary ManHours { get; set; }

            public Shop()
            {
                ManHours = new ManHoursDictionary();
            }
        }

        [CollectionDataContract
        (Name = "shops",
        ItemName = "entry",
        KeyName = "desk",
        ValueName = "manhours")]
        public class ManHoursDictionary : Dictionary<Desk, double> { }

        class ProductionmixModel
        {
            public List<Desk> Desks { get; set; }

            public List<Shop> Shops { get; set; }
        }
}

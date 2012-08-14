using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class steel3
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        static Model BuildModel()
        {
            #region Data

            var steel3Model = new steel3model { HoursAvailable = 40 };

            var products = new List<Product>
            {
                new Product
                {
                    Id = 0,
                    Name = "bands",
                    Rate = 200,
                    Profit = 25,
                    Commit = 1000,
                    Market = 6000
                },
                new Product
                {
                    Id = 1,
                    Name = "coils",
                    Rate = 140,
                    Profit = 30,
                    Commit = 500,
                    Market = 4000
                },
                new Product
                {
                    Id = 2,
                    Name = "plate",
                    Rate = 160,
                    Profit = 29,
                    Commit = 750,
                    Market = 3500
                }
            };

            steel3Model.Products = products;

            #endregion

            #region Model

            /*
             * mathematical Model
             */

            var mathModel = new Model();

            var Make = new VariableCollection<Product>(
                x => new StringBuilder("Prod_").Append(x.Id),
                0,
                double.PositiveInfinity,
                VariableType.Continuous,
                steel3Model.Products);

            mathModel.AddObjective(Expression.Sum(steel3Model.Products.Select(p => p.Profit * Make[p])), null, ObjectiveSense.Maximize);

            foreach (var prod in steel3Model.Products)
            {
                mathModel.AddConstraint(Make[prod] >= prod.Commit);
                mathModel.AddConstraint(Make[prod] <= prod.Market);
            }

            mathModel.AddConstraint(Expression.Sum(steel3Model.Products.Select(p => (1.0 / p.Rate) * Make[p])) <= steel3Model.HoursAvailable);

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

        class steel3model
        {
            public List<Product> Products;

            public int HoursAvailable;

            public steel3model()
            {
                Products = new List<Product>();
            }
        }

        class Product
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int Rate { get; set; }
            public int Profit { get; set; }
            public int Commit { get; set; }
            public int Market { get; set; }
        }
    }
}

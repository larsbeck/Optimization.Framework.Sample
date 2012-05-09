using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class steel4
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        static Model BuildModel()
        {
            var steel4Model = new steel4model();

            var reheat = new Stage
            {
                Id = 0,
                Name = "reheat",
                Avail = 35
            };
            var roll = new Stage
            {
                Id = 1,
                Name = "roll",
                Avail = 40
            };

            var stages = new List<Stage>
            {
                reheat,
                roll
            };

            var prods = new List<Prod>
            {
                new Prod
                {
                    Id = 0,
                    Name = "bands",
                    Rate = new Dictionary<Stage, int>
                    {
                        {reheat, 200},
                        {roll, 200}
                    },
                    Profit = 25,
                    Commit = 1000,
                    Market = 6000
                },
                new Prod
                {
                    Id = 1,
                    Name = "coils",
                    Rate = new Dictionary<Stage, int>
                    {
                        {reheat, 200},
                        {roll, 140}
                    },
                    Profit = 30,
                    Commit = 500,
                    Market = 4000
                },
                new Prod
                {
                    Id = 2,
                    Name = "plate",
                    Rate = new Dictionary<Stage, int>
                    {
                        {reheat, 200},
                        {roll, 160}
                    },
                    Profit = 29,
                    Commit = 750,
                    Market = 3500
                }
            };

            steel4Model.Stages = stages;
            steel4Model.Products = prods;

            /*
             * mathematical Model
             */

            var mathModel = new Model();

            var Make = new VariableCollection<Prod>(
                x => new StringBuilder("Prod_").Append(x.Id),
                0,
                double.PositiveInfinity,
                VariableType.Continuous,
                steel4Model.Products);

            mathModel.AddObjective(Expression.Sum(steel4Model.Products.Select(prod => prod.Profit * Make[prod])), null, ObjectiveSense.Maximize);

            foreach (Stage stage in steel4Model.Stages)
            {
                mathModel.AddConstraint(Expression.Sum(steel4Model.Products.Select(prod => (1.0 / prod.Rate[stage]) * Make[prod])) <= stage.Avail);
            }

            foreach (var prod in steel4Model.Products)
            {
                mathModel.AddConstraint(Make[prod] >= prod.Commit);
                mathModel.AddConstraint(Make[prod] <= prod.Market);
            }

            return mathModel;
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

        class steel4model
        {
            public List<Prod> Products;
            public List<Stage> Stages;

            public steel4model()
            {
                Products = new List<Prod>();
                Stages = new List<Stage>();
            }
        }

        class Prod
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public Dictionary<Stage, int> Rate { get; set; }
            public int Profit { get; set; }
            public int Commit { get; set; }
            public int Market { get; set; }
            public int Units { get; set; }
        }

        class Stage
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int Avail { get; set; }
        }
    }
}

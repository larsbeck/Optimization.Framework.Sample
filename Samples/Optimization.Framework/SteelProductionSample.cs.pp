using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class SteelProductionSample
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        static Model BuildModel()
        {
            /*
             * Data
             */
            var steelProductionSample = new SteelProductionSampleModel { HoursAvailable = 40 };

            var bands = new Prod { name = "bands", rate = 200, profit = 25, market = 6000 };
            var coils = new Prod { name = "coils", rate = 140, profit = 30, market = 4000 };
            var prods = new List<Prod> { bands, coils };

            steelProductionSample.Products = prods;

            /*
             * mathematical Model
             */
            var mathModel = new Model();

            var make = new VariableCollection<Prod>(product => new StringBuilder("Prod_").Append(product.name), 0, double.PositiveInfinity, VariableType.Integer, steelProductionSample.Products);

            foreach (var product in steelProductionSample.Products)
            {
                mathModel.AddConstraint(make[product] <= product.market, new StringBuilder(product.name).Append("_market_ub").ToString());
            }

            mathModel.AddObjective(Expression.Sum(steelProductionSample.Products.Select(product => product.profit * make[product])), "total_profit", ObjectiveSense.Maximize);

            mathModel.AddConstraint(Expression.Sum(steelProductionSample.Products.Select(product => (1.0 / product.rate) * make[product])) <= steelProductionSample.HoursAvailable);

            return mathModel;
        }

        private static Solution SolveModel(Model mathModel)
        {
            ISolver solver = new GLPKSolver(Console.WriteLine);
            Solution solution = solver.Solve(mathModel);

            foreach (var variable in solution.VariableValues)
            {
                Console.WriteLine(variable.Key + ": " +variable.Value);
            }

            return solution;
        }
		
		/*
		 * Classes used for the definition of the data.
		 */

		class SteelProductionSampleModel
		{
			public List<Prod> Products;
			public int HoursAvailable;

			public SteelProductionSampleModel()
			{
				Products = new List<Prod>();
			}
		}

		class Prod
		{
			public string name { get; set; }
			public int rate { get; set; }
			public int profit { get; set; }
			public int market { get; set; }
			public int units { get; set; }
		}
    }
}

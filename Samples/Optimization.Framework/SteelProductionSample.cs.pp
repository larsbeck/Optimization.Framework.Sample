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
			#region Data
			/*
			 * Data
			 */
			var steelProductionSample = new SteelProductionSampleModel { HoursAvailable = 40 };

			var bands = new Product { Name = "bands", Rate = 200, Profit = 25, Market = 6000 };
			var coils = new Product { Name = "coils", Rate = 140, Profit = 30, Market = 4000 };
			var products = new List<Product> { bands, coils };

			steelProductionSample.Products = products;
			#endregion

			#region Model
			/*
			 * mathematical Model
			 */
			var mathModel = new Model();

			var make = new VariableCollection<Product>(product => new StringBuilder("Product_").Append(product.Name), 0, double.PositiveInfinity, VariableType.Integer, steelProductionSample.Products);

			foreach (var product in steelProductionSample.Products)
			{
				mathModel.AddConstraint(make[product] <= product.Market, new StringBuilder(product.Name).Append("_market_ub").ToString());
			}

			mathModel.AddObjective(Expression.Sum(steelProductionSample.Products.Select(product => product.Profit * make[product])), "total_profit", ObjectiveSense.Maximize);

			mathModel.AddConstraint(Expression.Sum(steelProductionSample.Products.Select(product => (1.0 / product.Rate) * make[product])) <= steelProductionSample.HoursAvailable);

			return mathModel;
			#endregion
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
			public List<Product> Products;
			public int HoursAvailable;

			public SteelProductionSampleModel()
			{
				Products = new List<Product>();
			}
		}

		class Product
		{
			public string Name { get; set; }
			public int Rate { get; set; }
			public int Profit { get; set; }
			public int Market { get; set; }
			public int Units { get; set; }
		}
    }
}

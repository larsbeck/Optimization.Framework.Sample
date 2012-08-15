using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class SteelProductionTransportSample
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
			var steelProductionTransportSampleModel = new SteelProducionTransportSampleModel();

			var bands = new Product { Name = "bands" };
			var coils = new Product { Name = "coils" };
			var plate = new Product { Name = "plate" };

			var products = new List<Product>
			{
				bands,
				coils,
				plate
			};

			var gary = new Origin
			{
				Name = "GARY",
				Rate = new Dictionary<Product, int>
				{
					{bands, 200},
					{coils, 140},
					{plate, 160}
				},
				Avail = 20,
				MakeCost = new Dictionary<Product, int>
				{
					{bands, 180},
					{coils, 170},
					{plate, 180}
				}
			};
			var clev = new Origin
			{
				Name = "CLEV",
				Rate = new Dictionary<Product, int>
				{
					{bands, 190},
					{coils, 130},
					{plate, 160}
				},
				Avail = 15,
				MakeCost = new Dictionary<Product, int>
				{
					{bands, 190},
					{coils, 170},
					{plate, 185}
				}
			};
			var pitt = new Origin
			{
				Name = "PITT",
				Rate = new Dictionary<Product, int>
				{
					{bands, 230},
					{coils, 160},
					{plate, 170}
				},
				Avail = 20,
				MakeCost = new Dictionary<Product, int>
				{
					{bands, 190},
					{coils, 180},
					{plate, 185}
				}
			};

			var origins = new List<Origin>
			{
				gary,
				clev,
				pitt
			};

			Destination fra = new Destination
			{
				Name = "FRA",
				Demand = new Dictionary<Product, int>
				{
					{bands, 300},
					{coils, 500},
					{plate, 100}
				}
			};
			Destination det = new Destination
			{
				Name = "DET",
				Demand = new Dictionary<Product, int>
				{
					{bands, 300},
					{coils, 750},
					{plate, 100}
				}
			};
			Destination lan = new Destination
			{
				Name = "LAN",
				Demand = new Dictionary<Product, int>
				{
					{bands, 100},
					{coils, 400},
					{plate, 0}
				}
			};
			Destination win = new Destination
			{
				Name = "WIN",
				Demand = new Dictionary<Product, int>
				{
					{bands, 75},
					{coils, 250},
					{plate, 50}
				}
			};
			Destination stl = new Destination
			{
				Name = "STL",
				Demand = new Dictionary<Product, int>
				{
					{bands, 650},
					{coils, 950},
					{plate, 200}
				}
			};
			Destination fre = new Destination
			{
				Name = "FRE",
				Demand = new Dictionary<Product, int>
				{
					{bands, 225},
					{coils, 850},
					{plate, 100}
				}
			};
			Destination laf = new Destination
			{
				Name = "LAF",
				Demand = new Dictionary<Product, int>
				{
					{bands,250},
					{coils,500},
					{plate,250}
				}
			};

			var destinations = new List<Destination>
			{
				fra,
				det,
				lan,
				win,
				stl,
				fre,
				laf
			};

			gary.TransCost = new List<Tuple<Destination, Product, int>>
			{
				new Tuple<Destination,Product,int>(fra,bands,30),
				new Tuple<Destination,Product,int>(fra,coils,39),
				new Tuple<Destination,Product,int>(fra,plate,41),

				new Tuple<Destination,Product,int>(det,bands,10),
				new Tuple<Destination,Product,int>(det,coils,14),
				new Tuple<Destination,Product,int>(det,plate,15),

				new Tuple<Destination,Product,int>(lan,bands,8),
				new Tuple<Destination,Product,int>(lan,coils,11),
				new Tuple<Destination,Product,int>(lan,plate,12),

				new Tuple<Destination,Product,int>(win,bands,10),
				new Tuple<Destination,Product,int>(win,coils,14),
				new Tuple<Destination,Product,int>(win,plate,16),

				new Tuple<Destination,Product,int>(stl,bands,11),
				new Tuple<Destination,Product,int>(stl,coils,16),
				new Tuple<Destination,Product,int>(stl,plate,17),

				new Tuple<Destination,Product,int>(fre,bands,71),
				new Tuple<Destination,Product,int>(fre,coils,82),
				new Tuple<Destination,Product,int>(fre,plate,86),

				new Tuple<Destination,Product,int>(laf,bands,6),
				new Tuple<Destination,Product,int>(laf,coils,8),
				new Tuple<Destination,Product,int>(laf,plate,8)
			};

			clev.TransCost = new List<Tuple<Destination, Product, int>>
			{
				new Tuple<Destination,Product,int>(fra,bands,22),
				new Tuple<Destination,Product,int>(fra,coils,27),
				new Tuple<Destination,Product,int>(fra,plate,29),

				new Tuple<Destination,Product,int>(det,bands,7),
				new Tuple<Destination,Product,int>(det,coils,9),
				new Tuple<Destination,Product,int>(det,plate,9),

				new Tuple<Destination,Product,int>(lan,bands,10),
				new Tuple<Destination,Product,int>(lan,coils,12),
				new Tuple<Destination,Product,int>(lan,plate,13),

				new Tuple<Destination,Product,int>(win,bands,7),
				new Tuple<Destination,Product,int>(win,coils,9),
				new Tuple<Destination,Product,int>(win,plate,9),

				new Tuple<Destination,Product,int>(stl,bands,11),
				new Tuple<Destination,Product,int>(stl,coils,26),
				new Tuple<Destination,Product,int>(stl,plate,28),

				new Tuple<Destination,Product,int>(fre,bands,71),
				new Tuple<Destination,Product,int>(fre,coils,95),
				new Tuple<Destination,Product,int>(fre,plate,99),

				new Tuple<Destination,Product,int>(laf,bands,6),
				new Tuple<Destination,Product,int>(laf,coils,17),
				new Tuple<Destination,Product,int>(laf,plate,18)
			};

			pitt.TransCost = new List<Tuple<Destination, Product, int>>
			{
				new Tuple<Destination,Product,int>(fra,bands,19),
				new Tuple<Destination,Product,int>(fra,coils,24),
				new Tuple<Destination,Product,int>(fra,plate,26),

				new Tuple<Destination,Product,int>(det,bands,11),
				new Tuple<Destination,Product,int>(det,coils,14),
				new Tuple<Destination,Product,int>(det,plate,14),

				new Tuple<Destination,Product,int>(lan,bands,12),
				new Tuple<Destination,Product,int>(lan,coils,17),
				new Tuple<Destination,Product,int>(lan,plate,17),

				new Tuple<Destination,Product,int>(win,bands,10),
				new Tuple<Destination,Product,int>(win,coils,13),
				new Tuple<Destination,Product,int>(win,plate,13),

				new Tuple<Destination,Product,int>(stl,bands,25),
				new Tuple<Destination,Product,int>(stl,coils,28),
				new Tuple<Destination,Product,int>(stl,plate,31),

				new Tuple<Destination,Product,int>(fre,bands,83),
				new Tuple<Destination,Product,int>(fre,coils,99),
				new Tuple<Destination,Product,int>(fre,plate,104),

				new Tuple<Destination,Product,int>(laf,bands,15),
				new Tuple<Destination,Product,int>(laf,coils,20),
				new Tuple<Destination,Product,int>(laf,plate,20)
			};

			steelProductionTransportSampleModel.Origins = origins;
			steelProductionTransportSampleModel.Destinations = destinations;
			steelProductionTransportSampleModel.Products = products;

			#endregion

			#region Model

			/*
			 * mathematical Model
			 */

			var mathModel = new Model();

			var Make = new VariableCollection<Origin, Product>(
				(x, y) => new StringBuilder("Orig_").Append(x.Name).Append(" produces Product_").Append(y.Name),
				0,
				double.PositiveInfinity,
				VariableType.Integer,
				steelProductionTransportSampleModel.Origins,
				steelProductionTransportSampleModel.Products
			);

			var Trans = new VariableCollection<Origin, Destination, Product>(
				(x, y, z) => new StringBuilder("Product_").Append(z.Name).Append(" from Orig_").Append(x.Name).Append(" to Dest_").Append(y.Name),
				0,
				double.PositiveInfinity,
				VariableType.Integer,
				steelProductionTransportSampleModel.Origins,
				steelProductionTransportSampleModel.Destinations,
				steelProductionTransportSampleModel.Products
				);

			mathModel.AddObjective(
				Expression.Sum(steelProductionTransportSampleModel.Origins.SelectMany(orig => steelProductionTransportSampleModel.Products.Select(prod => orig.MakeCost[prod] * Make[orig,prod])))+Expression.Sum(steelProductionTransportSampleModel.Origins.SelectMany(orig => orig.TransCost.Select( costlist => (costlist.Item3 * Trans[orig, costlist.Item1, costlist.Item2])))),
				"z");

			foreach (Origin orig in origins)
			{
				mathModel.AddConstraint(
					Expression.Sum(steelProductionTransportSampleModel.Products.Select(prod => (1.0/orig.Rate[prod] * Make[orig,prod]))) <= orig.Avail
					);
			}

			foreach (Origin orig in origins)
			{
				foreach (Product prod in products)
				{
					mathModel.AddConstraint(
						Expression.Sum(steelProductionTransportSampleModel.Destinations.Select(dest => Trans[orig,dest,prod])) == Make[orig, prod]
						);
				}
			}

			foreach (Destination dest in destinations)
			{
				foreach (Product prod in products)
				{
					mathModel.AddConstraint(
						Expression.Sum(steelProductionTransportSampleModel.Origins.Select(orig => Trans[orig,dest,prod])) == dest.Demand[prod]
						);
				}
			}

			return mathModel;

			#endregion
		}

		private static Solution SolveModel(Model mathModel)
		{
			ISolver solver = new GLPKSolver(Console.WriteLine);
			Solution solution = solver.Solve(mathModel);

			foreach (var variable in solution.VariableValues)
			{
				Console.WriteLine(variable.Key + ": " + variable.Value);
			}

			return solution;
		}
		
		/*
		 * Classes used for definition of Data
		 */

		class SteelProducionTransportSampleModel
		{
			public List<Origin> Origins;
			public List<Destination> Destinations;
			public List<Product> Products;

			public SteelProducionTransportSampleModel()
			{
				Origins = new List<Origin>();
				Destinations = new List<Destination>();
				Products = new List<Product>();
			}
		}

		class Origin //origins (steel mills)
		{
			public string Name { get; set; }
			public Dictionary<Product, int> Rate { get; set; }
			public int Avail { get; set; }
			public Dictionary<Product, int> MakeCost { get; set; }
			public List<Tuple<Destination, Product, int>> TransCost { get; set; }
		}

		class Destination //destinations (factories)
		{
			public string Name { get; set; }
			public Dictionary<Product, int> Demand { get; set; }
		}

		class Product //products
		{
			public string Name { get; set; }
		}
    }
}

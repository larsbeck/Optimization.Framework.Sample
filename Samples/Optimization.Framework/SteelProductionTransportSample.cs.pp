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
            /*
             * Data
             */
            var steelProductionTransportSampleModel = new SteelProducionTransportSampleModel();

            var bands = new Prod { Name = "bands" };
            var coils = new Prod { Name = "coils" };
            var plate = new Prod { Name = "plate" };

            var prods = new List<Prod>
            {
                bands,
                coils,
                plate
            };

            var gary = new Orig
            {
                Name = "GARY",
                Rate = new Dictionary<Prod, int>
                {
                    {bands, 200},
                    {coils, 140},
                    {plate, 160}
                },
                Avail = 20,
                MakeCost = new Dictionary<Prod, int>
                {
                    {bands, 180},
                    {coils, 170},
                    {plate, 180}
                }
            };
            var clev = new Orig
            {
                Name = "CLEV",
                Rate = new Dictionary<Prod, int>
                {
                    {bands, 190},
                    {coils, 130},
                    {plate, 160}
                },
                Avail = 15,
                MakeCost = new Dictionary<Prod, int>
                {
                    {bands, 190},
                    {coils, 170},
                    {plate, 185}
                }
            };
            var pitt = new Orig
            {
                Name = "PITT",
                Rate = new Dictionary<Prod, int>
                {
                    {bands, 230},
                    {coils, 160},
                    {plate, 170}
                },
                Avail = 20,
                MakeCost = new Dictionary<Prod, int>
                {
                    {bands, 190},
                    {coils, 180},
                    {plate, 185}
                }
            };

            var origs = new List<Orig>
            {
                gary,
                clev,
                pitt
            };

            Dest fra = new Dest
            {
                Name = "FRA",
                Demand = new Dictionary<Prod, int>
                {
                    {bands, 300},
                    {coils, 500},
                    {plate, 100}
                }
            };
            Dest det = new Dest
            {
                Name = "DET",
                Demand = new Dictionary<Prod, int>
                {
                    {bands, 300},
                    {coils, 750},
                    {plate, 100}
                }
            };
            Dest lan = new Dest
            {
                Name = "LAN",
                Demand = new Dictionary<Prod, int>
                {
                    {bands, 100},
                    {coils, 400},
                    {plate, 0}
                }
            };
            Dest win = new Dest
            {
                Name = "WIN",
                Demand = new Dictionary<Prod, int>
                {
                    {bands, 75},
                    {coils, 250},
                    {plate, 50}
                }
            };
            Dest stl = new Dest
            {
                Name = "STL",
                Demand = new Dictionary<Prod, int>
                {
                    {bands, 650},
                    {coils, 950},
                    {plate, 200}
                }
            };
            Dest fre = new Dest
            {
                Name = "FRE",
                Demand = new Dictionary<Prod, int>
                {
                    {bands, 225},
                    {coils, 850},
                    {plate, 100}
                }
            };
            Dest laf = new Dest
            {
                Name = "LAF",
                Demand = new Dictionary<Prod, int>
                {
                    {bands,250},
                    {coils,500},
                    {plate,250}
                }
            };

            var dests = new List<Dest>
            {
                fra,
                det,
                lan,
                win,
                stl,
                fre,
                laf
            };

            gary.TransCost = new List<Tuple<Dest, Prod, int>>
            {
                new Tuple<Dest,Prod,int>(fra,bands,30),
                new Tuple<Dest,Prod,int>(fra,coils,39),
                new Tuple<Dest,Prod,int>(fra,plate,41),

                new Tuple<Dest,Prod,int>(det,bands,10),
                new Tuple<Dest,Prod,int>(det,coils,14),
                new Tuple<Dest,Prod,int>(det,plate,15),

                new Tuple<Dest,Prod,int>(lan,bands,8),
                new Tuple<Dest,Prod,int>(lan,coils,11),
                new Tuple<Dest,Prod,int>(lan,plate,12),

                new Tuple<Dest,Prod,int>(win,bands,10),
                new Tuple<Dest,Prod,int>(win,coils,14),
                new Tuple<Dest,Prod,int>(win,plate,16),

                new Tuple<Dest,Prod,int>(stl,bands,11),
                new Tuple<Dest,Prod,int>(stl,coils,16),
                new Tuple<Dest,Prod,int>(stl,plate,17),

                new Tuple<Dest,Prod,int>(fre,bands,71),
                new Tuple<Dest,Prod,int>(fre,coils,82),
                new Tuple<Dest,Prod,int>(fre,plate,86),

                new Tuple<Dest,Prod,int>(laf,bands,6),
                new Tuple<Dest,Prod,int>(laf,coils,8),
                new Tuple<Dest,Prod,int>(laf,plate,8)
            };

            clev.TransCost = new List<Tuple<Dest, Prod, int>>
            {
                new Tuple<Dest,Prod,int>(fra,bands,22),
                new Tuple<Dest,Prod,int>(fra,coils,27),
                new Tuple<Dest,Prod,int>(fra,plate,29),

                new Tuple<Dest,Prod,int>(det,bands,7),
                new Tuple<Dest,Prod,int>(det,coils,9),
                new Tuple<Dest,Prod,int>(det,plate,9),

                new Tuple<Dest,Prod,int>(lan,bands,10),
                new Tuple<Dest,Prod,int>(lan,coils,12),
                new Tuple<Dest,Prod,int>(lan,plate,13),

                new Tuple<Dest,Prod,int>(win,bands,7),
                new Tuple<Dest,Prod,int>(win,coils,9),
                new Tuple<Dest,Prod,int>(win,plate,9),

                new Tuple<Dest,Prod,int>(stl,bands,11),
                new Tuple<Dest,Prod,int>(stl,coils,26),
                new Tuple<Dest,Prod,int>(stl,plate,28),

                new Tuple<Dest,Prod,int>(fre,bands,71),
                new Tuple<Dest,Prod,int>(fre,coils,95),
                new Tuple<Dest,Prod,int>(fre,plate,99),

                new Tuple<Dest,Prod,int>(laf,bands,6),
                new Tuple<Dest,Prod,int>(laf,coils,17),
                new Tuple<Dest,Prod,int>(laf,plate,18)
            };

            pitt.TransCost = new List<Tuple<Dest, Prod, int>>
            {
                new Tuple<Dest,Prod,int>(fra,bands,19),
                new Tuple<Dest,Prod,int>(fra,coils,24),
                new Tuple<Dest,Prod,int>(fra,plate,26),

                new Tuple<Dest,Prod,int>(det,bands,11),
                new Tuple<Dest,Prod,int>(det,coils,14),
                new Tuple<Dest,Prod,int>(det,plate,14),

                new Tuple<Dest,Prod,int>(lan,bands,12),
                new Tuple<Dest,Prod,int>(lan,coils,17),
                new Tuple<Dest,Prod,int>(lan,plate,17),

                new Tuple<Dest,Prod,int>(win,bands,10),
                new Tuple<Dest,Prod,int>(win,coils,13),
                new Tuple<Dest,Prod,int>(win,plate,13),

                new Tuple<Dest,Prod,int>(stl,bands,25),
                new Tuple<Dest,Prod,int>(stl,coils,28),
                new Tuple<Dest,Prod,int>(stl,plate,31),

                new Tuple<Dest,Prod,int>(fre,bands,83),
                new Tuple<Dest,Prod,int>(fre,coils,99),
                new Tuple<Dest,Prod,int>(fre,plate,104),

                new Tuple<Dest,Prod,int>(laf,bands,15),
                new Tuple<Dest,Prod,int>(laf,coils,20),
                new Tuple<Dest,Prod,int>(laf,plate,20)
            };

            steelProductionTransportSampleModel.Origins = origs;
            steelProductionTransportSampleModel.Destinations = dests;
            steelProductionTransportSampleModel.Products = prods;

            /*
             * mathematical Model
             */

            var mathModel = new Model();

            var Make = new VariableCollection<Orig, Prod>(
                (x, y) => new StringBuilder("Orig_").Append(x.Name).Append(" produces Product_").Append(y.Name),
                0,
                double.PositiveInfinity,
                VariableType.Integer,
                steelProductionTransportSampleModel.Origins,
                steelProductionTransportSampleModel.Products
            );

            var Trans = new VariableCollection<Orig, Dest, Prod>(
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

            foreach (Orig orig in origs)
            {
                mathModel.AddConstraint(
                    Expression.Sum(steelProductionTransportSampleModel.Products.Select(prod => (1.0/orig.Rate[prod] * Make[orig,prod]))) <= orig.Avail
                    );
            }

            foreach (Orig orig in origs)
            {
                foreach (Prod prod in prods)
                {
                    mathModel.AddConstraint(
                        Expression.Sum(steelProductionTransportSampleModel.Destinations.Select(dest => Trans[orig,dest,prod])) == Make[orig, prod]
                        );
                }
            }

            foreach (Dest dest in dests)
            {
                foreach (Prod prod in prods)
                {
                    mathModel.AddConstraint(
                        Expression.Sum(steelProductionTransportSampleModel.Origins.Select(orig => Trans[orig,dest,prod])) == dest.Demand[prod]
                        );
                }
            }

            return mathModel;
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
			public List<Orig> Origins;
			public List<Dest> Destinations;
			public List<Prod> Products;

			public SteelProducionTransportSampleModel()
			{
				Origins = new List<Orig>();
				Destinations = new List<Dest>();
				Products = new List<Prod>();
			}
		}

		class Orig //origins (steel mills)
		{
			public string Name { get; set; }
			public Dictionary<Prod, int> Rate { get; set; }
			public int Avail { get; set; }
			public Dictionary<Prod, int> MakeCost { get; set; }
			public List<Tuple<Dest, Prod, int>> TransCost { get; set; }
		}

		class Dest //destinations (factories)
		{
			public string Name { get; set; }
			public Dictionary<Prod, int> Demand { get; set; }
		}

		class Prod //products
		{
			public string Name { get; set; }
		}
    }
}

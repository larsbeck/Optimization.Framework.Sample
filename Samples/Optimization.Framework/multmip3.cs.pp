using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class multmip3
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        static Model BuildModel()
        {
            #region Data

            var multimip3Model = new multimip3model { Limit = 625, MinLoad = 375, MaxServe = 5 };

            var bands = new Product { Id = 0, Name = "bands" };
            var coils = new Product { Id = 1, Name = "coils" };
            var plate = new Product { Id = 2, Name = "plate" };

            var products = new List<Product>
            {
                bands,
                coils,
                plate
            };

            var gary = new Origin
            {
                Id = 0,
                Name = "GARY",
                Supply = new Dictionary<Product, int>
                {
                    {bands, 400},
                    {coils, 800},
                    {plate, 200}
                }
            };
            var clev = new Origin
            {
                Id = 1,
                Name = "CLEV",
                Supply = new Dictionary<Product, int>
                {
                    {bands, 700},
                    {coils, 1600},
                    {plate, 300}
                }
            };
            var pitt = new Origin
            {
                Id = 2,
                Name = "PITT",
                Supply = new Dictionary<Product, int>
                {
                    {bands, 800},
                    {coils, 1800},
                    {plate, 300}
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
                Id = 0,
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
                Id = 1,
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
                Id = 2,
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
                Id = 3,
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
                Id = 4,
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
                Id = 5,
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
                Id = 6,
                Name = "LAF",
                Demand = new Dictionary<Product, int>
                {
                    {bands, 250},
                    {coils, 500},
                    {plate, 250}
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

            gary.Vcost = new List<Tuple<Destination, Product, int>>
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

            clev.Vcost = new List<Tuple<Destination, Product, int>>
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

                new Tuple<Destination,Product,int>(stl,bands,21),
                new Tuple<Destination,Product,int>(stl,coils,26),
                new Tuple<Destination,Product,int>(stl,plate,28),

                new Tuple<Destination,Product,int>(fre,bands,82),
                new Tuple<Destination,Product,int>(fre,coils,95),
                new Tuple<Destination,Product,int>(fre,plate,99),

                new Tuple<Destination,Product,int>(laf,bands,13),
                new Tuple<Destination,Product,int>(laf,coils,17),
                new Tuple<Destination,Product,int>(laf,plate,18)
            };

            pitt.Vcost = new List<Tuple<Destination, Product, int>>
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

            gary.Fcost = new Dictionary<Destination, int>
            {
                {fra, 3000},
                {det, 1200},
                {lan, 1200},
                {win, 1200},
                {stl, 2500},
                {fre, 3500},
                {laf, 2500}
            };

            clev.Fcost = new Dictionary<Destination, int>
            {
                {fra, 2000},
                {det, 1000},
                {lan, 1500},
                {win, 1200},
                {stl, 2500},
                {fre, 3000},
                {laf, 2200}
            };

            pitt.Fcost = new Dictionary<Destination, int>
            {
                {fra, 2000},
                {det, 1200},
                {lan, 1500},
                {win, 1500},
                {stl, 2500},
                {fre, 3500},
                {laf, 2200}
            };

            multimip3Model.Destinations = destinations;
            multimip3Model.Origins = origins;
            multimip3Model.Products = products;

            foreach (Product prod in multimip3Model.Products)
            {
                if (multimip3Model.Origins.Sum(orig => orig.Supply[prod]) != multimip3Model.Destinations.Sum(dest => dest.Demand[prod]))
                {
                    throw new ArgumentException("Supply needs to be equal to demand!");
                }
            }

            #endregion

            #region Model

            /*
             * mathematicalModel
             */

            var mathModel = new Model();

            var Transport = new VariableCollection<Origin, Destination, Product>(
                (x, y, z) => new StringBuilder("Product_").Append(z.Id).Append(" from Orig_").Append(x.Id).Append(" to Dest_").Append(y.Id),
                0,
                double.PositiveInfinity,
                VariableType.Integer,
                multimip3Model.Origins,
                multimip3Model.Destinations,
                multimip3Model.Products
                );

            var Use = new VariableCollection<Origin, Destination>(
                (x, y) => new StringBuilder("Orig_").Append(x.Id).Append(" to Dest_").Append(y.Id),
                0,
                1,
                VariableType.Integer,
                multimip3Model.Origins,
                multimip3Model.Destinations
                );

            mathModel.AddObjective(
                Expression.Sum(multimip3Model.Origins.SelectMany(orig => orig.Vcost.Select(vcostlist => vcostlist.Item3 * Transport[orig, vcostlist.Item1, vcostlist.Item2]))) + Expression.Sum(multimip3Model.Origins.SelectMany(orig => multimip3Model.Destinations.Select(dest => orig.Fcost[dest] * Use[orig, dest]))),
                "z"
                );

            // Supply
            foreach (Origin orig in multimip3Model.Origins)
            {
                foreach (Product prod in multimip3Model.Products)
                {
                    var expression = Expression.Sum(multimip3Model.Destinations.Select(dest => Transport[orig, dest, prod]));
                    mathModel.AddConstraint(expression == orig.Supply[prod]);
                }
            }

            // Demand
            foreach (Destination dest in multimip3Model.Destinations)
            {
                foreach (Product prod in multimip3Model.Products)
                {
                    var expression = Expression.Sum(multimip3Model.Origins.Select(orig => Transport[orig, dest, prod]));
                    mathModel.AddConstraint(expression == dest.Demand[prod]);
                }
            }

            // Multi
            foreach (Origin orig in multimip3Model.Origins)
            {
                foreach (Destination dest in multimip3Model.Destinations)
                {
                    var expression = Expression.Sum(multimip3Model.Products.Select(prod => Transport[orig, dest, prod]));
                    mathModel.AddConstraint(expression <= multimip3Model.Limit * Use[orig, dest]);
                }
            }

            // Min_Shipment
            foreach (Origin orig in multimip3Model.Origins)
            {
                foreach (Destination dest in multimip3Model.Destinations)
                {
                    var expression = Expression.Sum(multimip3Model.Products.Select(prod => Transport[orig, dest, prod]));
                    mathModel.AddConstraint(expression >= multimip3Model.MinLoad * Use[orig, dest]);
                }
            }

            // Max_Serve
            foreach (var orig in multimip3Model.Origins)
            {
                mathModel.AddConstraint(Expression.Sum(multimip3Model.Destinations.Select(dest => Use[orig, dest])) <= multimip3Model.MaxServe);
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

        class multimip3model
        {
            public List<Origin> Origins;
            public List<Destination> Destinations;
            public List<Product> Products;

            public int Limit;
            public int MinLoad;
            public int MaxServe;

            public multimip3model()
            {
                Origins = new List<Origin>();
                Destinations = new List<Destination>();
                Products = new List<Product>();
            }
        }

        class Origin
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public Dictionary<Product, int> Supply { get; set; }
            public List<Tuple<Destination, Product, int>> Vcost { get; set; }
            public Dictionary<Destination, int> Fcost { get; set; }
        }

        class Destination
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public Dictionary<Product, int> Demand { get; set; }
        }

        class Product
        {
            public int Id { get; set; }
            public string Name { get; set; }
        }
    }
}

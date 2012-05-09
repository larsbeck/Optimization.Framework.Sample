using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class multmip1
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        static Model BuildModel()
        {
            var multimip1Model = new multimip1model { Limit = 625 };

            var bands = new Prod { Id = 0, Name = "bands" };
            var coils = new Prod { Id = 1, Name = "coils" };
            var plate = new Prod { Id = 2, Name = "plate" };

            var prods = new List<Prod>
            {
                bands,
                coils,
                plate
            };

            var gary = new Orig
            {
                Id = 0,
                Name = "GARY",
                Supply = new Dictionary<Prod, int>
                {
                    {bands, 400},
                    {coils, 800},
                    {plate, 200}
                }
            };
            var clev = new Orig
            {
                Id = 1,
                Name = "CLEV",
                Supply = new Dictionary<Prod, int>
                {
                    {bands, 700},
                    {coils, 1600},
                    {plate, 300}
                }
            };
            var pitt = new Orig
            {
                Id = 2,
                Name = "PITT",
                Supply = new Dictionary<Prod, int>
                {
                    {bands, 800},
                    {coils, 1800},
                    {plate, 300}
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
                Id = 0,
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
                Id = 1,
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
                Id = 2,
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
                Id = 3,
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
                Id = 4,
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
                Id = 5,
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
                Id = 6,
                Name = "LAF",
                Demand = new Dictionary<Prod, int>
                {
                    {bands, 250},
                    {coils, 500},
                    {plate, 250}
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

            gary.Vcost = new List<Tuple<Dest, Prod, int>>
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

            clev.Vcost = new List<Tuple<Dest, Prod, int>>
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

                new Tuple<Dest,Prod,int>(stl,bands,21),
                new Tuple<Dest,Prod,int>(stl,coils,26),
                new Tuple<Dest,Prod,int>(stl,plate,28),

                new Tuple<Dest,Prod,int>(fre,bands,82),
                new Tuple<Dest,Prod,int>(fre,coils,95),
                new Tuple<Dest,Prod,int>(fre,plate,99),

                new Tuple<Dest,Prod,int>(laf,bands,13),
                new Tuple<Dest,Prod,int>(laf,coils,17),
                new Tuple<Dest,Prod,int>(laf,plate,18)
            };

            pitt.Vcost = new List<Tuple<Dest, Prod, int>>
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

            gary.Fcost = new Dictionary<Dest, int>
            {
                {fra, 3000},
                {det, 1200},
                {lan, 1200},
                {win, 1200},
                {stl, 2500},
                {fre, 3500},
                {laf, 2500}
            };

            clev.Fcost = new Dictionary<Dest, int>
            {
                {fra, 2000},
                {det, 1000},
                {lan, 1500},
                {win, 1200},
                {stl, 2500},
                {fre, 3000},
                {laf, 2200}
            };

            pitt.Fcost = new Dictionary<Dest, int>
            {
                {fra, 2000},
                {det, 1200},
                {lan, 1500},
                {win, 1500},
                {stl, 2500},
                {fre, 3500},
                {laf, 2200}
            };

            foreach (Prod prod in prods)
            {
                if (origs.Sum(origin => origin.Supply[prod]) != dests.Sum(dest => dest.Demand[prod]))
                {
                    throw new ArgumentException("Supply needs to be equal to demand!");
                }
            }

            multimip1Model.Destinations = dests;
            multimip1Model.Origins = origs;
            multimip1Model.Products = prods;

            /*
             * mathematical model
             */

            var mathModel = new Model();

            var Trans = new VariableCollection<Orig, Dest, Prod>(
                (x, y, z) => new StringBuilder("Product_").Append(z.Id).Append(" from Orig_").Append(x.Id).Append(" to Dest_").Append(y.Id),
                0,
                double.PositiveInfinity,
                VariableType.Integer,
                multimip1Model.Origins,
                multimip1Model.Destinations,
                multimip1Model.Products
                );

            var Use = new VariableCollection<Orig, Dest>(
                (x, y) => new StringBuilder("Orig_").Append(x.Id).Append(" to Dest_").Append(y.Id),
                0,
                1,
                VariableType.Integer,
                multimip1Model.Origins,
                multimip1Model.Destinations
                );

            mathModel.AddObjective(
                Expression.Sum(multimip1Model.Origins.SelectMany(orig => orig.Vcost.Select(vcostlist => vcostlist.Item3 * Trans[orig, vcostlist.Item1, vcostlist.Item2]))) + Expression.Sum(multimip1Model.Origins.SelectMany(orig => multimip1Model.Destinations.Select(dest => orig.Fcost[dest] * Use[orig, dest]))),
                "z"
                );

            //Angebot
            foreach (Orig orig in multimip1Model.Origins)
            {
                foreach (Prod prod in multimip1Model.Products)
                {
                    var expression = Expression.Sum(multimip1Model.Destinations.Select(dest => Trans[orig, dest, prod]));
                    mathModel.AddConstraint(expression == orig.Supply[prod]);
                }
            }

            //Bedarf
            foreach (Dest dest in multimip1Model.Destinations)
            {
                foreach (Prod prod in multimip1Model.Products)
                {
                    var expression = Expression.Sum(multimip1Model.Origins.Select(orig => Trans[orig, dest, prod]));
                    mathModel.AddConstraint(expression == dest.Demand[prod]);
                }
            }

            //Multi
            foreach (Orig orig in multimip1Model.Origins)
            {
                foreach (Dest dest in multimip1Model.Destinations)
                {
                    var expression = Expression.Sum(multimip1Model.Products.Select(prod => Trans[orig, dest, prod]));
                    mathModel.AddConstraint(expression <= multimip1Model.Limit * Use[orig, dest]);
                }
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

        class multimip1model
        {
            public List<Orig> Origins;
            public List<Dest> Destinations;
            public List<Prod> Products;

            public int Limit;

            public multimip1model()
            {
                Origins = new List<Orig>();
                Destinations = new List<Dest>();
                Products = new List<Prod>();
            }
        }

        class Orig
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public Dictionary<Prod, int> Supply { get; set; }
            public List<Tuple<Dest, Prod, int>> Vcost { get; set; }
            public Dictionary<Dest, int> Fcost { get; set; }
        }

        class Dest
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public Dictionary<Prod, int> Demand { get; set; }
        }

        class Prod
        {
            public int Id { get; set; }
            public string Name { get; set; }
        }
    }
}

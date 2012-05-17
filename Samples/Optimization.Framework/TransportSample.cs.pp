using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    class TransportSample
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        static Model BuildModel()
        {
            var transportModel = new TransportModel();
            
            // dests
            var fra = new Dest
            {
                Id = 0,
                Name = "FRA",
                Demand = 900
            };
            var det = new Dest
            {
                Id = 1,
                Name = "DET",
                Demand = 1200
            };
            var lan = new Dest
            {
                Id = 2,
                Name = "LAN",
                Demand = 600
            };
            var win = new Dest
            {
                Id = 3,
                Name = "WIN",
                Demand = 400
            };
            var stl = new Dest
            {
                Id = 4,
                Name = "STL",
                Demand = 1700
            };
            var fre = new Dest
            {
                Id = 5,
                Name = "FRE",
                Demand = 1100
            };
            var laf = new Dest
            {
                Id = 6,
                Name = "LAF",
                Demand = 1000
            };

            var dests = new List<Dest> { fra, det, lan, win, stl, fre, laf };
            
            //origs
            var gary = new Orig
            {
                Id = 0,
                Name = "GARY",
                Supply = 1400,
                Cost = new Dictionary<Dest, int>{
                    {fra, 39},
                    {det, 14},
                    {lan, 11},
                    {win, 14},
                    {stl, 16},
                    {fre, 82},
                    {laf, 8}
                }
            };
            var clev = new Orig
            {
                Id = 1,
                Name = "CLEV",
                Supply = 2600,
                Cost = new Dictionary<Dest, int>
                {
                    {fra, 27},
                    {det, 9},
                    {lan, 12},
                    {win, 9},
                    {stl, 26},
                    {fre, 95},
                    {laf, 17}
                }
            };
            var pitt = new Orig
            {
                Id = 2,
                Name = "PITT",
                Supply = 2900,
                Cost = new Dictionary<Dest, int>
                {
                    {fra, 24},
                    {det, 14},
                    {lan, 17},
                    {win, 13},
                    {stl, 28},
                    {fre, 99},
                    {laf, 20}
                }
            };

            var origs = new List<Orig> { gary, clev, pitt };

            transportModel.Destinations = dests;
            transportModel.Origins = origs;

            /*
             * mathematical Model
             */
            
            var mathModel = new Model();

            var Trans = new VariableCollection<Orig, Dest>(
                (x, y) => new StringBuilder("Orig_").Append(x.Name).Append(" to Dest_").Append(y.Name),
                0,
                Double.PositiveInfinity,
                VariableType.Integer,
                transportModel.Origins,
                transportModel.Destinations
                );

            mathModel.AddObjective(
                Expression.Sum(transportModel.Origins.SelectMany(orig => transportModel.Destinations.Select(dest => orig.Cost[dest] * Trans[orig, dest])))
                );

            foreach (Orig orig in transportModel.Origins)
            {
                mathModel.AddConstraint(
                    Expression.Sum(transportModel.Destinations.Select(dest => Trans[orig, dest])) == orig.Supply
                    );
            }

            foreach (Dest dest in transportModel.Destinations)
            {
                mathModel.AddConstraint(
                    Expression.Sum(transportModel.Origins.Select(orig => Trans[orig, dest])) == dest.Demand
                    );
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

        class TransportModel
        {
            public List<Orig> Origins;
            public List<Dest> Destinations;

            public TransportModel()
            {
                Origins = new List<Orig>();
                Destinations = new List<Dest>();
            }
        }

        class Orig
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int Supply { get; set; }
            public Dictionary<Dest, int> Cost { get; set; }
        }

        class Dest
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int Demand { get; set; }
        }
    }
}

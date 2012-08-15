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
            #region Data

            var transportModel = new TransportModel();
            
            // dests
            var fra = new Destination
            {
                Id = 0,
                Name = "FRA",
                Demand = 900
            };
            var det = new Destination
            {
                Id = 1,
                Name = "DET",
                Demand = 1200
            };
            var lan = new Destination
            {
                Id = 2,
                Name = "LAN",
                Demand = 600
            };
            var win = new Destination
            {
                Id = 3,
                Name = "WIN",
                Demand = 400
            };
            var stl = new Destination
            {
                Id = 4,
                Name = "STL",
                Demand = 1700
            };
            var fre = new Destination
            {
                Id = 5,
                Name = "FRE",
                Demand = 1100
            };
            var laf = new Destination
            {
                Id = 6,
                Name = "LAF",
                Demand = 1000
            };

            var destinations = new List<Destination> { fra, det, lan, win, stl, fre, laf };
            
            //origs
            var gary = new Origin
            {
                Id = 0,
                Name = "GARY",
                Supply = 1400,
                Cost = new Dictionary<Destination, int>{
                    {fra, 39},
                    {det, 14},
                    {lan, 11},
                    {win, 14},
                    {stl, 16},
                    {fre, 82},
                    {laf, 8}
                }
            };
            var clev = new Origin
            {
                Id = 1,
                Name = "CLEV",
                Supply = 2600,
                Cost = new Dictionary<Destination, int>
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
            var pitt = new Origin
            {
                Id = 2,
                Name = "PITT",
                Supply = 2900,
                Cost = new Dictionary<Destination, int>
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

            var origins = new List<Origin> { gary, clev, pitt };

            transportModel.Destinations = destinations;
            transportModel.Origins = origins;

            #endregion

            #region Model

            /*
             * mathematical Model
             */
            
            var mathModel = new Model();

            var Transport = new VariableCollection<Origin, Destination>(
                (x, y) => new StringBuilder("Orig_").Append(x.Name).Append(" to Dest_").Append(y.Name),
                0,
                Double.PositiveInfinity,
                VariableType.Integer,
                transportModel.Origins,
                transportModel.Destinations
                );

            mathModel.AddObjective(
                Expression.Sum(transportModel.Origins.SelectMany(orig => transportModel.Destinations.Select(dest => orig.Cost[dest] * Transport[orig, dest])))
                );

            foreach (Origin orig in transportModel.Origins)
            {
                mathModel.AddConstraint(
                    Expression.Sum(transportModel.Destinations.Select(dest => Transport[orig, dest])) == orig.Supply
                    );
            }

            foreach (Destination dest in transportModel.Destinations)
            {
                mathModel.AddConstraint(
                    Expression.Sum(transportModel.Origins.Select(orig => Transport[orig, dest])) == dest.Demand
                    );
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

        class TransportModel
        {
            public List<Origin> Origins;
            public List<Destination> Destinations;

            public TransportModel()
            {
                Origins = new List<Origin>();
                Destinations = new List<Destination>();
            }
        }

        class Origin
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int Supply { get; set; }
            public Dictionary<Destination, int> Cost { get; set; }
        }

        class Destination
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int Demand { get; set; }
        }
    }
}

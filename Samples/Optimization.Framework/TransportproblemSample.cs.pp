using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    public class TransportproblemSample
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        private static Model BuildModel()
        {
            //Define the data: the markets and the canning plants
            TransportModel transportModel = new TransportModel() { Freight = 90 };

            Market newYork = new Market { Name = "New York", Demand = 325 };
            Market chicago = new Market { Name = "Chicago", Demand = 300 };
            Market topeka = new Market { Name = "Topeka", Demand = 275 };

            CanningPlant seattle = new CanningPlant { Name = "Seattle", Capacity = 350 };
            CanningPlant sanDiego = new CanningPlant { Name = "San-Diego", Capacity = 600 };

            //Define the distances between the plants and the markets
            seattle.Distances.Add(newYork, 2.5);
            seattle.Distances.Add(chicago, 1.7);
            seattle.Distances.Add(topeka, 1.8);

            sanDiego.Distances.Add(newYork, 2.5);
            sanDiego.Distances.Add(chicago, 1.8);
            sanDiego.Distances.Add(topeka, 1.4);

            var canningPlants = new List<CanningPlant> { seattle, sanDiego };
            var markets = new List<Market> { newYork, chicago, topeka };
        
            //Compute for each plant market pair the corresponding transport costs
            foreach (var canningPlant in canningPlants)
            {
                foreach (var distance in canningPlant.Distances)
                {
                    canningPlant.TransportCosts.Add(distance.Key, distance.Value*transportModel.Freight);
                }
            }

            //Encapsulate the markets and plants for easier handling
            transportModel.Markets = markets;
            transportModel.CanningPlants = canningPlants;


            //Build the mathematical model
            Model mathModel = new Model();

            VariableCollection<CanningPlant, Market> x = new VariableCollection<CanningPlant, Market>(
                (canningPlant, market) => new StringBuilder("x_").Append(canningPlant.Name).Append("_").Append(market.Name), 0,
                double.PositiveInfinity, VariableType.Integer, transportModel.CanningPlants, transportModel.Markets);
            
            //Add the objective
            mathModel.AddObjective(
                Expression.Sum(transportModel.CanningPlants.SelectMany(canningPlant =>
                    transportModel.Markets.Select(market => canningPlant.TransportCosts[market] * x[canningPlant, market]))), "z");

            //Add the constraints
            foreach (var canningPlant in transportModel.CanningPlants)
            {
                mathModel.AddConstraint(
                    Expression.Sum(transportModel.Markets.Select(market => x[canningPlant, market])) <=
                    canningPlant.Capacity, new StringBuilder("Capacity_").Append(canningPlant.Name).ToString());
            }
            foreach (var market in transportModel.Markets)
            {
                mathModel.AddConstraint(
                    Expression.Sum(transportModel.CanningPlants.Select(canningPlant => x[canningPlant, market])) >=
                    market.Demand, new StringBuilder("Demand_").Append(market.Name).ToString());
            }

            return mathModel;
        }

        private static Solution SolveModel(Model mathModel)
        {
        	//Choose a solver and solve the model, the solution contains the results
            ISolver solver = new GLPKSolver(s => Console.WriteLine(s));
            Solution solution = solver.Solve(mathModel);

            return solution;
        }
        
        /*
		 * Classes used for definition of Data
		 */
		 
		class TransportModel
    	{
        	public double Freight { get; set; }
        	public List<CanningPlant> CanningPlants { get; set; }
        	public List<Market> Markets { get; set; }
    	} 
		 
    	class Market
    	{
        	public string Name { get; set; }
        	public double Demand { get; set; }
    	}

    	class CanningPlant
    	{
        	public Dictionary<Market, double> Distances { get; set; }
        	public Dictionary<Market, double> TransportCosts { get; set; }

        	public CanningPlant()
        	{
        	    Distances = new Dictionary<Market, double>();
        	    TransportCosts = new Dictionary<Market, double>();
        	}

        	public string Name { get; set; }
        	public double Capacity { get; set; }

    	}
    }
}

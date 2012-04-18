using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Optimization;
using Optimization.Interfaces;
using Optimization.Solver.GLPK;

namespace $rootnamespace$.Samples.Optimization.Framework
{
    public class WarehouseproblemSample
    {
        public static void Run()
        {
            Model model = BuildModel();
            Solution solution = SolveModel(model);
        }

        private static Model BuildModel()
        {
            #region Data

            /*
             * Model with scalars
             * storecost   storage cost ($ per quarter per unit)
             * storecap    stocking capacity of warehouse (units)
             */
            var warehouseModel = new WarehouseModel { StoreCap = 100, StoreCost = 1 };

            /*
             * Data for
             * Set t   time in quarters
             */
            var q1 = new Quarter { Name = "Quarter1" };
            var q2 = new Quarter { Name = "Quarter2" };
            var q3 = new Quarter { Name = "Quarter3" };
            var q4 = new Quarter { Name = "Quarter4" };
            q2.Predecessor = q1;
            q3.Predecessor = q2;
            q4.Predecessor = q3;

            /*
             * Parameter price(t)  selling price ($ per unit)
             */
            q1.SellingPrice = 10;
            q2.SellingPrice = 12;
            q3.SellingPrice = 8;
            q4.SellingPrice = 9;

            /*
             * Parameter istock(t)  initial stock (units)
             */
            q1.InitialStock = 50;

            /*
             * Set t   time in quarters
             */
            var quarters = new List<Quarter> { q1, q2, q3, q4 };
            warehouseModel.Quarters = quarters;

            #endregion

            #region MathModel

            var mathModel = new Model();
            mathModel.Name = "WarehouseProblem";

            /*
             * Variable
             * stock(t)    stock stored at time t     (units)
             */
            var stock = new VariableCollection<Quarter>(quarter => new StringBuilder("stock_").Append(quarter.Name), 0,
                                                    warehouseModel.StoreCap, VariableType.Integer,
                                                    warehouseModel.Quarters);

            /*
             * Variable
             * sell(t)     stock sold at time t       (units)
             */
            var sell = new VariableCollection<Quarter>(quarter => new StringBuilder("sell_").Append(quarter.Name), 0,
                                                    Double.PositiveInfinity, VariableType.Integer,
                                                    warehouseModel.Quarters);

            /*
             * Variable
             * buy(t)      stock bought at time t     (units)
             */
            var buy = new VariableCollection<Quarter>(quarter => new StringBuilder("buy_").Append(quarter.Name), 0,
                                                    Double.PositiveInfinity, VariableType.Integer,
                                                    warehouseModel.Quarters);


            /*
             * Objective Function
             * cost =e= sum(t, price(t)*(buy(t)-sell(t)) + storecost*stock(t));
             */
            mathModel.AddObjective(Expression.Sum(warehouseModel.Quarters.Select(quarter => quarter.SellingPrice * (buy[quarter] - sell[quarter]) + warehouseModel.StoreCost * stock[quarter])), "cost");

            /*
             * Constraint for stock balance
             * stock(t) =e= stock(t-1) + buy(t) - sell(t) + istock(t);
             */
            foreach (var quarter in warehouseModel.Quarters)
            {
                if (quarter.Predecessor == null)
                {
                    mathModel.AddConstraint(stock[quarter] == buy[quarter] - sell[quarter] + quarter.InitialStock, new StringBuilder("StockBalance_").Append(quarter.Name).ToString());
                }
                else
                {
                    mathModel.AddConstraint(stock[quarter] == stock[quarter.Predecessor] + buy[quarter] - sell[quarter] + quarter.InitialStock, new StringBuilder("StockBalance_").Append(quarter.Name).ToString());
                }

            }

            return mathModel;

            #endregion
        }

        private static Solution SolveModel(Model mathModel)
        {
            ISolver solver = new GLPKSolver(s => Console.WriteLine(s));
            Solution solution = solver.Solve(mathModel);

            return solution;
        }

        /*
         * Classes used for the definition of the data
         */

        class Quarter
        {
            public string Name { get; set; }

            public double SellingPrice { get; set; }

            public int InitialStock { get; set; }

            public Quarter Predecessor { get; set; }

            public Quarter()
            {
                Name = "";
                SellingPrice = 0;
                InitialStock = 0;
                Predecessor = null;
            }
        }

        class WarehouseModel
        {
            public List<Quarter> Quarters { get; set; }

            public double StoreCost { get; set; }

            public int StoreCap { get; set; }
        }
    }
}

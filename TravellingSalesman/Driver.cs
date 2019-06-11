using System;
using System.Collections.Generic;
using System.Linq;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.TravellingSalesman
{
    class Driver
    {
        private const int NumberOfBits = 2;
        private const int TestCount = 1000;

        static void Main(string[] args)
        {
            for (int i = 0; i < TestCount; i++)
            {
                using (var qsim = new QuantumSimulator())
                {
                    var bits = HelloQ.Run(qsim).Result.Cast<int>().ToArray();
                    var result = ToBase10Nodes(bits.Take(8).ToArray());

                    AddResult(string.Join("", result));// + "_" +
                              //string.Join("", bits.Skip(8).ToArray()));
                    //Console.WriteLine(string.Join("", result));
                }
            }

            PrintResults();

            Console.WriteLine("Finished.");
            Console.ReadLine();
        }

        static int[] ToBase10Nodes(int[] bits)
        {
            if (bits.Length != 8)
                throw new Exception("Node array should have 8 bits");

            int[] nodes = new int[bits.Length/NumberOfBits];

            int skip = 0;
            int take = NumberOfBits;
            while (skip * NumberOfBits < bits.Length)
            {
                var nodeTag = bits.Skip(skip*NumberOfBits).Take(NumberOfBits).ToArray();
                var node = ConvertToBase10(nodeTag);
                nodes[skip] = node;

                skip++;
            }

            return nodes;
        }

        static int ConvertToBase10(int[] bits)
        {
            var result = 0;
            for (int i = 0; i < bits.Length; i++)
            {
                result += (int)Math.Pow(2, (bits.Length - 1 - i)) * bits[i];
            }
            return result;
        }

        static int[] ConvertToBase2(int number)
        {
            var result = new int[3];
            int index = 2;
            while (number > 0)
            {
                result[index] = number % 2;
                number = number / 2;
                index--;
            }

            return result;
        }

        private static void PrintResults()
        {
            foreach (var result in Results)
            {
                Console.WriteLine($"{result.Key}: {result.Value}");
            }
            Console.WriteLine($"Number of results: {Results.Count}");
        }

        private static void AddResult(string result)
        {
            if (!Results.ContainsKey(result))
            {
                Results[result] = 1;
            }
            else
            {
                Results[result]++;
            }
        }

        private static readonly Dictionary<string, double> Results = new Dictionary<string, double>();
    }
}
namespace Quantum.TravellingSalesman
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    operation HelloQ () : Result[] {
		mutable result = new Result[15];
        using (qubits = Qubit[15])
        {			
			//X(qubits[0]);
			//X(qubits[1]);

			WalkGraph(qubits);

			//GroverOracle([qubits[0], qubits[1], qubits[2], qubits[3], qubits[4], qubits[5], qubits[6], qubits[7]],
			//             [qubits[8], qubits[9], qubits[10], qubits[11]], qubits[14]);

			X(qubits[14]);
		    H(qubits[14]);
			//
			//GroverIteration(qubits);
			//GroverIteration(qubits);
			//GroverIteration(qubits);
			//GroverIteration(qubits);
			//GroverIteration(qubits);
			//GroverIteration(qubits);
			//GroverIteration(qubits);
			//GroverIteration(qubits);

			AmplitudeAmplification(qubits);
			//X(qubits[14]);
		    //H(qubits[14]);
			AmplitudeAmplification(qubits);
			//X(qubits[14]);
		    //H(qubits[14]);
			//AmplitudeAmplification(qubits);
			//X(qubits[14]);
		    //H(qubits[14]);
			//AmplitudeAmplification(qubits);

			for (i in 0..14)
			{
				set result w/= i <- M(qubits[i]);
			}

			ResetAll(qubits);
		}
		return result;
    }

	operation WalkGraph(qubits: Qubit[]) : Unit {
		body (...) {
			//Step([qubits[0], qubits[1]], [qubits[2], qubits[3]]);
			//Step([qubits[2], qubits[3]], [qubits[4], qubits[5]]);
			//Step([qubits[4], qubits[5]], [qubits[6], qubits[7]]);

			AllConnectionsStep([qubits[0], qubits[1]], [qubits[2], qubits[3]]);
			AllConnectionsStep([qubits[2], qubits[3]], [qubits[4], qubits[5]]);
			AllConnectionsStep([qubits[4], qubits[5]], [qubits[6], qubits[7]]);
		}

		adjoint auto;
	}

	operation Step(originalState: Qubit[], nextState: Qubit[]) : Unit {
		body(...) {
			X(originalState[0]);
			X(originalState[1]);
			Controlled GoTo0And1And3([originalState[0], originalState[1]], (nextState[0], nextState[1]));
			X(originalState[0]);
			X(originalState[1]);

			X(originalState[0]);
			//Controlled X([originalState[0], originalState[1]], nextState[1]);
			Controlled GoTo1And2([originalState[0], originalState[1]], (nextState[0], nextState[1]));
			X(originalState[0]);

			X(originalState[1]);
			//Controlled X([originalState[0], originalState[1]], nextState[0]);
			Controlled GoTo2And3([originalState[0], originalState[1]], (nextState[0], nextState[1]));
			X(originalState[1]);

			//Controlled X([originalState[0], originalState[1]], nextState[0]);
			//Controlled X([originalState[0], originalState[1]], nextState[1]);
			Controlled GoTo0And1And3([originalState[0], originalState[1]], (nextState[0], nextState[1]));
		}

		adjoint auto;
	}

	operation AllConnectionsStep(originalState: Qubit[], nextState: Qubit[]) : Unit {
		body (...) {
			H(nextState[0]);
			H(nextState[1]);
		}

		adjoint auto;
	}

	operation GoTo1And2(msb: Qubit, lsb: Qubit): Unit {
		body(...) {
			X(lsb);
			H(msb);
			CNOT(msb, lsb);
		}
		adjoint auto;
		controlled auto;
		adjoint controlled auto;
	}

	operation GoTo0And1And3(msb: Qubit, lsb: Qubit): Unit {
		body(...) {
			H(lsb);
			Controlled H([lsb],msb);
		}
		adjoint auto;
		controlled auto;
		adjoint controlled auto;
	}

	operation GoTo2And3(msb: Qubit, lsb: Qubit): Unit {
		body(...) {
			X(msb);
			H(lsb);
		}
		adjoint auto;
		controlled auto;
		adjoint controlled auto;
	}

	operation GroverIteration(qubits: Qubit[]) : Unit {

		StateOracle([qubits[0], qubits[1], qubits[2], qubits[3], qubits[4], qubits[5], qubits[6], qubits[7]],
			         [qubits[8], qubits[9], qubits[10], qubits[11]],
					 qubits[14]);

		//H(qubits[0]);
		//H(qubits[1]);
		H(qubits[2]);
		H(qubits[3]);
		H(qubits[4]);
		H(qubits[5]);
		H(qubits[6]);
		H(qubits[7]);

		PhaseShift([qubits[0], qubits[1], qubits[2], qubits[3], qubits[4], qubits[5], qubits[6], qubits[7]]);

		//H(qubits[0]);
		//H(qubits[1]);
		H(qubits[2]);
		H(qubits[3]);
		H(qubits[4]);
		H(qubits[5]);
		H(qubits[6]);
		H(qubits[7]);
	}

	operation StateOracle(qubits: Qubit[], ancilas: Qubit[], target: Qubit): Unit {
		PartialStateOracle([qubits[0], qubits[1]], ancilas);
		PartialStateOracle([qubits[2], qubits[3]], ancilas);
		PartialStateOracle([qubits[4], qubits[5]], ancilas);
		PartialStateOracle([qubits[6], qubits[7]], ancilas);

		Controlled X([ancilas[0], ancilas[1], ancilas[2], ancilas[3]], target);

		PartialStateOracle([qubits[0], qubits[1]], ancilas);
		PartialStateOracle([qubits[2], qubits[3]], ancilas);
		PartialStateOracle([qubits[4], qubits[5]], ancilas);
		PartialStateOracle([qubits[6], qubits[7]], ancilas);
	}

	operation PartialStateOracle(qubits: Qubit[], ancilas: Qubit[]): Unit {
		X(qubits[0]);
		X(qubits[1]);
		Controlled X([qubits[0], qubits[1]], ancilas[0]);
		X(qubits[0]);
		X(qubits[1]);

		X(qubits[0]);
		Controlled X([qubits[0], qubits[1]], ancilas[1]);
		X(qubits[0]);

		X(qubits[1]);
		Controlled X([qubits[0], qubits[1]], ancilas[2]);
		X(qubits[1]);

		Controlled X([qubits[0], qubits[1]], ancilas[3]);

		//Controlled X([qubits[8], qubits[9], qubits[10], qubits[11]], qubits[14]);
	}

	operation PhaseShift(qubits: Qubit[]) : Unit {
		X(qubits[0]);
		X(qubits[1]);
		X(qubits[2]);
		X(qubits[3]);
		X(qubits[4]);
		X(qubits[5]);
		X(qubits[6]);
		X(qubits[7]);

		Controlled Z([qubits[2], qubits[3], qubits[4], qubits[5], qubits[6]], qubits[7]);

		X(qubits[0]);
		X(qubits[1]);
		X(qubits[2]);
		X(qubits[3]);
		X(qubits[4]);
		X(qubits[5]);
		X(qubits[6]);
		X(qubits[7]);
	}

	operation AmplitudeAmplification(qubits: Qubit[]) : Unit {
		StateOracle([qubits[0], qubits[1], qubits[2], qubits[3], qubits[4], qubits[5], qubits[6], qubits[7]],
			         [qubits[8], qubits[9], qubits[10], qubits[11]],
					 qubits[14]);
		
		(Adjoint WalkGraph)(qubits);

		PhaseShift([qubits[0], qubits[1], qubits[2], qubits[3], qubits[4], qubits[5], qubits[6], qubits[7]]);

		WalkGraph(qubits);
	}
}

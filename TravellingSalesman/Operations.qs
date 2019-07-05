namespace Quantum.TravellingSalesman
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    operation HelloQ () : Result[] {
		mutable result = new Result[16];
        using (qubits = Qubit[16])
        {			
			//X(qubits[0]);
			//X(qubits[1]);

			WalkGraph(qubits);

			//GroverOracle([qubits[0], qubits[1], qubits[2], qubits[3], qubits[4], qubits[5], qubits[6], qubits[7]],
			//             [qubits[8], qubits[9], qubits[10], qubits[11]], qubits[14]);

			//X(qubits[14]);
		    //H(qubits[14]);
			//
			//GroverIteration(qubits);
			//
			//AmplitudeAmplification(qubits);

			for (i in 0..15)
			{
				set result w/= i <- M(qubits[i]);
			}

			ResetAll(qubits);
		}
		return result;
    }

	operation WalkGraph(qubits: Qubit[]) : Unit {
		body (...) {
			let counters = [qubits[8], qubits[9], qubits[10], qubits[11], qubits[12], qubits[13], qubits[14], qubits[15]];

			//Step(counters, [qubits[0], qubits[1]], [qubits[2], qubits[3]]);
			//Increment([qubits[0], qubits[1]], counters);

			//Step(counters, [qubits[2], qubits[3]], [qubits[4], qubits[5]]);
			//Increment([qubits[2], qubits[3]], counters);

			//Step(counters, [qubits[4], qubits[5]], [qubits[6], qubits[7]]);
			//Increment([qubits[4], qubits[5]], counters);

			AllConnectionsStep(counters, [qubits[0], qubits[1]], [qubits[2], qubits[3]]);
			Increment([qubits[0], qubits[1]], counters);
			AllConnectionsStep(counters, [qubits[2], qubits[3]], [qubits[4], qubits[5]]);
			Increment([qubits[2], qubits[3]], counters);
			AllConnectionsStep(counters, [qubits[4], qubits[5]], [qubits[6], qubits[7]]);
			Increment([qubits[4], qubits[5]], counters);
		}

		adjoint auto;
	}

	operation Step(counters: Qubit[], originalState: Qubit[], nextState: Qubit[]) : Unit {
		body(...) {
			X(counters[0]);
			X(counters[1]);
			X(originalState[0]);
			X(originalState[1]);
			Controlled GoTo0And1And3([counters[0], counters[1], originalState[0], originalState[1]], (nextState[0], nextState[1]));
			X(counters[0]);
			X(counters[1]);
			X(originalState[0]);
			X(originalState[1]);

			X(counters[2]);
			X(counters[3]);
			X(originalState[0]);
			//Controlled X([originalState[0], originalState[1]], nextState[1]);
			Controlled GoTo1And2([counters[2], counters[3], originalState[0], originalState[1]], (nextState[0], nextState[1]));
			X(counters[2]);
			X(counters[3]);
			X(originalState[0]);

			X(counters[4]);
			X(counters[5]);
			X(originalState[1]);
			//Controlled X([originalState[0], originalState[1]], nextState[0]);
			Controlled GoTo2And3([counters[4], counters[5], originalState[0], originalState[1]], (nextState[0], nextState[1]));
			X(counters[4]);
			X(counters[5]);
			X(originalState[1]);

			X(counters[6]);
			X(counters[7]);
			//Controlled X([originalState[0], originalState[1]], nextState[0]);
			//Controlled X([originalState[0], originalState[1]], nextState[1]);
			Controlled GoTo0And1And3([counters[6], counters[7], originalState[0], originalState[1]], (nextState[0], nextState[1]));
			X(counters[6]);
			X(counters[7]);
		}

		adjoint auto;
	}

	operation Increment(stepQubits: Qubit[], counters: Qubit[]) : Unit {
		body (...) {
			X(stepQubits[0]);
			X(stepQubits[1]);
			Controlled X([stepQubits[0], stepQubits[1], counters[1]], counters[0]);
			Controlled X([stepQubits[0], stepQubits[1]], counters[1]);
			X(stepQubits[0]);
			X(stepQubits[1]);

			X(stepQubits[0]);
			Controlled X([stepQubits[0], stepQubits[1], counters[3]], counters[2]);
			Controlled X([stepQubits[0], stepQubits[1]], counters[3]);
			X(stepQubits[0]);

			X(stepQubits[1]);
			Controlled X([stepQubits[0], stepQubits[1], counters[5]], counters[4]);
			Controlled X([stepQubits[0], stepQubits[1]], counters[5]);
			X(stepQubits[1]);

			Controlled X([stepQubits[0], stepQubits[1], counters[7]], counters[6]);
			Controlled X([stepQubits[0], stepQubits[1]], counters[7]);
		}

		adjoint auto;
	}

	operation AllConnectionsStep(counters: Qubit[], originalState: Qubit[], nextState: Qubit[]) : Unit {
		body (...) {
			//H(nextState[0]);
			//H(nextState[1]);

			X(counters[0]);
			X(counters[1]);
			X(originalState[0]);
			X(originalState[1]);
			Controlled H([counters[0], counters[1], originalState[0], originalState[1]], nextState[0]);
			Controlled H([counters[0], counters[1], originalState[0], originalState[1]], nextState[1]);
			X(counters[0]);
			X(counters[1]);
			X(originalState[0]);
			X(originalState[1]);

			X(counters[2]);
			X(counters[3]);
			X(originalState[0]);
			Controlled H([counters[2], counters[3], originalState[0], originalState[1]], nextState[0]);
			Controlled H([counters[2], counters[3], originalState[0], originalState[1]], nextState[1]);
			X(counters[2]);
			X(counters[3]);
			X(originalState[0]);

			X(counters[4]);
			X(counters[5]);
			X(originalState[1]);
			Controlled H([counters[4], counters[5], originalState[0], originalState[1]], nextState[0]);
			Controlled H([counters[4], counters[5], originalState[0], originalState[1]], nextState[1]);
			X(counters[4]);
			X(counters[5]);
			X(originalState[1]);

			X(counters[6]);
			X(counters[7]);
			Controlled H([counters[6], counters[7], originalState[0], originalState[1]], nextState[0]);
			Controlled H([counters[6], counters[7], originalState[0], originalState[1]], nextState[1]);
			X(counters[6]);
			X(counters[7]);
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

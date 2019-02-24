namespace Quantum.SuperdenseCoding
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
    operation SuperDenseCoding (toSend1: Bool, toSend2: Bool) : (Bool, Bool) {
        mutable received1 = false;
		mutable received2 = false;

		using(qubits = Qubit[2]) {
			H(qubits[0]);
			CNOT(qubits[0], qubits[1]);
			
			Encode(qubits[0], toSend1, toSend2);

			let (result1, result2) = MeasureInBellStateBasis(qubits[0], qubits[1]);
			
			set received1 = result1 == One;
			set received2 = result2 == One;

			ResetAll(qubits);
		}

		return (received1, received2);
    }

	operation Encode(toEncode: Qubit, bit1: Bool, bit2: Bool) : Unit {
		if (bit1 && bit2) {
			Y(toEncode);
		} else {
			if (bit1) {
				X(toEncode);
			} else {
				if (bit2) {
					Z(toEncode);
				}
			}
		}
	}

	operation MeasureInBellStateBasis(alice: Qubit, bob: Qubit) : (Result, Result) {
		CNOT(bob, alice);
		H(bob);
		return (M(alice), M(bob));
	}
}

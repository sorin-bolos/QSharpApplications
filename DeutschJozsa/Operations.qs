namespace Quantum.DeutschJozsa
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
	operation IsAlwaysZeroInvariant() : Bool {
		return DeutschJozsa(AlwaysZero);
	}

	operation IsAlwaysOneInvariant() : Bool {
		return DeutschJozsa(AlwaysOne);
	}

	operation IsOneIfOddInvariant() : Bool {
		return DeutschJozsa(OneIfOdd);
	}

    operation DeutschJozsa(someOperation : ((Qubit[], Qubit) => Unit)) : Bool {
        mutable isOperationConstant = false;

		using(qubits = Qubit[5]) {
			let x = qubits[0..3];
			let y = qubits[4];

			X(y);
			ApplyToEachA(H, qubits);

			someOperation(x, y);

			ApplyToEach(H, x);
			
			if (IsResultZero(MeasureAllZ(x))) {
                    set isOperationConstant = true;
            }

			ResetAll(qubits);
		}

		return isOperationConstant;
    }

	operation AlwaysZero(x: Qubit[], fx: Qubit) : Unit {
	}

	operation AlwaysOne(x: Qubit[], fx: Qubit) : Unit {
		X(fx);
	}

	operation OneIfOdd(x: Qubit[], fx: Qubit) : Unit {
		CNOT(x[Length(x) - 1], fx);
	}
}

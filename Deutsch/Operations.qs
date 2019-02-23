namespace Quantum.Deutsch
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation IsIdentityInvariant() : Bool {
		return Deutch(Identity);
	}

	operation IsNegationInvariant() : Bool {
		return Deutch(Negation);
	}

	operation IsSetToZeroInvariant() : Bool {
		return Deutch(SetToZero);
	}

	operation IsSetToOneInvariant() : Bool {
		return Deutch(SetToOne);
	}
    
    operation Deutch(someOperation: ((Qubit, Qubit) => Unit)) : Bool
	{
		mutable isOperationInvariant = false;
		using(qubits = Qubit[2])
		{
			let x = qubits[0];
			let y = qubits[1];

			X(y);
			H(x);
			H(y);

			someOperation(x, y);

			H(x);

			if (M(x) == Zero)
			{
				set isOperationInvariant = true;
			}

			ResetAll(qubits);
		}
		return isOperationInvariant;
    }

	operation Identity(x: Qubit, fx: Qubit) : Unit
	{
		CNOT(x, fx);
	}

	operation Negation(x: Qubit, fx: Qubit) : Unit
	{
		CNOT(x, fx);
		X(fx);
	}

	operation SetToZero(x: Qubit, fx: Qubit) : Unit
	{
	}

	operation SetToOne(x: Qubit, fx: Qubit) : Unit
	{
		X(fx);
	}
}

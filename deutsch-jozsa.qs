// Copyright (c) Sarah Kaiser. All rights reserved.
// Licensed under the MIT License.

namespace Build.DeutschJozsa {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;

    operation ZeroOracle(control : Qubit, target : Qubit) : Unit {
    }

    operation OneOracle(control : Qubit, target : Qubit) : Unit {
        X(target);
    }

    operation IdOracle(control : Qubit, target : Qubit) : Unit {
        CNOT(control, target);
    }

    operation NotOracle(control : Qubit, target : Qubit) : Unit {
        X(control);
        CNOT(control, target);
        X(control);
    }

    operation IsOracleBalanced(
            oracle : ((Qubit, Qubit) => Unit)              
    ) : Bool {
        mutable result = Zero;
        using ((control, target) = (Qubit(), Qubit())) {   
            H(control);                                    
            X(target);
            H(target);

            oracle(control, target);                       

            H(target);                                     
            X(target);

            set result = MResetX(control);                 
        }
        return result == One;
    }
 
    operation RunDeutschJozsaAlgorithm(verbose : Bool) : Unit {
        if(verbose){Message($"The ZeroOracle is Balanced: {IsOracleBalanced(ZeroOracle)}");}
        EqualityFactB(IsOracleBalanced(ZeroOracle), false, "Test failed for zero oracle."); 
        if(verbose){Message($"The OneOracle is Balanced: {IsOracleBalanced(OneOracle)}");}
        EqualityFactB(IsOracleBalanced(OneOracle), false, "Test failed for one oracle.");   
        if(verbose){Message($"The IdOracle is Balanced: {IsOracleBalanced(IdOracle)}");}
        EqualityFactB(IsOracleBalanced(IdOracle), true, "Test failed for id oracle.");
        if(verbose){Message($"The NotOracle is Balanced: {IsOracleBalanced(NotOracle)}");}
        EqualityFactB(IsOracleBalanced(NotOracle), true, "Test failed for not oracle.");

        Message("All tests passed!");                                                         
    }
}
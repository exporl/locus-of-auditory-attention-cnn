function [BP_equirip] = constructBpFilter(params)
Fs = params.targetSampleRate; 
Fst1 = params.highpass-0.45;
Fp1 = params.highpass+0.45;
Fp2 = params.lowpass-0.45;
Fst2 = params.lowpass+0.45;
Ast1 = 20;
Ap = 0.5;
Ast2 = 15;
BP = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2,Fs);
BP_equirip = design(BP,'equiripple');
end
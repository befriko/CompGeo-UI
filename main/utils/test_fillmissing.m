% test my new fillmissing MEX function for Octave
%

dataWithMissing = [ NaN, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, NaN, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, NaN, 2.6, 2.7, 2.8, 2.9, NaN ];

plot(dataWithMissing);

dataFilled = fillmissing(dataWithMissing)
plot(dataFilled);

% just realized this will fail with two NaN in consecutive cells
%
% add more code for special cases
%
badLeftA = [ 1.1, NaN, NaN, NaN, 1.2, 1.3, 1.4, 1.5 ];
filledLeftA = fillmissing(badLeftA);
plot(filledLeftA);
badLeftB = [ NaN, NaN, NaN, NaN, 1.2, 1.3, 1.4, 1.5 ];
filledLeftB = fillmissing(badLeftB);
plot(filledLeftB);

badRightA = [ 1.1, 1.2, 1.3, 1.4, NaN, NaN, NaN, 1.5 ];
filledRightA = fillmissing(badRightA);
plot(filledRightA);
badRightB = [ 1.1, 1.2, 1.3, 1.4, NaN, NaN, NaN, NaN ];
filledRightB = fillmissing(badRightB);
plot(filledRightB);

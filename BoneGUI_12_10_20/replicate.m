function B = replicate(A,S,S1)

%REPLICATE Expand array elements into submatrices
%
% B = replicate(A,S)
% B = replicate(A,M,N)
%
% REPLICATE is a companion to REPMAT, but instead of tiling a larger array
% with the input A, REPLICATE does the equivalent of calling REPMAT on each
% individual element and then tile the results together.
%
% Example:
% If A = [5 3  
%         2 7]
%
% then repmat(A,[2 2]) is [5 3 5 3  and replicate(A,[2 2]) is [5 5 3 3
%                          2 7 2 7                             5 5 3 3
%                          5 3 5 3                             2 2 7 7
%                          2 7 2 7]                            2 2 7 7]
%
% Only 2D and 3D arrays are supported.
%
% See also REPMAT, KRON.

% Written by Mark Ruzon, December 2008
% 2D case accelerated by Jos, December 2008

if nargin < 2
    error('You must provide a size vector');
end

if nargin == 3
    if numel(S) == 1 && numel(S1) == 1
        S = [S S1];
    else
        error('When using 3 arguments, the size arguments must be scalars');
    end
end

if length(S) ~= numel(S)
    error('Size must be a vector');
end

SA = size(A);
if length(S) == 1
    S = [S S];
end

ML = max(length(SA), length(S));

if ML == 2
    B = A(kron(reshape(1:numel(A),SA),ones(S)));
elseif ML == 3
    if length(S) == 2
        S = [S 1];
    elseif length(SA) == 2
        SA = [SA 1];
    end
    [X,Y,Z] = ndgrid(1:SA(1)*S(1), 1:SA(2)*S(2), 1:SA(3)*S(3));
    B = A(ceil(X./S(1)) + SA(1)*(ceil(Y./S(2))-1) + prod(SA(1:2))*(ceil(Z./S(3))-1));
else
    error('Replicate can handle only 2D and 3D arrays');
end
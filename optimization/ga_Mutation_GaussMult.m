%ga_Mutation_GaussMult: Mutation durch Multiplikation mit Zahlen aus
%   einer gaußschen Normalverteilung. Aufbauend auf der Matlab-Funktion 
%   mutationgaussian. Dort Addition der Zufallszahlen, hier Multiplikation,
%   damit nur positive Werte für die zu variierenden Parameter benutzt
%   werden.
% 
%   März 2012 - Moritz Schappler
% 
%   mutationChildren = PI_St_Mutation_GaussMult(parents,options,GenomeLength,...
%   FitnessFcn,state,thisScore,thisPopulation,scale0,shrink) Creates the
%   mutated children using the Gaussian distribution.
%
%   SCALE controls what fraction of the gene's range is searched. A
%   value of 0 will result in no change, a SCALE of 1 will result in a
%   distribution whose standard deviation is equal to the range of this gene.
%   Intermediate values will produce ranges in between these extremes.
%
%   SHRINK controls how fast the SCALE is reduced as generations go by.
%   A SHRINK value of 0 will result in no shrinkage, yielding a constant search
%   size. A value of 1 will result in SCALE shrinking linearly to 0 as
%   GA progresses to the number of generations specified by the options
%   structure. (See 'Generations' in GAOPTIMSET for more details). Intermediate
%   values of SHRINK will produce shrinkage between these extremes.
%   Note: SHRINK may be outside the interval (0,1), but this is ill-advised.
%
%   Example:
%     options = gaoptimset('MutationFcn',{@mutationgaussian});
%
%   This specifies that the mutation function used will be
%   MUTATIONGAUSSIAN, and since no values for SCALE or SHRINK are specified
%   the default values are used.
%
%     scale = 0.5; shrink = 0.75;
%     options = gaoptimset('MutationFcn',{@mutationgaussian,scale,shrink});
%
%   This specifies that the mutation function used will be
%   MUTATIONGAUSSIAN, and the values for SCALE or SHRINK are specified
%   as 0.5 and 0.75 respectively.
%

%   Copyright 2003-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2009/10/10 20:08:27 $

% Use default parameters if the are not passed in.
% If these defaults are not what you prefer, you can pass in your own
% values when you set the mutation function:
%
% options.MutationFunction = { mutationgaussian, 0.3, 0} ;
%



function mutationChildren = ga_Mutation_GaussMult(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,scale0,shrink)

if(strcmpi(options.PopulationType,'doubleVector'))

    if nargin < 9 || isempty(shrink)
        shrink = 1;
        if nargin < 8 || isempty(scale0)
            scale0 = 1;
        end
    end

    if (shrink > 1) || (shrink < 0)
        msg = sprintf('Shrink factors that are less than zero or greater than one may \n\t\t result in unexpected behavior.');
        warning('globaloptim:mutationgaussian:shrinkFactor',msg);
    end


    if length(scale0) == 1
        %Der Skalierungswert ist für jeden Parameterwert gleich
        Skalierung = repmat(scale0 * (1 - shrink * state.Generation/options.Generations), 1, GenomeLength);
    elseif length(scale0) == GenomeLength
        %Für jeden Parameterwert existiert eine eigene Skalierung (bei
        %Steigerung der Parameterzahl und festhalten der bisherigen
        %Parameter)
        Skalierung = scale0 * (1 - shrink * state.Generation/options.Generations);
    else
        msg = sprintf('Falsche Dimension des Skalierungswertes');
        error('globaloptim:mutationgaussian:scaleDimension',msg);
    end
    %range = options.PopInitRange;
    %lower = range(1,:);
    %upper = range(2,:);
    %scale = scale * (upper - lower);

    mutationChildren = zeros(length(parents),GenomeLength);
    for i=1:length(parents) % parents: Indizes der Individuen, die Eltern werden (bzw. Selbstvermehrung durch Mutation)
        parent = thisPopulation(parents(i),:);
        % Anpassung gegenüber MUTATIONGAUSSIAN: Multiplikation statt
        % Addition der Zahl
        % Multipliziere mit 2, potenziert mit normalverteilten Zahlen mit µ=0 und sigma=0.5. ->
        % Es wird gleich häufig mit *2 und *1/2 multipliziert.
        mutationChildren(i,:) = ...
            Skalierung .* 2 .^( 0.5*randn(1, GenomeLength)) .* parent;

    end
elseif(strcmpi(options.PopulationType,'bitString'))
    % there's no such thing as binary Gaussian mutation se we'll just
    % revert to uniform.
    mutationChildren = mutationuniform(parents ,options, GenomeLength,FitnessFcn,state, thisScore,thisPopulation);
end


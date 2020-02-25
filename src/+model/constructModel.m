function net = constructModel(inpSize)
samples = inpSize(1);
n_chans = inpSize(2);
n_filters = 5;

lr = [0.3 1.7] ; % separate learning rate for the weight and for the biases

net.layers = {} ;

fs = 128;
filter_width = round(0.130*fs); % 130 ms
conv = [filter_width,n_chans,n_filters];
randkern = 0.5*randn(conv(1),conv(2),1,conv(3),'single');

net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{randkern,zeros(1, conv(3), 'single')}}, ...
    'learningRate', lr, ...
    'stride', [1,1], ...
    'pad', [0 conv(1)-1 0 0]);
net.layers{end+1} = struct('type', 'relu');

pool = [samples,1];
stride = [samples,1];
net.layers{end+1} = struct('type', 'pool', ...
    'method', 'avg', ...
    'pool', pool, ...
    'stride', stride, ...
    'pad', [0,0,0,0]) ;

Nold = conv(3);
conv = [1,1,5];
randkern = 0.5*randn(conv(1),conv(2),Nold,conv(3),'single');
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{randkern,zeros(1, conv(3), 'single')}}, ...    
    'learningRate', lr, ...
    'stride', [1,1], ...
    'pad', [0 0 0 0]);

net.layers{end+1} = struct('type','sigmoid');

Nold = conv(3);
conv = [1,1,2];
randkern = 0.5*randn(conv(1),conv(2),Nold,conv(3),'single');
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{randkern, zeros(1, conv(3), 'single')}}, ...
    'learningRate', lr, ...
    'stride', [1,1], ...
    'pad', [0 0 0 0]);

net.layers{end+1} = struct('type', 'loss');

%% Meta parameters
net.meta.inputSize = inpSize ;
net.meta.trainOpts.learningRate = 150*[0.002*ones(1,10) 0.001*ones(1,25) 0.0005*ones(1,80)];

net.meta.trainOpts.batchSize = 20;  
net.meta.trainOpts.numEpochs = 100;

net = vl_simplenn_tidy(net);
end

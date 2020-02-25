function acc = evaluate(net,x,y)
net2 = net;

net2.layers(end)=[];
rr2 = vl_simplenn(net2,single(x),[],[],'mode','test');

acc = rr2(end).x(:,:,1,:) < rr2(end).x(:,:,2,:);
acc = reshape(acc,1,[]);
acc = sum(acc == y-1)/size(x,4);
end
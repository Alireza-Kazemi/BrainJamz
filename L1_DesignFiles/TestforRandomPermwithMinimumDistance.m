
n=200;
k=5;
b=1;

t = [];
d = [];
for i=1:10000
    values = sort(randperm(n-(k-1)*(b-1),k))+(0:k-1)*(b-1);
    t = cat(2,t,values);
    d = cat(2,d,diff(values));
end
unique(t)
subplot 221
hist(t,1:n)
subplot 222
hist(d,1:n)

t = [];
d = [];
for i=1:10000

    values = sort(ceil(rand(1,k)*(n-b*(k-1)))-1)+(1:b:k*b);
    t = cat(2,t,values);
    d = cat(2,d,diff(values));
end
unique(t)
subplot 223
hist(t,1:n)
subplot 224
hist(d,1:n)


t = [];
d = [];
for i=1:10000

    values = sort(ceil(rand(1,k)*200));%sort(randperm(n-(k-1)*(b-1),k));
    t = cat(2,t,values);
    d = cat(2,d,diff(values));
end
subplot 223
hist(t,1:200)
subplot 224
hist(d,1:200)
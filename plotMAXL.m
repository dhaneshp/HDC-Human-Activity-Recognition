x = [1,2,3,4,5,6];
name = {'20','30','40','50','70','100'};
y = [0.819 0.854;0.93 0.942;0.848 0.863;0.862 0.892;0.864 0.922;0.887 0.925];
y = y.*100;

bar(x,y);
title('Variation of Precision,Recall with MAXL')
set(gca,'xticklabel',name)
xlabel('MAXL')
ylabel('Percentage')
legend('Precision','Recall','Location','northwest')

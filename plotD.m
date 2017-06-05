x = [1,2,3,4,5];
name = {'100','1000','5000','7000','10000'};
y = [0.167 0.1849;0.782 0.799;0.888 0.905;0.923 0.935;0.93 0.942];
y = y.*100;

bar(x,y);
title('Variation of Precision,Recall with D')
set(gca,'xticklabel',name)
xlabel('D')
ylabel('Percentage')
legend('Precision','Recall','Location','northwest')

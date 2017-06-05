x = [1,2];
name = {'Train on 1 person','Train on 2 person'};
y = [0.765 0.7705;0.9304 0.9427];
y = y.*100;

bar(x,y);
title('Variation of precision and recall on training, test data from Right handed')
set(gca,'xticklabel',name)
xlabel('Training data')
ylabel('Percentage')
legend('Precision','Recall','Location','northwest')

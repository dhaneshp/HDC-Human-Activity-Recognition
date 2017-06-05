x = [1,2,3];
name = {'Train on 1 person','Train on 2 person','Train on 3 person'};
y = [0.6445 0.6657;0.7830 0.7831;0.8118 0.8188];
y = y.*100;

bar(x,y);
title('Variation of precision and recall on training, test data from Right handed and Left handed person')
set(gca,'xticklabel',name)
xlabel('Training data')
ylabel('Percentage')
legend('Precision','Recall','Location','northwest')

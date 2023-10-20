% خواندن دادهها از فایل
data = readtable('train.csv');

% محاسبه احتمالات شرطی و اطلاعات متقابل

% محاسبه تعداد افراد زنده مانده و کشته شده
survived = sum(data.Survived == 1);
died = sum(data.Survived == 0);

% محاسبه احتمال زنده ماندن و کشته شدن
p_survived = survived / height(data);
p_died = died / height(data);

% محاسبه احتمال شرطی برای عوامل مختلف

% جنسیت
p_male = sum(strcmp(data.Gender, 'male')) / height(data);
p_female = sum(strcmp(data.Gender, 'female')) / height(data);

% طبقه
p_class1 = sum(data.Pclass == 1) / height(data);
p_class2 = sum(data.Pclass == 2) / height(data);
p_class3 = sum(data.Pclass == 3) / height(data);

% بندر
p_embarkedS = sum(strcmp(data.Embarked, 'S')) / height(data);
p_embarkedC = sum(strcmp(data.Embarked, 'C')) / height(data);
p_embarkedQ = sum(strcmp(data.Embarked, 'Q')) / height(data);

% تعداد همراهان
p_sibsp0 = sum(data.SibSp == 0) / height(data);
p_sibsp1 = sum(data.SibSp == 1) / height(data);
p_sibsp2 = sum(data.SibSp == 2) / height(data);
p_sibsp3 = sum(data.SibSp == 3) / height(data);

p_parch0 = sum(data.Parch == 0) / height(data);
p_parch1 = sum(data.Parch == 1) / height(data);
p_parch2 = sum(data.Parch == 2) / height(data);
p_parch3 = sum(data.Parch == 3) / height(data);


%سن
% بازه‌های سنی
ageRanges = {'Under 2', '2-13', '14-24', '25-50', 'Above 50'};

% محاسبه تعداد افراد در هر بازه سنی
ageCounts = zeros(1, numel(ageRanges));
for i = 1:numel(ageRanges)
    range = ageRanges{i};
    if strcmp(range, 'Under 2')
        ageCounts(i) = sum(data.Age < 2);
    elseif strcmp(range, '2-13')
        ageCounts(i) = sum(data.Age >= 2 & data.Age <= 13);
    elseif strcmp(range, '14-24')
        ageCounts(i) = sum(data.Age >= 14 & data.Age <= 24);
    elseif strcmp(range, '25-50')
        ageCounts(i) = sum(data.Age >= 25 & data.Age <= 50);
    elseif strcmp(range, 'Above 50')
        ageCounts(i) = sum(data.Age > 50);
    end
end

% محاسبه احتمال شرطی برای هر بازه سنی
p_age = ageCounts / height(data);

% محاسبه اطلاعات متقابل
% محاسبه اطلاعات متقابل
x1 = entropy([p_male, p_female]) - p_survived * entropy([sum(data.Survived == 1 & strcmp(data.Gender, 'male')), sum(data.Survived == 1 & strcmp(data.Gender, 'female'))]) - p_died * entropy([sum(data.Survived == 0 & strcmp(data.Gender, 'male')), sum(data.Survived == 0 & strcmp(data.Gender, 'female'))]);

x2 = entropy([p_class1, p_class2, p_class3]) - p_survived * entropy([sum(data.Survived == 1 & data.Pclass == 1), sum(data.Survived == 1 & data.Pclass == 2), sum(data.Survived == 1 & data.Pclass == 3)]) - p_died * entropy([sum(data.Survived == 0 & data.Pclass == 1), sum(data.Survived == 0 & data.Pclass == 2), sum(data.Survived == 0 & data.Pclass == 3)]);

x3 = entropy([p_embarkedS, p_embarkedC, p_embarkedQ]) - p_survived * entropy([sum(data.Survived == 1 & strcmp(data.Embarked, 'S')), sum(data.Survived == 1 & strcmp(data.Embarked, 'C')), sum(data.Survived == 1 & strcmp(data.Embarked, 'Q'))]) - p_died * entropy([sum(data.Survived == 0 & strcmp(data.Embarked, 'S')), sum(data.Survived == 0 & strcmp(data.Embarked, 'C')), sum(data.Survived == 0 & strcmp(data.Embarked, 'Q'))]);

x4 = entropy([p_sibsp0, p_sibsp1, p_sibsp2, p_sibsp3]) - p_survived * entropy([sum(data.Survived == 1 & data.SibSp == 0), sum(data.Survived == 1 & data.SibSp == 1), sum(data.Survived == 1 & data.SibSp == 2), sum(data.Survived == 1 & data.SibSp == 3)]) - p_died * entropy([sum(data.Survived == 0 & data.SibSp == 0), sum(data.Survived == 0 & data.SibSp == 1), sum(data.Survived == 0 & data.SibSp == 2), sum(data.Survived == 0 & data.SibSp == 3)]);

x5 = entropy([p_parch0, p_parch1, p_parch2, p_parch3]) - p_survived * entropy([sum(data.Survived == 1 & data.Parch == 0), sum(data.Survived == 1 & data.Parch == 1), sum(data.Survived == 1 & data.Parch == 2), sum(data.Survived == 1 & data.Parch == 3)]) - p_died * entropy([sum(data.Survived == 0 & data.Parch == 0), sum(data.Survived == 0 & data.Parch == 1), sum(data.Survived == 0 & data.Parch == 2), sum(data.Survived == 0 & data.Parch == 3)]);

x6 = entropy(p_age) - p_survived * entropy([sum(data.Age(data.Survived == 1) < 2), ...
    sum(data.Age(data.Survived == 1) >= 2 & data.Age(data.Survived == 1) <= 13), ...
    sum(data.Age(data.Survived == 1) >= 14 & data.Age(data.Survived == 1) <= 24), ...
    sum(data.Age(data.Survived == 1) >= 25 & data.Age(data.Survived == 1) <= 50), ...
    sum(data.Age(data.Survived == 1) > 50)]) - ...
    p_died * entropy([sum(data.Age(data.Survived == 0) < 2), ...
    sum(data.Age(data.Survived == 0) >= 2 & data.Age(data.Survived == 0) <= 13), ...
    sum(data.Age(data.Survived == 0) >= 14 & data.Age(data.Survived == 0) <= 24), ...
    sum(data.Age(data.Survived == 0) >= 25 & data.Age(data.Survived == 0) <= 50), ...
    sum(data.Age(data.Survived == 0) > 50)]);


% نمایش نتایج در یک نمودار
categories = {'SibSp', 'Class', 'Embarked', 'Gender', 'Parch','Age'};
information_gains = [x1, x5, x3, x4, x2,x6];
bar(information_gains);
set(gca, 'XTickLabel', categories);
xlabel('Factors');
ylabel('Information Gain');
title('Information Gain for Survival Factors');

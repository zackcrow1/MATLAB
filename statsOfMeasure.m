function [stats] = statsOfMeasure(confusionmat, verbatim)


tp = [];
fp = [];
fn = [];
tn = [];
len = size(confusionmat, 1);
for k = 1:len                  
    % True positives           
    tp_value = confusionmat(k,k); 
    tp = [tp, tp_value];       
                                              
    % False positives                         
    fp_value = sum(confusionmat(:,k)) - tp_value; 
    fp = [fp, fp_value];                       
                                               
                           
    fn_value = sum(confusionmat(k,:)) - tp_value; 
    fn = [fn, fn_value];                       
                                                                       
    % True negatives (all the rest)                                    
    tn_value = sum(sum(confusionmat)) - (tp_value + fp_value + fn_value);
    tn = [tn, tn_value];                                               
end


prec = tp ./ (tp + fp); 
sens = tp ./ (tp + fn); 
spec = tn ./ (tn + fp); 
acc = sum(tp) ./ sum(sum(confusionmat));
f1 = (2 .* prec .* sens) ./ (prec + sens);


microprec = sum(tp) ./ (sum(tp) + sum(fp)); 
microsens = sum(tp) ./ (sum(tp) + sum(fn));
microspec = sum(tn) ./ (sum(tn) + sum(fp));
microacc = acc;
microf1 = (2 .* microprec .* microsens) ./ (microprec + microsens);


name = ["true_positive"; "false_positive"; "false_negative"; "true_negative"; ...
    "precision"; "sensitivity"; "specificity"; "accuracy"; "F-measure"];


varNames = ["name"; "classes"; "macroAVG"; "microAVG"];


values = [tp; fp; fn; tn; prec; sens; spec; repmat(acc, 1, len); f1];


macroAVG = mean(values, 2);


microAVG = [macroAVG(1:4); microprec; microsens; microspec; microacc; microf1];


stats = table(name, values, macroAVG, microAVG, 'VariableNames',varNames);
if verbatim
    stats
end
end
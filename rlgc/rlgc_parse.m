files = dir('./rlgc_files/*.rlgc');
param_names = {'Lo' 'Co' 'Ro' 'Go' 'Rs' 'Gd'};
param_num = numel(param_names);

file_num = numel(files);
param_values = zeros(file_num,param_num,3);
% Zo, Zoo, Zoe, kc, kl, Kb, Kf, vo, ve
out = zeros(file_num,9);
% vp, td, Vb_amp, Vb_t, Vf_amp
cross = zeros(file_num,5);
% Width, Gap, Laminate, pre-preg
inputs = zeros(file_num,4);

len_b = 12*0.0254;

i = 1;
for file = files'
    ['./rlgc_files/' file.name]
    [mat,tok] = regexp(file.name,'(\d*.?\d+)_(\d*.?\d+)_(\d*.?\d+)_(\d*.?\d+).rlgc', 'match', 'tokens');
    rlgc_file = fileread(['./rlgc_files/' file.name]);
    for idx = 1: size(inputs,2)
        inputs(i,idx) = str2num(tok{1}{idx});
    end
    for idx = 1:param_num
        [mat,tok] = regexp(rlgc_file,[param_names{idx} ' = (\d*.\d*)e([+-]\d*)\W+(\d*.\d*)e([+-]\d*)\W+(\d*.\d*)e([+-]\d*)'], 'match', 'tokens');
        param_values(i,idx,:) = [str2double(tok{1}{1})*10^str2double(tok{1}{2}), str2double(tok{1}{3})*10^str2double(tok{1}{4}), str2double(tok{1}{5})*10^str2double(tok{1}{6})];
    end
    line = [param_values(i,1,1),param_values(i,1,2),param_values(i,2,1),param_values(i,2,2),param_values(i,3,1),param_values(i,3,2),];
    out(i,1) = sqrt(line(1)/line(3));
    out(i,2) = sqrt((line(1)-line(2))/(line(3)+line(4)));
    out(i,3) = sqrt((line(1)+line(2))/(line(3)-line(4)));
    out(i,4) = line(4)/line(3);
    out(i,5) = line(2)/line(1);
    out(i,6) = (out(i,4)+out(i,5))/4;
    out(i,7) = (out(i,4)-out(i,5))/2;
    out(i,8) = 1/sqrt((line(1)-line(2))*(line(3)+line(4)));
    out(i,9) = 1/sqrt((line(1)+line(2))*(line(3)-line(4)));
    
    cross(i,1) = 1/sqrt(line(1)*line(3));
    cross(i,2) = len_b/cross(i,1);
    cross(i,3) = out(i,6);
    cross(i,4) = cross(i,2)*2;
    cross(i,5) = out(i,7)*cross(i,2)/(100E-12);
    i = i + 1;
end

%%



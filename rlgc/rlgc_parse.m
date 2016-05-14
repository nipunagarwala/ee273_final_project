files = dir('./rlgc_files/*.rlgc');
param_names = {'Lo' 'Co' 'Ro' 'Go' 'Rs' 'Gd'};
param_num = numel(param_names);

file_num = numel(files)
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

Rdc = param_values(:,3,1);
Rs = param_values(:,5,1);
f = 10*10^9;
Gd = param_values(:,6,1);
R = Rdc+Rs*sqrt(f);
G = Gd*f;
Zo= out(:,1);
ar = R./(2*Zo);
ad = G.*Zo/2;

atten = log10(exp(-(ar+ad)))*20/39.6;
Kbs = out(:,6);
sums = inputs(:,1)*2+inputs(:,2);


kb_thresh = 0.05;

width_col = inputs(:,1) + inputs(:,2);
backCross_col = out(:,6) > kb_thresh;
aug_input = [inputs width_col backCross_col out(:,6) -atten];

sort_input = sortrows(aug_input, [6,5, 8, 7]);

min_widths = dataset({sort_input 'Width','Gap','Width+Gap','Laminate','Pre-preg', ...
    'Is_not_kb', 'Kb', 'Attenuation'},'obsnames', {});

export(min_widths)



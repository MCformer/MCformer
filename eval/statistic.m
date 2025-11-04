clear all;
clc;

ts = 0;  % 用于累加SSIM值
tp = 0;  % 用于累加PSNR值
num_samples = 1400;  % 测试样本数量

% 定义图像路径
truth_dir = './results/target-DDN-png/';       % 真值图像目录
recon_dir = './results/DDN-Data/';     % 重建图像目录

% 循环处理每一对图像
for i = 1:num_samples
    % 构建图像文件名（均为数字.jpg格式）
    truth_filename = sprintf('%d.png', i);
    recon_filename = sprintf('%d.png', i);
    
    % 构建完整路径
    truth_path = fullfile(truth_dir, truth_filename);
    recon_path = fullfile(recon_dir, recon_filename);
    
    % 检查文件是否存在
    if ~exist(truth_path, 'file')
        error('真值图像不存在: %s', truth_path);
    end
    if ~exist(recon_path, 'file')
        error('重建图像不存在: %s', recon_path);
    end
    
    % 读取图像并转换为双精度
    x_true = im2double(imread(truth_path));  % 读取真值图像
    x = im2double(imread(recon_path));       % 读取重建图像
    
    % 转换到YCbCr空间并提取亮度通道（Y通道）
    x_true = rgb2ycbcr(x_true);
    x_true = x_true(:, :, 1); 
    
    x = rgb2ycbcr(x);
    x = x(:, :, 1);
    
    % 计算并累加PSNR和SSIM值
    tp = tp + psnr(x, x_true);
    ts = ts + ssim(x*255, x_true*255);
    
    % 显示进度
    if mod(i, 100) == 0
        fprintf('已处理 %d/%d 张图像\n', i, num_samples);
    end
end

% 计算并输出平均值
psnr_avg = tp / num_samples;
ssim_avg = ts / num_samples;
fprintf('平均PSNR = %6.4f, 平均SSIM = %6.4f\n', psnr_avg, ssim_avg);

num = [834 15846 70056];
den = [1 40 623 5344 28672 70056];

t = linspace(0, 1, 1000);

[r, p, k] = residue(num, den);
h_t = zeros(size(t));
for i = 1:length(r)
    h_t = h_t + real(r(i) * exp(p(i)*t));
end
if ~isempty(k)
    h_t = h_t + polyval(k, t);
end

num_step = num;
den_step = conv(den, [1 0]);

[rs, ps, ks] = residue(num_step, den_step);
y_t = zeros(size(t));
for i = 1:length(rs)
    y_t = y_t + real(rs(i) * exp(ps(i)*t));
end
if ~isempty(ks)
    y_t = y_t + polyval(ks, t);
end

figure;
subplot(2,1,1);
plot(t, h_t, 'LineWidth', 1.5);
title('Respuesta al impulso (\delta(t))');
xlabel('Tiempo (s)');
ylabel('h(t)');
grid on;

subplot(2,1,2);
plot(t, y_t, 'LineWidth', 1.5);
title('Respuesta al escalón (\mu(t))');
xlabel('Tiempo (s)');
ylabel('y(t)');
grid on;

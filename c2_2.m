num = [834 15846 70056];
den = [1 40 623 5344 28672 70056];
[r, p, k] = residue(num, den);

t = linspace(0, 12, 2000);

f_t = zeros(size(t));
for i = 1:length(t)
    ti = t(i);
    if ti > 0.5 && ti <= 5.5
        f_t(i) = (1/5)*ti + 2.9;
    elseif ti > 5.5 && ti <= 7.5
        f_t(i) = -(1/2)*ti + 6.75;
    elseif ti > 7.5 && ti <= 9
        f_t(i) = -(4/3)*ti + 10;
    elseif ti > 9 && ti <= 9.5
        f_t(i) = 4*ti - 38;
    end
end

h_t = zeros(size(t));
for i = 1:length(r)
    h_t = h_t + real(r(i) * exp(p(i) * t));
end
if ~isempty(k)
    h_t = h_t + polyval(k, t);
end

dt = t(2) - t(1);
y_t = conv(f_t, h_t) * dt;
y_t = y_t(1:length(t));

plot(t, y_t, 'b', 'LineWidth', 1.5);
title('Respuesta del sistema y(t)');
xlabel('Tiempo (s)');
ylabel('y(t)');
grid on;
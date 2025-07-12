num = [15 285 1260];
den = [1 40 623 4510 12826];
F2 = tf(num, den);

[y, t] = step(F2);

ess = dcgain(F2);
S = stepinfo(F2);

overshoot = S.Overshoot;
settling_time = S.SettlingTime;
rise_time = S.RiseTime;

valor_max = max(y);

fprintf('Valor en estado estacionario (entrada escalón): %.4f\n', ess);
fprintf('Sobreimpulso: %.4f %%\n', overshoot);
fprintf('Tiempo de asentamiento: %.4f s\n', settling_time);
fprintf('Tiempo de subida: %.4f s\n', rise_time);
fprintf('Valor máximo alcanzado: %.4f\n', valor_max);

figure;
step(F2);
title('Respuesta al escalón de F2(s)');
grid on;

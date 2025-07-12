num = [834 15846 70056];
den = [1 40 623 5344 28672 70056];
H = tf(num, den);

w = logspace(-1, 3, 1000);
[mag, phase] = bode(H, w);
mag = squeeze(mag);
phase = squeeze(phase);
mag_dB = 20*log10(mag);

figure;
subplot(2,1,1);
semilogx(w, mag_dB, 'b', 'LineWidth', 1.5);
xlabel('Frecuencia [rad/s]');
ylabel('Magnitud [dB]');
title('Diagrama de Bode - Magnitud');
grid on;
hold on;

n_zeros = length(num) - 1;
n_polos = length(den) - 1;
ganancia_estatica = num(end) / den(end);
K_dB = 20 * log10(ganancia_estatica);
w0 = 1;
asintota_mag = K_dB - 60*log10(w / w0);
semilogx(w, asintota_mag, '--r', 'LineWidth', 1.2);
legend('Magnitud real', 'Asíntota estimada');

subplot(2,1,2);
semilogx(w, phase, 'b', 'LineWidth', 1.5);
xlabel('Frecuencia [rad/s]');
ylabel('Fase [°]');
title('Diagrama de Bode - Fase');
grid on;

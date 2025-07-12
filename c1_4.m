num_base = [15 285 1260];
den_base = [1 40 623 4510 12826];
F2 = tf(num_base, den_base);

a_vals = -300:2:300;    % Posición del cero (s - a)
p_vals = 0.1:5:50;  % Posición del polo (s + p)
K_vals = 0.1:1:30;   % Ganancia total

ess_target = 3.5;
ess_tol = 1.0;

encontrado = false;

for a = a_vals
    for p = p_vals
        for K = K_vals
            % Numerador: (s - a) * num_base
            num_mod = conv([1 -a], num_base);
            num_mod = K * num_mod;

            % Denominador: (s + p) * den_base * s
            den_mod = conv([den_base 0], [1 p]);

            H = tf(num_mod, den_mod);

            if all(real(pole(H)) < 0)
                try
                    info = stepinfo(H);
                    ess = dcgain(H);
                    os = info.Overshoot;
                    ts = info.SettlingTime;
                    tr = info.RiseTime;

                    if abs(ess - ess_target) <= ess_tol && ...
                       os >= 20 && os <= 30 && ...
                       ts < 80 && tr < 15

                       encontrado = true;
                       fprintf('\n✅ Encontrado!\n');
                       fprintf('Cero en (s - %.2f), Polo en (s + %.2f), Ganancia K = %.2f\n', a, p, K);
                       fprintf('Valor estacionario: %.4f\n', ess);
                       fprintf('Sobreimpulso: %.2f %%\n', os);
                       fprintf('Tiempo de asentamiento: %.2f s\n', ts);
                       fprintf('Tiempo de subida: %.2f s\n', tr);

                       figure;
                       step(H);
                       title(sprintf('Respuesta con cero (s - %.2f), polo (s + %.2f), K = %.2f', a, p, K));
                       grid on;
                       break;
                    end
                catch
                    continue
                end
            end
        end
        if encontrado
            break;
        end
    end
    if encontrado
        break;
    end
end

if ~encontrado
    fprintf('\n❌ No se encontró combinación que cumpla todos los requisitos.\n');
end

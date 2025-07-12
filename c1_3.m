num_base = [15 285 1260];
den_base = [1 40 623 4510 12826];
F2 = tf(num_base,den_base);

p_vals = 0.1:0.5:500;   % Polo en semiplano izquierdo (estable)
K_vals = 0.1:0.1:100;   % Ganancia total externa

ess_target = 3.5;
ess_tol = 1.0;

encontrado = false;

for p = p_vals
    for K = K_vals
        % Nuevo polo: 1 / (s + p) => multiplicamos denominador
        num_mod = K * num_base;
        den_mod = conv([den_base 0], [1 p]);  % agrega nuevo polo

        H = tf(num_mod, den_mod);

        if all(real(pole(H)) < 0)  % Verificar estabilidad
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
                   fprintf('Polo agregado en (s + %.2f), Ganancia K = %.2f\n', p, K);
                   fprintf('Valor estacionario: %.4f\n', ess);
                   fprintf('Sobreimpulso: %.2f %%\n', os);
                   fprintf('Tiempo de asentamiento: %.2f s\n', ts);
                   fprintf('Tiempo de subida: %.2f s\n', tr);

                   figure;
                   step(H);
                   title(sprintf('Respuesta al escalón con polo en (s + %.2f), K = %.2f', p, K));
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

if ~encontrado
    fprintf('No se encontró combinación que cumpla todos los requisitos.\n');
end

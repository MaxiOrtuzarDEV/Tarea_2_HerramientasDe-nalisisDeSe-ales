num_base = [15 285 1260];
den = [1 40 623 4510 12826];
F2 = tf(num_base, den);

a_vals = -100:0.5:100;
K_vals = 0.1:0.1:100;

ess_target = 3.5;
ess_tol = 1.0;

encontrado = false;

for a = a_vals
    for K = K_vals
        num_mod = conv([1 -a], num_base);   
        num_mod = K * num_mod;              
        H = tf(num_mod, [den 0]);

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
                   fprintf('CERO agregado: (s - %.2f), Ganancia total K = %.2f\n', a, K);
                   fprintf('Valor estacionario: %.4f\n', ess);
                   fprintf('Sobreimpulso: %.2f %%\n', os);
                   fprintf('Tiempo de asentamiento: %.2f s\n', ts);
                   fprintf('Tiempo de subida: %.2f s\n', tr);

                   figure;
                   step(H);
                   title(sprintf('Respuesta al escalón con cero en (s - %.2f), K = %.2f', a, K));
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
